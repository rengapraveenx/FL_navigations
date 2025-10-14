import 'package:flutter/material.dart';

// This file contains examples for all advanced stack management methods.
// The main screen acts as a menu to navigate to each specific example.

// --- The Main Menu for this Lesson ---

class StackManagementScreen extends StatelessWidget {
  const StackManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nav 1.0: Stack Management'),
      ),
      body: ListView(
        children: [
          _buildMenuItem(
            context,
            'pushReplacement',
            'Replaces the current screen with a new one.',
            const _PushReplacementExample(),
          ),
          _buildMenuItem(
            context,
            'popUntil',
            'Pops screens until a condition is met.',
            const _PopUntilExample(),
          ),
          _buildMenuItem(
            context,
            'pushAndRemoveUntil',
            'Pushes a screen and removes others.',
            const _PushAndRemoveUntilExample(),
          ),
          _buildMenuItem(
            context,
            'removeRoute',
            'Removes a specific screen from the middle of the stack.',
            const _RemoveRouteExample(),
          ),
          // `replace`, `replaceRouteBelow`, and `removeRouteBelow` are less common
          // and more complex to demonstrate visually, but they follow similar principles
          // of targeting a specific route in the stack and modifying it.
        ],
      ),
    );
  }

  Widget _buildMenuItem(
      BuildContext context, String title, String subtitle, Widget screen) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        title: Text(title),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.arrow_forward_ios),
        onTap: () => Navigator.push(
            context, MaterialPageRoute(builder: (context) => screen)),
      ),
    );
  }
}

// --- Example 1: pushReplacement ---

class _PushReplacementExample extends StatelessWidget {
  const _PushReplacementExample();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('pushReplacement')),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            // Use case: Like a splash screen. You go to the home screen,
            // but you can't go back to the splash screen.
            // It pops the current screen and pushes the new one.
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const _FinalScreen(
                title: 'Final Screen',
                message: 'You cannot go back to the previous screen.',
              )),
            );
          },
          child: const Text('Go to Final Screen (and replace this one)'),
        ),
      ),
    );
  }
}

// --- Example 2: popUntil ---

class _PopUntilExample extends StatelessWidget {
  const _PopUntilExample();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('popUntil: Screen 1')),
      body: Center(
        child: ElevatedButton(
          onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const _PopUntilScreenTwo())),
          child: const Text('Go to Screen 2'),
        ),
      ),
    );
  }
}
class _PopUntilScreenTwo extends StatelessWidget {
  const _PopUntilScreenTwo();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('popUntil: Screen 2')),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            // This will pop all screens until it finds the one where the
            // predicate `(route) => route.isFirst` returns true.
            // In a simple flow, this takes you to the app's root.
            // Here, it will take us back to the main lesson menu.
            Navigator.popUntil(context, (route) => route.isFirst);
          },
          child: const Text('Pop back to the very first screen'),
        ),
      ),
    );
  }
}

// --- Example 3: pushAndRemoveUntil ---

class _PushAndRemoveUntilExample extends StatelessWidget {
  const _PushAndRemoveUntilExample();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('pushAndRemoveUntil')),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            // Use Case: Login flow. After logging in, you go to a home screen
            // and clear the entire stack behind it.
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const _FinalScreen(
                title: 'Home Screen',
                message: 'The stack was cleared. You can\'t go back.',
              )),
              // This predicate always returns false, so it removes ALL routes.
              (Route<dynamic> route) => false,
            );
          },
          child: const Text('Simulate Login'),
        ),
      ),
    );
  }
}

// --- Example 4: removeRoute ---

class _RemoveRouteExample extends StatelessWidget {
  const _RemoveRouteExample();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('removeRoute: Screen 1')),
      body: Center(
        child: ElevatedButton(
          onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const _RemoveRouteScreenTwo())),
          child: const Text('Go to Screen 2'),
        ),
      ),
    );
  }
}
class _RemoveRouteScreenTwo extends StatelessWidget {
  const _RemoveRouteScreenTwo();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('removeRoute: Screen 2 (The one to be removed)')),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            // We need a handle to the route to remove it.
            final route = ModalRoute.of(context);
            if (route != null) {
              // Push screen 3, and from screen 3, we will remove screen 2.
              Navigator.push(context, MaterialPageRoute(builder: (context) => _RemoveRouteScreenThree(routeToRemove: route)));
            }
          },
          child: const Text('Go to Screen 3'),
        ),
      ),
    );
  }
}
class _RemoveRouteScreenThree extends StatelessWidget {
  final Route<dynamic> routeToRemove;
  const _RemoveRouteScreenThree({required this.routeToRemove});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('removeRoute: Screen 3')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('From here, we can remove Screen 2 from the stack.'),
            ElevatedButton(
              onPressed: () {
                // This removes the specific route we passed.
                Navigator.removeRoute(context, routeToRemove);
              },
              child: const Text('Remove Screen 2'),
            ),
            const SizedBox(height: 20),
            const Text('Now, when you pop this screen, you will go to Screen 1.'),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Pop this screen'),
            ),
          ],
        ),
      ),
    );
  }
}


// --- A generic final screen for examples ---
class _FinalScreen extends StatelessWidget {
  final String title;
  final String message;
  const _FinalScreen({required this.title, required this.message});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title), automaticallyImplyLeading: false,),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(message, textAlign: TextAlign.center, style: const TextStyle(fontSize: 18)),
        ),
      ),
    );
  }
}