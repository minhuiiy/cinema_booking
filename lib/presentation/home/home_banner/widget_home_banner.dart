import 'package:carousel_slider/carousel_slider.dart';
import 'package:cinema_booking/common/widgets/image/shimmer_image.dart';
import 'package:cinema_booking/core/configs/theme/app_color.dart';
import 'package:cinema_booking/presentation/home/home_banner/bloc/home_banner_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class WidgetHomeBanner extends StatefulWidget {
  const WidgetHomeBanner({super.key});

  @override
  State<WidgetHomeBanner> createState() => _WidgetHomeBannerState();
}

class _WidgetHomeBannerState extends State<WidgetHomeBanner> {
  var currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeBannerBloc, HomeBannerState>(
      builder: (context, state) {
        if (state is HomeBannerLoaded) {
          return Column(
            children: [
              _buildCarouselSlider(state),
              const SizedBox(height: 12),
              _buildIndicators(state),
            ],
          );
        } else {
          return Container();
        }
      },
    );
  }

  /// 🎬 **Slider có khoảng cách giữa các banner**
  Widget _buildCarouselSlider(HomeBannerLoaded state) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12), // Cách trên & dưới nhẹ
      child: CarouselSlider.builder(
        itemCount: state.banners.length,
        itemBuilder: (context, index, realIndex) {
          return ClipRRect(
            borderRadius: BorderRadius.circular(16), // Bo góc
            child: Stack(
              children: [
                ShimmerImage(
                  url: state.banners[index].url,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: 180, // Chiều cao chuẩn giống ảnh mẫu
                ),
                // Overlay mờ phía dưới để cinematic hơn
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: [
                        Colors.black.withOpacity(0.5),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
        options: CarouselOptions(
          height: 180, // Giống ảnh mẫu
          viewportFraction: 0.80, // Giữ khoảng cách nhỏ giữa banner
          enlargeCenterPage: true, // Hiệu ứng focus vào slide chính
          enableInfiniteScroll: true,
          autoPlay: true,
          autoPlayInterval: const Duration(seconds: 3),
          autoPlayAnimationDuration: const Duration(milliseconds: 800),
          autoPlayCurve: Curves.fastLinearToSlowEaseIn,
          onPageChanged: (index, reason) {
            setState(() {
              currentIndex = index;
            });
          },
        ),
      ),
    );
  }

  /// 🎯 **Indicator giống ảnh mẫu**
  Widget _buildIndicators(HomeBannerLoaded state) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(state.banners.length, (index) {
        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          width: currentIndex == index ? 18 : 8, // Hình viên thuốc khi active
          height: 8,
          margin: const EdgeInsets.symmetric(horizontal: 4),
          decoration: BoxDecoration(
            color: currentIndex == index ? AppColors.white : AppColors.white.withOpacity(0.3),
            borderRadius: BorderRadius.circular(4), // Bo góc thành viên thuốc
          ),
        );
      }),
    );
  }
}
