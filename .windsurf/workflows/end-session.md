---
description: Avsluta utvecklingssession med full dokumentationssynk
auto_execution_mode: 1
---

# End Session Workflow

> Komplett sessionsavslutning med dokumentation

## 1. Session Info

// turbo
```powershell
$today = Get-Date -Format 'yyyy-MM-dd'
$time = Get-Date -Format 'HH:mm'
Write-Host "============================================" -ForegroundColor Cyan
Write-Host "=== SESSION END: $today $time ===" -ForegroundColor Cyan
Write-Host "============================================" -ForegroundColor Cyan
```

---

## 2. Uncommitted Changes

// turbo
```powershell
Write-Host "`n=== UNCOMMITTED CHANGES ===" -ForegroundColor Yellow
git status --short
$changes = git status --porcelain | Measure-Object -Line
Write-Host "`nÄndrade filer: $($changes.Lines)" -ForegroundColor Cyan
```

---

## 3. Dagens Commits

// turbo
```powershell
Write-Host "`n=== COMMITS DENNA SESSION ===" -ForegroundColor Yellow
git log --oneline --since="8 hours ago" --format="%h %s"
$commits = git log --oneline --since="8 hours ago" | Measure-Object -Line
Write-Host "`nAntal commits: $($commits.Lines)" -ForegroundColor Cyan
```

---

## 4. Commit Stats

// turbo
```powershell
Write-Host "`n=== ÄNDRINGSSTATISTIK ===" -ForegroundColor Yellow
git diff --stat HEAD~1 2>$null
```

---

## 5. Uppdatera DEVLOG

**KRITISKT:** Lägg till i `docs/dev/DEVLOG.md`:

```markdown
## YYYY-MM-DD

### Session (HH:MM-HH:MM) - [Focus]

- `HASH` type(scope): beskrivning
  - **Nya filer:** Lista nya filer
  - **Ändrade filer:** Lista ändrade
  - **Statistik:** X filer, +A/-B rader
  - **Features:** Beskriv nya features
  - **Verifierat:** Vad som testats
```

---

## 6. Uppdatera CHANGELOG

Under `[Unreleased]` i `docs/CHANGELOG.md`:

```markdown
### Added
- Feature beskrivning

### Changed
- Ändring beskrivning

### Fixed
- Buggfix beskrivning
```

---

## 7. Slutför Session Report

Uppdatera `docs/dev/sessions/YYYY-MM-DD.md`:

```markdown
## Session Sammanfattning

**Duration:** X timmar
**Commits:** Y st
**Lines:** +A / -B

---

## Utfört Arbete

### Klart
- [x] Uppgift 1
- [x] Uppgift 2

### Delvis Klart
- [ ] Uppgift 3 - [Status]

---

## Handoff Notes

### Nuvarande Status
- [Vad är klart]

### Nästa Prioritet
- [Vad ska göras härnäst]

### Varningar
- [Saker att vara medveten om]
```

---

## 8. Final Checklista

### Dokumentation
- [ ] DEVLOG uppdaterad med alla commits
- [ ] CHANGELOG uppdaterad (om features/fixes)
- [ ] Session report slutförd

### Kod
- [ ] Alla viktiga ändringar committed
- [ ] Inga kritiska uncommitted changes

### Handoff
- [ ] Handoff notes skrivna
- [ ] Nästa prioritet identifierad

---

## 9. Annonsera Session Slut

// turbo
```powershell
Write-Host "`n============================================" -ForegroundColor Green
Write-Host "=== SESSION COMPLETE ===" -ForegroundColor Green
Write-Host "============================================" -ForegroundColor Green
$commits = git log --oneline --since="8 hours ago" | Measure-Object -Line
Write-Host "Commits: $($commits.Lines)"
Write-Host "Ready for handoff: YES"
```

---

## Dokumentationsmatris

| Ändring | Uppdatera |
|---------|-----------|
| Ny feature | DEVLOG + CHANGELOG + Session |
| Bugfix | DEVLOG + CHANGELOG |
| Refactoring | DEVLOG + Session |
| Ny fil/klass | DEVLOG med sökväg |
| Config-ändring | DEVLOG |

---

## ⚠️ VIKTIGA REGLER

1. **ALDRIG git commit/push utan explicit instruktion**
2. **DOKUMENTERA ALLT** - Nästa session ska förstå vad som gjordes
3. **DEVLOG är primär** - Var noggrann och detaljerad
