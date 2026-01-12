---
description: Research och kunskapsinsamling för Godot Engine utveckling
---

# Research Workflow

> Systematisk kunskapsinsamling för Godot Engine

## 1. Definiera Research-frågan

| Fråga | Svar |
|-------|------|
| **Ämne** | [Vad ska undersökas?] |
| **Syfte** | [Varför behövs research?] |
| **Scope** | [Hur djupt?] |
| **Tidsgräns** | [Max tid] |

### Research-typer

| Typ | När | Exempel |
|-----|-----|---------|
| **Module** | Ny modul | "Hur implementerar Godot liknande?" |
| **API** | Ny feature | "Vilken Godot-klass ärver vi från?" |
| **Pattern** | Designbeslut | "Hur gör andra modules?" |
| **Performance** | Optimering | "Hur optimerar Godot detta?" |

---

## 2. Godot-specifika Källor

### 2.1 Godot Dokumentation

**URL:** https://docs.godotengine.org

**Söktermer:**
```
site:docs.godotengine.org [ämne]
site:docs.godotengine.org contributing [ämne]
```

### 2.2 Godot Source Code

**URL:** https://github.com/godotengine/godot

Sök i kodbasen:
```powershell
# Hitta liknande implementation
Select-String -Path "modules/**/*.cpp" -Pattern "[sökterm]" -Recurse

# Hitta klass-registrering
Select-String -Path "modules/**/*.cpp" -Pattern "GDREGISTER" -Recurse

# Hitta property binding
Select-String -Path "scene/**/*.cpp" -Pattern "ADD_PROPERTY" -Recurse
```

### 2.3 Existerande Modules

**Bra referens-moduler:**

| Modul | Komplexitet | Bra för |
|-------|-------------|---------|
| noise | Enkel | Första modul |
| regex | Medel | Thirdparty wrap |
| websocket | Medel | Nätverk |
| navigation_3d | Komplex | Server |
| gdscript | Expert | Scripting |

---

## 3. Context7 - Aktuell Dokumentation

### Godot Library IDs
- /godotengine/godot - Engine source
- /websites/godotengine_en_4_5 - Docs 4.5

### Query Examples
```
Query: "How to create custom module"
Query: "ClassDB register class"
Query: "bind_method example"
```

---

## 4. Undersök Existerande Kod

### Studera en enkel modul

```powershell
# Noise module structure
Get-ChildItem modules/noise/
```

```powershell
# Läs config.py
Get-Content modules/noise/config.py
```

```powershell
# Läs register_types
Get-Content modules/noise/register_types.cpp
```

### Hitta Pattern

```powershell
# Hur registrerar andra modules klasser?
Select-String -Path "modules/*/register_types.cpp" -Pattern "GDREGISTER_CLASS" | Select-Object -First 10

# Hur binder andra methods?
Select-String -Path "modules/*/*.cpp" -Pattern "bind_method" | Select-Object -First 10
```

---

## 5. Community Källor

### GitHub Discussions
- https://github.com/godotengine/godot/discussions

### Godot Proposals
- https://github.com/godotengine/godot-proposals

### Reddit
- r/godot
- r/gamedev

---

## 6. Research Process

### Steg 1: Snabb Översikt (5 min)
1. Godot docs sökning
2. Identifiera nyckeltermer

### Steg 2: Studera Existerande (10 min)
1. Hitta liknande modul
2. Läs dess implementation

### Steg 3: Context7 (5 min)
1. Query aktuell dokumentation
2. Hitta code examples

### Steg 4: Sammanställning (5 min)
1. Dokumentera findings
2. Välj approach

---

## 7. Research Rapport

```markdown
# Research: [Ämne]

## Datum
YYYY-MM-DD

## Frågeställning
[Vad ska undersökas?]

## Källor

### Godot Docs
- [URL] - [Sammanfattning]

### Existerande Modules
- modules/xxx - [Relevant för]

### Code Examples
- [Fil] - [Vad den visar]

## Sammanfattning

### Approach
[Vald implementation]

### Key Insights
- [Insight 1]
- [Insight 2]

## Implementation Notes
- [Steg 1]
- [Steg 2]
```

---

## 8. MCP Verktyg

| Tool | Användning |
|------|------------|
| mcp0_query-docs | Godot dokumentation |
| mcp1_ask_question | Fråga om godot repo |
| search_web | Bred sökning |
| grep_search | Sök i lokal kod |
| code_search | Intelligent kodsökning |

---

## 9. Research Checklista

### Innan
- [ ] Frågeställning klar
- [ ] Scope avgränsad

### Under
- [ ] Godot docs kollad
- [ ] Existerande modules studerade
- [ ] Context7 konsulterad
- [ ] Kod-exempel hittade

### Efter
- [ ] Rapport skapad
- [ ] Approach vald
- [ ] Ready för implementation
