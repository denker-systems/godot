---
trigger: always_on
description: Godot module development
---

# Module Development

> Creating custom Godot engine modules

## Module Structure

```
modules/
 my_module/
     config.py           # Module configuration
     SCsub               # SCons build file
     register_types.h    # Registration header
     register_types.cpp  # Class registration
     my_class.h          # Your classes
     my_class.cpp
     doc_classes/        # XML documentation
        MyClass.xml
     editor/             # Editor-only code
         my_editor_plugin.cpp
```

---

## config.py

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

## SCsub

```python
#!/usr/bin/env python
Import("env")
Import("env_modules")

env_my_module = env_modules.Clone()

# Add thirdparty includes if needed
# env_my_module.Prepend(CPPPATH=["#thirdparty/mylib/"])

module_obj = []
env_my_module.add_source_files(module_obj, "*.cpp")

# Editor-only code
if env.editor_build:
    env_my_module.add_source_files(module_obj, "editor/*.cpp")

env.modules_sources += module_obj
```

---

## register_types.h

```cpp
#pragma once
#include "modules/register_module_types.h"

void initialize_my_module_module(ModuleInitializationLevel p_level);
void uninitialize_my_module_module(ModuleInitializationLevel p_level);
```

---

## register_types.cpp

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

## Build Commands

```powershell
# Build with module
python -m SCons platform=windows target=editor module_my_module_enabled=yes

# Disable module
python -m SCons platform=windows target=editor module_my_module_enabled=no
```
