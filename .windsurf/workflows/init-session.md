---
description: Starta en utvecklingssession med full kontextladdning
auto_execution_mode: 1
---

# Init Session Workflow

> Komplett sessioninitiering för Godot Plugins utveckling

## 1. Session Info

// turbo
```powershell
$today = Get-Date -Format 'yyyy-MM-dd HH:mm'
$dev = $env:USERNAME
Write-Host "============================================" -ForegroundColor Cyan
Write-Host "=== GODOT SESSION START: $today ===" -ForegroundColor Cyan
Write-Host "=== Developer: $dev ===" -ForegroundColor Cyan
Write-Host "============================================" -ForegroundColor Cyan
```

---

## 2. Git Status

// turbo
```powershell
Write-Host "`n=== GIT STATUS ===" -ForegroundColor Yellow
git status --short
Write-Host "`nCurrent Branch: $(git branch --show-current)" -ForegroundColor Green
```

---

## 3. Senaste Commits

// turbo
```powershell
Write-Host "`n=== SENASTE 10 COMMITS ===" -ForegroundColor Yellow
git log --oneline -10 --format="%h %an: %s (%ar)"
```

---

## 4. Föregående Session

// turbo
```powershell
Write-Host "`n=== FÖREGÅENDE SESSION ===" -ForegroundColor Yellow
$latest = Get-ChildItem docs/dev/sessions/*.md -ErrorAction SilentlyContinue | Sort-Object Name -Descending | Select-Object -First 1
if ($latest) { 
    Write-Host "Fil: $($latest.Name)" -ForegroundColor Cyan
    Get-Content $latest.FullName | Select-Object -First 30
} else {
    Write-Host "Ingen session report hittad" -ForegroundColor Gray
}
```

---

## 5. DEVLOG Status

// turbo
```powershell
Write-Host "`n=== DEVLOG (senaste) ===" -ForegroundColor Yellow
if (Test-Path "docs/dev/DEVLOG.md") {
    Get-Content docs/dev/DEVLOG.md | Select-Object -First 40
} else {
    Write-Host "Ingen DEVLOG.md - skapa docs/dev/DEVLOG.md" -ForegroundColor Red
}
```

---

## 6. ROADMAP Check

// turbo
```powershell
Write-Host "`n=== ROADMAP ===" -ForegroundColor Yellow
$roadmap = Get-ChildItem -Recurse -Filter "ROADMAP.md" -ErrorAction SilentlyContinue | Select-Object -First 1
if ($roadmap) {
    Get-Content $roadmap.FullName | Select-Object -First 50
} else {
    Write-Host "Ingen ROADMAP.md hittad" -ForegroundColor Gray
}
```

---

## 7. Build Status

// turbo
```powershell
Write-Host "`n=== BUILD CHECK ===" -ForegroundColor Yellow
if (Test-Path "bin\godot.windows.editor.x86_64.exe") {
    $lastBuild = (Get-Item "bin\godot.windows.editor.x86_64.exe").LastWriteTime
    Write-Host "Editor build: $lastBuild" -ForegroundColor Green
} else {
    Write-Host "No editor build - run /build" -ForegroundColor Yellow
}
```

---

## 8. Skapa Session Report

Skapa `docs/dev/sessions/YYYY-MM-DD.md`:

```markdown
# Session YYYY-MM-DD

**Developer:** [Namn]
**Branch:** [branch-name]
**Start:** HH:MM
**Focus:** [Dagens huvuduppgift]

---

## Sessionsmål

- [ ] Mål 1
- [ ] Mål 2

---

## Progress Log

### HH:MM - Session Start
- Branch: [branch]
- Build: [OK/FAIL]

### HH:MM - [Aktivitet]
- [Vad gjordes]

---

## Commits Denna Session

| Hash | Type | Scope | Beskrivning |
|------|------|-------|-------------|

---

## Handoff Notes

### Nuvarande Status
- [Status]

### Nästa Prioritet
- [Prioritet]
```

---

## 9. Checklista

### Obligatoriskt
- [ ] Git status kontrollerad
- [ ] Inga kritiska uncommitted changes
- [ ] Föregående session läst

### Rekommenderat
- [ ] DEVLOG granskad
- [ ] ROADMAP kollad
- [ ] Session report skapad
- [ ] Dagens mål identifierade

---

## Quick Reference

### Projekt Struktur
```
godot/
├── addons/           # EditorPlugins (GDScript)
│   └── story_builder/
├── modules/          # C++ modules
├── plugins/          # GDExtension plugins
├── docs/
│   ├── dev/
│   │   ├── DEVLOG.md
│   │   └── sessions/
│   └── CHANGELOG.md
└── .windsurf/workflows/
```

### Vanliga Kommandon
```powershell
# Build Godot
python -m SCons platform=windows target=editor -j8

# Kör Editor
.\bin\godot.windows.editor.x86_64.exe

# Git
git status --short
git log --oneline -5
```
