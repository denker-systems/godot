---
description: Update project documentation after changes
auto_execution_mode: 1
---

# Update Docs Workflow

> Håll dokumentationen synkad med koden

## 1. Analysera Ändringar

**KRITISKT:** Kör ALLTID detta först!

// turbo
```powershell
git diff --stat HEAD~1
```

### Identifiera ALLA ändringar:
- [ ] Nya filer/klasser?
- [ ] Flyttade filer?
- [ ] Nya features?
- [ ] Bugfixes?

---

## 2. Dokumentationsmatris

| Ändring | Uppdatera |
|---------|-----------|
| Nytt plugin/addon | `docs/dev/DEVLOG.md` + `CHANGELOG.md` |
| Ny feature | `docs/dev/DEVLOG.md` + `CHANGELOG.md` |
| Bugfix | `docs/dev/DEVLOG.md` + `CHANGELOG.md` |
| Arkitekturändring | `docs/dev/sessions/YYYY-MM-DD.md` |
| Nytt workflow | `docs/dev/DEVLOG.md` |
| Ny modul | `modules_plan.md` + DEVLOG |

---

## 3. docs/dev/DEVLOG.md (PRIMÄR)

```markdown
## YYYY-MM-DD

### Session (HH:MM-HH:MM) - [Focus]

- `abc123` type(scope): beskrivning
  - **Nya filer:** Lista alla nya filer
  - **Ändrade filer:** Lista ändrade
  - **Statistik:** X filer, +A/-B rader
  - **Features:** Beskriv nya features
  - **Verifierat:** Lista vad som testats
```

**VIKTIGT:** DEVLOG är primär dokumentation!

---

## 4. docs/dev/sessions/YYYY-MM-DD.md (SEKUNDÄR)

Detaljerad session rapport med:
- Commits denna session
- Utfört arbete
- Nya/ändrade/borttagna filer
- Tekniska beslut
- Handoff notes

---

## 5. docs/CHANGELOG.md (TERTIÄR)

```markdown
## [Unreleased]

### Added
- Feature beskrivning

### Changed
- Ändring beskrivning

### Fixed
- Buggfix beskrivning
```

---

## 6. Plugin-specifik Dokumentation

### addons/[plugin]/README.md
```markdown
# Plugin Name

## Features
- Feature 1
- Feature 2

## Installation
1. Step 1
2. Step 2

## Usage
...
```

### addons/[plugin]/ROADMAP.md
```markdown
## Current Status: vX.X

### Implemented
- [x] Feature 1

### Planned
- [ ] Feature 2
```

---

## 7. Checklista

### Kod
- [ ] README.md i nya plugins
- [ ] ROADMAP.md för större projekt
- [ ] Inline-kommentarer förklarar VARFÖR

### Projekt (PRIMÄRT)
- [ ] **docs/dev/DEVLOG.md** uppdaterad
- [ ] **docs/dev/sessions/YYYY-MM-DD.md** komplett
- [ ] **docs/CHANGELOG.md** uppdaterad

---

## Quick Reference

### Dokumentstruktur
```
godot/
├── docs/
│   ├── dev/
│   │   ├── DEVLOG.md       # Primär - alla commits
│   │   └── sessions/       # Per-session rapporter
│   │       └── YYYY-MM-DD.md
│   └── CHANGELOG.md        # Release notes
├── addons/
│   └── [plugin]/
│       ├── README.md
│       └── ROADMAP.md
└── modules_plan.md         # C++ modules status
```
