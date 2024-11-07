import 'package:flutter/cupertino.dart';
import 'package:infiniteagent/core/build_context_extension.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class CustomRefreshHeader extends StatelessWidget {
  const CustomRefreshHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomHeader(
      builder: (context, mode) {
        return SizedBox(
          height: 55.0,
          child: Center(
            child: CupertinoActivityIndicator(
              color: context.primaryColor,
            ),
          ),
        );
      },
    );
  }
}
