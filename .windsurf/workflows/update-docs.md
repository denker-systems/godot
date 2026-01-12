---
description: Uppdatera dokumentation för Godot Engine
---

# Update Docs Workflow

> Uppdatera dokumentation efter ändringar

## 1. Generera Class Reference

```powershell
.\bin\godot.windows.editor.x86_64.exe --doctool doc/classes
```

---

## 2. Uppdatera Module Docs

### doc_classes/MyClass.xml
Se documentation.md för XML-format.

---

## 3. Uppdatera modules_plan.md

Markera avklarade modules:
```markdown
### 1. UUID Generator
**Status:**  Klar
```

---

## 4. CHANGELOG Entry

Vid release, uppdatera CHANGELOG.md:
```markdown
## [Version] - YYYY-MM-DD

### Added
- New module: UUID Generator
```
