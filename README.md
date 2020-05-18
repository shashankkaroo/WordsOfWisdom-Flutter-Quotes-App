# words of wisdom quotes application

A new Flutter application developed with Firestore and Firebase Authentication

## Getting Started

This project is a starting point for a Flutter application.

Add your Google services file from firebase console to your app for android and ios.

Replace this with your secret key at below location (for ios app)

Location : WordsOfWisdom-Quotes-App/ios/Runner/Info.plist

<array>
        <dict>
            <key>CFBundleTypeRole</key>
            <string>Editor</string>
            <key>CFBundleURLSchemes</key>
            <array>
                <string>com.googleusercontent.apps.... your key from Google services file..</string>
            </array>
        </dict>
    </array>

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://flutter.dev/docs/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://flutter.dev/docs/cookbook)

For help getting started with Flutter, view our
[online documentation](https://flutter.dev/docs), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
