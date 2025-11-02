/*
 * @ Author: Chung Nguyen Thanh <chunhthanhde.dev@gmail.com>
 * @ Created: 2024-12-21 21:28:06
 * @ Message: 🎯 Happy coding and Have a nice day! 🌤️
 */

import 'package:cinema_booking/core/configs/theme/app_color.dart';
import 'package:cinema_booking/core/configs/theme/app_font.dart';
import 'package:cinema_booking/presentation/all_movies/sc_all_movies.dart';
import 'package:cinema_booking/presentation/all_tickets/screen_all_tickets.dart';
import 'package:cinema_booking/presentation/home/bloc/home_bloc.dart';
import 'package:cinema_booking/presentation/home/home_content_main.dart';
import 'package:cinema_booking/presentation/chat_ai/chat_ai_floating.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  bool? _isAdmin;

  /// List of screens for navigation
  final List<Widget> _pages = [
    HomeContentScreen(), // Home
    AllMoviesScreen(), // Search
    ListTicketsScreen(), // love
    SizedBox(),
  ];

  void _onItemTapped(int index) {
    if (index == 3) {
      context.go('/user');
    } else {
      setState(() {
        _selectedIndex = index;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    BlocProvider.of<HomeBloc>(context).add(LoadHome());
    _checkAdminClaims();
  }

  Future<void> _checkAdminClaims() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        setState(() => _isAdmin = false);
        return;
      }
      final token = await user.getIdTokenResult(true);
      final claims = token.claims ?? {};
      final isAdmin = claims['admin'] == true || claims['role'] == 'admin';
      if (mounted) setState(() => _isAdmin = isAdmin);
    } catch (_) {
      if (mounted) setState(() => _isAdmin = false);
    }
  }

  Widget _buildBottomNavigationBar() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.black,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: BottomNavigationBar(
        backgroundColor: AppColors.darkBackground,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: AppColors.defaultColor,
        unselectedItemColor: AppColors.gray1.withValues(alpha: 0.6),
        showSelectedLabels: false,
        showUnselectedLabels: false,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        elevation: 0,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home, size: 28),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search, size: 28),
            label: "Search",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite, size: 28),
            label: "Favorites",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle, size: 28),
            label: "Profile",
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            _pages[_selectedIndex],
            if (_selectedIndex == 0)
              Positioned(
                right: 16,
                bottom: 16,
                child: ChatAiFloating(),
              ),
            if (_selectedIndex == 0 && (_isAdmin == true))
              Positioned(
                right: 16,
                bottom: 86,
                child: FloatingActionButton(
                  tooltip: 'Mở Admin Dashboard',
                  onPressed: () => context.go('/admin'),
                  child: const Icon(Icons.admin_panel_settings),
                ),
              ),
          ],
        ), // overlay chat on Home
        bottomNavigationBar: _buildBottomNavigationBar(),
        // Remove navigating FAB, chat is now embedded on Home
      ),
    );
  }
}
