---
description: Skapa ny Godot Engine module
---

# New Module Workflow

> Skapa en ny engine module för Godot

## Fas 1: Planering

### 1.1 Definiera Module

| Fråga | Svar |
|-------|------|
| **Namn** | [module_name] |
| **Syfte** | [Vad gör modulen?] |
| **Klasser** | [Lista av klasser] |
| **Dependencies** | [Thirdparty libs?] |

---

## Fas 2: Skapa Mappstruktur

```powershell
$moduleName = "my_module"
New-Item -ItemType Directory -Path "modules/$moduleName" -Force
New-Item -ItemType Directory -Path "modules/$moduleName/doc_classes" -Force
```

---

## Fas 3: Skapa config.py

```python
def can_build(env, platform):
    return True

def configure(env):
    pass

def get_doc_classes():
    return ["MyClass"]

def get_doc_path():
    return "doc_classes"
```

---

## Fas 4: Skapa SCsub

```python
#!/usr/bin/env python
Import("env")
Import("env_modules")

env_my_module = env_modules.Clone()

module_obj = []
env_my_module.add_source_files(module_obj, "*.cpp")

if env.editor_build:
    env_my_module.add_source_files(module_obj, "editor/*.cpp")

env.modules_sources += module_obj
```

---

## Fas 5: Skapa register_types.h

```cpp
#pragma once
#include "modules/register_module_types.h"

void initialize_my_module_module(ModuleInitializationLevel p_level);
void uninitialize_my_module_module(ModuleInitializationLevel p_level);
```

---

## Fas 6: Skapa register_types.cpp

```cpp
#include "register_types.h"
#include "my_class.h"

void initialize_my_module_module(ModuleInitializationLevel p_level) {
    if (p_level == MODULE_INITIALIZATION_LEVEL_SCENE) {
        GDREGISTER_CLASS(MyClass);
    }
}

void uninitialize_my_module_module(ModuleInitializationLevel p_level) {
}
```

---

## Fas 7: Skapa Klass-header

```cpp
#pragma once
#include "core/object/ref_counted.h"

class MyClass : public RefCounted {
    GDCLASS(MyClass, RefCounted);

protected:
    static void _bind_methods();

public:
    MyClass();
    ~MyClass();

    // Public API
    void my_method();
    int get_value() const;
    void set_value(int p_value);

private:
    int value = 0;
};
```

---

## Fas 8: Skapa Klass-implementation

```cpp
#include "my_class.h"

void MyClass::_bind_methods() {
    ClassDB::bind_method(D_METHOD("my_method"), &MyClass::my_method);
    ClassDB::bind_method(D_METHOD("get_value"), &MyClass::get_value);
    ClassDB::bind_method(D_METHOD("set_value", "value"), &MyClass::set_value);
    
    ADD_PROPERTY(PropertyInfo(Variant::INT, "value"), "set_value", "get_value");
}

MyClass::MyClass() {}
MyClass::~MyClass() {}

void MyClass::my_method() {
    // Implementation
}

int MyClass::get_value() const {
    return value;
}

void MyClass::set_value(int p_value) {
    value = p_value;
}
```

---

## Fas 9: Build och Test

// turbo
```powershell
python -m SCons platform=windows target=editor module_my_module_enabled=yes -j8
```

---

## Fas 10: Verifiera i Editor

```gdscript
# Test i GDScript
var obj = MyClass.new()
obj.value = 42
print(obj.get_value())
obj.my_method()
```

---

## Module Checklista

- [ ] config.py skapad
- [ ] SCsub skapad
- [ ] register_types.h/.cpp skapade
- [ ] Klass-filer skapade
- [ ] Build fungerar
- [ ] Klass synlig i editor
- [ ] Dokumentation (doc_classes/)
