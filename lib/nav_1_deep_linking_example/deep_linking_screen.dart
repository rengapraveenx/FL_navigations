import 'package:flutter/material.dart';

/// This screen demonstrates a self-contained example of dynamic routing
/// using `onGenerateRoute`, which is the foundation for deep linking.
class DeepLinkingScreen extends StatelessWidget {
  const DeepLinkingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Deep Link Example',
      initialRoute: '/',
      // Use onGenerateRoute to handle all navigation logic.
      onGenerateRoute: (settings) {
        // The OS would pass a path like '/orders/123' to settings.name
        // when a deep link is clicked.

        if (settings.name != null && settings.name!.startsWith('/orders/')) {
          final orderId = settings.name!.split('/').last;
          return MaterialPageRoute(
            builder: (context) => _OrderDetailsScreen(orderId: orderId),
          );
        }

        // Handle the home route
        if (settings.name == '/') {
          return MaterialPageRoute(builder: (context) => const _ExampleHomeScreen());
        }

        // If the route is unknown, you can show an error page
        return MaterialPageRoute(
          builder: (context) => const Scaffold(
            body: Center(child: Text('404: Page Not Found')),
          ),
        );
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
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context, rootNavigator: true).pop(),
        ),
      ),
      body: Center(
        child: ElevatedButton(
          // This simulates a deep link navigation
          onPressed: () => Navigator.pushNamed(context, '/orders/123'),
          child: const Text('View Order 123 (Simulate Deep Link)'),
        ),
      ),
    );
  }
}

class _OrderDetailsScreen extends StatelessWidget {
  final String orderId;
  const _OrderDetailsScreen({super.key, required this.orderId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Order #$orderId')),
      body: Center(child: Text('Showing details for order ID: $orderId')),
    );
  }
}
