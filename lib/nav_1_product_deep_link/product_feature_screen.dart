import 'package:flutter/material.dart';

// --- Data Model ---
@immutable
class Product {
  final String id;
  final String name;
  final String description;
  final Color color;

  const Product({
    required this.id,
    required this.name,
    required this.description,
    required this.color,
  });
}

// --- Data Source ---
// A hardcoded list of 20 products for our example.
final List<Product> productDatabase = List.generate(
  20,
  (index) => Product(
    id: '${index + 1}',
    name: 'Product #${index + 1}',
    description: 'This is the detailed description for product #${index + 1}. It is a high-quality item.',
    color: Colors.primaries[index % Colors.primaries.length],
  ),
);

// --- Main Entry Point for the Feature ---

/// A self-contained feature demonstrating a product list and detail screen
/// that can be opened via a deep link like `navigations://products/5`.
class ProductFeatureScreen extends StatelessWidget {
  const ProductFeatureScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/',
      onGenerateRoute: (settings) {
        // --- This is the core routing logic ---

        // Handle the root route (`/`)
        if (settings.name == '/') {
          return MaterialPageRoute(
            builder: (context) => const _ProductListScreen(),
          );
        }

        // Handle routes like `/products/1`, `/products/2`, etc.
        if (settings.name != null && settings.name!.startsWith('/products/')) {
          final productId = settings.name!.split('/').last;
          // Find the product in our dummy database.
          final product = productDatabase.firstWhere(
            (p) => p.id == productId,
            orElse: () => const Product(id: '-1', name: 'Not Found', description: '', color: Colors.grey),
          );

          // If the product was not found, show an error screen.
          if (product.id == '-1') {
            return MaterialPageRoute(
              builder: (context) => const _ErrorScreen(message: 'Product not found'),
            );
          }

          // If the product is found, show its detail screen.
          return MaterialPageRoute(
            builder: (context) => _ProductDetailScreen(product: product),
          );
        }

        // If the route is unknown, show a generic error screen.
        return MaterialPageRoute(
          builder: (context) => const _ErrorScreen(message: 'Unknown route'),
        );
      },
    );
  }
}

// --- Screen Widgets ---

class _ProductListScreen extends StatelessWidget {
  const _ProductListScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Product Catalog'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context, rootNavigator: true).pop(),
        ),
      ),
      body: ListView.builder(
        itemCount: productDatabase.length,
        itemBuilder: (context, index) {
          final product = productDatabase[index];
          return ListTile(
            leading: CircleAvatar(backgroundColor: product.color),
            title: Text(product.name),
            onTap: () {
              // When a product is tapped, navigate using its named route.
              // This is the same path a deep link would use.
              Navigator.pushNamed(context, '/products/${product.id}');
            },
          );
        },
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
      appBar: AppBar(
        backgroundColor: product.color,
        title: Text(product.name),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Details for ${product.name}',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 20),
              Text(
                product.description,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ErrorScreen extends StatelessWidget {
  final String message;
  const _ErrorScreen({required this.message});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Error')),
      body: Center(
        child: Text(message, style: const TextStyle(color: Colors.red, fontSize: 18)),
      ),
    );
  }
}
