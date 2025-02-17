import 'package:cinema_booking/common/widgets/image/svg_image.dart';
import 'package:cinema_booking/common/widgets/space/widget_spacer.dart';
import 'package:cinema_booking/core/configs/assets/app_vectors.dart';
import 'package:cinema_booking/core/configs/theme/app_font.dart';
import 'package:cinema_booking/presentation/booking/bloc/book_time_slot_bloc.dart';
import 'package:cinema_booking/presentation/booking/bloc/book_time_slot_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class WidgetSearchSortToolbar extends StatefulWidget {
  final String title;

  const WidgetSearchSortToolbar({super.key, required this.title});

  @override
  State<WidgetSearchSortToolbar> createState() => _WidgetSearchSortToolbarState();
}

class _WidgetSearchSortToolbarState extends State<WidgetSearchSortToolbar> {
  late BuildContext _blocContext;
  final TextEditingController _searchController = TextEditingController();
  bool isSearching = false;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      final keyword = _searchController.text;
      if (keyword.isNotEmpty) {
        BlocProvider.of<BookTimeSlotBloc>(_blocContext).add(SearchQueryChanged(keyword: keyword));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<BookTimeSlotBloc, BookTimeSlotState>(
      listener: (context, state) {},
      builder: (context, state) {
        _blocContext = context;
        return Container(
          height: 60,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF9C27B0), Color(0xFFE91E63)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.white.withOpacity(0.1),
                blurRadius: 10,
                spreadRadius: -2,
              ),
            ],
          ),
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: <Widget>[
              InkWell(
                onTap: () => Navigator.pop(context),
                borderRadius: BorderRadius.circular(12),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: MySvgImage(
                    width: 19,
                    height: 16,
                    path: AppVectors.iconBack,
                  ),
                ),
              ),
              Expanded(child: _buildTitle(state)),
              _buildActions(state),
            ],
          ),
        );
      },
    );
  }

  Widget _buildTitle(BookTimeSlotState state) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        color: isSearching ? Colors.white.withValues(alpha: .1) : Colors.transparent,
        boxShadow: isSearching
            ? [
                BoxShadow(
                  color: Colors.black.withOpacity(0.9), // Darker shadow
                  blurRadius: 15,
                  spreadRadius: -5,
                  offset: Offset(0, 6),
                ),
                BoxShadow(
                  color: Colors.black.withOpacity(0.7), // Lighter shadow layer
                  blurRadius: 10,
                  spreadRadius: -3,
                ),
              ]
            : [],
      ),
      padding: EdgeInsets.symmetric(horizontal: 12),
      child: isSearching && state.movieSearchField
          ? TextField(
              controller: _searchController,
              keyboardType: TextInputType.text,
              maxLines: 1,
              autofocus: true,
              textInputAction: TextInputAction.search,
              style: AppFont.regular_white_14,
              decoration: InputDecoration(hintText: 'Search', hintStyle: AppFont.regular_gray4_14),
            )
          : Text(widget.title, style: AppFont.semibold_white_18),
    );
  }

  Widget _buildActions(BookTimeSlotState state) {
    return Row(
      children: <Widget>[
        InkWell(
          onTap: () {
            setState(() {
              isSearching = !isSearching;
              if (!isSearching) _searchController.clear();
            });
            BlocProvider.of<BookTimeSlotBloc>(_blocContext)
                .add(state.movieSearchField ? ClickCloseSearch() : ClickIconSearch());
          },
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: MySvgImage(
              path: state.movieSearchField ? AppVectors.iconClose : AppVectors.iconSearch,
              width: 20,
              height: 20,
            ),
          ),
        ),
        WidgetSpacer(width: 8),
        InkWell(
          onTap: () {
//            BlocProvider.of<BookTimeSlotBloc>(_blocContext).add(ClickIconSort());
          },
          child: MySvgImage(
            path: AppVectors.iconMore,
            width: 20,
            height: 20,
          ),
        ),
        WidgetSpacer(width: 12)
      ],
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
