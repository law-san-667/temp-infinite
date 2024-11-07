import 'package:flutter/material.dart';

import '../../../core/build_context_extension.dart';

class BoxesMenuWidget extends StatefulWidget {
  const BoxesMenuWidget({
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
  State<BoxesMenuWidget> createState() => _BoxesMenuWidgetState();
}

class _BoxesMenuWidgetState extends State<BoxesMenuWidget> {
  int selectedIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.height,
      width: widget.width,
      decoration: BoxDecoration(
        color: context.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 5,
            blurRadius: 7,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: ListView.separated(
        itemCount: widget.menuItems.length,
        scrollDirection: Axis.horizontal,
        separatorBuilder: (context, index) {
          return VerticalDivider(
            color: context.thirdColor,
            thickness: 1,
            // indent: 5,
            // endIndent: 5,
            width: 0,
          );
        },
        itemBuilder: (context, index) => InkWell(
          onTap: () {
            setState(() {
              selectedIndex = index;
              widget.onTap(index);
            });
          },
          child: Container(
            width: widget.width / widget.menuItems.length,
            decoration: BoxDecoration(
              color: selectedIndex == index
                  ? context.thirdColor
                  : Colors.transparent,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(
                  index == 0 ? 10 : 0,
                ), //if first add left bottom&top radius
                bottomLeft: Radius.circular(
                  index == 0 ? 10 : 0,
                ), //if first add left bottom&top radius
                topRight: Radius.circular(
                  index == widget.menuItems.length - 1 ? 10 : 0,
                ), //if last add right bottom&top radius
                bottomRight: Radius.circular(
                  index == widget.menuItems.length - 1 ? 10 : 0,
                ),
              ),
            ),
            child: Center(
              child: Text(
                widget.menuItems[index],
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: widget.fontSize,
                  color: selectedIndex == index
                      ? context.white
                      : context.thirdColor,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
