# DEVLOG - Godot Custom Plugins

Kronologisk logg av alla ändringar.

**Format:** `[HASH]` type(scope): beskrivning

---

## 2026-01-12

### Session (18:00-19:00) - Story Builder Plugin Improvements

- `0eb8cc327f` feat(addon): add debugging, clear generated, roadmap for Story Builder
  - **Nya filer:**
    - `addons/story_builder/ROADMAP.md` - v1.0 status och v2.0 plan
  - **Ändrade filer (10 st):**
    - `ai/anthropic_provider.gd` - max_tokens 4096→8192
    - `ai/conversation_manager.gd` - Extensiv debugging
    - `prompts/system_prompt.txt` - Compact JSON rules
    - `scaffolding/asset_builder.gd` - Auto-create directories
    - `scaffolding/project_generator.gd` - Debugging output
    - `scaffolding/script_builder.gd` - Auto-create directories
    - `ui/chat_panel.gd` - Copy Chat, Clear Generated buttons
    - `ui/chat_panel.tscn` - New buttons
    - `ui/confirmation_dialog.gd` - Window + own buttons
    - `ui/confirmation_dialog.tscn` - Proper layout
  - **Statistik:** 11 filer, +387/-25 rader
  - **Features:**
    - Console debugging med prefix [StoryBuilder], [Anthropic], etc.
    - Clear Generated knapp - raderar scaffoldade filer
    - Copy Chat knapp - kopierar konversation
    - Confirmation dialog stängs nu korrekt
    - Mappar skapas automatiskt vid scaffolding
  - **Verifierat:** Plugin fungerar, generering OK

- `197ba494fe` feat(addon): implement Story Builder AI chat plugin with model selection
  - **Features:** Model dropdown, Anthropic integration

- `9336ab2cb6` feat(plugins): add Story Builder AI scaffolding plugin
  - **Nya filer:** Hela addons/story_builder/ strukturen

---

## 2026-01-11

### Session - Initial Plugin Development

- `4b084f7383` feat(plugins): add GDExtension plugin development structure
  - **Nya filer:**
    - `plugins/README.md`
    - `plugins/example_plugin/` - GDExtension exempel
    - `.windsurf/workflows/create-plugin.md`
    - `plugins/GDEXTENSION_STANDARDS.md`

---

## Template

```markdown
## YYYY-MM-DD

### Session (HH:MM-HH:MM) - [Focus]

- `HASH` type(scope): beskrivning
  - **Nya filer:** Lista
  - **Ändrade filer:** Lista
  - **Statistik:** X filer, +A/-B rader
  - **Features:** Beskrivning
  - **Verifierat:** Vad som testats
```
