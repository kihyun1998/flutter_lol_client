# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is a Flutter package (`flutter_lol_client`) designed to provide easy access to Riot Games' League of Legends LCU (League Client Update) API. The LCU API allows interaction with the League of Legends client while it's running, enabling features like:

- Retrieving summoner information and stats
- Accessing match history and game data
- Managing friends and chat
- Interacting with champion select and in-game data
- Controlling client settings and preferences

## Development Commands

### Testing
```bash
flutter test                    # Run all tests
flutter test test/specific_test.dart  # Run a specific test file
```

### Code Quality
```bash
dart analyze                    # Run static analysis (uses analysis_options.yaml with flutter_lints)
dart format .                   # Format all Dart code
```

### Package Management
```bash
flutter pub get                 # Install dependencies
flutter pub deps               # Show dependency tree
flutter pub publish --dry-run  # Validate package before publishing
```

## Architecture Considerations for LCU API

### LCU API Basics
- The LCU API runs on `https://127.0.0.1:<port>` with a self-signed certificate
- Requires authentication via basic auth with credentials found in League client lockfile
- Uses WebSocket connections for real-time events and REST endpoints for queries
- Port and auth token change each time the client restarts

### Key Implementation Areas
- **Connection Management**: Handle lockfile discovery, port detection, and certificate validation
- **Authentication**: Basic auth with riot client credentials  
- **HTTP Client**: Custom HTTP client that handles self-signed certificates
- **WebSocket Handler**: Real-time event subscription and handling
- **API Models**: Data classes for League API responses (summoner, match, champion data, etc.)
- **Error Handling**: Connection failures, API rate limits, client unavailability

### Package Structure Recommendations
- `lib/src/client/` - HTTP client and connection management
- `lib/src/auth/` - Authentication and lockfile handling
- `lib/src/models/` - Data models for API responses
- `lib/src/endpoints/` - API endpoint definitions organized by feature
- `lib/src/websocket/` - Real-time event handling
- `lib/flutter_lol_client.dart` - Main export file

## Dependencies Needed

The package will likely need:
- `http` or `dio` for HTTP requests
- `web_socket_channel` for WebSocket connections
- `path` for file system operations (lockfile access)
- JSON serialization libraries like `json_annotation`/`json_serializable`

## Testing Strategy

- Unit tests for individual API endpoints
- Integration tests that work with actual League client (when available)
- Mock tests for offline development
- WebSocket event handling tests