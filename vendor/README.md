# Vendor App

Vendor Flutter app for order management.

## Getting Started

```sh
# install dependencies (listed in pubspec.yaml).
flutter pub get
# build injector artifacts.
flutter pub run build_runner build
# run the app.
flutter run
```

## Development

Use flutter from master release channel.

```sh
flutter channel stable
```

Watch for changes and auto-generate injector artifacts.

```sh
flutter pub run build_runner watch
```

Run from `dev_main.dart` to run with dev (fake) services.

```sh
flutter run -t lib/dev_main.dart
```

## Release

- Building & releasing Andriod app (https://flutter.dev/docs/deployment/android)

## New to Flutter?

- [Lab: Write your first Flutter app](https://flutter.dev/docs/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://flutter.dev/docs/cookbook)
- [Online documentation](https://flutter.dev/docs) (tutorials, samples, guidance on mobile development, and a full API reference)
