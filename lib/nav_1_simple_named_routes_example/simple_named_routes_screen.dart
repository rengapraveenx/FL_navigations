
import 'package:flutter/material.dart';

/// This screen demonstrates a self-contained example of simple named routing
/// using the `routes` map in `MaterialApp`.
class SimpleNamedRoutesScreen extends StatelessWidget {
  const SimpleNamedRoutesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // This example uses its own MaterialApp to contain the routing logic.
    return MaterialApp(
      title: 'Simple Named Routes Example',
      // The initialRoute is the entry point of this navigation sub-tree.
      initialRoute: '/',
      // The routes map defines all possible static paths.
      routes: {
        '/': (context) => const _ExampleHomeScreen(),
        '/settings': (context) => const _ExampleSettingsScreen(),
      },
    );
  }
}

// --- Screen Widgets for this Example ---

class _ExampleHomeScreen extends StatelessWidget {
  const _ExampleHomeScreen();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Screen'),
        // Add a back button to exit this sub-app and return to the main lesson menu.
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context, rootNavigator: true).pop(),
        ),
      ),
      body: Center(
        child: ElevatedButton(
          // Use the name to navigate
          onPressed: () => Navigator.pushNamed(context, '/settings'),
          child: const Text('Go to Settings'),
        ),
      ),
    );
  }
}

class _ExampleSettingsScreen extends StatelessWidget {
  const _ExampleSettingsScreen();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: const Center(child: Text('This is the settings page.')),
    );
  }
}
