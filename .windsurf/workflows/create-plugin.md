---
description: Systematisk skapande av nya GDExtension plugins för Godot
---

# Create Plugin Workflow

> Steg-för-steg guide för att skapa nya GDExtension plugins

## 1. Planering

### Definiera Plugin
| Fråga | Svar |
|-------|------|
| **Plugin-namn** | [t.ex. state_machine_plugin] |
| **Syfte** | [Vad ska plugin göra?] |
| **Klasser** | [Vilka Godot-klasser ska skapas?] |
| **Basklass** | [Node, Resource, RefCounted, etc.] |

### Exempel
```
Plugin: state_machine_plugin
Syfte: Visual state machine editor
Klasser: StateMachine, State, Transition
Basklass: Node (för StateMachine), RefCounted (för State)
```

---

## 2. Skapa Plugin-struktur

### Steg 2.1: Kopiera Template
```powershell
# Från Godot repo root
cd plugins
Copy-Item -Recurse example_plugin my_new_plugin
cd my_new_plugin
```

### Steg 2.2: Byt Namn i Filer
**Filer att uppdatera:**
1. `my_new_plugin.gdextension` (byt namn från `example_plugin.gdextension`)
2. `SConstruct` - library name
3. `src/register_types.h/cpp` - function names
4. `src/example_node.h/cpp` - byt till din klass

### Steg 2.3: Uppdatera .gdextension Manifest
```ini
[configuration]
entry_symbol = "my_plugin_library_init"  # Byt namn
compatibility_minimum = "4.3"

[libraries]
windows.debug.x86_64 = "res://addons/my_plugin/bin/my_plugin.windows.template_debug.x86_64.dll"
windows.release.x86_64 = "res://addons/my_plugin/bin/my_plugin.windows.template_release.x86_64.dll"
linux.debug.x86_64 = "res://addons/my_plugin/bin/my_plugin.linux.template_debug.x86_64.so"
linux.release.x86_64 = "res://addons/my_plugin/bin/my_plugin.linux.template_release.x86_64.so"
```

---

## 3. Implementera Klasser

### Steg 3.1: Skapa Header (.h)
```cpp
// src/my_class.h
#pragma once

#include <godot_cpp/classes/node.hpp>  // Eller annan basklass

namespace godot {

class MyClass : public Node {
    GDCLASS(MyClass, Node)

private:
    // Member variables
    double time_passed = 0.0;

protected:
    static void _bind_methods();

public:
    MyClass();
    ~MyClass();

    // Godot virtual methods
    void _ready() override;
    void _process(double delta) override;
    
    // Custom methods
    void my_method();
    
    // Properties (getters/setters)
    void set_my_property(int value);
    int get_my_property() const;
};

}
```

### Steg 3.2: Implementera Source (.cpp)
```cpp
// src/my_class.cpp
#include "my_class.h"
#include <godot_cpp/core/class_db.hpp>
#include <godot_cpp/variant/utility_functions.hpp>

using namespace godot;

void MyClass::_bind_methods() {
    // Bind methods
    ClassDB::bind_method(D_METHOD("my_method"), &MyClass::my_method);
    
    // Bind properties
    ClassDB::bind_method(D_METHOD("set_my_property", "value"), &MyClass::set_my_property);
    ClassDB::bind_method(D_METHOD("get_my_property"), &MyClass::get_my_property);
    ADD_PROPERTY(PropertyInfo(Variant::INT, "my_property"), "set_my_property", "get_my_property");
    
    // Bind signals
    ADD_SIGNAL(MethodInfo("my_signal", PropertyInfo(Variant::STRING, "message")));
}

MyClass::MyClass() {
    time_passed = 0.0;
}

MyClass::~MyClass() {
}

void MyClass::_ready() {
    UtilityFunctions::print("MyClass ready!");
}

void MyClass::_process(double delta) {
    time_passed += delta;
}

void MyClass::my_method() {
    emit_signal("my_signal", "Hello from MyClass!");
}

void MyClass::set_my_property(int value) {
    // Set logic
}

int MyClass::get_my_property() const {
    return 0;
}
```

### Steg 3.3: Registrera Klass
```cpp
// src/register_types.cpp
#include "register_types.h"
#include "my_class.h"  // Lägg till din klass

#include <gdextension_interface.h>
#include <godot_cpp/core/defs.hpp>
#include <godot_cpp/godot.hpp>

using namespace godot;

void initialize_my_plugin_module(ModuleInitializationLevel p_level) {
    if (p_level != MODULE_INITIALIZATION_LEVEL_SCENE) {
        return;
    }
    GDREGISTER_CLASS(MyClass);  // Registrera din klass
}

void uninitialize_my_plugin_module(ModuleInitializationLevel p_level) {
    if (p_level != MODULE_INITIALIZATION_LEVEL_SCENE) {
        return;
    }
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

## 4. Uppdatera SConstruct

```python
#!/usr/bin/env python
import os
import sys

env = SConscript("../godot-cpp/SConstruct")

# Add source files
env.Append(CPPPATH=["src/"])
sources = Glob("src/*.cpp")

# Build shared library
if env["platform"] == "macos":
    library = env.SharedLibrary(
        "bin/my_plugin.{}.{}.framework/my_plugin.{}.{}".format(
            env["platform"], env["target"], env["platform"], env["target"]
        ),
        source=sources,
    )
else:
    library = env.SharedLibrary(
        "bin/my_plugin{}{}".format(env["suffix"], env["SHLIBSUFFIX"]),
        source=sources,
    )

Default(library)
```

---

## 5. Bygg Plugin

### Steg 5.1: Bygg godot-cpp (första gången)
```powershell
cd plugins/godot-cpp
scons platform=windows target=template_debug
scons platform=windows target=template_release
cd ..
```

### Steg 5.2: Bygg Plugin
```powershell
cd my_new_plugin
scons platform=windows target=template_debug
scons platform=windows target=template_release
```

**Output:**
- `bin/my_plugin.windows.template_debug.x86_64.dll`
- `bin/my_plugin.windows.template_release.x86_64.dll`

---

## 6. Testa Plugin i Godot

### Steg 6.1: Skapa Test-projekt
```powershell
# Skapa nytt Godot-projekt eller använd befintligt
```

### Steg 6.2: Kopiera Plugin
```powershell
# I Godot-projektet
mkdir -p res://addons/my_plugin
Copy-Item my_plugin.gdextension res://addons/my_plugin/
Copy-Item -Recurse bin res://addons/my_plugin/
```

### Steg 6.3: Aktivera i Godot
1. Öppna Godot-projektet
2. Project → Project Settings → Plugins
3. Aktivera "My Plugin"

### Steg 6.4: Använd Klass
1. Skapa ny Node i scenen
2. Sök efter "MyClass"
3. Lägg till och testa

---

## 7. Debugging

### Debug Build
```powershell
scons platform=windows target=template_debug
```

### Print Debugging
```cpp
#include <godot_cpp/variant/utility_functions.hpp>
UtilityFunctions::print("Debug message: ", variable);
```

### Attach Debugger (Visual Studio)
1. Bygg med `target=template_debug`
2. Starta Godot
3. Attach to process `godot.windows.editor.x86_64.exe`

---

## 8. Best Practices

### Namngivning
- **Plugin:** `my_plugin` (snake_case)
- **Klasser:** `MyClass` (PascalCase)
- **Metoder:** `my_method()` (snake_case i GDScript-stil)
- **Properties:** `my_property` (snake_case)

### Filstruktur
```
my_plugin/
├── src/
│   ├── register_types.h/cpp
│   ├── my_class.h/cpp
│   └── my_other_class.h/cpp
├── bin/
│   └── *.dll (genereras vid build)
├── SConstruct
├── my_plugin.gdextension
└── README.md
```

### Memory Management
- Använd `Ref<>` för RefCounted-klasser
- Nodes ägs av SceneTree (använd `queue_free()`)
- Aldrig `delete` på Godot-objekt

### Signals
```cpp
// I _bind_methods()
ADD_SIGNAL(MethodInfo("my_signal", 
    PropertyInfo(Variant::STRING, "param1"),
    PropertyInfo(Variant::INT, "param2")));

// Emit
emit_signal("my_signal", "hello", 42);
```

---

## 9. Checklista

### Innan Build
- [ ] Alla klasser har GDCLASS macro
- [ ] _bind_methods() implementerad
- [ ] Klasser registrerade i register_types.cpp
- [ ] .gdextension manifest uppdaterad
- [ ] SConstruct uppdaterad

### Efter Build
- [ ] DLL genererad i bin/
- [ ] Inga build errors
- [ ] Plugin kopierad till Godot-projekt
- [ ] Plugin aktiverad i Project Settings
- [ ] Klass synlig i Create Node dialog

### Innan Commit
- [ ] Kod kompilerar (debug + release)
- [ ] Plugin testad i Godot
- [ ] README uppdaterad
- [ ] Exempel-scen skapad (om relevant)

---

## 10. Vanliga Problem

### Problem: "Symbol not found"
**Lösning:** Kontrollera att entry_symbol i .gdextension matchar funktionsnamnet i register_types.cpp

### Problem: "Class not found in editor"
**Lösning:** 
- Kontrollera GDREGISTER_CLASS() anropas
- Verifiera MODULE_INITIALIZATION_LEVEL_SCENE
- Starta om Godot

### Problem: "Build fails with linker errors"
**Lösning:**
- Bygg godot-cpp först
- Kontrollera att platform/target matchar

### Problem: "Plugin doesn't load"
**Lösning:**
- Kontrollera .gdextension paths
- Verifiera DLL finns i bin/
- Kolla Godot output för error messages

---

## Referenser

- [Godot GDExtension Docs](https://docs.godotengine.org/en/stable/tutorials/scripting/gdextension/)
- [godot-cpp GitHub](https://github.com/godotengine/godot-cpp)
- [GDExtension C++ Example](https://docs.godotengine.org/en/stable/tutorials/scripting/gdextension/gdextension_cpp_example.html)
