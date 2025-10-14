import 'package:flutter/material.dart';

// The content for the "Returning Data" lesson.
class DataReturningScreen extends StatefulWidget {
  const DataReturningScreen({super.key});

  @override
  State<DataReturningScreen> createState() => _DataReturningScreenState();
}

class _DataReturningScreenState extends State<DataReturningScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nav 1.0: Returning Data'),
      ),
      body: Center(
        child: ElevatedButton(
          // Make the onPressed method async.
          onPressed: () async {
            // Await the result from Navigator.push.
            final result = await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const _SecondScreen(),
              ),
            );

            // Check for the result and show a SnackBar.
            if (result != null && mounted) {
              ScaffoldMessenger.of(context)
                ..removeCurrentSnackBar()
                ..showSnackBar(SnackBar(content: Text('$result')));
            }
          },
          child: const Text('Go to screen and get data back'),
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
            // Pass a result back when popping the screen.
            Navigator.pop(context, 'Success! Data from second screen.');
          },
          child: const Text('Pop and Return Data'),
        ),
      ),
    );
  }
}
