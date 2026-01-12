---
description: Systematisk buggundersökning och root cause analysis för Godot Engine
auto_execution_mode: 1
---

# Investigate Workflow

> Root cause analysis för Godot Engine utveckling

## 1. Samla Information

### Reproducera Buggen

```powershell
# Build med debug
python -m SCons platform=windows target=editor dev_build=yes -j8

# Kör med console output
.\bin\godot.windows.editor.x86_64.console.exe --verbose
```

### Dokumentera Buggen

| Information | Beskrivning |
|-------------|-------------|
| **Symptom** | Vad händer? |
| **Förväntad** | Vad borde hända? |
| **Steg** | Exakta steg 1, 2, 3... |
| **Frekvens** | Alltid? Ibland? |
| **Senaste fungerande** | Vilken commit? |

---

## 2. Klassificera Buggen

| Typ | Symptom | Verktyg |
|-----|---------|---------|
| **Crash** | Program avslutas | Debugger, stack trace |
| **Freeze** | Program hänger | Break, debugger |
| **Logic** | Fel beteende | Logging |
| **Memory** | Korruption, leak | ASan |
| **Rendering** | Visuellt fel | RenderDoc |
| **Module** | Modul fungerar ej | print_line() |

### Prioritering

| Prio | Typ | Åtgärd |
|------|-----|--------|
|  P1 | Crash, data loss | Fixa omedelbart |
|  P2 | Bruten feature | Fixa denna session |
|  P3 | Minor bug | När tid finns |
|  P4 | Kosmetiskt | Låg prioritet |

---

## 3. Isolera Problemet

### Git Bisect

```powershell
git bisect start
git bisect bad HEAD
git bisect good abc123
# Testa och markera good/bad
git bisect reset
```

### Logging i Godot

```cpp
// Debug output
print_line("Value: " + String::num(value));
print_line("Object: " + obj->to_string());

// Warning
WARN_PRINT("Something unusual");

// Error
ERR_PRINT("Something went wrong");

// Conditional fail
ERR_FAIL_COND(ptr == nullptr);
ERR_FAIL_COND_V(index >= size, -1);
```

---

## 4. Vanliga Bugmönster i Godot

### Null Pointer
```cpp
// BUG
node->get_name();  // node kan vara null

// FIX
if (node) {
    node->get_name();
}

// Eller med ERR_FAIL
ERR_FAIL_NULL(node);
node->get_name();
```

### Class Not Registered
```cpp
// BUG: GDREGISTER saknas
// Klass syns inte i editor

// FIX: I register_types.cpp
void initialize_my_module_module(ModuleInitializationLevel p_level) {
    if (p_level == MODULE_INITIALIZATION_LEVEL_SCENE) {
        GDREGISTER_CLASS(MyClass);  // Glöm inte detta!
    }
}
```

### Method Not Bound
```cpp
// BUG: Metod kan inte anropas från GDScript

// FIX: Bind i _bind_methods()
void MyClass::_bind_methods() {
    ClassDB::bind_method(D_METHOD("my_method"), &MyClass::my_method);
}
```

### Property Not Exposed
```cpp
// FIX: ADD_PROPERTY
ADD_PROPERTY(PropertyInfo(Variant::INT, "my_value"), "set_my_value", "get_my_value");
```

---

## 5. Debug Verktyg

| Verktyg | Användning |
|---------|------------|
| print_line() | Quick debug output |
| WARN_PRINT() | Varningar |
| ERR_PRINT() | Errors |
| DEV_ASSERT() | Dev-only assertions |
| --verbose | Verbose logging |
| Visual Studio | Breakpoints, watch |

### Visual Studio Integration

```powershell
# Generera VS solution
python -m SCons platform=windows vsproj=yes dev_build=yes
```

---

## 6. Dokumentera Root Cause

```markdown
## Root Cause Analysis

### Problem
[Beskrivning]

### Root Cause
[Vad var den underliggande orsaken]

### Location
- File: modules/xxx/my_class.cpp
- Function: my_method()
- Line: ~42

### Fix
[Hur fixades det]

### Regression Test
[Test som förhindrar regression]
```

---

## 7. Investigation Checklista

### Innan du börjar
- [ ] Kan reproducera buggen?
- [ ] Dokumenterat steg?
- [ ] Kollat senaste commits?

### Under investigation
- [ ] Klassificerat bugtyp
- [ ] Isolerat problemområde
- [ ] Identifierat root cause

### Efter fix
- [ ] Fix verifierad
- [ ] Test tillagd
- [ ] Inga nya buggar
