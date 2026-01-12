---
trigger: always_on
description: Error handling standards för Godot Engine
---

# Error Handling

> Felhantering i Godot modules

## Godot Error Macros

| Macro | Användning |
|-------|------------|
| `ERR_FAIL_COND(cond)` | Return om condition true |
| `ERR_FAIL_COND_V(cond, ret)` | Return value om true |
| `ERR_FAIL_NULL(ptr)` | Return om null |
| `ERR_FAIL_NULL_V(ptr, ret)` | Return value om null |
| `ERR_FAIL_INDEX(idx, size)` | Bounds check |
| `WARN_PRINT("msg")` | Varning |
| `ERR_PRINT("msg")` | Error |

---

## Exempel

```cpp
void MyClass::process(Object *obj) {
    ERR_FAIL_NULL(obj);  // Returnerar tidigt om null
    
    // Säker att använda obj här
    obj->do_something();
}

int MyClass::get_item(int index) const {
    ERR_FAIL_INDEX_V(index, items.size(), -1);
    return items[index];
}
```

---

## Best Practices

-  Validera input tidigt
-  Använd ERR_FAIL macros
-  Ge meningsfulla felmeddelanden
-  Ignorera errors
-  Returnera utan validering
-  Krascha utan info
