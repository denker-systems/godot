---
trigger: always_on
description: Testing standards för Godot Engine
---

# Testing Standards

> Testregler för Godot utveckling

## Testregler

### Obligatoriskt
- [ ] Build fungerar (Release)
- [ ] Build fungerar (Debug)
- [ ] Editor startar
- [ ] Feature fungerar i GDScript

### Rekommenderat
- [ ] Unit tests för ny kod
- [ ] Regression tests för bugfixes
- [ ] Edge case tests

---

## Test Typer

| Typ | När | Hur |
|-----|-----|-----|
| Build test | Varje ändring | SCons |
| Smoke test | Efter build | Starta editor |
| GDScript test | Ny feature | Testa i editor |
| Unit test | Kritisk logik | tests/ |

---

## Test Kommandon

```powershell
# Build
python -m SCons platform=windows target=editor -j8

# Starta editor
.\bin\godot.windows.editor.x86_64.exe

# Kör unit tests
.\bin\godot.windows.editor.x86_64.exe --test
```

---

## Innan Commit

- [ ] Release build OK
- [ ] Editor startar
- [ ] Feature testad
- [ ] Inga regressioner
