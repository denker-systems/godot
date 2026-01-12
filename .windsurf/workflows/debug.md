---
description: Debugging workflow för Godot Engine
---

# Debug Workflow

> Debugging och felsökning för Godot Engine

## 1. Build med Debug Symbols

```powershell
python -m SCons platform=windows target=editor dev_build=yes debug_symbols=yes -j8
```

---

## 2. Console Output

### Kör med Console
```powershell
.\bin\godot.windows.editor.x86_64.console.exe
```

### Verbose Logging
```powershell
.\bin\godot.windows.editor.x86_64.console.exe --verbose
```

---

## 3. Vanliga Debug Macros

| Macro | Användning |
|-------|------------|
| `print_line("msg")` | Print till konsol |
| `WARN_PRINT("msg")` | Varning |
| `ERR_PRINT("msg")` | Error |
| `ERR_FAIL_COND(cond)` | Fail om condition |
| `ERR_FAIL_COND_V(cond, ret)` | Fail med return value |
| `ERR_FAIL_NULL(ptr)` | Fail om null |
| `DEV_ASSERT(cond)` | Dev-only assert |
| `CRASH_NOW()` | Force crash |

---

## 4. Debugger Integration

### Visual Studio
```powershell
# Generera VS solution
python -m SCons platform=windows vsproj=yes dev_build=yes
```

Öppna `godot.sln` i Visual Studio.

---

## 5. Logs

### Log Locations
- Windows: `%APPDATA%\Godot\`
- Editor log: `editor_log.txt`
- Project log: `godot.log`

---

## 6. Crash Debugging

### Stack Trace
- Debug build ger automatisk stack trace
- Använd `dev_build=yes` för extra info

### Common Crashes
| Symptom | Trolig orsak |
|---------|--------------|
| Null pointer | Uninitialized pointer |
| Stack overflow | Infinite recursion |
| Memory corruption | Buffer overflow |
| Assertion failed | Logic error |

---

## 7. Module-specifik Debug

```cpp
// I din module-kod
#ifdef DEBUG_ENABLED
    print_line("Debug info: " + String::num(value));
#endif
```
