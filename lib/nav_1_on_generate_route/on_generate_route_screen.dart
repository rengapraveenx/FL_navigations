import 'package:flutter/material.dart';

// This file demonstrates the industry-standard way to handle arguments
// with named routes: the `onGenerateRoute` callback.

// --- Data Model ---
// A simple class to represent the data we want to pass.
class Product {
  final String id;
  final String name;
  const Product({required this.id, required this.name});
}

// --- Main Widget for the Lesson ---
class OnGenerateRouteScreen extends StatelessWidget {
  const OnGenerateRouteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // We don't use the `routes` map.
      // Instead, we provide an `onGenerateRoute` function.
      onGenerateRoute: (settings) {
        // `settings` contains the name and arguments of the route.

        // Logic to handle different routes.
        if (settings.name == '/') {
          return MaterialPageRoute(builder: (context) => const _HomeScreen());
        }

        // Handle the '/product-details' route.
        if (settings.name == '/product-details') {
          // 1. Safely cast the arguments to the expected type.
          final product = settings.arguments as Product?;

          // 2. If arguments are valid, create the screen with the data.
          if (product != null) {
            return MaterialPageRoute(
              builder: (context) {
                // 3. Pass the data to the widget's constructor (type-safe!).
                return _ProductDetailScreen(product: product);
              },
            );
          }
        }

        // If the route is unknown or arguments are invalid, show an error page.
        return MaterialPageRoute(
          builder: (context) => const _ErrorScreen(),
        );
      },
      // The initial route to show.
      initialRoute: '/',
    );
  }
}

// --- Screen Widgets ---

class _HomeScreen extends StatelessWidget {
  const _HomeScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('onGenerateRoute Standard'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context, rootNavigator: true).pop(),
        ),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            // 4. Navigate by name, passing a custom object as an argument.
            Navigator.pushNamed(
              context,
              '/product-details',
              arguments: const Product(id: 'abc-123', name: 'Flutter T-Shirt'),
            );
          },
          child: const Text('View Product Details'),
        ),
      ),
    );
  }
}

class _ProductDetailScreen extends StatelessWidget {
  final Product product;
  const _ProductDetailScreen({required this.product});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(product.name)),
      body: Center(
        child: Text('Product ID: ${product.id}'),
      ),
    );
  }
}

class _ErrorScreen extends StatelessWidget {
  const _ErrorScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Error')),
      body: const Center(
        child: Text('Route not found or arguments were invalid.'),
      ),
    );
  }
}
