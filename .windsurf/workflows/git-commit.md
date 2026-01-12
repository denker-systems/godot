---
description: Git commit workflow för Godot Engine
---

# Git Commit Workflow

> Committa ändringar med conventional format

## 1. Granska Ändringar

// turbo
```powershell
git status
git diff --stat
```

---

## 2. Stage Ändringar

```powershell
# Stage alla
git add .

# Eller selektivt
git add modules/my_module/
git add modules_plan.md
```

---

## 3. Commit Format

```
type(scope): kort beskrivning

[valfri längre beskrivning]

[valfri footer]
```

### Types
| Type | Användning |
|------|------------|
| feat | Ny feature/modul |
| fix | Buggfix |
| module | Modul-ändringar |
| docs | Dokumentation |
| refactor | Refaktorering |
| perf | Prestanda |
| test | Tester |
| build | Build-system |

### Scopes
| Scope | Område |
|-------|--------|
| core | core/ |
| scene | scene/ |
| servers | servers/ |
| editor | editor/ |
| modules | modules/ |
| platform | platform/ |

---

## 4. Exempel Commits

```powershell
# Ny modul
git commit -m "module(uuid): add UUID generator module

- Implements UUID v4 and v7 generation
- Adds UUIDGenerator class
- Includes documentation"

# Buggfix
git commit -m "fix(core): resolve memory leak in Object

Ref counting was not properly decremented
when reparenting nodes."

# Feature
git commit -m "feat(editor): add module browser panel

New panel for browsing installed modules
with enable/disable functionality."
```

---

## 5. Pre-commit Checklista

- [ ] Build fungerar
- [ ] Inga nya warnings
- [ ] Kod dokumenterad
- [ ] Tester passerar (om tillämpligt)

---

## 6. VIKTIGT

**ALDRIG git push utan explicit instruktion!**
