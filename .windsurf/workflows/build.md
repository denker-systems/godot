---
description: Komplett build-process för Godot Engine
---

# Build Workflow

> Bygg Godot Engine för Windows

## 1. Snabb Build (Vanligast)

### Build Editor (Release)
// turbo
```powershell
& "C:\Program Files\Microsoft Visual Studio\18\Insiders\Common7\Tools\Launch-VsDevShell.ps1" -Arch amd64; Set-Location "C:\Users\Calle\Documents\GitHub\godot"; python -m SCons platform=windows target=editor -j8
```

### Build Editor (Debug)
```powershell
& "C:\Program Files\Microsoft Visual Studio\18\Insiders\Common7\Tools\Launch-VsDevShell.ps1" -Arch amd64; Set-Location "C:\Users\Calle\Documents\GitHub\godot"; python -m SCons platform=windows target=editor dev_build=yes -j8
```

---

## 2. Build Targets

| Target | Output | Description |
|--------|--------|-------------|
| editor | godot.windows.editor.x86_64.exe | Full editor |
| template_release | godot.windows.template_release.x86_64.exe | Release template |
| template_debug | godot.windows.template_debug.x86_64.exe | Debug template |

### Build Specific Target
```powershell
# Editor
python -m SCons platform=windows target=editor -j8

# Release template
python -m SCons platform=windows target=template_release -j8

# Debug template
python -m SCons platform=windows target=template_debug -j8
```

---

## 3. Kör Efter Build

### Editor
```powershell
.\bin\godot.windows.editor.x86_64.exe
```

### Med Console
```powershell
.\bin\godot.windows.editor.x86_64.console.exe
```

---

## 4. Build Options

| Option | Values | Description |
|--------|--------|-------------|
| platform | windows/linuxbsd/macos | Target platform |
| target | editor/template_release/template_debug | Build target |
| arch | x86_64/x86_32/arm64 | Architecture |
| dev_build | yes/no | Development build |
| debug_symbols | yes/no | Include debug symbols |
| d3d12 | yes/no | D3D12 support |
| vulkan | yes/no | Vulkan support |
| opengl3 | yes/no | OpenGL 3.3 support |
| -j8 | Number | Parallel jobs |

---

## 5. Clean Build

```powershell
# Remove all build artifacts
Remove-Item -Recurse -Force bin\* -ErrorAction SilentlyContinue
Remove-Item -Recurse -Force .sconsign*.dblite -ErrorAction SilentlyContinue

# Rebuild
python -m SCons platform=windows target=editor -j8
```

---

## 6. Module-specifika Builds

```powershell
# Enable specific module
python -m SCons platform=windows target=editor module_my_module_enabled=yes

# Disable specific module
python -m SCons platform=windows target=editor module_mono_enabled=no

# Minimal build (fewer modules)
python -m SCons platform=windows target=editor module_mono_enabled=no module_openxr_enabled=no
```

---

## 7. Felsökning

### Vanliga Errors

| Error | Lösning |
|-------|---------|
| D3D12 SDK missing | `python misc/scripts/install_d3d12_sdk_windows.py` |
| MSVC not found | Kör från Developer PowerShell |
| Python not found | Installera Python 3.8+ |
| SCons not found | `pip install scons` |

### MSVC Environment
```powershell
# Aktivera MSVC miljö
& "C:\Program Files\Microsoft Visual Studio\18\Insiders\Common7\Tools\Launch-VsDevShell.ps1" -Arch amd64
```

---

## 8. Build Checklista

- [ ] MSVC miljö aktiverad
- [ ] D3D12 SDK installerat
- [ ] Python och SCons tillgängliga
- [ ] Inga tidigare build errors
