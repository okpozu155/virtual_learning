import 'package:flutter/material.dart';

class ResizeHandle extends StatelessWidget {
  final Alignment alignment;
  final VoidCallback? onTap;

  const ResizeHandle({
    super.key,
    required this.alignment,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: alignment,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width: 18,
          height: 18,
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(
              color: Colors.blue,
              width: 2,
            ),
            borderRadius: BorderRadius.circular(9),
            boxShadow: const [
              BoxShadow(
                blurRadius: 3,
                color: Colors.black26,
              ),
            ],
          ),
        ),
      ),
    );
  }
}