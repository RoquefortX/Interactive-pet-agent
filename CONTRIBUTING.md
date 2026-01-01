# Contributing to Interactive Pet Agent

Thank you for your interest in contributing to Interactive Pet Agent! This document provides guidelines for contributing to the project.

## Code of Conduct

- Be respectful and inclusive
- Focus on constructive feedback
- Help others learn and grow

## How to Contribute

### Reporting Bugs

1. Check if the bug has already been reported
2. Create a new issue with:
   - Clear, descriptive title
   - Steps to reproduce
   - Expected vs actual behavior
   - macOS version and app version
   - Screenshots if applicable

### Suggesting Features

1. Check existing feature requests
2. Create a new issue describing:
   - The problem you're trying to solve
   - Your proposed solution
   - Alternative approaches considered
   - How it benefits users

### Pull Requests

1. Fork the repository
2. Create a feature branch:
   ```bash
   git checkout -b feature/your-feature-name
   ```

3. Make your changes following our coding standards

4. Write or update tests

5. Ensure all tests pass:
   ```bash
   swift test
   ```

6. Commit with clear messages:
   ```bash
   git commit -m "Add: feature description"
   ```

7. Push to your fork and submit a pull request

## Coding Standards

### Swift Style Guide

- Follow Swift API Design Guidelines
- Use meaningful variable and function names
- Add comments for complex logic
- Use `// MARK: -` to organize code sections
- Prefer clarity over cleverness

### Code Structure

```swift
// MARK: - Type Definition

class MyClass {
    // MARK: - Properties
    
    private var property: Type
    
    // MARK: - Initialization
    
    init() {
        // ...
    }
    
    // MARK: - Public Methods
    
    func publicMethod() {
        // ...
    }
    
    // MARK: - Private Methods
    
    private func privateMethod() {
        // ...
    }
}

// MARK: - Extensions

extension MyClass: Protocol {
    // Protocol implementation
}
```

### Testing

- Write unit tests for new features
- Maintain or improve code coverage
- Test edge cases and error conditions
- Use descriptive test names:
  ```swift
  func testTimerStartsWorkSessionOnLaunch()
  func testPetAppearsWhenBreakTimeStarts()
  ```

## Project Structure

- `Sources/`: Core application code
- `Resources/`: App resources (Info.plist, entitlements)
- `Tests/`: Unit and integration tests
- `docs/`: Documentation

## Key Components

1. **AppDelegate**: Application lifecycle
2. **PetWindow**: Window management
3. **PetScene**: Animation logic
4. **PetController**: Behavior and state
5. **TimerService**: Timer functionality
6. **EmotionEngine**: AI behavior

## Development Workflow

1. **Local Development**
   - Build: `swift build`
   - Run: `swift run`
   - Test: `swift test`

2. **Before Committing**
   - Run all tests
   - Check for warnings
   - Format code consistently
   - Update documentation

3. **Pull Request Review**
   - Code will be reviewed by maintainers
   - Address feedback promptly
   - Keep PRs focused and small

## Questions?

Feel free to:
- Open an issue for discussion
- Ask questions in pull requests
- Reach out to maintainers

Thank you for contributing! 🎉
