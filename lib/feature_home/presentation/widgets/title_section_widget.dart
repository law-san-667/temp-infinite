import 'package:flutter/material.dart';

import '../../../core/build_context_extension.dart';

class TitleSectionWidget extends StatelessWidget {
  const TitleSectionWidget({
    super.key,
    required this.text,
    this.style,
    this.color,
  });

  final String text;
  final Color? color;
  final TextStyle? style;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: context.width,
      constraints: BoxConstraints(
        minHeight: context.height * 0.1,
      ),
      // color: context.white,
      child: Padding(
        padding: const EdgeInsets.only(
          left: 8.0,
          bottom: 8,
        ),
        child: Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: Text(
              text,
              style: style ??
                  TextStyle(
                    color: color ?? context.primaryColor,
                    fontSize: context.width * 0.05,
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ),
        ),
      ),
    );
  }
}

class CustomListTileWidget extends StatelessWidget {
  final String title;

  final String subtitle;
  final Widget trailing;
  final double? titleSize;
  final double? subtitleSize;
  const CustomListTileWidget({
    super.key,
    required this.title,
    required this.subtitle,
    required this.trailing,
    this.titleSize,
    this.subtitleSize,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
        top: context.height * 0.01,
        left: context.width * 0.04,
        right: context.width * 0.04,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                title,
                style: TextStyle(
                  color: context.black,
                  fontSize: titleSize ?? context.width * 0.03,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Roboto',
                ),
              ),
              Visibility(
                visible: subtitle.isNotEmpty,
                child: Text(
                  subtitle,
                  style: TextStyle(
                    color: context.black,
                    fontSize: subtitleSize ?? context.width * 0.025,
                    fontWeight: FontWeight.w200,
                    fontFamily: 'Roboto',
                  ),
                ),
              ),
            ],
          ),
          trailing,
        ],
      ),
    );
  }
}

