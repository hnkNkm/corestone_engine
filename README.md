# Corestone Engine

A minimal, cross-platform game engine built with Zig.

## Overview

Corestone Engine is a lightweight game engine designed for learning and customization. It uses SDL2 for OS abstraction, allowing developers to focus on rendering and core game logic implementation.

## Prerequisites

- **Zig**: 0.14.0 or later
- **SDL2**: 2.0.0 or later

### Installing SDL2

#### macOS
```bash
brew install sdl2
```

#### Ubuntu/Debian
```bash
sudo apt-get install libsdl2-dev
```

#### Windows
Download SDL2 development libraries from [SDL's official website](https://www.libsdl.org/download-2.0.php) and set up the paths in `build.zig`.

## Building and Running

```bash
# Build the project
zig build

# Run the engine
zig build run

# Run tests
zig build test
```

## Project Structure

```
corestone_engine/
├── build.zig              # Build configuration
├── build.zig.zon          # Package manifest
├── src/
│   ├── main.zig           # Application entry point
│   ├── root.zig           # Library root
│   ├── core/              # Engine core systems
│   │   └── engine.zig     # Main engine structure
│   ├── renderer/          # Rendering system (OpenGL)
│   ├── ecs/               # Entity-Component-System
│   └── math/              # Math utilities
│       └── vec2.zig       # 2D vector math
└── assets/                # Game assets
```

## Features

### Current (Phase 1)
- [x] SDL2 integration
- [x] Window creation and event handling
- [x] Basic project structure
- [ ] OpenGL context initialization
- [ ] Basic shader system
- [ ] First triangle rendering

### Planned
- **Phase 2**: Enhanced rendering (textures, sprites, 2D camera)
- **Phase 3**: ECS implementation
- **Phase 4**: 3D rendering, audio, UI system
- **Phase 5**: Hot-reloading, scene serialization, performance optimization

## Architecture

The engine follows a modular architecture:
- **SDL2**: Provides cross-platform window management and input handling
- **Renderer**: Custom OpenGL-based rendering system (Vulkan support planned)
- **ECS**: Entity-Component-System for game object management
- **Math Library**: Custom vector and matrix operations for graphics

## Development Philosophy

- **Explicit over implicit**: Following Zig's philosophy, no hidden allocations or magic
- **Minimal dependencies**: Only SDL2 as external dependency
- **Learning-friendly**: Clear code structure for educational purposes
- **Performance-conscious**: Designed for efficient game development

## Contributing

This project is in early development. Feel free to explore the codebase and experiment with it.

## License

[License information to be added]