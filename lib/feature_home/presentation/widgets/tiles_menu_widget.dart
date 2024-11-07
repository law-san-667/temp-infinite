import 'package:flutter/material.dart';

import '../../../core/build_context_extension.dart';

class TilesMenuWidget extends StatefulWidget {
  const TilesMenuWidget({
    super.key,
    required this.menuItems,
    required this.onTap,
    required this.height,
    required this.fontSize,
    required this.width,
  });
  final List<String> menuItems;
  final Function(int) onTap;
  final double height;
  final double fontSize;
  final double width;

  @override
  State<TilesMenuWidget> createState() => _TilesMenuWidgetState();
}

class _TilesMenuWidgetState extends State<TilesMenuWidget> {
  int selectedIndex = 0;
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        height: widget.height,
        width: widget.width,
        color: context.white,
        child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: widget.menuItems.length,
            itemBuilder: (context, index) => InkWell(
                  onTap: () {
                    setState(() {
                      selectedIndex = index;
                      widget.onTap(index);
                    });
                  },
                  child: Container(
                    margin: EdgeInsets.symmetric(
                      horizontal: context.height * 0.02,
                    ),
                    decoration: selectedIndex == index
                        ? BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                color: context.primaryColor,
                                width: 1,
                              ),
                            ),
                          )
                        : null,
                    child: Center(
                      child: Text(
                        widget.menuItems[index],
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: widget.fontSize,
                          fontFamily: 'Roboto',
                          color: selectedIndex == index
                              ? context.black
                              : Colors.grey,
                        ),
                      ),
                    ),
                  ),
                )),
      ),
    );
  }
}
