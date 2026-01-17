import 'package:flutter/material.dart';

class DotsIndicator extends StatelessWidget {
  final int currentIndex;
  final int total;

  const DotsIndicator({
    super.key,
    required this.currentIndex,
    required this.total,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(total, (index) {
        final isActive = index == currentIndex;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          margin: const EdgeInsets.only(right: 6),
          width: isActive ? 16 : 6,
          height: 6,
          decoration: BoxDecoration(
            color: isActive ? const Color(0xFFFF0055) : Colors.grey.shade300,
            borderRadius: BorderRadius.circular(6),
          ),
        );
      }),
    );
  }
}
