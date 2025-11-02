import 'package:cinema_booking/core/configs/theme/app_color.dart';
import 'package:cinema_booking/core/configs/theme/app_font.dart';
import 'package:cinema_booking/common/widgets/space/widget_spacer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({super.key});

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen>
    with SingleTickerProviderStateMixin {
  bool _checking = true;
  bool _isAdmin = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _checkAdmin();
  }

  Future<void> _checkAdmin() async {
    setState(() {
      _checking = true;
      _error = null;
    });
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        setState(() {
          _isAdmin = false;
          _checking = false;
          _error = 'Bạn cần đăng nhập để truy cập trang quản trị';
        });
        return;
      }
      final token = await user.getIdTokenResult(true);
      final claims = token.claims ?? {};
      final isAdmin = claims['admin'] == true || claims['role'] == 'admin';
      setState(() {
        _isAdmin = isAdmin;
        _checking = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _checking = false;
        _isAdmin = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: AppColors.darkBackground,
        appBar: AppBar(
          backgroundColor: AppColors.darkBackground,
          title: const Text('Admin Dashboard'),
          bottom: const TabBar(
            tabs: [
              Tab(icon: Icon(Icons.people), text: 'Users'),
              Tab(icon: Icon(Icons.movie), text: 'Movies'),
              Tab(icon: Icon(Icons.schedule), text: 'Showtimes'),
            ],
          ),
          actions: [
            IconButton(
              tooltip: 'Làm mới quyền',
              onPressed: _checkAdmin,
              icon: const Icon(Icons.refresh),
            ),
          ],
        ),
        body: _checking
            ? const Center(child: CircularProgressIndicator())
            : !_isAdmin
                ? _buildNotAdmin()
                : const TabBarView(
                    children: [
                      _UsersTab(),
                      _MoviesTab(),
                      _ShowtimesTab(),
                    ],
                  ),
      ),
    );
  }

  Widget _buildNotAdmin() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.lock_outline, color: Colors.white.withOpacity(0.8), size: 48),
            WidgetSpacer(height: 16),
            Text(
              _error ?? 'Bạn không có quyền truy cập trang quản trị',
              textAlign: TextAlign.center,
              style: AppFont.medium_white_16,
            ),
            WidgetSpacer(height: 16),
            Text(
              'Nếu bạn vừa được cấp quyền admin, hãy đăng xuất và đăng nhập lại, hoặc nhấn làm mới quyền.',
              textAlign: TextAlign.center,
              style: AppFont.medium_white_16.copyWith(fontSize: 13, color: Colors.white70),
            ),
          ],
        ),
      ),
    );
  }
}

class _UsersTab extends StatelessWidget {
  const _UsersTab();

  @override
  Widget build(BuildContext context) {
    final fs = FirebaseFirestore.instance;
    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      stream: fs.collection('users').orderBy('createdAt', descending: true).limit(50).snapshots(),
      builder: (context, snap) {
        if (snap.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snap.hasError) {
          return Center(child: Text('Lỗi tải users: ${snap.error}', style: AppFont.medium_white_16));
        }
        final docs = snap.data?.docs ?? [];
        if (docs.isEmpty) {
          return const Center(child: Text('Chưa có người dùng', style: TextStyle(color: Colors.white70)));
        }
        return ListView.separated(
          itemBuilder: (context, i) {
            final d = docs[i].data();
            final name = (d['fullName'] ?? '').toString();
            final email = (d['email'] ?? '').toString();
            final uid = (d['uid'] ?? '').toString();
            return ListTile(
              title: Text(name.isNotEmpty ? name : email, style: AppFont.medium_white_16),
              subtitle: Text('UID: $uid', style: AppFont.medium_white_16.copyWith(fontSize: 12, color: Colors.white60)),
              trailing: IconButton(
                tooltip: 'Sao chép UID',
                icon: const Icon(Icons.copy, color: Colors.white70),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Đã sao chép UID (hãy dùng server để cấp quyền).')),
                  );
                },
              ),
            );
          },
          separatorBuilder: (_, __) => const Divider(height: 1),
          itemCount: docs.length,
        );
      },
    );
  }
}

class _MoviesTab extends StatelessWidget {
  const _MoviesTab();

  @override
  Widget build(BuildContext context) {
    final fs = FirebaseFirestore.instance;
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            children: [
              ElevatedButton.icon(
                onPressed: () => _openCreateMovieDialog(context, fs),
                icon: const Icon(Icons.add),
                label: const Text('Thêm Movie'),
              ),
            ],
          ),
        ),
        const Divider(height: 1),
        Expanded(
          child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
            stream: fs.collection('movies').orderBy('release_date', descending: true).limit(100).snapshots(),
            builder: (context, snap) {
              if (snap.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (snap.hasError) {
                return Center(child: Text('Lỗi tải movies: ${snap.error}', style: AppFont.medium_white_16));
              }
              final docs = snap.data?.docs ?? [];
              if (docs.isEmpty) {
                return const Center(child: Text('Chưa có phim', style: TextStyle(color: Colors.white70)));
              }
              return ListView.separated(
                itemBuilder: (context, i) {
                  final d = docs[i];
                  final data = d.data();
                  final name = (data['name'] ?? '').toString();
                  final duration = (data['duration'] ?? 0) as int;
                  final tags = (data['tags'] ?? []) as List<dynamic>;
                  return ListTile(
                    title: Text(name, style: AppFont.medium_white_16),
                    subtitle: Text('Duration: $duration • Tags: ${tags.join(', ')}', style: const TextStyle(color: Colors.white70)),
                    trailing: IconButton(
                      tooltip: 'Xoá',
                      icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
                      onPressed: () async {
                        await d.reference.delete();
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Đã xoá movie')));
                      },
                    ),
                  );
                },
                separatorBuilder: (_, __) => const Divider(height: 1),
                itemCount: docs.length,
              );
            },
          ),
        ),
      ],
    );
  }

  void _openCreateMovieDialog(BuildContext context, FirebaseFirestore fs) {
    final nameCtrl = TextEditingController();
    final durationCtrl = TextEditingController(text: '120');
    final tagsCtrl = TextEditingController(text: 'Action,Drama');
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: const Text('Thêm Movie'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(controller: nameCtrl, decoration: const InputDecoration(labelText: 'Tên phim')),
              TextField(controller: durationCtrl, decoration: const InputDecoration(labelText: 'Thời lượng (phút)'), keyboardType: TextInputType.number),
              TextField(controller: tagsCtrl, decoration: const InputDecoration(labelText: 'Tags (phân cách bằng ,)')),
            ],
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Huỷ')),
            ElevatedButton(
              onPressed: () async {
                final name = nameCtrl.text.trim();
                final duration = int.tryParse(durationCtrl.text.trim()) ?? 0;
                final tags = tagsCtrl.text
                    .split(',')
                    .map((e) => e.trim())
                    .where((e) => e.isNotEmpty)
                    .toList();
                await fs.collection('movies').add({
                  'name': name,
                  'duration': duration,
                  'tags': tags,
                  'release_date': DateTime.now().millisecondsSinceEpoch,
                  'createdAt': FieldValue.serverTimestamp(),
                });
                if (context.mounted) {
                  Navigator.pop(ctx);
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Đã thêm movie')));
                }
              },
              child: const Text('Lưu'),
            ),
          ],
        );
      },
    );
  }
}

class _ShowtimesTab extends StatelessWidget {
  const _ShowtimesTab();

  @override
  Widget build(BuildContext context) {
    final fs = FirebaseFirestore.instance;
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            children: [
              ElevatedButton.icon(
                onPressed: () => _openCreateShowtimeDialog(context, fs),
                icon: const Icon(Icons.add),
                label: const Text('Thêm Showtime'),
              ),
            ],
          ),
        ),
        const Divider(height: 1),
        Expanded(
          child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
            stream: fs.collection('showtimes').orderBy('createdAt', descending: true).limit(100).snapshots(),
            builder: (context, snap) {
              if (snap.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (snap.hasError) {
                return Center(child: Text('Lỗi tải showtimes: ${snap.error}', style: AppFont.medium_white_16));
              }
              final docs = snap.data?.docs ?? [];
              if (docs.isEmpty) {
                return const Center(child: Text('Chưa có suất chiếu', style: TextStyle(color: Colors.white70)));
              }
              return ListView.separated(
                itemBuilder: (context, i) {
                  final d = docs[i];
                  final data = d.data();
                  final movieId = (data['movieId'] ?? '').toString();
                  final cinemaId = (data['cinemaId'] ?? '').toString();
                  final format = (data['format'] ?? '').toString();
                  return ListTile(
                    title: Text('Movie: $movieId', style: AppFont.medium_white_16),
                    subtitle: Text('Cinema: $cinemaId • Format: $format', style: const TextStyle(color: Colors.white70)),
                    trailing: IconButton(
                      tooltip: 'Xoá',
                      icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
                      onPressed: () async {
                        await d.reference.delete();
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Đã xoá showtime')));
                      },
                    ),
                  );
                },
                separatorBuilder: (_, __) => const Divider(height: 1),
                itemCount: docs.length,
              );
            },
          ),
        ),
      ],
    );
  }

  void _openCreateShowtimeDialog(BuildContext context, FirebaseFirestore fs) {
    final movieIdCtrl = TextEditingController();
    final cinemaIdCtrl = TextEditingController();
    final formatCtrl = TextEditingController(text: '2D');
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: const Text('Thêm Showtime'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(controller: movieIdCtrl, decoration: const InputDecoration(labelText: 'Movie ID')),
              TextField(controller: cinemaIdCtrl, decoration: const InputDecoration(labelText: 'Cinema ID')),
              TextField(controller: formatCtrl, decoration: const InputDecoration(labelText: 'Format')),
            ],
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Huỷ')),
            ElevatedButton(
              onPressed: () async {
                final movieId = movieIdCtrl.text.trim();
                final cinemaId = cinemaIdCtrl.text.trim();
                final format = formatCtrl.text.trim();
                await fs.collection('showtimes').add({
                  'movieId': movieId,
                  'cinemaId': cinemaId,
                  'format': format,
                  'createdAt': FieldValue.serverTimestamp(),
                });
                if (context.mounted) {
                  Navigator.pop(ctx);
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Đã thêm showtime')));
                }
              },
              child: const Text('Lưu'),
            ),
          ],
        );
      },
    );
  }
}