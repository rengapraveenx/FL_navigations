import 'package:flutter/material.dart';
import 'package:navigations/nav_1_basic/basic_navigation_screen.dart';
import 'package:navigations/nav_1_data_passing/data_passing_screen.dart';
import 'package:navigations/nav_1_data_returning/data_returning_screen.dart';
import 'package:navigations/nav_1_named_routes/named_routes_screen.dart';
import 'package:navigations/nav_1_on_generate_route/on_generate_route_screen.dart';
import 'package:navigations/nav_1_restoration/restoration_screen.dart';
import 'package:navigations/nav_1_route_arguments/route_arguments_screen.dart';
import 'package:navigations/nav_1_stack_management/stack_management_screen.dart';

import 'package:navigations/nav_1_deep_linking_example/deep_linking_screen.dart';
import 'package:navigations/nav_1_simple_named_routes_example/simple_named_routes_screen.dart';
import 'package:navigations/nav_1_product_deep_link/product_feature_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Navigation Examples',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MainMenu(),
    );
  }
}

class MainMenu extends StatelessWidget {
  const MainMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter Navigation Lessons'),
      ),
      body: ListView(
        children: [
          _buildMenuItem(
            context,
            title: '1. Nav 1.0: Basic Push and Pop',
            subtitle: 'The fundamentals of imperative navigation.',
            screen: const BasicNavigationScreen(),
          ),
          _buildMenuItem(
            context,
            title: '2. Nav 1.0: Passing Data (Constructor)',
            subtitle: 'Type-safe method to send data to a new screen.',
            screen: const DataPassingScreen(),
          ),
          _buildMenuItem(
            context,
            title: '3. Nav 1.0: Passing Data (Arguments)',
            subtitle: 'Flexible, non-type-safe method using arguments.',
            screen: const RouteArgumentsScreen(),
          ),
          _buildMenuItem(
            context,
            title: '4. Nav 1.0: Returning Data Back',
            subtitle: 'Using await and pop to get data from a screen.',
            screen: const DataReturningScreen(),
          ),
          _buildMenuItem(
            context,
            title: '5. Nav 1.0: Named Routes (Simple)',
            subtitle: 'Centralizing routes in the MaterialApp `routes` map.',
            screen: const NamedRoutesScreen(),
          ),
          _buildMenuItem(
            context,
            title: '6. Nav 1.0: Named Routes (onGenerateRoute)',
            subtitle: 'Standard pattern for passing arguments to named routes.',
            screen: const OnGenerateRouteScreen(),
          ),
          _buildMenuItem(
            context,
            title: '7. Nav 1.0: Advanced Stack Management',
            subtitle: 'Using popUntil, pushReplacement, and more.',
            screen: const StackManagementScreen(),
          ),
          _buildMenuItem(
            context,
            title: '8. Nav 1.0: State Restoration',
            subtitle: 'Using restorablePush to save/restore the stack.',
            screen: const RestorationScreen(),
          ),
          _buildMenuItem(
            context,
            title: '9. Nav 1.0: Full Named Route Example',
            subtitle: 'A self-contained example using the `routes` map.',
            screen: const SimpleNamedRoutesScreen(),
          ),
          _buildMenuItem(
            context,
            title: '10. Nav 1.0: Full Deep Link Example',
            subtitle: 'A self-contained example using `onGenerateRoute`.',
            screen: const DeepLinkingScreen(),
          ),
          _buildMenuItem(
            context,
            title: '11. Nav 1.0: Deep Link Product Example',
            subtitle: 'A complete feature demonstrating a product deep link.',
            screen: const ProductFeatureScreen(),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem(BuildContext context,
      {required String title, required String subtitle, required Widget screen}) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        title: Text(title),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.arrow_forward_ios),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => screen),
          );
        },
      ),
    );
  }
}

