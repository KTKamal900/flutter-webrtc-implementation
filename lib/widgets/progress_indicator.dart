import 'package:flutter/material.dart';

class ProgressIndicatorr extends StatelessWidget {
  const ProgressIndicatorr({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Center(
              child: SizedBox(
                  width: 30, height: 30, child: CircularProgressIndicator())),
        ],
      ),
    );
  }
}
