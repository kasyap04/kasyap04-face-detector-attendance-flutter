import 'package:flutter/material.dart';
import 'package:face_attendence/utils/constant.dart';

class MainButton extends StatelessWidget {
  const MainButton({
    super.key,
    required this.name,
    required this.action,
    required this.width,
  });
  final String name;
  final double width;
  final void Function() action;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: Padding(
        padding: const EdgeInsets.all(2),
        child: ElevatedButton(
          onPressed: action,
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.white,
            backgroundColor: primaryColor,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
          ),
          child: Text(name),
        ),
      ),
    );
  }
}
