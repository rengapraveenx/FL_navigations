import 'package:flutter/material.dart';

// The content for the "Named Routes" lesson.
// This widget demonstrates named routes by creating its own MaterialApp.
class NamedRoutesScreen extends StatelessWidget {
  const NamedRoutesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // We don't use `home` with named routes, we use `initialRoute`.
      initialRoute: '/',
      // Define the available routes and their builders.
      routes: {
        // The base route, our home screen.
        '/': (context) => const _HomeScreen(),
        // The second screen route.
        '/second': (context) => const _SecondScreen(),
      },
    );
  }
}

class _HomeScreen extends StatelessWidget {
  const _HomeScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nav 1.0: Named Routes'),
        // Add a back button to exit this sub-app and return to the main menu.
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context, rootNavigator: true).pop(),
        ),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            // Navigate to the second screen using its name.
            Navigator.pushNamed(context, '/second');
          },
          child: const Text('Push using name: /second'),
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
            // Pop the screen as usual.
            Navigator.pop(context);
          },
          child: const Text('Pop Screen'),
        ),
      ),
    );
  }
}
