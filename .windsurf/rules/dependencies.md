---
trigger: always_on
description: Godot Engine dependencies
---

# Dependencies

> Bundled thirdparty libraries

## Build Tools

| Tool | Version | Purpose |
|------|---------|---------|
| Python | 3.8+ | Build system |
| SCons | 4.0+ | Build orchestration |
| MSVC/GCC/Clang | C++17 | Compilation |

---

## Windows-specific

### D3D12 SDK (Required for D3D12)
```powershell
python misc/scripts/install_d3d12_sdk_windows.py
```

Installs to: `%LOCALAPPDATA%\Godot\build_deps\`
- Mesa NIR
- WinPixEventRuntime  
- DirectX 12 Agility SDK

---

## Key Thirdparty Libraries

| Library | Purpose |
|---------|---------|
| Vulkan SDK | Rendering API |
| glslang | Shader compilation |
| SPIRV-Cross | Shader cross-compilation |
| Jolt Physics | 3D Physics |
| FreeType | Font rendering |
| HarfBuzz | Text shaping |
| ICU4C | Unicode/i18n |
| mbedTLS | Cryptography |
| zlib, zstd | Compression |
| libpng, libjpeg | Image formats |

---

## Build Commands

```powershell
# Editor build
python -m SCons platform=windows target=editor -j8

# Release template
python -m SCons platform=windows target=template_release -j8

# Debug template  
python -m SCons platform=windows target=template_debug -j8

# Disable D3D12
python -m SCons platform=windows target=editor d3d12=no
```

---

## SCons Options

| Option | Values | Default |
|--------|--------|---------|
| platform | windows/linuxbsd/macos/android/ios/web | auto |
| target | editor/template_release/template_debug | editor |
| arch | x86_64/x86_32/arm64/arm32 | auto |
| dev_build | yes/no | no |
| debug_symbols | yes/no | no |
| d3d12 | yes/no | yes |
| vulkan | yes/no | yes |
| opengl3 | yes/no | yes |
