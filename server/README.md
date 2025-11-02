# Cinema Booking Backend

Simple Express backend providing an image proxy endpoint to bypass browser CORS when loading external images in Flutter Web.

## Endpoints

- `GET /health` — health check.
- `GET /img?url=<encoded>` — proxies an external image and returns bytes with `Access-Control-Allow-Origin: *`.

## Setup

1. Create environment file:

```
cp .env.example .env
```

2. Install dependencies:

```
npm install
```

3. Start server:

```
npm start
```

Server runs on `http://localhost:3000/` by default. You can change `PORT` in `.env`.

## Notes

- This proxy is intended for development. For production, prefer hosting images on a domain you control with proper CORS settings.
- The frontend can call `http://localhost:3000/img?url=<encoded original url>` to load images on web without CORS errors.