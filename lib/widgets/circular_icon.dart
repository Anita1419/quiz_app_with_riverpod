import 'package:flutter/material.dart';
import 'package:quiz_app_with_riverpod/widgets/constants.dart';

class CircularIcon extends StatefulWidget {
  final IconData iconData;
  final Color color;

  const CircularIcon({
    Key? key,
    required this.iconData,
    required this.color,
  }) : super(key: key);

  @override
  State<CircularIcon> createState() => _CircularIconState();
}

class _CircularIconState extends State<CircularIcon> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 24.0,
      width: 24.0,
      decoration: BoxDecoration(
          color: widget.color, shape: BoxShape.circle, boxShadow: boxShadow),
      child: Icon(
        widget.iconData,
        color: Colors.white,
        size: 16.0,
      ),
    );
  }
}
