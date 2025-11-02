require('dotenv').config();
const express = require('express');
const cors = require('cors');
const helmet = require('helmet');
const morgan = require('morgan');
const { fetch } = require('undici');
const QRCode = require('qrcode');
const nodemailer = require('nodemailer');
const admin = require('firebase-admin');

const app = express();
const PORT = process.env.PORT || 3000;
const ADMIN_API_KEY = process.env.ADMIN_API_KEY || '';

// Initialize Firebase Admin (requires GOOGLE_APPLICATION_CREDENTIALS env pointing to service account JSON)
try {
  if (!admin.apps.length) {
    admin.initializeApp();
    console.log('Firebase Admin initialized');
  }
} catch (e) {
  console.warn('Firebase Admin init failed:', e.message);
}

// Security and CORS
app.use(helmet());
app.use(cors({ origin: true }));
app.use(morgan('dev'));
app.use(express.json());

// Health check
app.get('/health', (req, res) => {
  res.json({ status: 'ok' });
});

// Simple image proxy to bypass browser CORS for external images
// Usage: /img?url=<encoded external url>
app.get('/img', async (req, res) => {
  try {
    const url = req.query.url;
    if (!url || typeof url !== 'string') {
      return res.status(400).json({ error: 'Missing url query parameter' });
    }
    let target;
    try {
      target = new URL(url);
    } catch (_) {
      return res.status(400).json({ error: 'Invalid url' });
    }
    if (!['http:', 'https:'].includes(target.protocol)) {
      return res.status(400).json({ error: 'Only http/https protocols are allowed' });
    }

    const response = await fetch(target.href, {
      headers: {
        // Hint some servers to return image bytes
        'Accept': 'image/avif,image/webp,image/apng,image/*,*/*;q=0.8',
        'User-Agent': 'cinema-booking-proxy/1.0'
      }
    });

    if (!response.ok) {
      return res.status(502).json({ error: 'Upstream fetch failed', status: response.status });
    }

    const contentType = response.headers.get('content-type') || 'application/octet-stream';
    res.setHeader('Content-Type', contentType);
    res.setHeader('Cache-Control', 'public, max-age=300');
    // Allow any origin to read this proxied resource
    res.setHeader('Access-Control-Allow-Origin', '*');

    // Stream body to the client
    const body = response.body;
    if (body && typeof body.pipe === 'function') {
      body.pipe(res);
    } else {
      const arrayBuffer = await response.arrayBuffer();
      res.end(Buffer.from(arrayBuffer));
    }
  } catch (err) {
    console.error('Proxy error:', err);
    res.status(500).json({ error: 'Proxy error' });
  }
});

// Simple Visa payment mock + QR generation + email sending
app.post('/api/visa/pay', async (req, res) => {
  try {
    const {
      cardNumber, expMonth, expYear, cvv,
      amount, currency, email, ticket
    } = req.body || {};

    if (!cardNumber || !expMonth || !expYear || !cvv || !amount || !ticket) {
      return res.status(400).json({ error: 'Missing required fields' });
    }

    // Basic validations (Luhn for card number, expiry, cvv)
    const luhnCheck = (num) => {
      const arr = (num + '')
        .split('')
        .reverse()
        .map(x => parseInt(x));
      const last = arr.shift();
      let sum = arr.reduce((acc, val, idx) => acc + (idx % 2 === 0 ? ((val *= 2) > 9 ? val - 9 : val) : val), 0);
      sum += last;
      return sum % 10 === 0;
    };

    const now = new Date();
    const expOk = Number(expYear) > now.getFullYear() || (Number(expYear) === now.getFullYear() && Number(expMonth) >= (now.getMonth() + 1));
    const cvvOk = String(cvv).length >= 3;
    const cardOk = luhnCheck(String(cardNumber).replace(/\s|-/g, ''));

    if (!cardOk || !expOk || !cvvOk) {
      return res.status(400).json({ error: 'Invalid card details' });
    }

    // Simulate payment processing
    const paymentId = 'pay_' + Math.random().toString(36).slice(2);

    const qrPayload = {
      paymentId,
      amount,
      currency,
      email,
      ticket,
      ts: Date.now()
    };

    // Generate QR PNG (base64)
    const qrDataUrl = await QRCode.toDataURL(JSON.stringify(qrPayload), { errorCorrectionLevel: 'M' });
    const qrBase64 = qrDataUrl.split(',')[1];

    // Attempt to send email if SMTP is configured
    let emailSent = false;
    const { SMTP_HOST, SMTP_PORT, SMTP_USER, SMTP_PASS, SMTP_SECURE } = process.env;
    if (SMTP_HOST && SMTP_USER && SMTP_PASS) {
      const transporter = nodemailer.createTransport({
        host: SMTP_HOST,
        port: Number(SMTP_PORT || 587),
        secure: String(SMTP_SECURE || 'false') === 'true',
        auth: { user: SMTP_USER, pass: SMTP_PASS }
      });

      try {
        await transporter.sendMail({
          from: `Cinema Booking <${SMTP_USER}>`,
          to: email,
          subject: 'Mã QR vé xem phim - Thanh toán thành công',
          text: `Cảm ơn bạn đã thanh toán. Đính kèm là mã QR vé của bạn. PaymentId: ${paymentId}`,
          attachments: [{
            filename: 'ticket-qr.png',
            content: Buffer.from(qrBase64, 'base64'),
            contentType: 'image/png'
          }]
        });
        emailSent = true;
      } catch (err) {
        console.error('Email send error:', err);
      }
    }

    return res.json({ success: true, paymentId, qrBase64, emailSent });
  } catch (err) {
    console.error('Pay error:', err);
    return res.status(500).json({ error: 'Server error' });
  }
});

// Admin: set custom claim admin=true/false for a given UID
app.post('/admin/set-admin', async (req, res) => {
  try {
    if (!ADMIN_API_KEY || req.headers['x-admin-api-key'] !== ADMIN_API_KEY) {
      return res.status(401).json({ error: 'Unauthorized' });
    }
    const { uid, makeAdmin } = req.body || {};
    if (!uid || typeof makeAdmin !== 'boolean') {
      return res.status(400).json({ error: 'Missing uid or makeAdmin(boolean)' });
    }
    // Merge with existing claims if present
    const user = await admin.auth().getUser(uid);
    const existing = user.customClaims || {};
    const updated = { ...existing, admin: makeAdmin };
    await admin.auth().setCustomUserClaims(uid, updated);
    // Force token refresh so client picks up new claims
    await admin.auth().revokeRefreshTokens(uid);
    return res.json({ success: true, uid, admin: makeAdmin });
  } catch (err) {
    console.error('set-admin error:', err);
    return res.status(500).json({ error: 'Server error' });
  }
});

// Admin: create a Firebase Auth user and optionally set admin claim
app.post('/admin/create-user', async (req, res) => {
  try {
    if (!ADMIN_API_KEY || req.headers['x-admin-api-key'] !== ADMIN_API_KEY) {
      return res.status(401).json({ error: 'Unauthorized' });
    }
    const { email, password, displayName, makeAdmin = true } = req.body || {};
    if (!email || !password) {
      return res.status(400).json({ error: 'Missing email or password' });
    }

    // Create user in Firebase Auth
    const created = await admin.auth().createUser({ email, password, displayName });

    // Set custom claim admin
    const claims = { admin: !!makeAdmin };
    await admin.auth().setCustomUserClaims(created.uid, claims);
    await admin.auth().revokeRefreshTokens(created.uid);

    // Create Firestore user doc (optional convenience for frontend)
    try {
      const db = admin.firestore();
      await db.collection('users').doc(created.uid).set({
        email,
        displayName: displayName || null,
        isAdmin: !!makeAdmin,
        createdAt: admin.firestore.FieldValue.serverTimestamp(),
      }, { merge: true });
    } catch (e) {
      console.warn('Create Firestore user doc failed:', e.message);
    }

    return res.json({ success: true, uid: created.uid, email, admin: !!makeAdmin });
  } catch (err) {
    console.error('create-user error:', err);
    // If email exists or weak password, surface message
    return res.status(500).json({ error: err.message || 'Server error' });
  }
});

// Admin: seed movies into Firestore (from sourceUrl or provided array)
app.post('/admin/seed-movies', async (req, res) => {
  try {
    if (!ADMIN_API_KEY || req.headers['x-admin-api-key'] !== ADMIN_API_KEY) {
      return res.status(401).json({ error: 'Unauthorized' });
    }

    const { sourceUrl, movies } = req.body || {};

    // Fetch data from external sourceUrl if provided
    let payload = movies;
    if (sourceUrl && typeof sourceUrl === 'string') {
      try {
        const r = await fetch(sourceUrl, { headers: { 'Accept': 'application/json' } });
        if (!r.ok) {
          return res.status(502).json({ error: 'Fetch source failed', status: r.status });
        }
        const json = await r.json();
        payload = json;
      } catch (e) {
        return res.status(500).json({ error: `Fetch error: ${e.message}` });
      }
    }

    // Normalize various response shapes into a flat list of movie objects
    const normalizeList = (data) => {
      const out = [];
      const pushItem = (item) => {
        if (!item || typeof item !== 'object') return;
        const detail = item.detail || {};
        const name = (detail.name || item.name || item.title || '').toString();
        if (!name) return;
        const duration = Number(detail.duration || item.duration || 120);
        const tagsRaw = detail.tags || item.tags || [];
        const tags = Array.isArray(tagsRaw) ? tagsRaw.map(String) : String(tagsRaw || '').split(',').map(s => s.trim()).filter(Boolean);
        const release = Number(item.release_date || detail.release_date || Date.now());
        out.push({ name, duration, tags, release_date: release });
      };

      if (Array.isArray(data)) {
        data.forEach(pushItem);
        return out;
      }
      if (data && typeof data === 'object') {
        const keys = ['nowMovieing', 'comingSoon', 'exclusive', 'movies', 'data', 'list'];
        let foundAny = false;
        for (const k of keys) {
          const arr = data[k];
          if (Array.isArray(arr)) {
            arr.forEach(pushItem);
            foundAny = true;
          }
        }
        if (!foundAny) pushItem(data);
        return out;
      }
      return out;
    };

    const list = normalizeList(payload);
    if (!list.length) {
      return res.status(400).json({ error: 'No movies to seed (empty payload)' });
    }

    const db = admin.firestore();
    const batch = db.batch();
    const col = db.collection('movies');
    list.forEach((m) => {
      const docRef = col.doc();
      batch.set(docRef, {
        name: m.name,
        duration: m.duration,
        tags: m.tags,
        release_date: m.release_date,
        createdAt: admin.firestore.FieldValue.serverTimestamp(),
      });
    });
    await batch.commit();

    return res.json({ success: true, inserted: list.length });
  } catch (err) {
    console.error('seed-movies error:', err);
    return res.status(500).json({ error: 'Server error' });
  }
});

app.listen(PORT, () => {
  console.log(`Backend listening on http://localhost:${PORT}`);
});