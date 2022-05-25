import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CircleProgreesIndicator extends StatelessWidget {
  const CircleProgreesIndicator({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }
}
