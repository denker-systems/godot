---
trigger: always_on
description: Code review standards för Godot utveckling
---

# Code Review

> Kvalitetskontroll för kod

## Review Checklista

### Kod Kvalitet
- [ ] Följer Godot coding standards
- [ ] Läsbar och förståelig
- [ ] Ingen duplicerad kod
- [ ] Rimlig komplexitet

### Dokumentation
- [ ] Klass dokumenterad
- [ ] Metoder dokumenterade
- [ ] XML docs (doc_classes/)

### Funktionalitet
- [ ] Feature fungerar
- [ ] Edge cases hanterade
- [ ] Error handling

### Build
- [ ] Kompilerar utan errors
- [ ] Inga nya warnings
- [ ] Tester passerar

---

## Review Kommentarer

| Prefix | Betydelse | Blockerar |
|--------|-----------|-----------|
| [BLOCKER] | Måste fixas | Ja |
| [MAJOR] | Bör fixas | Oftast |
| [MINOR] | Kan förbättras | Nej |
| [NIT] | Stilfråga | Nej |
| [QUESTION] | Förtydligande | Kanske |

---

## Self-Review

Innan du ber om review:

1. `git diff` - Granska alla ändringar
2. Build och testa
3. Läs igenom koden som reviewer
4. Fixa uppenbara problem
