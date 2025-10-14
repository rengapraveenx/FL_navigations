import 'package:flutter/material.dart';

// The content for the "Route Arguments" lesson.
class RouteArgumentsScreen extends StatelessWidget {
  const RouteArgumentsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nav 1.0: Route Arguments'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            // When we push the new screen, we can pass along any object
            // as the `arguments`. Here, we're passing a simple String.
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const _SecondScreen(),
                // Step 1: Provide the data to the `arguments` property of the route.
                settings: const RouteSettings(
                  arguments: 'Data sent via route arguments!',
                ),
              ),
            );
          },
          child: const Text('Push screen with arguments'),
        ),
      ),
    );
  }
}

class _SecondScreen extends StatelessWidget {
  const _SecondScreen();

  @override
  Widget build(BuildContext context) {
    // Step 2: Extract the arguments on the new screen.
    // You must use ModalRoute.of(context) to access the current route's settings.
    final String message = ModalRoute.of(context)!.settings.arguments as String;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Second Screen'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Message from arguments:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            // Step 3: Display the extracted data.
            Text(
              message,
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Go Back'),
            ),
          ],
        ),
      ),
    );
  }
}
