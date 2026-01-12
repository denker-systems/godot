---
description: Komplett feature-utveckling för Godot Engine
---

# New Feature Workflow

> Feature-utveckling för Godot Engine modules

## Fas 1: Planering

### 1.1 Definiera Feature

| Fråga | Svar |
|-------|------|
| **Vad?** | [Kort beskrivning] |
| **Varför?** | [Problemet som löses] |
| **Hur?** | [Teknisk approach] |
| **Beroenden?** | [Andra system] |
| **Estimat?** | [Tid] |

### 1.2 Feature Kategorier

| Kategori | Location | Exempel |
|----------|----------|---------|
| **Module** | modules/ | UUID, StateMachine |
| **Core** | core/ | Nya Variant-typer |
| **Scene** | scene/ | Nya Node-typer |
| **Editor** | editor/ | Editor plugins |
| **Server** | servers/ | Nya servers |

---

## Fas 2: Setup

### 2.1 Skapa Feature Branch

```powershell
git checkout main
git pull origin main
git checkout -b feature/description
git branch --show-current
```

### 2.2 Branch Namngivning

| Prefix | Användning |
|--------|------------|
| feature/ | Ny funktionalitet |
| module/ | Ny modul |
| bugfix/ | Buggfix |
| refactor/ | Refaktorering |

### 2.3 Verifiera Startläge

// turbo
```powershell
python -m SCons platform=windows target=editor -j8
.\bin\godot.windows.editor.x86_64.exe
```

---

## Fas 3: Implementation

### 3.1 För Ny Modul

Använd /new-module workflow.

### 3.2 För Ny Klass i Existerande Modul

**Header (.h):**
```cpp
#pragma once
#include "core/object/ref_counted.h"

class MyNewClass : public RefCounted {
    GDCLASS(MyNewClass, RefCounted);

protected:
    static void _bind_methods();

public:
    MyNewClass();
    ~MyNewClass();

    void my_method();
    int get_value() const;
    void set_value(int p_value);

private:
    int value = 0;
};
```

**Implementation (.cpp):**
```cpp
#include "my_new_class.h"

void MyNewClass::_bind_methods() {
    ClassDB::bind_method(D_METHOD("my_method"), &MyNewClass::my_method);
    ClassDB::bind_method(D_METHOD("get_value"), &MyNewClass::get_value);
    ClassDB::bind_method(D_METHOD("set_value", "value"), &MyNewClass::set_value);
    
    ADD_PROPERTY(PropertyInfo(Variant::INT, "value"), "set_value", "get_value");
}

MyNewClass::MyNewClass() {}
MyNewClass::~MyNewClass() {}

void MyNewClass::my_method() {
    // Implementation
}

int MyNewClass::get_value() const {
    return value;
}

void MyNewClass::set_value(int p_value) {
    value = p_value;
}
```

### 3.3 Registrera Klassen

I register_types.cpp:
```cpp
#include "my_new_class.h"

void initialize_xxx_module(ModuleInitializationLevel p_level) {
    if (p_level == MODULE_INITIALIZATION_LEVEL_SCENE) {
        GDREGISTER_CLASS(MyNewClass);  // Lägg till
    }
}
```

### 3.4 Uppdatera SCsub

Om ny fil, lägg till i SCsub (oftast auto via *.cpp).

---

## Fas 4: Testning

### 4.1 Build
// turbo
```powershell
python -m SCons platform=windows target=editor -j8
```

### 4.2 Smoke Test

```powershell
.\bin\godot.windows.editor.x86_64.exe
```

### 4.3 GDScript Test

```gdscript
# Testa i editor
var obj = MyNewClass.new()
obj.value = 42
print(obj.get_value())
obj.my_method()
```

---

## Fas 5: Dokumentation

### 5.1 XML Documentation

Skapa doc_classes/MyNewClass.xml:
```xml
<?xml version="1.0" encoding="UTF-8" ?>
<class name="MyNewClass" inherits="RefCounted" version="4.0">
    <brief_description>
        Short description.
    </brief_description>
    <description>
        Detailed description.
    </description>
    <methods>
        <method name="my_method">
            <return type="void" />
            <description>
                Method description.
            </description>
        </method>
    </methods>
</class>
```

### 5.2 Uppdatera modules_plan.md

Markera progress.

---

## Fas 6: Self-Review

### Checklista

- [ ] Följer Godot coding standards
- [ ] Ingen debug-kod kvar
- [ ] Kompilerar utan errors
- [ ] Inga nya warnings
- [ ] Feature fungerar
- [ ] Dokumentation klar

---

## Fas 7: Commit

// turbo
```powershell
git status
git diff --stat
```

```powershell
git add .
git commit -m "feat(modules): add MyNewClass

- Implements X functionality
- Adds methods: my_method(), get/set_value()
- Includes XML documentation"
```

---

## Quick Reference

### Godot Basklasser

| Klass | Användning |
|-------|------------|
| Object | Bas för allt |
| RefCounted | Reference-counted |
| Resource | Sparbar resurs |
| Node | Scen-nod |
| Control | GUI element |

### Viktiga Macros

| Macro | Användning |
|-------|------------|
| GDCLASS(Name, Parent) | Klass-deklaration |
| GDREGISTER_CLASS(Name) | Registrera klass |
| D_METHOD("name") | Method binding |
| ADD_PROPERTY(...) | Property binding |
| ADD_SIGNAL(...) | Signal binding |

---

## VIKTIGT

1. **ALDRIG git push utan instruktion**
2. **Följ Godot coding standards**
3. **Dokumentera all ny kod**
4. **Testa innan commit**
