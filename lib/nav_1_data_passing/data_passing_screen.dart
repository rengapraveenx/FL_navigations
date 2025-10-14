import 'package:flutter/material.dart';

// The content for the "Passing Data" lesson.
class DataPassingScreen extends StatelessWidget {
  const DataPassingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nav 1.0: Passing Data'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                // Pass data to the SecondScreen constructor.
                builder: (context) => const _SecondScreen(message: 'Hello from the first screen!'),
              ),
            );
          },
          child: const Text('Go to Second Screen'),
        ),
      ),
    );
  }
}

class _SecondScreen extends StatelessWidget {
  // 1. Add a final field to hold the data.
  final String message;

  // 2. Update the constructor to accept the data.
  const _SecondScreen({required this.message});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Second Screen'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // 3. Display the received data.
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
