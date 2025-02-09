/*
 * @ Author: Chung Nguyen Thanh <chunhthanhde.dev@gmail.com>
 * @ Created: 2024-12-22 08:23:02
 * @ Message: 🎯 Happy coding and Have a nice day! 🌤️
 */

import 'package:flutter/material.dart';

///
/// A horizontally scrolling list view that wraps its content,
/// supporting item and optional separator widgets.
///
class WrapContentHozListView<T> extends StatefulWidget {
  /// The list of data items to be displayed.
  final List<T> list;

  /// Builder function for constructing each item widget.
  /// - Takes `BuildContext` and the index of the item.
  /// - Returns a `Widget` representing the item.
  final IndexedWidgetBuilder itemBuilder;

  /// Optional builder function for constructing separator widgets.
  /// - Placed between items when provided.
  /// - Takes `BuildContext` and the index of the item before it.
  /// - Returns a `Widget` representing the separator.
  final IndexedWidgetBuilder? separatorBuilder;

  const WrapContentHozListView({
    super.key,
    required this.list,
    required this.itemBuilder,
    this.separatorBuilder,
  });

  @override
  State<WrapContentHozListView> createState() => _WrapContentHozListViewState();
}

class _WrapContentHozListViewState extends State<WrapContentHozListView> {
  /// Generates the list of widgets by interleaving items and separators.
  /// - Uses `List.generate()` for efficient item generation.
  /// - Ensures separators are added between items when `separatorBuilder` is provided.
  List<Widget> _generateItemWidgets() {
    List<Widget> items = [];
    for (int i = 0; i < widget.list.length; i++) {
      items.add(widget.itemBuilder(context, i));
      if (widget.separatorBuilder != null) {
        items.add(widget.separatorBuilder!(context, i));
      }
    }

    return items;
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: BouncingScrollPhysics(),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: _generateItemWidgets(),
      ),
    );
  }
}
