# Gemini AI - Flutter Navigation Study

This repository is dedicated to learning and exploring Flutter's navigation systems, both Navigation 1.0 (imperative) and Navigation 2.0 (declarative).

## Main Goal

To gain a deep understanding of Flutter's navigation and routing capabilities, from basic screen transitions to complex deep linking and state management.

## Study Plan

### Part 1: Flutter Navigation 1.0 (Imperative Approach)

*   [ ] **Basics:** Understand the core concepts of the imperative `Navigator` widget.
    *   `MaterialApp` and the `home` property.
    *   The concept of a `Route` and a `MaterialPageRoute`.
*   [ ] **Simple Navigation:**
    *   [ ] Implement `Navigator.push()` to navigate to a new screen.
    *   [ ] Implement `Navigator.pop()` to return to the previous screen.
*   [ ] **Passing Data:**
    *   [ ] Pass data to a new screen using `arguments`.
    *   [ ] Return data from a screen using `Navigator.pop()`.
*   [ ] **Named Routes:**
    *   [ ] Define named routes in `MaterialApp`.
    *   [ ] Navigate using `Navigator.pushNamed()`.
    *   [ ] Handle route arguments with `ModalRoute.of(context).settings.arguments`.

### Part 2: Flutter Navigation 2.0 (Declarative Approach - Router API)

*   [ ] **Core Concepts:** Understand the key components of the Router API.
    *   [ ] **Page:** The declarative representation of a route.
    *   [ ] **Router:** The widget that displays pages based on the app's state.
    *   [ ] **RouterDelegate:** The heart of Navigation 2.0. It listens to app state changes and builds the `Navigator`.
    *   [ ] **RouteInformationParser:** Parses route information from the engine (e.g., a URL) into a user-defined data type.
    *   [ ] **RouteInformationProvider:** Provides route information to the `Router`.
*   [ ] **Simple Implementation:**
    *   [ ] Create a basic app with a `Router` and a `RouterDelegate`.
    *   [ ] Manage a simple list of pages based on app state.
*   [ ] **Handling URLs and Deep Linking:**
    *   [ ] Implement a `RouteInformationParser` to handle URLs.
    *   [ ] Synchronize the app's state with the URL.
*   [ ] **Advanced Topics:**
    *   [ ] Nested `Router` widgets for complex UI layouts.
    *   [ ] Handling the browser's back/forward buttons.
    *   [ ] Programmatic navigation with the `RouterDelegate`.

### Part 3: Comparison and Best Practices

*   [ ] **Compare Navigation 1.0 and 2.0:**
    *   [ ] Pros and cons of each approach.
    *   [ ] When to use one over the other.
*   [ ] **Explore popular navigation packages:**
    *   [ ] `go_router`
    *   [ ] `auto_route`
*   [ ] **Review and Refactor:**
    *   [ ] Refactor a Navigation 1.0 app to use Navigation 2.0.
    *   [ ] Apply best practices for navigation in a production app.
