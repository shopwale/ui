# local

Flutter app to connect customers with local shops.

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
