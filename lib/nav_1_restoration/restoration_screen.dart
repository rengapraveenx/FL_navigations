import 'package:flutter/material.dart';

// The content for the "State Restoration" lesson.
// This entire widget is a self-contained app to demonstrate restoration.
class RestorationScreen extends StatelessWidget {
  const RestorationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      // 1. Add a restorationScopeId to the MaterialApp.
      // This ID is used to save and restore the state of the navigator.
      restorationScopeId: 'app',
      home: _RestorableHomeScreen(),
    );
  }
}

class _RestorableHomeScreen extends StatefulWidget {
  const _RestorableHomeScreen();

  @override
  State<_RestorableHomeScreen> createState() => _RestorableHomeScreenState();
}

// 2. Use the RestorationMixin to make the State restorable.
class _RestorableHomeScreenState extends State<_RestorableHomeScreen> with RestorationMixin {

  // 3. Create restorable properties for any state you want to save.
  // Here, we save a simple counter.
  final RestorableInt _counter = RestorableInt(0);

  @override
  // 4. Provide a restorationId for the State.
  String? get restorationId => 'home_screen';

  @override
  void restoreState(RestorationBucket? oldBucket, bool initialRestore) {
    // 5. Register your restorable properties.
    registerForRestoration(_counter, 'counter');
  }

  @override
  void dispose() {
    _counter.dispose();
    super.dispose();
  }

  void _incrementCounter() {
    setState(() {
      _counter.value++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Restorable Navigation'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context, rootNavigator: true).pop(),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '${_counter.value}',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // 6. Use `restorablePush` to navigate.
                // This requires a static method that returns a restorable Route.
                Navigator.restorablePush(context, _restorableSecondScreenRoute);
              },
              child: const Text('Push Restorable Route'),
            ),
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                'To test: run this, increment the counter, navigate to the second screen, then hot restart the app (NOT hot reload). The counter state and the navigation stack should be restored.',
                textAlign: TextAlign.center,
              ),
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }

  // 7. Define a static method that creates the restorable route.
  // This method must be static or a top-level function.
  static Route<void> _restorableSecondScreenRoute(BuildContext context, Object? arguments) {
    return MaterialPageRoute(builder: (context) => const _SecondScreen());
  }
}

class _SecondScreen extends StatelessWidget {
  const _SecondScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Second Restorable Screen'),
      ),
      body: const Center(
        child: Text('This screen can also be restored.'),
      ),
    );
  }
}
