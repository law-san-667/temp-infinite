import 'package:flutter/material.dart';
import 'package:infiniteagent/core/build_context_extension.dart';

class BasicSkeletonItemWidget extends StatelessWidget {
  const BasicSkeletonItemWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: context.width * 0.35,
      margin: const EdgeInsets.symmetric(
        horizontal: 8.0,
        vertical: 6,
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: 15,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SkeletonItemWidget(
                width: context.width * 0.15,
                height: 30,
              ),
              SkeletonItemWidget(
                width: context.width * 0.6,
                height: 30,
              ),
              SkeletonItemWidget(
                width: context.width * 0.1,
                height: 30,
              ),
            ],
          ),
          const SizedBox(
            height: 5,
          ),
          SkeletonItemWidget(
            width: context.width * 0.5,
            height: 30,
          ),
          const SizedBox(
            height: 5,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SkeletonItemWidget(
                height: 30,
                width: context.width * 0.3,
              ),
              SkeletonItemWidget(
                height: 30,
                width: context.width * 0.25,
              ),
              SkeletonItemWidget(
                height: 30,
                width: context.width * 0.2,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class SkeletonItemWidget extends StatelessWidget {
  final double? height, width;

  const SkeletonItemWidget({
    super.key,
    this.height,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      padding: const EdgeInsets.symmetric(
        horizontal: 8.0,
        vertical: 6,
      ),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.04),
        borderRadius: const BorderRadius.all(
          Radius.circular(7),
        ),
      ),
    );
  }
}

class SkeletonViewWidget extends StatelessWidget {
  const SkeletonViewWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 8.0,
        vertical: 6,
      ),
      child: Row(
        children: [
          SkeletonItemWidget(
            width: context.height * 0.17,
            height: context.height * 0.15,
          ),
          const Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SkeletonItemWidget(
                    height: 20,
                    width: 100,
                  ),
                  SizedBox(
                    height: 12,
                  ),
                  SkeletonItemWidget(
                    height: 20,
                    width: 300,
                  ),
                  SizedBox(
                    height: 12,
                  ),
                  SkeletonItemWidget(
                    height: 20,
                    width: 200,
                  ),
                  SizedBox(
                    height: 12,
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

class SkeletonWidget extends StatelessWidget {
  final Axis direction;

  final Widget skeletonItem;
  const SkeletonWidget({
    super.key,
    this.direction = Axis.vertical,
    this.skeletonItem = const SkeletonViewWidget(),
  });

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemBuilder: (context, index) => skeletonItem,
      scrollDirection: direction,
      separatorBuilder: (context, index) => direction == Axis.horizontal
          ? SizedBox(
              width: context.width * 0.04,
            )
          : Divider(
              height: context.height * 0.02,
              thickness: 0.5,
              color: Colors.grey.withOpacity(0.5),
            ),
      itemCount: 6,
    );
  }
}
