import 'dart:async';

import 'package:app_links/app_links.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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
final List<Product> productDatabase = List.generate(
  20,
  (index) => Product(
    id: '${index + 1}',
    name: 'Product #${index + 1}',
    description:
        'This is the detailed description for product #${index + 1}. It is a high-quality item.',
    color: Colors.primaries[index % Colors.primaries.length],
  ),
);

// --- Main Entry Point for the Feature ---

class ProductFeatureScreen extends StatefulWidget {
  const ProductFeatureScreen({super.key});

  @override
  State<ProductFeatureScreen> createState() => _ProductFeatureScreenState();
}

class _ProductFeatureScreenState extends State<ProductFeatureScreen> {
  final _navigatorKey = GlobalKey<NavigatorState>();
  // Initialize AppLinks at the point of declaration for safety.
  final _appLinks = AppLinks();
  StreamSubscription<Uri>? _linkSubscription;

  @override
  void initState() {
    super.initState();
    _initDeepLinks();
  }

  @override
  void dispose() {
    _linkSubscription?.cancel();
    super.dispose();
  }

  Future<void> _initDeepLinks() async {
    // Listen for links when the app is already running
    _linkSubscription = _appLinks.uriLinkStream.listen((uri) {
      // ignore: avoid_print
      print('DEEP LINK (running): Received link: $uri');
      _handleDeepLink(uri);
    });

    // Handle the initial link that launched the app
    try {
      final initialUri = await _appLinks.getInitialLink();
      //getInitialAppLink
      if (initialUri != null) {
        // ignore: avoid_print
        print('DEEP LINK (initial): Received link: $initialUri');
        // Use a post-frame callback to ensure the navigator is ready
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) {
            _handleDeepLink(initialUri);
          }
        });
      }
    } on PlatformException {
      // ignore: avoid_print
      print('DEEP LINK (initial): Failed to get initial link.');
    }
  }

  void _handleDeepLink(Uri uri) {
    if (uri.host == 'products' && uri.pathSegments.isNotEmpty) {
      final productId = uri.pathSegments.first;
      // ignore: avoid_print
      print('DEEP LINK HANDLER: Navigating to /products/$productId');
      _navigatorKey.currentState?.pushNamed('/products/$productId');
    } else {
      // ignore: avoid_print
      print('DEEP LINK HANDLER: URI did not match expected format: $uri');
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: _navigatorKey,
      initialRoute: '/',
      onGenerateRoute: (settings) {
        if (settings.name == '/') {
          return MaterialPageRoute(
            builder: (context) => const _ProductListScreen(),
          );
        }

        if (settings.name != null && settings.name!.startsWith('/products/')) {
          final productId = settings.name!.split('/').last;
          final product = productDatabase.firstWhere(
            (p) => p.id == productId,
            orElse: () => const Product(
              id: '-1',
              name: 'Not Found',
              description: '',
              color: Colors.grey,
            ),
          );

          if (product.id == '-1') {
            return MaterialPageRoute(
              builder: (context) =>
                  const _ErrorScreen(message: 'Product not found'),
            );
          }

          return MaterialPageRoute(
            builder: (context) => _ProductDetailScreen(product: product),
          );
        }

        return MaterialPageRoute(
          builder: (context) => const _ErrorScreen(message: 'Unknown route'),
        );
      },
    );
  }
}

// --- Screen Widgets (No changes needed here) ---

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
      appBar: AppBar(backgroundColor: product.color, title: Text(product.name)),
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
        child: Text(
          message,
          style: const TextStyle(color: Colors.red, fontSize: 18),
        ),
      ),
    );
  }
}
