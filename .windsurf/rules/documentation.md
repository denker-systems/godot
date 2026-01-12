---
description: Dokumentation standards för Godot Engine
---

# Documentation Standards

> Dokumentationskrav för Godot utveckling

## Fil-header

```cpp
/**************************************************************************/
/*  my_class.cpp                                                          */
/**************************************************************************/
/*                         This file is part of:                          */
/*                             GODOT ENGINE                               */
/*                        https://godotengine.org                         */
/**************************************************************************/
/* Copyright (c) 2014-present Godot Engine contributors (see AUTHORS.md). */
/* Copyright (c) 2007-2014 Juan Linietsky, Ariel Manzur.                  */
/*                                                                        */
/* [MIT License text...]                                                  */
/**************************************************************************/
```

---

## Klass-dokumentation (doc_classes/)

### XML Format
```xml
<?xml version="1.0" encoding="UTF-8" ?>
<class name="MyClass" inherits="RefCounted" version="4.0">
    <brief_description>
        Short description of the class.
    </brief_description>
    <description>
        Detailed description of the class and its usage.
    </description>
    <tutorials>
    </tutorials>
    <methods>
        <method name="my_method">
            <return type="void" />
            <description>
                Description of what the method does.
            </description>
        </method>
    </methods>
    <members>
        <member name="value" type="int" default="0">
            Description of the property.
        </member>
    </members>
    <signals>
        <signal name="value_changed">
            <param index="0" name="new_value" type="int" />
            <description>
                Emitted when value changes.
            </description>
        </signal>
    </signals>
</class>
```

---

## Inline-kommentarer

```cpp
// Godot style: Use // for single line comments
// Keep comments concise and meaningful

/* 
 * Multi-line comments for longer explanations
 * when necessary.
 */
```

---

## Generera Dokumentation

```powershell
# Generera API docs
.\bin\godot.windows.editor.x86_64.exe --doctool doc/classes
```
