---
description: Prestanda-optimering för Godot Engine
---

# Performance Guidelines

> Prestandaoptimering för Godot modules

## Hot Path Rules

- Undvik allokering i update loops
- Använd object pooling
- Cache lookups
- Minimera virtual calls

---

## Godot-specifika Tips

### Använd StringName
```cpp
// Snabbt (cached)
static const StringName method_name = "my_method";
object->call(method_name);

// Långsamt (skapar String varje gång)
object->call("my_method");
```

### Använd Godot Containers
```cpp
// Godot containers (optimerade)
Vector<int> vec;
HashMap<String, int> map;
List<Object*> list;

// INTE std containers
// std::vector<int> - förbjudet
```

### LocalVector för Stack
```cpp
// Stack-allokerad för små storlekar
LocalVector<int, 16> small_vec;
```

---

## Profiling

### Build med Profiling
```powershell
python -m SCons platform=windows target=editor dev_build=yes -j8
```

### Godot Profiler
- Editor  Debugger  Profiler
- Monitor frame time
- Identify bottlenecks

---

## Memory

### Object Allocation
```cpp
// Korrekt
Object *obj = memnew(MyClass);
memdelete(obj);

// Ref-counted
Ref<Resource> res;
res.instantiate();
```
