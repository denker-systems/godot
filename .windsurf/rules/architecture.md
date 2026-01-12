---
trigger: always_on
description: Godot Engine architecture overview
---

# Godot Engine Architecture

> Cross-platform game engine architecture

## Project Structure

```
godot/
 core/               # Engine core - Object, Variant, Math
─ servers/            # Backend services (Rendering, Physics, Audio)
 scene/              # Node system, 2D/3D, GUI
 drivers/            # Platform drivers (Vulkan, D3D12, OpenGL)
 modules/            # Optional modules (GDScript, Physics, etc.)
 platform/           # Platform-specific code
 editor/             # Godot Editor
 thirdparty/         # Bundled libraries (70+)
 main/               # Entry points
 tests/              # Unit tests
```

---

## Core Systems

| System | Location | Purpose |
|--------|----------|---------|
| Object | core/object/ | Base class, signals, properties |
| Variant | core/variant/ | Dynamic type system |
| Servers | servers/ | Backend singletons |
| Scene | scene/ | Node tree, resources |
| Drivers | drivers/ | Rendering backends |

---

## Server Architecture

```
RenderingServer   Vulkan/D3D12/OpenGL/Metal
PhysicsServer3D   Jolt/Godot Physics
PhysicsServer2D   Godot Physics 2D
AudioServer       Platform audio
DisplayServer     Window management
NavigationServer  Pathfinding
TextServer        Text rendering
XRServer          VR/AR
```

---

## Module System

| Type | Location | Build |
|------|----------|-------|
| Core Module | modules/xxx/ | Compiled into engine |
| GDExtension | External | Loaded at runtime |
| Editor Plugin | addons/ | GDScript/C# |

---

## Build Targets

| Target | Output | Description |
|--------|--------|-------------|
| editor | godot.exe | Full editor |
| template_release | godot.exe | Export template |
| template_debug | godot.exe | Debug template |
