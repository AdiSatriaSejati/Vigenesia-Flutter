import 'package:flutter/material.dart';

class AnimatedBottomNavigation extends StatelessWidget {
  final List<IconData> icons;
  final Function(int) onTapChange;
  final int currentIndex;

  const AnimatedBottomNavigation({
    Key? key,
    required this.icons,
    required this.onTapChange,
    required this.currentIndex,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(
          icons.length,
          (index) => IconButton(
            icon: Icon(icons[index]),
            onPressed: () => onTapChange(index),
            color: currentIndex == index
                ? Colors.blue
                : const Color.fromARGB(255, 23, 2, 2),
          ),
        ),
      ),
    );
  }
}
