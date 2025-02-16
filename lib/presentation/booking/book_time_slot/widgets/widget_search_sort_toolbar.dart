import 'package:cinema_booking/common/widgets/image/svg_image.dart';
import 'package:cinema_booking/common/widgets/space/widget_spacer.dart';
import 'package:cinema_booking/core/configs/assets/app_vectors.dart';
import 'package:cinema_booking/core/configs/theme/app_color.dart';
import 'package:cinema_booking/core/configs/theme/app_font.dart';
import 'package:cinema_booking/presentation/booking/book_time_slot/bloc/book_time_slot_bloc.dart';
import 'package:cinema_booking/presentation/booking/book_time_slot/bloc/book_time_slot_state.dart';
import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

//TODO: duplicate with WidgetAllShowsToolbar. should refactor into one
class WidgetSearchSortToolbar extends StatefulWidget {
  final String title;

  const WidgetSearchSortToolbar({
    required this.title,
  });

  @override
  State<WidgetSearchSortToolbar> createState() => _WidgetSearchSortToolbarState();
}

class _WidgetSearchSortToolbarState extends State<WidgetSearchSortToolbar> {
  late BuildContext _blocContext;

  final TextEditingController _searchController = TextEditingController();

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
          color: AppColors.blue,
          height: 50,
          child: Row(
            children: <Widget>[
              InkWell(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Padding(
                  padding: const EdgeInsets.only(left: 12, right: 10),
                  child: MySvgImage(
                    width: 19,
                    height: 16,
                    path: AppVectors.iconBack,
                  ),
                ),
              ),
              Expanded(
                child: _buildTitle(state),
              ),
              _buildActions(state),
            ],
          ),
        );
      },
    );
  }

  _buildActions(BookTimeSlotState state) {
    return Row(
      children: <Widget>[
        InkWell(
          onTap: () {
            BlocProvider.of<BookTimeSlotBloc>(_blocContext)
                .add(state.movieSearchField ? ClickCloseSearch() : ClickIconSearch());
          },
          child: MySvgImage(
            path: state.movieSearchField ? "assets/ic_close.svg" : "assets/ic_search.svg",
            width: 20,
            height: 20,
          ),
        ),
        WidgetSpacer(width: 12),
        InkWell(
          onTap: () {
//            BlocProvider.of<BookTimeSlotBloc>(_blocContext).add(ClickIconSort());
          },
          child: MySvgImage(
            path: "assets/ic_more.svg",
            width: 20,
            height: 20,
          ),
        ),
        WidgetSpacer(width: 12)
      ],
    );
  }

  _buildTitle(BookTimeSlotState state) {
    if (state.movieSearchField) {
      return TextField(
        controller: _searchController,
        keyboardType: TextInputType.text,
        maxLines: 1,
        autofocus: true,
        textInputAction: TextInputAction.search,
        style: AppFont.regular_white_14,
        decoration: InputDecoration(hintText: 'Search', hintStyle: AppFont.regular_gray4_14),
      );
    } else {
      return Text(widget.title, style: AppFont.medium_white_16);
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
