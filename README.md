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

**Requirements**
- [Flutter SDK](https://docs.flutter.dev/development/tools/sdk/releases)
- [Android Studio](https://developer.android.com/studio/)
- Xcode + [iOS Simulator](https://developer.apple.com/library/archive/documentation/IDEs/Conceptual/iOS_Simulator_Guide/Introduction/Introduction.html) (for Apple machines)

**Local Repository Setup**
- After cloning, install all the packages into the repository by running `flutter pub get`
- Establish dotenv files in a `ROOT/env/` folder, typically this will include the following three files
    - `.env.development`
    - `.env.staging`
    - `.env.production`

**Local Development**
- Find available devices by running `flutter devices` (if using offline simulators, make sure they are running first).
- Use one of the available devices to run the flutter application by running `flutter run -d <DEVICE_ID>`. This process is automated using the `run.sh` script

**Other Useful CLI Commands**
- `flutter doctor`

**Visual Studio**
Recommended to use Visual Studio and install the Flutter extension for support and debugging.

With the Flutter extension installed, a lot of the flutter commands can be accessed through `CMD` + `SHIFT` + `P`.

## Build
### Building for Android
- Run the `build.sh` file to build an output file (`apk`, etc)

Other manual method:
- Simply connect android device through USB and run `flutter install -d <DEVICE_ID>`
    - May need to run `flutter build apk --release` first

Additional Refs:
- https://developer.android.com/studio/build/build-variants

### Building for iOS
- Run the `build.sh` file

Honestly have never tried it before - can't give good insight into this
Resource: https://medium.com/front-end-weekly/how-to-test-your-flutter-ios-app-on-your-ios-device-75924bfd75a8

### Generating icons
```
flutter pub run flutter_launcher_icons
```