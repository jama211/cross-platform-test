# Simple Platformer Demo

A minimal cross-platform 2D platformer game built with MonoGame and C#.

## Features

- Cross-platform support (Windows, Mac, Linux)
- Console-ready architecture for future porting
- Minimal codebase (only 2 main C# files)
- Small executable size
- Simple platformer mechanics:
  - Player movement (arrow keys, WASD)
  - Jumping (spacebar, up arrow, W)
  - Gravity and collision detection
  - Multiple platforms to navigate

## Requirements

- [.NET 6+ SDK](https://dotnet.microsoft.com/download/dotnet) (.NET 6, 7, or 8)
  - **Auto-install**: The build scripts will automatically detect and install .NET SDK if missing
  - **Flexible**: Works with any .NET 6+ version (including the latest .NET 8)

## Quick Start

### Clone and Run

```bash
git clone <your-repo-url>
cd SimplePlatformer
```

### Windows
```cmd
run.bat
```

### Mac/Linux
```bash
./run.sh
```

That's it! The run script handles SDK installation, building, and running automatically.

## Commands

All commands work the same across platforms:

### Build Only
- **Windows**: `build.bat` (checks/installs .NET 6+ SDK automatically, then builds)
- **Mac/Linux**: `./build.sh` (checks/installs .NET 6+ SDK automatically, then builds)

### Build & Run (One-Click)
- **Windows**: `run.bat` (calls `build.bat`, then runs the game)
- **Mac/Linux**: `./run.sh` (calls `./build.sh`, then runs the game)
- **Perfect for**: Double-click to play! Handles everything automatically.

### Publish (Release Build)
- **Windows**: `publish.bat` (calls `build.bat`, then creates self-contained executable)
- **Mac/Linux**: `./publish.sh` (calls `./build.sh`, then creates self-contained executable)

The publish command creates a self-contained executable in the `dist` folder.

## Controls

- **Move Left**: Left Arrow or A
- **Move Right**: Right Arrow or D
- **Jump**: Spacebar, Up Arrow, or W
- **Exit**: Escape

## Technical Details

- **Framework**: MonoGame 3.8.1 with DesktopGL
- **Target**: .NET 6 (works with .NET 6, 7, or 8)
- **Platform**: Cross-platform (Windows, Mac, Linux)
- **Files**: Only 2 main C# files for minimal complexity
- **Size**: Small executable due to minimal dependencies
- **Zero Setup**: All scripts handle .NET SDK installation and building automatically
- **Clean Architecture**: `run` → `build`, `publish` → `build` (no code duplication)

## Console Porting Ready

The project structure is designed to be easily portable to game consoles:
- Uses MonoGame Framework (console-compatible)
- Simple asset pipeline
- Minimal external dependencies
- Standard game loop architecture

## File Structure

```
SimplePlatformer/
├── Game1.cs              # Main game logic (174 lines)
├── Program.cs            # Entry point (4 lines)
├── SimplePlatformer.csproj # Project configuration
├── Content/
│   └── Content.mgcb      # Content pipeline
├── .config/
│   └── dotnet-tools.json # MonoGame tools
├── build.bat/.sh         # Build only (handles SDK installation)
├── run.bat/.sh           # Build + Run (calls build, then runs)
├── publish.bat/.sh       # Build + Publish (calls build, then publishes)
└── README.md             # This file
```

**Script Architecture:**
- **`build`**: Core script (SDK detection/install + build)
- **`run`**: Calls `build` → runs game
- **`publish`**: Calls `build` → creates release