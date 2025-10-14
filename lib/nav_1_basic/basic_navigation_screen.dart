import 'package:flutter/material.dart';

// The content for the "Basic Navigation" lesson.
class BasicNavigationScreen extends StatelessWidget {
  const BasicNavigationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nav 1.0: Basic Push/Pop'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            // Push a new screen onto the stack.
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const _SecondScreen()),
            );
          },
          child: const Text('Push Second Screen'),
        ),
      ),
    );
  }
}

class _SecondScreen extends StatelessWidget {
  const _SecondScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Second Screen'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            // Pop this screen off the stack.
            Navigator.pop(context);
          },
          child: const Text('Pop Screen'),
        ),
      ),
    );
  }
}
