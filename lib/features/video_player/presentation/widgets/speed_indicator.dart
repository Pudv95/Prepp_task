import 'package:flutter/material.dart';

class SpeedIndicator extends StatelessWidget {
  final bool isLeftEdge;

  const SpeedIndicator({super.key, required this.isLeftEdge});

  @override
  Widget build(BuildContext context) {
    final speed = isLeftEdge ? "2x" : "0.5x";
    final icon = isLeftEdge ? Icons.fast_forward : Icons.fast_rewind;

    return Positioned(
      top: MediaQuery.of(context).size.height / 2 - 30,
      left: isLeftEdge ? 20 : null,
      right: isLeftEdge ? null : 20,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.5),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: Colors.white),
            const SizedBox(width: 4),
            Text(
              speed,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
