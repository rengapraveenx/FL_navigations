import 'package:flutter/material.dart';

// A class to hold the arguments passed to the second screen.
class ScreenArguments {
  final String message;

  ScreenArguments(this.message);
}

// The content for the "Named Routes" lesson.
class NamedRoutesScreen extends StatelessWidget {
  const NamedRoutesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/',
      routes: {
        '/': (context) => const _HomeScreen(),
        // Update the route definition to use a builder that extracts arguments.
        _SecondScreen.routeName: (context) => const _SecondScreen(),
      },
    );
  }
}

class _HomeScreen extends StatefulWidget {
  const _HomeScreen();

  @override
  State<_HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<_HomeScreen> {
  final _textController = TextEditingController();

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nav 1.0: Named Routes'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context, rootNavigator: true).pop(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextFormField(
              controller: _textController,
              decoration: const InputDecoration(
                labelText: 'Enter a message for named route',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(
                  context,
                  _SecondScreen.routeName,
                  arguments: ScreenArguments(_textController.text),
                );
              },
              child: const Text('Push to Second Screen'),
            ),
          ],
        ),
      ),
    );
  }
}

class _SecondScreen extends StatelessWidget {
  const _SecondScreen({super.key});

  // Define a route name for easy access.
  static const routeName = '/second';

  @override
  Widget build(BuildContext context) {
    // Extract the arguments from the current ModalRoute settings.
    final args = ModalRoute.of(context)!.settings.arguments as ScreenArguments?;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Second Screen'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              args?.message.isEmpty ?? true
                  ? 'No message was sent'
                  : args!.message,
              style: const TextStyle(fontSize: 18),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Pop Screen'),
            ),
          ],
        ),
      ),
    );
  }
}