# Build Instructions

## Prerequisites

- macOS 13.0 or later
- Xcode 15.0 or later
- Swift 5.9 or later

## Building the Application

### Using Swift Package Manager

1. Navigate to the project directory:
```bash
cd Interactive-pet-agent
```

2. Build the project:
```bash
swift build -c release
```

3. Run the application:
```bash
swift run
```

### Using Xcode

1. Generate an Xcode project (if needed):
```bash
swift package generate-xcodeproj
```

2. Open the generated `.xcodeproj` file in Xcode

3. Select the appropriate target and scheme

4. Build and run (⌘R)

## Running Tests

Execute the test suite:
```bash
swift test
```

For verbose output:
```bash
swift test --verbose
```

## Distribution Build

For App Store or direct distribution:

1. Open the project in Xcode
2. Select Product > Archive
3. Use the Organizer to export the archive:
   - For App Store: Choose "App Store Connect"
   - For direct distribution: Choose "Developer ID" and sign

4. Notarize the application:
```bash
xcrun notarytool submit InteractivePetAgent.dmg --keychain-profile "AC_PASSWORD" --wait
```

5. Staple the notarization ticket:
```bash
xcrun stapler staple InteractivePetAgent.app
```

## Code Signing

The application requires proper code signing for distribution:

1. Configure your development team in Xcode
2. Select the appropriate provisioning profile
3. Enable hardened runtime
4. Configure entitlements as specified in `InteractivePetAgent.entitlements`

## Troubleshooting

### Build Failures

If you encounter build errors:
- Ensure you're using the correct Swift version: `swift --version`
- Clean the build folder: `swift package clean`
- Update package dependencies: `swift package update`

### Runtime Issues

- Check that all required permissions are granted in System Preferences > Security & Privacy
- Verify that the app has accessibility permissions for cursor tracking
- Ensure macOS version compatibility (13.0+)

## Development Setup

For active development:

1. Enable debugging in Xcode
2. Set breakpoints as needed
3. Use Instruments for performance profiling
4. Enable Address Sanitizer for memory debugging

## Continuous Integration

The project is configured for CI/CD:

```yaml
# Example GitHub Actions workflow
- name: Build
  run: swift build -c release
  
- name: Test
  run: swift test
```
