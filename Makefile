.PHONY: build run test clean install help

# Default target
all: build

# Build the application
build:
	@echo "Building Interactive Pet Agent..."
	swift build -c release

# Run the application
run:
	@echo "Running Interactive Pet Agent..."
	swift run

# Run tests
test:
	@echo "Running tests..."
	swift test

# Run tests with verbose output
test-verbose:
	@echo "Running tests (verbose)..."
	swift test --verbose

# Clean build artifacts
clean:
	@echo "Cleaning build artifacts..."
	swift package clean
	rm -rf .build

# Install (copy to Applications)
install: build
	@echo "Installing to /Applications..."
	@if [ -d ".build/release/InteractivePetAgent.app" ]; then \
		cp -r .build/release/InteractivePetAgent.app /Applications/; \
		echo "Installed to /Applications/InteractivePetAgent.app"; \
	else \
		echo "Error: Application bundle not found"; \
		exit 1; \
	fi

# Update dependencies
update:
	@echo "Updating dependencies..."
	swift package update

# Generate Xcode project
xcode:
	@echo "Generating Xcode project..."
	swift package generate-xcodeproj
	open InteractivePetAgent.xcodeproj

# Format code (requires swift-format)
format:
	@if command -v swift-format >/dev/null 2>&1; then \
		echo "Formatting code..."; \
		find InteractivePetAgent/Sources -name "*.swift" -exec swift-format -i {} \; ; \
	else \
		echo "swift-format not installed. Install with: brew install swift-format"; \
	fi

# Lint code (requires swiftlint)
lint:
	@if command -v swiftlint >/dev/null 2>&1; then \
		echo "Linting code..."; \
		swiftlint; \
	else \
		echo "swiftlint not installed. Install with: brew install swiftlint"; \
	fi

# Show help
help:
	@echo "Interactive Pet Agent - Makefile Commands"
	@echo ""
	@echo "Usage: make [target]"
	@echo ""
	@echo "Targets:"
	@echo "  build          Build the application (release mode)"
	@echo "  run            Run the application"
	@echo "  test           Run tests"
	@echo "  test-verbose   Run tests with verbose output"
	@echo "  clean          Clean build artifacts"
	@echo "  install        Install to /Applications"
	@echo "  update         Update package dependencies"
	@echo "  xcode          Generate and open Xcode project"
	@echo "  format         Format code with swift-format"
	@echo "  lint           Lint code with swiftlint"
	@echo "  help           Show this help message"
