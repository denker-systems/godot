---
description: Starta en utvecklingssession för Godot Engine
---

# Init Session Workflow

> Komplett sessioninitiering för Godot Engine utveckling

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
Write-Host "
=== GIT STATUS ===" -ForegroundColor Yellow
git status --short
Write-Host "
Current Branch: $(git branch --show-current)" -ForegroundColor Green
```

---

## 3. Senaste Commits

// turbo
```powershell
Write-Host "
=== SENASTE 10 COMMITS ===" -ForegroundColor Yellow
git log --oneline -10 --format="%h %an: %s (%ar)"
```

---

## 4. Build Status Check

// turbo
```powershell
Write-Host "
=== BUILD CHECK ===" -ForegroundColor Yellow
if (Test-Path "bin\godot.windows.editor.x86_64.exe") {
    Write-Host "Editor executable exists" -ForegroundColor Green
    $lastBuild = (Get-Item "bin\godot.windows.editor.x86_64.exe").LastWriteTime
    Write-Host "Last build: $lastBuild"
} else {
    Write-Host "No editor build found - run /build" -ForegroundColor Red
}
```

---

## 5. Modules Plan Check

// turbo
```powershell
Write-Host "
=== MODULES PLAN ===" -ForegroundColor Yellow
if (Test-Path "modules_plan.md") {
    Get-Content modules_plan.md | Select-Object -First 30
} else {
    Write-Host "No modules_plan.md found" -ForegroundColor Gray
}
```

---

## 6. Kör Editor (Smoke Test)

```powershell
.\bin\godot.windows.editor.x86_64.exe
```

---

## 7. Session Checklista

### Obligatoriskt
- [ ] Git status kontrollerad
- [ ] Inga kritiska uncommitted changes
- [ ] Editor build finns

### Rekommenderat
- [ ] modules_plan.md granskad
- [ ] Dagens mål identifierade

---

## Quick Reference

### Godot Struktur
```
godot/
 core/           # Engine core
 servers/        # Backend services
 scene/          # Node system
 modules/        # Optional modules
 editor/         # Editor code
 platform/       # Platform code
 bin/            # Build output
```

### Vanliga Kommandon
```powershell
# Build
python -m SCons platform=windows target=editor -j8

# Kör Editor
.\bin\godot.windows.editor.x86_64.exe

# Git status
git status --short
```
