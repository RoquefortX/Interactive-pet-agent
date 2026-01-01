# Platform Note

This is a **macOS-only** application that uses macOS-specific frameworks:
- **Cocoa/AppKit**: Native macOS UI framework
- **SpriteKit**: 2D animation framework
- **Quartz Window Services**: Window management

## Building Requirements

The project **must** be built on macOS with:
- macOS 13.0 or later
- Xcode 15.0 or later
- Swift 5.9 or later

## Why Linux Build Fails

The build will fail on Linux because:
1. Cocoa framework is macOS-only
2. SpriteKit is not available on Linux
3. NSWindow, NSApplication, and other AppKit types are macOS-specific

## CI/CD Considerations

For continuous integration:
- Use GitHub Actions with `runs-on: macos-13` or later
- Use Xcode 15.0 or later
- The `.github/workflows/build.yml` file is configured correctly for macOS

## Development Environment

To work on this project:
1. Use a Mac with Xcode installed
2. Clone the repository
3. Open in Xcode or use Swift Package Manager
4. Build and run on macOS

## Cross-Platform Alternative

If cross-platform support is needed in the future, consider:
- Using Electron or other cross-platform frameworks
- Reimplementing with SwiftUI for potential iOS/iPadOS support
- Creating platform-specific implementations

For now, this is intentionally a macOS-native application to provide the best user experience with native APIs and performance.
