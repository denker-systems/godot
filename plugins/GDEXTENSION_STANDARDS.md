# GDExtension Coding Standards

> Best practices för GDExtension plugin-utveckling i Godot

## Namngivning

### Plugin-namn
- **Format:** `snake_case`
- **Exempel:** `state_machine_plugin`, `custom_physics`
- **Undvik:** Prefix som `godot_`, `gd_` (reserved för officiella plugins)

### Klasser
- **Format:** `PascalCase`
- **Exempel:** `StateMachine`, `CustomPhysicsBody`
- **Regel:** En klass per fil-par (.h/.cpp)

### Metoder och Properties
- **Format:** `snake_case` (GDScript-stil)
- **Exempel:** `get_current_state()`, `set_speed()`
- **Undvik:** camelCase (även om C++ använder det)

### Filer
- **Header:** `my_class.h`
- **Source:** `my_class.cpp`
- **Registration:** `register_types.h/cpp` (standard)

---

## Filstruktur

### Minimal Plugin
```
my_plugin/
├── src/
│   ├── register_types.h
│   ├── register_types.cpp
│   ├── my_class.h
│   └── my_class.cpp
├── bin/                    # Genereras vid build
├── SConstruct
├── my_plugin.gdextension
└── README.md
```

### Större Plugin
```
my_plugin/
├── src/
│   ├── core/              # Kärnfunktionalitet
│   ├── nodes/             # Node-klasser
│   ├── resources/         # Resource-klasser
│   ├── editor/            # Editor-integration (optional)
│   └── register_types.h/cpp
├── bin/
├── doc/                   # Dokumentation
├── examples/              # Exempel-scener
├── SConstruct
├── my_plugin.gdextension
└── README.md
```

---

## Klass-design

### GDCLASS Macro (Obligatoriskt)
```cpp
class MyClass : public Node {
    GDCLASS(MyClass, Node)  // ALLTID första raden i class body
    
    // ...
};
```

### Member Variables
```cpp
private:
    // Godot-exponerade properties
    int m_health = 100;
    String m_name = "Player";
    
    // Interna variabler (ej exponerade)
    double m_time_passed = 0.0;
```

### Method Binding
```cpp
protected:
    static void _bind_methods();  // ALLTID protected

public:
    // Getters/setters för properties
    void set_health(int value);
    int get_health() const;
    
    // Custom methods
    void take_damage(int amount);
```

---

## _bind_methods Implementation

### Properties
```cpp
void MyClass::_bind_methods() {
    // Bind getters/setters
    ClassDB::bind_method(D_METHOD("set_health", "value"), &MyClass::set_health);
    ClassDB::bind_method(D_METHOD("get_health"), &MyClass::get_health);
    
    // Exponera som property i Inspector
    ADD_PROPERTY(PropertyInfo(Variant::INT, "health", PROPERTY_HINT_RANGE, "0,100"), 
                 "set_health", "get_health");
}
```

### Methods
```cpp
// Bind custom methods
ClassDB::bind_method(D_METHOD("take_damage", "amount"), &MyClass::take_damage);
```

### Signals
```cpp
// Deklarera signal
ADD_SIGNAL(MethodInfo("health_changed", 
    PropertyInfo(Variant::INT, "new_health")));

// Emit signal (i annan method)
emit_signal("health_changed", m_health);
```

### Constants
```cpp
BIND_ENUM_CONSTANT(STATE_IDLE);
BIND_ENUM_CONSTANT(STATE_WALKING);
```

---

## Godot Virtual Methods

### Override Pattern
```cpp
// I header
void _ready() override;
void _process(double delta) override;
void _physics_process(double delta) override;

// I source
void MyClass::_ready() {
    // Initialization
}

void MyClass::_process(double delta) {
    // Frame update
}
```

### Vanliga Overrides
| Method | När | Användning |
|--------|-----|------------|
| `_ready()` | Node enters tree | Initialization |
| `_process(double)` | Every frame | Visual updates |
| `_physics_process(double)` | Fixed timestep | Physics |
| `_input(InputEvent)` | Input event | Input handling |
| `_notification(int)` | Various events | Advanced |

---

## Memory Management

### Ref<> för RefCounted
```cpp
// Automatisk reference counting
Ref<Resource> my_resource;
my_resource.instantiate();
// Cleanup automatiskt när Ref går ur scope
```

### Nodes (SceneTree-ägda)
```cpp
// Nodes ägs av SceneTree
Node* child = memnew(Node);
add_child(child);  // SceneTree tar ownership

// Ta bort
child->queue_free();  // ALDRIG delete!
```

### Raw Pointers (Non-owning)
```cpp
// Använd för referenser, inte ownership
Node* get_parent_node() {
    return get_parent();  // Ägs av SceneTree
}
```

---

## Error Handling

### ERR_FAIL Macros
```cpp
void MyClass::set_health(int value) {
    ERR_FAIL_COND(value < 0);  // Return om condition true
    m_health = value;
}

int MyClass::get_item(int index) {
    ERR_FAIL_INDEX_V(index, items.size(), -1);  // Return value om out of bounds
    return items[index];
}

void MyClass::process_node(Node* node) {
    ERR_FAIL_NULL(node);  // Return om null
    node->queue_free();
}
```

### Print/Warning
```cpp
#include <godot_cpp/variant/utility_functions.hpp>

UtilityFunctions::print("Debug: ", variable);
UtilityFunctions::printerr("Error: ", error_msg);
UtilityFunctions::push_warning("Warning: ", warning_msg);
```

---

## Build Configuration

### SConstruct Template
```python
#!/usr/bin/env python
import os
import sys

env = SConscript("../godot-cpp/SConstruct")

# Source files
env.Append(CPPPATH=["src/"])
sources = Glob("src/*.cpp")

# Platform-specific library output
if env["platform"] == "macos":
    library = env.SharedLibrary(
        "bin/{}.{}.{}.framework/{}.{}.{}".format(
            env["LIBNAME"], env["platform"], env["target"],
            env["LIBNAME"], env["platform"], env["target"]
        ),
        source=sources,
    )
else:
    library = env.SharedLibrary(
        "bin/{}{}{}".format(env["LIBNAME"], env["suffix"], env["SHLIBSUFFIX"]),
        source=sources,
    )

Default(library)
```

### Build Commands
```bash
# Debug
scons platform=windows target=template_debug

# Release
scons platform=windows target=template_release

# Clean
scons --clean
```

---

## .gdextension Manifest

### Standard Format
```ini
[configuration]
entry_symbol = "my_plugin_library_init"
compatibility_minimum = "4.3"

[libraries]
windows.debug.x86_64 = "res://addons/my_plugin/bin/my_plugin.windows.template_debug.x86_64.dll"
windows.release.x86_64 = "res://addons/my_plugin/bin/my_plugin.windows.template_release.x86_64.dll"
linux.debug.x86_64 = "res://addons/my_plugin/bin/libmy_plugin.linux.template_debug.x86_64.so"
linux.release.x86_64 = "res://addons/my_plugin/bin/libmy_plugin.linux.template_release.x86_64.so"
macos.debug = "res://addons/my_plugin/bin/my_plugin.macos.template_debug.framework"
macos.release = "res://addons/my_plugin/bin/my_plugin.macos.template_release.framework"
```

---

## Registration Pattern

### register_types.cpp
```cpp
#include "register_types.h"
#include "my_class.h"

#include <gdextension_interface.h>
#include <godot_cpp/core/defs.hpp>
#include <godot_cpp/godot.hpp>

using namespace godot;

void initialize_my_plugin_module(ModuleInitializationLevel p_level) {
    if (p_level != MODULE_INITIALIZATION_LEVEL_SCENE) {
        return;
    }
    
    // Registrera alla klasser
    GDREGISTER_CLASS(MyClass);
    GDREGISTER_CLASS(MyOtherClass);
}

void uninitialize_my_plugin_module(ModuleInitializationLevel p_level) {
    if (p_level != MODULE_INITIALIZATION_LEVEL_SCENE) {
        return;
    }
    // Cleanup om nödvändigt
}

extern "C" {
GDExtensionBool GDE_EXPORT my_plugin_library_init(
        GDExtensionInterfaceGetProcAddress p_get_proc_address,
        const GDExtensionClassLibraryPtr p_library,
        GDExtensionInitialization *r_initialization) {
    godot::GDExtensionBinding::InitObject init_obj(p_get_proc_address, p_library, r_initialization);

    init_obj.register_initializer(initialize_my_plugin_module);
    init_obj.register_terminator(uninitialize_my_plugin_module);
    init_obj.set_minimum_library_initialization_level(MODULE_INITIALIZATION_LEVEL_SCENE);

    return init_obj.init();
}
}
```

---

## Initialization Levels

| Level | När | Användning |
|-------|-----|------------|
| `CORE` | Tidigast | Core types, Math |
| `SERVERS` | Efter core | Rendering, Physics servers |
| `SCENE` | Efter servers | Nodes, Resources (vanligast) |
| `EDITOR` | Sist | Editor plugins |

**Regel:** Använd `MODULE_INITIALIZATION_LEVEL_SCENE` för de flesta plugins.

---

## Best Practices

### DO ✅
- Använd `GDCLASS` macro för alla Godot-klasser
- Bind alla exponerade methods i `_bind_methods()`
- Använd `Ref<>` för RefCounted-objekt
- Använd `queue_free()` för Nodes
- Validera input med `ERR_FAIL` macros
- Följ GDScript naming (snake_case för methods/properties)
- Dokumentera public API i README

### DON'T ❌
- Använd `new`/`delete` på Godot-objekt
- Glöm `GDREGISTER_CLASS()` i register_types.cpp
- Hardkoda paths i .gdextension (använd `res://`)
- Exponera C++-specifika typer (använd Godot types)
- Anta att Nodes alltid existerar (kolla null)
- Använd exceptions (Godot använder error codes)

---

## Testing Workflow

### 1. Build Plugin
```bash
cd plugins/my_plugin
scons platform=windows target=template_debug
```

### 2. Kopiera till Test-projekt
```bash
# I Godot-projekt
mkdir -p res://addons/my_plugin
cp my_plugin.gdextension res://addons/my_plugin/
cp -r bin res://addons/my_plugin/
```

### 3. Aktivera Plugin
- Project → Project Settings → Plugins
- Enable "My Plugin"

### 4. Testa Klass
- Create Node → Sök "MyClass"
- Verifiera properties i Inspector
- Testa methods via script

---

## Debugging

### Print Debugging
```cpp
#include <godot_cpp/variant/utility_functions.hpp>

UtilityFunctions::print("Value: ", my_value);
UtilityFunctions::print("Position: ", get_position());
```

### Visual Studio Debugger
1. Bygg med `target=template_debug`
2. Starta Godot editor
3. Debug → Attach to Process → `godot.windows.editor.x86_64.exe`
4. Sätt breakpoints i C++ kod

### Common Issues
- **Class not found:** Kontrollera `GDREGISTER_CLASS()`
- **Crash on load:** Kontrollera entry_symbol i .gdextension
- **Properties not visible:** Kontrollera `ADD_PROPERTY()` i _bind_methods()

---

## Versioning

### Compatibility
- **Minor versions:** GDExtension för 4.1 ska fungera i 4.2
- **Major versions:** GDExtension för 4.x fungerar INTE i 5.x
- **godot-cpp branch:** Matcha Godot version (4.3 branch för Godot 4.3)

### Version i Manifest
```ini
[configuration]
compatibility_minimum = "4.3"  # Minimum Godot version
```

---

## Referenser

- [Godot GDExtension Docs](https://docs.godotengine.org/en/stable/tutorials/scripting/gdextension/)
- [godot-cpp GitHub](https://github.com/godotengine/godot-cpp)
- [GDExtension C++ Example](https://docs.godotengine.org/en/stable/tutorials/scripting/gdextension/gdextension_cpp_example.html)
- [ClassDB Reference](https://docs.godotengine.org/en/stable/classes/class_classdb.html)
