import 'package:flutter/material.dart';

class AnimatedFAB extends StatefulWidget {
  final VoidCallback onAddTask;

  const AnimatedFAB({super.key, required this.onAddTask});

  @override
  _AnimatedFABState createState() => _AnimatedFABState();
}

class _AnimatedFABState extends State<AnimatedFAB>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<Color?> _colorAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.3).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    _colorAnimation = ColorTween(
      begin: Colors.deepPurple[700],
      end: Colors.green,
    ).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggleAnimation() {
    if (_controller.isCompleted) {
      _controller.reverse();
    } else {
      _controller.forward();
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _toggleAnimation();
        Future.delayed(const Duration(milliseconds: 200), widget.onAddTask);
      },
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: FloatingActionButton(
              backgroundColor: _colorAnimation.value,
              onPressed: null, // Disabled, action handled in GestureDetector
              child: const Icon(
                Icons.add,
                size: 28,
                color: Colors.white,
              ),
            ),
          );
        },
      ),
    );
  }
}
