---
trigger: always_on
description: Memory safety för Godot Engine
---

# Memory Safety

> Minneshantering i Godot

## Godot Allokering

```cpp
// Korrekt - använd memnew/memdelete
Object *obj = memnew(MyClass);
memdelete(obj);

// Reference-counted (automatisk cleanup)
Ref<Resource> res;
res.instantiate();

// ALDRIG raw new/delete
Object *obj = new MyClass();  //  FÖRBJUDET
delete obj;                    //  FÖRBJUDET
```

---

## Ownership

| Typ | Ownership | Cleanup |
|-----|-----------|---------|
| Node | SceneTree | Automatisk |
| RefCounted | Reference count | Automatisk |
| Object | Manuell | memdelete |

---

## Vanliga Fel

```cpp
// BUG: Use after free
Node *node = get_node("...");
node->queue_free();
node->get_name();  //  CRASH

// BUG: Dangling pointer
Object *obj = memnew(MyClass);
Object *copy = obj;
memdelete(obj);
copy->call("method");  //  CRASH
```

---

## Best Practices

-  Använd Ref<> för RefCounted
-  Använd memnew/memdelete
-  Kolla nullptr innan användning
-  Raw new/delete
-  std:: containers
