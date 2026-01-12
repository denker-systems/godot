---
trigger: always_on
description: Godot Engine coding standards
---

# Coding Standards

> Godot Engine C++ coding conventions

## Naming Conventions

| Type | Convention | Example |
|------|------------|---------|
| Classes | PascalCase | `PlayerBody3D` |
| Methods | snake_case | `get_position()` |
| Member vars | No prefix | `position` |
| Private vars | Underscore suffix | `cache_` |
| Constants | SCREAMING_SNAKE | `MAX_LIGHTS` |
| Enums | PascalCase | `Mode::MODE_2D` |
| Files | snake_case | `player_body.cpp` |

---

## Include Order

```cpp
// 1. Class header (for .cpp files)
#include "my_class.h"

// 2. Godot headers
#include "core/object/class_db.h"
#include "scene/main/node.h"

// 3. Thirdparty
#include <thirdparty/xxx/xxx.h>

// 4. Standard library (rarely used)
#include <cstdint>
```

---

## Class Registration

```cpp
void MyClass::_bind_methods() {
    ClassDB::bind_method(D_METHOD("get_value"), &MyClass::get_value);
    ClassDB::bind_method(D_METHOD("set_value", "value"), &MyClass::set_value);
    
    ADD_PROPERTY(PropertyInfo(Variant::INT, "value"), "set_value", "get_value");
    
    ADD_SIGNAL(MethodInfo("value_changed", PropertyInfo(Variant::INT, "new_value")));
    
    BIND_ENUM_CONSTANT(MODE_A);
    BIND_ENUM_CONSTANT(MODE_B);
}
```

---

## Memory Management

```cpp
// Use Ref<> for Reference-counted objects
Ref<Resource> res = memnew(Resource);

// Use raw pointers for Nodes (owned by tree)
Node *child = memnew(Node);
add_child(child);

// Manual cleanup
memdelete(object);
```

---

## Godot Macros

| Macro | Purpose |
|-------|---------|
| `GDCLASS(Name, Parent)` | Class declaration |
| `GDREGISTER_CLASS(Name)` | Register in ClassDB |
| `D_METHOD("name", ...)` | Method binding |
| `memnew(Type)` | Allocate object |
| `memdelete(ptr)` | Free object |
| `ERR_FAIL_COND(cond)` | Error check |
| `WARN_PRINT("msg")` | Warning |

---

## Forbidden

- Raw `new`/`delete` (use memnew/memdelete)
- `std::` containers (use Godot's Vector, HashMap, etc.)
- Exceptions
- RTTI
