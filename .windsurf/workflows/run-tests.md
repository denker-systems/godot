---
description: Kör tester för Godot Engine
---

# Run Tests Workflow

> Kör unit tests och integration tests

## 1. Build med Tester

```powershell
python -m SCons platform=windows target=editor tests=yes -j8
```

---

## 2. Kör Alla Tester

```powershell
.\bin\godot.windows.editor.x86_64.exe --test
```

---

## 3. Kör Specifika Tester

```powershell
# Specifik test suite
.\bin\godot.windows.editor.x86_64.exe --test --test-case="[TestSuite]*"

# Specifikt test
.\bin\godot.windows.editor.x86_64.exe --test --test-case="test_name"
```

---

## 4. Test Output

```powershell
# Verbose output
.\bin\godot.windows.editor.x86_64.exe --test --verbose

# Visa alla test-namn
.\bin\godot.windows.editor.x86_64.exe --test --list-tests
```

---

## 5. Skriva Tester

### Test Location
```
tests/
 core/       # Core tests
 scene/      # Scene tests
 servers/    # Server tests
 test_main.cpp
```

### Test Example
```cpp
#include "tests/test_macros.h"

namespace TestMyClass {

TEST_CASE("[MyClass] Basic functionality") {
    MyClass obj;
    
    CHECK(obj.get_value() == 0);
    
    obj.set_value(42);
    CHECK(obj.get_value() == 42);
}

TEST_CASE("[MyClass] Edge cases") {
    MyClass obj;
    
    obj.set_value(-1);
    CHECK(obj.get_value() >= 0); // Should clamp
}

} // namespace TestMyClass
```

---

## 6. Test Macros

| Macro | Användning |
|-------|------------|
| `TEST_CASE("name")` | Definiera test case |
| `CHECK(cond)` | Verifiera condition |
| `CHECK_EQ(a, b)` | Equality check |
| `CHECK_NE(a, b)` | Not equal check |
| `REQUIRE(cond)` | Fail om false |
| `CHECK_MESSAGE(cond, msg)` | Med meddelande |
