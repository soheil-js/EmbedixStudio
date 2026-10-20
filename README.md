# EmbedixStudio

A cross-platform desktop GUI for [Embedix](https://github.com/soheil-js/Embedix), built with Flutter for Windows, macOS and Linux.

## 📖 About

**EmbedixStudio** is a desktop application designed to provide a graphical interface for [Embedix](https://github.com/soheil-js/Embedix), a modular .NET assembly embedding toolkit.

It aims to make assembly embedding accessible through a desktop workflow, allowing developers to interact with Embedix without relying exclusively on command-line operations.

Built with Flutter, EmbedixStudio is maintained as a separate project from the core Embedix toolkit, keeping the desktop user interface independent of the underlying assembly-processing engine.

## ✨ Goals

- 🖥️ **Cross-Platform Desktop UI** — Build a desktop application for Windows, macOS and Linux.
- 🧩 **Embedix Integration** — Provide a graphical entry point to the Embedix assembly embedding workflow.
- 🎯 **Simplified Workflow** — Make assembly embedding easier to configure and execute through a visual interface.
- 🏗️ **Separation of Concerns** — Keep the Flutter frontend separate from Embedix's .NET implementation.
- 🚀 **Extensible Architecture** — Establish a foundation for future desktop features and improvements.

## 🔗 Related Project

### [Embedix](https://github.com/soheil-js/Embedix)

Embedix is a modular .NET assembly embedding toolkit with a Core library, GUI and CLI.

Its assembly-processing engine can:

- Embed managed .NET dependencies into a target assembly.
- Compress dependencies before embedding them.
- Detect referenced dependencies automatically or allow manual selection.
- Inject runtime loading logic to resolve embedded assemblies from memory.
- Process compiled assemblies without requiring dedicated build-time integration.

EmbedixStudio focuses on the Flutter-based desktop experience, while Embedix provides the underlying assembly embedding functionality.

## 💻 Supported Platforms

| Platform | Support |
| --- | --- |
| Windows | Target platform |
| macOS | Target platform |
| Linux | Target platform |

> Platform support describes the project's intended targets. Refer to the available releases and current implementation to determine which platforms are ready for use.

## 🚀 Getting Started

### Prerequisites

To build and run EmbedixStudio from source, you will need:

- [Flutter SDK](https://docs.flutter.dev/get-started/install) with desktop development support enabled.
- [Git](https://git-scm.com/) to clone the repository.
- The platform-specific development tools required by Flutter for your operating system.

### Clone the Repository

```bash
git clone https://github.com/soheil-js/EmbedixStudio.git
cd EmbedixStudio
```

### Install Dependencies

```bash
flutter pub get
```

### Run the Application

Choose the target platform for your development environment.

#### Run on Windows

```bash
flutter run -d windows
```

#### Run on macOS

```bash
flutter run -d macos
```

#### Run on Linux

```bash
flutter run -d linux
```

### Build a Release

Build a release version for your target desktop platform.

#### Build for Windows

```bash
flutter build windows --release
```

#### Build for macOS

```bash
flutter build macos --release
```

#### Build for Linux

```bash
flutter build linux --release
```

For detailed platform setup instructions, refer to the [Flutter desktop documentation](https://docs.flutter.dev/platform-integration/desktop).

## 🧑‍💻 Development

Contributions and improvements are welcome.

To get started:

1. Fork the repository.
2. Create a feature branch.
3. Make your changes and run the relevant checks.
4. Commit your changes with a clear, descriptive message.
5. Open a pull request.

Before submitting changes, ensure the application builds successfully for the platform you are targeting.

## 📄 License

EmbedixStudio is distributed under the terms specified in the [LICENSE](LICENSE) file.
