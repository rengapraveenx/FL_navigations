# Flutter Navigation 1.0: A Beginner's Guide

This document provides a comprehensive overview of Flutter's original imperative navigation system, often called "Navigation 1.0".

## The Building Blocks of Navigation

Before diving into patterns, it's crucial to understand the four main components you'll interact with.

### 1. `MaterialApp`

- **Analogy**: This is the **entire universe** of your application. It's the top-level widget that holds everything together.
- **What it does**: It provides a huge amount of standard functionality that most apps need, such as applying a theme, handling localization (text for different languages), and, most importantly for navigation, **it creates the root `Navigator`**. You can't have navigation without a `Navigator`, and `MaterialApp` sets one up for you automatically.
- **Real-time Example**: When you launch a Flutter app, the `runApp()` function is usually called with `MaterialApp`. This sets up the entire visual and functional foundation for your app to run on.

    ```dart
    void main() {
      runApp(
        // MaterialApp is the root of the widget tree
        MaterialApp(
          title: 'My Awesome App',
          theme: ThemeData(primarySwatch: Colors.blue),
          // The 'home' property defines the very first screen (route)
          // that the app's Navigator will display.
          home: const HomeScreen(),
        ),
      );
    }
    ```

### 2. `Navigator`

- **Analogy**: This is the **hallway and elevator system** of your app's universe. It's the machinery that knows where all the screens are and how to move between them.
- **What it does**: It's a widget that manages a stack of `Route` objects. You don't usually create a `Navigator` yourself; you use the one provided by `MaterialApp`. You interact with it using static methods like `Navigator.of(context)` or, more commonly, the shorthand `Navigator.push(...)` and `Navigator.pop(...)`.
- **Real-time Example**: When a user taps a "Login" button, your code calls `Navigator.push(...)`. The `Navigator` hears this command, builds the new login screen, and places it on top of the stack, making it visible.

    ```dart
    // The Navigator is implicitly used here.
    // This command finds the nearest Navigator in the widget tree
    // and tells it to "push" a new route.
    Navigator.push(context, ...);
    ```

### 3. `Route`

- **Analogy**: This is a **single floor** in your app's building. It's an abstract concept, not a concrete screen. It represents a single entry in the `Navigator`'s history stack.
- **What it does**: A `Route` is an object that represents one screen's journey onto and off the `Navigator` stack. It's more than just the widget you see; it also defines the screen's background (e.g., is it transparent?), how it animates in and out, and whether it's a fullscreen dialog. You rarely create a `Route` directly. Instead, you use a subclass.
- **Real-time Example**: When you navigate from a product list to a product detail page, the detail page exists on the stack as a `Route`. This `Route` object holds the `ProductDetailPage` widget itself, plus the logic for how it slides in from the right and slides out when you press back.

### 4. `MaterialPageRoute`

- **Analogy**: This is a **specific, standard blueprint** for a floor. It says the floor should have standard Material Design walls, doors, and windows that open and close in a familiar way.
- **What it does**: This is the most common subclass of `Route`. Its main job is to wrap your screen widget and provide the standard, platform-appropriate transition animations (e.g., sliding in from the right on iOS, fading and sliding up from the bottom on Android). Its most important property is the `builder`.
- **The `builder` function**: This is a function you provide to `MaterialPageRoute`. Its job is to build and return the actual widget you want to display for that screen.
- **Real-time Example**: This is the object you create and pass to `Navigator.push()`. It's the concrete instruction that tells the `Navigator`, "Please show *this* widget, and use the standard Material Design animation to do it."

    ```dart
    ElevatedButton(
      onPressed: () {
        // Here, we create a MaterialPageRoute.
        // We provide a `builder` function that returns the widget
        // we want to show on the new screen.
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const DetailScreen()),
        );
      },
      child: const Text('View Details'),
    )
    ```

### Key Distinction: Route vs. Widget

A common point of confusion is why you can't pass a widget directly to `Navigator.push()`.

```dart
// Why can't I do this? This will cause a compile error.
Navigator.push(context, const DetailScreen());
```

The reason is that `Navigator.push()` requires a `Route`, not a `Widget`.

- A **`Widget`** is just the UI configuration—the "furniture" of your screen. It knows how to draw pixels but knows nothing about navigation, transitions, or its place in the app's history.
- A **`Route`** is the complete "floor plan" for that screen. It tells the `Navigator` everything it needs, including:
    1.  **What to build**: It uses your widget in its `builder`.
    2.  **How to animate**: It defines the entry and exit transitions.
    3.  **Other screen properties**: Is it a fullscreen dialog?

`MaterialPageRoute` is the essential wrapper that takes your `Widget` (the furniture) and puts it into a `Route` (the floor plan) that the `Navigator` can understand and manage.

---

## The Core Concept: A Stack of Screens

Think of navigation in Flutter as a stack of plates. The screen you see is the top plate.
- When you go to a new screen, you **push** a new plate onto the top of the stack.
- When you go back, you **pop** the top plate off, revealing the one below it.

The widget that manages this stack is the `Navigator`. A `MaterialApp` automatically creates one for you.

---

### 1. Basic Navigation: `push` and `pop`

This is the most fundamental navigation pattern.

- **`Navigator.push(context, route)`**: Adds a new screen (`Route`) to the top of the stack.
- **`MaterialPageRoute`**: A common type of `Route` that creates a platform-adaptive transition and builds your screen widget.
- **`Navigator.pop(context)`**: Removes the top screen from the stack.

**Example:**

```dart
// From your current screen, push a new one
ElevatedButton(
  onPressed: () {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const SecondScreen()),
    );
  },
  child: const Text('Go to Second Screen'),
)

// On the SecondScreen, pop to go back
ElevatedButton(
  onPressed: () {
    Navigator.pop(context);
  },
  child: const Text('Go Back'),
)
```

---

### 2. Passing Data to a New Screen

You'll often need to send data to the screen you are navigating to.

#### Method A: Constructor Arguments (Recommended)

This method is **type-safe** and easy to understand. You simply add a field to your destination widget and pass the data when you create it.

**Example:**

```dart
// 1. Define your destination widget with a constructor argument
class DetailScreen extends StatelessWidget {
  final String itemId;
  const DetailScreen({super.key, required this.itemId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Center(child: Text('Item ID: $itemId')));
  }
}

// 2. Pass the data when you push the route
Navigator.push(
  context,
  MaterialPageRoute(
    builder: (context) => const DetailScreen(itemId: '123'),
  ),
);
```

#### Method B: Route Arguments

This method is more flexible but is **not type-safe**, as you must manually cast the data.

**Example:**

```dart
// 1. Push a route and provide data to the `arguments` property
Navigator.push(
  context,
  MaterialPageRoute(
    builder: (context) => const AnotherScreen(),
    settings: const RouteSettings(
      arguments: 'Hello from arguments!',
    ),
  ),
);

// 2. On the destination screen, extract the data using ModalRoute
class AnotherScreen extends StatelessWidget {
  const AnotherScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Extract the arguments and cast them to the correct type
    final String message = ModalRoute.of(context)!.settings.arguments as String;
    return Scaffold(body: Center(child: Text(message)));
  }
}
```

---

### 3. Returning Data from a Screen

You can get data back from a screen when it is popped. `Navigator.push` returns a `Future`, which completes when the pushed screen is popped.

**Example:**

```dart
// 1. On the first screen, `await` the result of Navigator.push
onPressed: () async {
  // `await` the result that will be sent back from SelectionScreen
  final result = await Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => const SelectionScreen()),
  );

  // Use the result
  if (result != null) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('$result')));
  }
},

// 2. On the SelectionScreen, pass data back with Navigator.pop
ElevatedButton(
  onPressed: () {
    // Pass the selected data back as the second argument to pop
    Navigator.pop(context, 'You chose Option A!');
  },
  child: const Text('Choose Option A'),
)
```

---

### 4. Named Routes

This allows you to centralize your route definitions and navigate using simple string names. There are two main approaches.

#### Approach A: Simple `routes` Map

Good for simple routes that do not require arguments.

**Example:**

```dart
// 1. Define routes in your MaterialApp
MaterialApp(
  initialRoute: '/', // The route to show first
  routes: {
    '/': (context) => const HomeScreen(),
    '/details': (context) => const DetailScreen(),
  },
);

// 2. Navigate using the name
Navigator.pushNamed(context, '/details');
```

#### Approach B: `onGenerateRoute` (Industry Standard)

This is the recommended approach for any app with more than a few routes, especially if you need to pass arguments in a type-safe way.

**How it works:**
1. You define a callback function for the `onGenerateRoute` property of your `MaterialApp`.
2. This function is called whenever a named route is pushed that isn't in the `routes` map.
3. Inside the function, you inspect the route `settings` (which contain the name and arguments) and return the appropriate `MaterialPageRoute`, passing the arguments to your widget's constructor.

**Example:**

```dart
// 1. Implement onGenerateRoute in MaterialApp
MaterialApp(
  initialRoute: '/',
  onGenerateRoute: (settings) {
    if (settings.name == '/product') {
      final product = settings.arguments as Product?;
      if (product != null) {
        return MaterialPageRoute(
          builder: (context) => ProductScreen(product: product),
        );
      }
    }
    // Handle other routes or return an error screen
    return MaterialPageRoute(builder: (context) => const NotFoundScreen());
  },
);

// 2. Navigate with arguments
Navigator.pushNamed(
  context, 
  '/product',
  arguments: Product(id: '123', name: 'Amazing Gadget'),
);
```


---

### 5. Advanced Stack Management

These methods give you powerful control over the navigation stack.

- **`pushReplacement`**: Replaces the current route. The user can't go back to the replaced route.
  - **Use Case**: A splash screen that navigates to a home screen.
  ```dart
  Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const HomeScreen()));
  ```

- **`popUntil`**: Keeps popping routes until a condition is met.
  - **Use Case**: From a deep page, jump all the way back to the root.
  ```dart
  // Pops all routes until it finds the very first one.
  Navigator.popUntil(context, (route) => route.isFirst);
  ```

- **`pushAndRemoveUntil`**: Pushes a new route and removes all previous routes until a condition is met.
  - **Use Case**: A login flow. After login, the user goes to the home screen and cannot go back to the login screen.
  ```dart
  Navigator.pushAndRemoveUntil(
    context,
    MaterialPageRoute(builder: (context) => const HomeScreen()),
    (Route<dynamic> route) => false, // This predicate removes all routes.
  );
  ```

- **`removeRoute`**: Removes a specific route from anywhere in the stack.
  - **Use Case**: Dynamically removing a page from a checkout flow if it's no longer valid.
  ```dart
  // You need a reference to the route you want to remove.
  Navigator.removeRoute(context, routeToRemove);
  ```

---

### 6. State Restoration (`restorablePush`)

This is an advanced topic for automatically saving and restoring your navigation stack and other UI state if the OS closes your app.

**Key Concepts:**
- **`RestorationScope`**: Enables state restoration for its descendants. Add `restorationScopeId` to your `MaterialApp`.
- **`RestorationMixin`**: Add this to your `State` class to give it restoration capabilities.
- **`RestorableProperty`**: Use types like `RestorableInt` to define state that should be saved.
- **`Navigator.restorablePush`**: A version of `push` that integrates with the restoration framework.

**Example Snippet:**

```dart
// In your State class with RestorationMixin
final RestorableInt _counter = RestorableInt(0);

@override
String? get restorationId => 'my_screen';

@override
void restoreState(RestorationBucket? oldBucket, bool initialRestore) {
  registerForRestoration(_counter, 'counter');
}

// Pushing a restorable route
Navigator.restorablePush(context, _myRestorableRouteBuilder);

// The route builder must be a static or top-level function
static Route<void> _myRestorableRouteBuilder(BuildContext context, Object? arguments) {
  return MaterialPageRoute(builder: (context) => const SecondScreen());
}
```
