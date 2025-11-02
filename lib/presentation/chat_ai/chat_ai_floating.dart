import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:cinema_booking/core/configs/theme/app_color.dart';
import 'package:cinema_booking/core/configs/theme/app_font.dart';
import 'package:cinema_booking/common/widgets/space/widget_spacer.dart';
import 'package:cinema_booking/common/widgets/image/shimmer_image.dart';
import 'package:cinema_booking/domain/entities/response/home.dart';
import 'package:cinema_booking/domain/entities/movies/movies.dart';
import 'package:cinema_booking/domain/usecase/home/get_home_data.dart';
import 'package:cinema_booking/service_locator.dart';

class ChatAiFloating extends StatefulWidget {
  const ChatAiFloating({super.key});

  @override
  State<ChatAiFloating> createState() => _ChatAiFloatingState();
}

class _ChatAiFloatingState extends State<ChatAiFloating> {
  bool _isOpen = false;
  final TextEditingController _controller = TextEditingController();
  final List<_ChatMessage> _messages = [];
  Future<HomeEntity>? _homeFuture;

  @override
  void initState() {
    super.initState();
    _homeFuture = _loadHome();
    _messages.add(_ChatMessage(
      isUser: false,
      text:
          'Xin chào! Hãy nói thể loại hoặc cảm xúc bạn muốn xem phim.',
    ));
  }

  Future<HomeEntity> _loadHome() async {
    final either = await sl<GetHomeDataUseCase>().call();
    return either.fold(
      (err) => HomeEntity(
        banners: [],
        genres: [],
        recommendedMovies: [],
        nearbyCinemas: [],
        movieByGenres: [],
      ),
      (home) => home as HomeEntity,
    );
  }

  void _toggle() {
    setState(() {
      _isOpen = !_isOpen;
    });
  }

  void _send() async {
    final text = _controller.text.trim();
    if (text.isEmpty) return;
    if (mounted) {
      setState(() {
        _messages.add(_ChatMessage(isUser: true, text: text));
      });
    }
    _controller.clear();

    try {
      final home = await _homeFuture;
      final suggestions = _recommendMovies(text, home);
      final response = _buildResponse(text, suggestions);
      if (mounted) {
        setState(() {
          _messages.add(
            _ChatMessage(
              isUser: false,
              text: response,
              suggestions: suggestions,
            ),
          );
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _messages.add(
            _ChatMessage(
              isUser: false,
              text: 'Có lỗi khi lấy dữ liệu. Vui lòng thử lại.',
            ),
          );
        });
      }
    }
  }

  List<MovieDetailEntity> _recommendMovies(String query, HomeEntity? home) {
    if (home == null) return [];
    final q = query.toLowerCase();
    final keywordToGenre = {
      'hành động': 'Action',
      'kịch tính': 'Dramatic',
      'sinh tồn': 'Survival',
      'khám phá': 'Explore',
      'khoa học': 'Science',
      'anime': 'Anime',
      'lãng mạn': 'Romance',
      'hài': 'Comedy',
      'kinh dị': 'Horror',
    };

    final selectedGenres = keywordToGenre.entries
        .where((e) => q.contains(e.key))
        .map((e) => e.value)
        .toSet();

    List<MovieDetailEntity> pool = [];
    if (selectedGenres.isEmpty) {
      pool = home.recommendedMovies;
    } else {
      for (final section in home.movieByGenres) {
        final movies =
            section.movies.where((m) => m.genres.any(selectedGenres.contains));
        pool.addAll(movies);
      }
      pool.addAll(home.recommendedMovies
          .where((m) => m.genres.any(selectedGenres.contains)));
    }

    final seen = <String>{};
    final dedup = <MovieDetailEntity>[];
    for (final m in pool) {
      if (!seen.contains(m.detail.id)) {
        seen.add(m.detail.id);
        dedup.add(m);
      }
    }

    dedup.sort((a, b) => b.detail.rate.compareTo(a.detail.rate));
    return dedup.take(3).toList();
  }

  String _buildResponse(String query, List<MovieDetailEntity> suggestions) {
    if (suggestions.isEmpty) {
      return 'Mình chưa tìm thấy gợi ý phù hợp. Hãy thử nêu thể loại hoặc cảm xúc bạn muốn nhé!';
    }
    final names = suggestions.map((m) => m.detail.name).join(', ');
    return 'Dựa trên yêu cầu của bạn, mình đề xuất: $names.';
  }

  void _openMovie(MovieDetailEntity m) {
    context.go('/movie', extra: m);
  }

  @override
  Widget build(BuildContext context) {
    if (!_isOpen) {
      return FloatingActionButton(
        onPressed: _toggle,
        backgroundColor: AppColors.defaultColor,
        child: const Icon(Icons.smart_toy_outlined, color: Colors.white),
      );
    }

    final screenWidth = MediaQuery.of(context).size.width;
    final panelWidth = screenWidth < 400 ? 320.0 : 360.0;
    final panelHeight = 420.0;

    return Container(
      width: panelWidth,
      height: panelHeight,
      decoration: BoxDecoration(
        color: AppColors.darkBackground,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.5),
            blurRadius: 12,
            spreadRadius: 2,
          ),
        ],
        border: Border.all(color: AppColors.gray1.withValues(alpha: 0.3)),
      ),
      child: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: AppColors.black,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
            child: Row(
              children: [
                const Icon(Icons.smart_toy_outlined, color: Colors.white, size: 18),
                WidgetSpacer(width: 8),
                Expanded(
                  child: Text('AI Chat', style: AppFont.medium_white_12),
                ),
                IconButton(
                  onPressed: _toggle,
                  icon: const Icon(Icons.close, color: Colors.white, size: 18),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              ],
            ),
          ),

          // Messages
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final msg = _messages[index];
                return Align(
                  alignment: msg.isUser
                      ? Alignment.centerRight
                      : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 6),
                    padding: const EdgeInsets.all(10),
                    constraints:
                        BoxConstraints(maxWidth: panelWidth - 40),
                    decoration: BoxDecoration(
                      color: msg.isUser
                          ? AppColors.defaultColor
                          : AppColors.black,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          msg.text,
                          style: AppFont.regular_white_12,
                        ),
                        if (msg.suggestions != null &&
                            msg.suggestions!.isNotEmpty) ...[
                          WidgetSpacer(height: 8),
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: msg.suggestions!.map((m) {
                              return GestureDetector(
                                onTap: () => _openMovie(m),
                                child: Container(
                                  width: 150,
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: AppColors.darkBackground,
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(
                                      color: AppColors.gray1
                                          .withValues(alpha: 0.3),
                                    ),
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(8),
                                        child: ShimmerImage(
                                          url: m.detail.thumb,
                                          width: 134,
                                          height: 72,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                      WidgetSpacer(height: 6),
                                      Text(
                                        m.detail.name,
                                        style: AppFont.regular_white_12,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        ],
                      ],
                    ),
                  ),
                );
              },
            ),
          ),

          // Input
          SafeArea(
            child: Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              decoration: BoxDecoration(
                color: AppColors.black,
                border: Border(
                  top: BorderSide(
                    color: AppColors.gray1.withValues(alpha: 0.2),
                  ),
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      style: AppFont.regular_white_12,
                      decoration: InputDecoration(
                        hintText:
                            'Hỏi AI gợi ý phim (ví dụ: hành động, lãng mạn...)',
                        hintStyle:
                            AppFont.regular_gray1_14.copyWith(fontSize: 12),
                        filled: true,
                        fillColor: AppColors.darkBackground,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 8,
                        ),
                      ),
                      onSubmitted: (_) => _send(),
                    ),
                  ),
                  WidgetSpacer(width: 8),
                  IconButton(
                    onPressed: _send,
                    icon: const Icon(Icons.send, color: Colors.white, size: 20),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ChatMessage {
  final bool isUser;
  final String text;
  final List<MovieDetailEntity>? suggestions;
  _ChatMessage({required this.isUser, required this.text, this.suggestions});
}