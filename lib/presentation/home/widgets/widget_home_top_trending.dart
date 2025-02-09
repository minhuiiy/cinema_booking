import 'package:flutter/material.dart';

class WidgetContinueWatching extends StatelessWidget {
  final List<Movie> movies;

  const WidgetContinueWatching({super.key, required this.movies});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildHeader(context),
        const SizedBox(height: 8),
        _buildMovieList(),
      ],
    );
  }

  /// Tiêu đề + "View All"
  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text("Continue Watching",
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              )),
          Text("View All", style: TextStyle(color: Colors.redAccent, fontSize: 14)),
        ],
      ),
    );
  }

  /// Danh sách phim dạng horizontal scroll
  Widget _buildMovieList() {
    return SizedBox(
      height: 160, // Tăng chiều cao để ảnh không bị ngắn
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: movies.length,
        padding: const EdgeInsets.only(left: 16),
        itemBuilder: (context, index) {
          final movie = movies[index];
          return Padding(
            padding: const EdgeInsets.only(right: 12), // Khoảng cách giữa các item
            child: _buildMovieItem(movie, index == 0 || index == movies.length - 1),
          );
        },
      ),
    );
  }

  /// Một item trong danh sách phim với hiệu ứng cinematic
  Widget _buildMovieItem(Movie movie, bool isEdge) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Stack(
                children: [
                  Image.network(movie.imageUrl,
                      width: 180, // Đúng kích thước ảnh mẫu
                      height: 120,
                      fit: BoxFit.cover),
                  // Hiệu ứng làm mờ đen khi ở mép màn hình
                  if (isEdge)
                    Positioned.fill(
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: isEdge ? Alignment.centerLeft : Alignment.centerRight,
                            end: isEdge ? Alignment.centerRight : Alignment.centerLeft,
                            colors: [
                              Colors.black.withOpacity(0.6),
                              Colors.transparent,
                            ],
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            // Thanh tiến trình xem
            Positioned(
              bottom: 6,
              left: 10,
              right: 10,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: Container(
                  height: 4, // Giảm chiều cao thanh progress đúng như ảnh mẫu
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.3), // Nền thanh progress
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: FractionallySizedBox(
                    alignment: Alignment.centerLeft,
                    widthFactor: movie.progress, // Tiến trình xem
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.redAccent,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        Padding(
          padding: const EdgeInsets.only(left: 4),
          child: Text(
            movie.title,
            style: TextStyle(color: Colors.white, fontSize: 14),
          ),
        ),
      ],
    );
  }
}

/// Model dữ liệu phim
class Movie {
  final String title;
  final String imageUrl;
  final double progress; // Tiến trình xem (0.0 - 1.0)

  Movie({required this.title, required this.imageUrl, required this.progress});
}
