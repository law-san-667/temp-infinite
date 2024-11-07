import 'package:flutter/material.dart';

import '../../../core/build_context_extension.dart';

class DataConsomationWidget extends StatelessWidget {
  const DataConsomationWidget({
    super.key,
    required this.value,
    required this.type,
  });

  final String value;
  final String type;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: context.width * 0.25,
      height: context.height * 0.11,
      padding: const EdgeInsets.all(5),
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
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text(
            value,
            style: TextStyle(
              fontSize: context.width * 0.045,
              color: context.secondaryColor,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            type,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: context.width * 0.03,
              color: context.thirdColor,
            ),
          ),
        ],
      ),
    );
  }
}
