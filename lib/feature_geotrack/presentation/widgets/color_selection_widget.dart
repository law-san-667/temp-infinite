import 'package:flutter/material.dart';
import 'package:infiniteagent/feature_geotrack/presentation/controllers/map_page_controller.dart';
import 'package:provider/provider.dart';

class ColorSelectionWidget extends StatelessWidget {
  const ColorSelectionWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    MapPageController controller = context.read<MapPageController>();
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            ElevatedButton(
              onPressed: () {
                controller.polygonsList.last.color = Colors.red;
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                padding: const EdgeInsets.all(20),
              ),
              child: const Icon(
                Icons.check,
                color: Colors.white,
              ),
            ),
            ElevatedButton(
              onPressed: () {
                controller.polygonsList.last.color = Colors.blue;
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                padding: const EdgeInsets.all(20),
              ),
              child: const Icon(
                Icons.check,
                color: Colors.white,
              ),
            ),
            ElevatedButton(
              onPressed: () {
                controller.polygonsList.last.color = Colors.green;
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                padding: const EdgeInsets.all(20),
              ),
              child: const Icon(
                Icons.check,
                color: Colors.white,
              ),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            ElevatedButton(
              onPressed: () {
                controller.polygonsList.last.color = Colors.yellow;
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.yellow,
                padding: const EdgeInsets.all(20),
              ),
              child: const Icon(
                Icons.check,
                color: Colors.white,
              ),
            ),
            ElevatedButton(
              onPressed: () {
                controller.polygonsList.last.color = Colors.purple;
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.purple,
                padding: const EdgeInsets.all(20),
              ),
              child: const Icon(
                Icons.check,
                color: Colors.white,
              ),
            ),
            ElevatedButton(
              onPressed: () {
                controller.polygonsList.last.color = Colors.orange;
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                padding: const EdgeInsets.all(20),
              ),
              child: const Icon(
                Icons.check,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
