# Deep Linking Implementation Checklist

This document provides a step-by-step checklist to implement deep linking using a custom URL scheme in a Flutter application.

---

### Phase 1: Add Dependencies

- [ ] **Add the `app_links` package:** This package handles receiving links from the native OS.
  ```bash
  flutter pub add app_links
  ```

---

### Phase 1.5: Define Your URL Structure

- [ ] **1. Choose a URL Scheme:**
  - This is a unique, lowercase name for your app (e.g., `my-cool-app`).

- [ ] **2. Define a Path Structure:**
  - Decide what information you want in the link. A common pattern is `host/path`.
  - **Host:** The type of content (e.g., `products`, `users`).
  - **Path:** The specific ID of the content (e.g., `123`).

- [ ] **3. Form the Example URL:**
  - Combine the parts to create your full deep link URL.
  - Example: `my-cool-app://products/123`

---

### Phase 2: Android Configuration

- [ ] **1. Locate the Manifest File:**
  - Open `android/app/src/main/AndroidManifest.xml`.

- [ ] **2. Add the Intent Filter:**
  - Inside the main `<activity>` tag (the one with the `LAUNCHER` intent), add the following `<intent-filter>` block. Replace `your_scheme` with your actual scheme name (e.g., `navigations`).
  ```xml
  <!-- Add this inside the <activity> tag -->
  <intent-filter>
      <action android:name="android.intent.action.VIEW" />
      <category android:name="android.intent.category.DEFAULT" />
      <category android:name="android.intent.category.BROWSABLE" />
      <data android:scheme="your_scheme" />
  </intent-filter>
  ```

---

### Phase 3: iOS Configuration

- [ ] **1. Locate the Info.plist File:**
  - Open `ios/Runner/Info.plist`.

- [ ] **2. Add the URL Type:**
  - Inside the top-level `<dict>` tag, add the following `CFBundleURLTypes` block. Replace `your_scheme` with your actual scheme name.
  ```xml
  <!-- Add this inside the top-level <dict> tag -->
  <key>CFBundleURLTypes</key>
  <array>
      <dict>
          <key>CFBundleTypeRole</key>
          <string>Editor</string>
          <key>CFBundleURLSchemes</key>
          <array>
              <string>your_scheme</string>
          </array>
      </dict>
  </array>
  ```

---

### Phase 4: Flutter Logic Implementation

- [ ] **1. Create a Stateful Widget:**
  - Your main app widget or the screen that manages navigation should be a `StatefulWidget` to handle the link stream.

- [ ] **2. Create a Navigator Key:**
  - This key is essential for navigating from outside the widget tree.
  ```dart
  final _navigatorKey = GlobalKey<NavigatorState>();
  ```

- [ ] **3. Initialize the Link Listener:**
  - In your `State` class, create an `AppLinks` instance and listen to the stream in `initState`. Also, check for the initial link that launched the app.
  ```dart
  import 'dart:async';
  import 'package:app_links/app_links.dart';

  class _MyAppState extends State<MyApp> {
    final _navigatorKey = GlobalKey<NavigatorState>();
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
      // Listen for incoming links
      _linkSubscription = _appLinks.uriLinkStream.listen((uri) {
        _handleDeepLink(uri);
      });

      // Check for initial link
      final initialUri = await _appLinks.getInitialAppLink();
      if (initialUri != null) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) _handleDeepLink(initialUri);
        });
      }
    }
    // ... next step ...
  }
  ```

- [ ] **4. Implement the Link Handler:**
  - Create the method that parses the URI and triggers the navigation.
  ```dart
  void _handleDeepLink(Uri uri) {
    // Example: your_scheme://products/12
    if (uri.host == 'products' && uri.pathSegments.isNotEmpty) {
      final productId = uri.pathSegments.first;
      _navigatorKey.currentState?.pushNamed('/products/$productId');
    }
  }
  ```

- [ ] **5. Configure MaterialApp:**
  - Assign your `navigatorKey` and `onGenerateRoute` function to your `MaterialApp`.
  ```dart
  MaterialApp(
    navigatorKey: _navigatorKey,
    initialRoute: '/',
    onGenerateRoute: (settings) {
      // ... see next step ...
    },
  );
  ```

- [ ] **6. Implement `onGenerateRoute`:**
  - This function translates the route name (from `pushNamed`) into an actual screen.
  ```dart
  onGenerateRoute: (settings) {
    if (settings.name != null && settings.name!.startsWith('/products/')) {
      final productId = settings.name!.split('/').last;
      // Find product and return MaterialPageRoute for ProductDetailScreen
      // ...
    }
    // Handle other routes like '/'
    // ...
  }
  ```

---

### Phase 5: Screen Design for Testing

- [ ] **1. Create a List Screen:**
  - Build a screen that shows a list of items. This will typically be your home screen (`/`).

- [ ] **2. Create a Detail Screen:**
  - Build the screen that the deep link will open (e.g., `ProductDetailScreen`). It should accept an ID in its constructor.

- [ ] **3. Connect the Screens:**
  - In the list screen, make each item tappable. The `onTap` should call `Navigator.pushNamed` with the same path format your deep link uses (e.g., `Navigator.pushNamed(context, '/products/12')`).

---

### Phase 6: Testing

- [ ] **1. CRITICAL: Full Re-install:**
  - After changing `AndroidManifest.xml` or `Info.plist`, you **must** completely uninstall and then reinstall the app on your device/emulator.

- [ ] **2. Test Cold Start:**
  - Close the app completely.
  - Run the `adb` command to launch via the link.
  ```bash
  # Replace with your scheme and path
  adb shell am start -a android.intent.action.VIEW -d "your_scheme://your/path"
  ```
  - **Command Breakdown:**
    - `adb shell`: Opens a command-line shell on your connected device/emulator.
    - `am start`: Issues a command to the Activity Manager to start an Activity.
    - `-a android.intent.action.VIEW`: Specifies the "VIEW" action.
    - `-d "your_scheme://your/path"`: Specifies the data URI (your deep link) to send with the intent.
  - **Expected Result:** The app should launch and open directly on the detail screen.

- [ ] **3. Test Warm Start:**
  - Open the app and navigate to the home screen.
  - While the app is running in the foreground, run the `adb` command again.
  - **Expected Result:** The app should navigate from the home screen to the detail screen.