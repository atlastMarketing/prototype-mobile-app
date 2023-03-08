# atlast_mobile_app

Prototype for the "atlast" mobile application.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

## Development

**Local Repository Setup**
- After cloning, install all the packages into the repository by running `flutter pub get`

**Local Development**
- Find available devices by running `flutter devices`
- Use one of the available devices to run the flutter application by running `flutter run -d <DEVICE_ID>`

**Other Useful CLI Commands**
- `flutter doctor`

**Visual Studio**
Recommended to use Visual Studio and install the Flutter extension for support and debugging.

With the Flutter extension installed, a lot of the flutter commands can be accessed through `CMD` + `SHIFT` + `P`.

## Build
### Building for Android
- Export to `.apk` file
```
flutter build apk --split-per-abi
```
- Simply connect android device through USB and run `flutter install -d <DEVICE_ID>`

### Building for iOS
Honestly have never tried it before - can't give good insight into this
Resource: https://medium.com/front-end-weekly/how-to-test-your-flutter-ios-app-on-your-ios-device-75924bfd75a8
