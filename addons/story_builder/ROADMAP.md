# Story Builder - Roadmap

> AI-driven game project scaffolding for Godot Engine

## Current Status: v1.0 ✅

### Implemented Features

#### AI Integration
- [x] **Multi-provider support** - Anthropic, OpenAI, Gemini
- [x] **Model selection** - Choose model per provider
- [x] **Conversation manager** - Message history, JSON extraction
- [x] **Settings persistence** - API keys saved in EditorSettings

#### User Interface
- [x] **Chat panel** - Bottom dock integration
- [x] **Settings dialog** - Provider/model/API key configuration
- [x] **Confirmation dialog** - Tree-view preview before generation
- [x] **Action buttons** - Clear History, Copy Chat, Clear Generated

#### Project Scaffolding
- [x] **Folder builder** - Creates directory structure
- [x] **Script builder** - Generates scripts from templates
- [x] **Scene builder** - Creates .tscn files programmatically
- [x] **Asset builder** - Placeholder sprites (PNG)
- [x] **Project updater** - Autoloads, input map

#### Developer Experience
- [x] **Console debugging** - Prefixed logging for all systems
- [x] **Portable addon** - No hardcoded paths, works in any project

---

## Roadmap: v2.0

### Phase 1: Context & Documentation 🎯 Next
**Goal:** Persistent project context and auto-generated documentation

| Feature | Description | Status |
|---------|-------------|--------|
| `game_design_doc.md` | AI generates GDD after scaffolding | ⬜ Planned |
| `roadmap.md` | Development steps with checkboxes | ⬜ Planned |
| `assets_manifest.json` | List all assets with descriptions | ⬜ Planned |
| `project_context.json` | Persistent context for continued work | ⬜ Planned |
| Story document | Full story, characters, world-building | ⬜ Planned |

### Phase 2: Image Upload & Vision 👁️
**Goal:** Analyze reference images and describe characters

| Feature | Description | Status |
|---------|-------------|--------|
| Image upload button | Upload reference images in chat | ⬜ Planned |
| Claude Vision integration | Analyze uploaded images | ⬜ Planned |
| Character description | "Describe this character" → AI spec | ⬜ Planned |
| Style extraction | Extract art style from references | ⬜ Planned |

### Phase 3: Image Generation 🎨
**Goal:** Generate actual game assets from descriptions

| Feature | Description | Status |
|---------|-------------|--------|
| DALL-E / GPT-Image integration | Generate sprites from text | ⬜ Planned |
| Stability AI option | Alternative image provider | ⬜ Planned |
| Style consistency | Maintain style across assets | ⬜ Planned |
| Batch generation | Generate all placeholders at once | ⬜ Planned |
| Sprite sheet support | Generate animation frames | ⬜ Planned |

### Phase 4: Workflow Agent 🤖
**Goal:** Intelligent agent that can perform multi-step tasks

| Feature | Description | Status |
|---------|-------------|--------|
| Tool definitions | Define tools agent can use | ⬜ Planned |
| Agent loop | Iterative work until task complete | ⬜ Planned |
| Subagent routing | Specialized agents for different tasks | ⬜ Planned |
| Story Agent | Writing, dialogue, quests | ⬜ Planned |
| Art Director Agent | Asset consistency, style guide | ⬜ Planned |
| Code Agent | Script generation, bug fixes | ⬜ Planned |

### Phase 5: Advanced Features 🚀
**Goal:** Production-ready game development assistant

| Feature | Description | Status |
|---------|-------------|--------|
| Git integration | Commit generated changes | ⬜ Future |
| Asset import pipeline | Proper .import files | ⬜ Future |
| Tileset generator | Generate tilesets from style | ⬜ Future |
| Sound effect suggestions | AI-recommended SFX | ⬜ Future |
| Music prompt generation | Prompts for music AI tools | ⬜ Future |

---

## Architecture: v2.0 Vision

```
┌─────────────────────────────────────────────────────────┐
│                    STORY BUILDER 2.0                    │
├─────────────────────────────────────────────────────────┤
│                                                         │
│  ┌─────────────┐    ┌─────────────┐    ┌─────────────┐ │
│  │   VISION    │    │   STORY     │    │   IMAGE     │ │
│  │   Agent     │    │   Agent     │    │   Agent     │ │
│  │             │    │             │    │             │ │
│  │ • Analyze   │    │ • Write GDD │    │ • Generate  │ │
│  │   uploads   │    │ • Roadmap   │    │   sprites   │ │
│  │ • Describe  │    │ • Quests    │    │ • Backgrounds│ │
│  │   chars     │    │ • Dialogue  │    │ • UI assets │ │
│  └──────┬──────┘    └──────┬──────┘    └──────┬──────┘ │
│         │                  │                  │         │
│         └──────────────────┼──────────────────┘         │
│                            ▼                            │
│              ┌─────────────────────────┐               │
│              │    ORCHESTRATOR         │               │
│              │    (Main Agent)         │               │
│              │                         │               │
│              │ • Route tasks           │               │
│              │ • Maintain context      │               │
│              │ • Generate project      │               │
│              └─────────────────────────┘               │
│                            │                            │
│         ┌──────────────────┼──────────────────┐        │
│         ▼                  ▼                  ▼        │
│  ┌─────────────┐    ┌─────────────┐    ┌─────────────┐│
│  │  PROJECT    │    │   DOCS      │    │   ASSETS    ││
│  │  Generator  │    │   Generator │    │   Manager   ││
│  └─────────────┘    └─────────────┘    └─────────────┘│
│                                                         │
└─────────────────────────────────────────────────────────┘
```

---

## Technical Notes

### Current AI Providers
| Provider | Models | Status |
|----------|--------|--------|
| Anthropic | claude-sonnet-4-5-20250929, claude-sonnet-4-20250514, claude-3-5-haiku, claude-3-opus | ✅ Working |
| OpenAI | gpt-4o, gpt-4o-mini, gpt-4-turbo | ⬜ Untested |
| Gemini | gemini-1.5-pro, gemini-1.5-flash | ⬜ Untested |

### Image APIs (Planned)
| Provider | API | Use Case |
|----------|-----|----------|
| OpenAI | DALL-E 3 | Sprite generation |
| OpenAI | GPT-4 Vision | Image analysis |
| Anthropic | Claude Vision | Image analysis |
| Stability AI | Stable Diffusion | Alternative generation |

### File Structure
```
addons/story_builder/
├── ai/                     # AI providers
│   ├── ai_provider.gd
│   ├── anthropic_provider.gd
│   ├── openai_provider.gd
│   ├── gemini_provider.gd
│   └── conversation_manager.gd
├── ui/                     # User interface
│   ├── chat_panel.gd/.tscn
│   ├── settings_dialog.gd/.tscn
│   └── confirmation_dialog.gd/.tscn
├── scaffolding/            # Project generation
│   ├── project_generator.gd
│   ├── folder_builder.gd
│   ├── script_builder.gd
│   ├── scene_builder.gd
│   ├── asset_builder.gd
│   └── project_updater.gd
├── templates/              # Script templates
├── prompts/                # AI system prompts
├── plugin.gd               # EditorPlugin entry
├── plugin.cfg              # Plugin config
└── ROADMAP.md              # This file
```

---

## Contributing

1. Fork the repository
2. Create feature branch: `git checkout -b feature/my-feature`
3. Implement with tests
4. Submit PR with description

## License

MIT License - See LICENSE file
