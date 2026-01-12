# Story Builder Plugin - Detaljerad Plan

> AI-driven game project scaffolding för Godot Engine

## Vision

Ett EditorPlugin för Godot som använder AI (Anthropic Claude, OpenAI GPT, Google Gemini) för att automatiskt scaffolda kompletta spelprojekt baserat på naturlig språkbeskrivning. Användaren chattar med AI:n för att förfina sin vision, och pluginet genererar sedan folder structure, scenes, scripts och placeholder assets.

---

## Exempel Use Case

### User Input
```
"I want to create a 2D platformer adventure game about a Dog called Tux. 
Tux lives in the Washington DC area, and is exploring the animal world of 
that area, chasing squirrels, collecting dog bones, and talks to humans."
```

### AI Conversation
```
AI: Great! Let me clarify a few things:
1. Is this a side-scrolling platformer or top-down?
2. What's the main gameplay loop?
3. How many areas/levels do you envision?
4. Any special mechanics? (double jump, wall climb, etc.)

User: Side-scrolling, collect bones to unlock areas, 3 areas, double jump

AI: Perfect! Here's what I'll create:
[Shows detailed project structure]
Proceed? (Yes/No/Modify)
```

### Generated Output
```
res://
├── Assets/
│   ├── Sprites/
│   │   ├── Player/
│   │   │   └── tux_placeholder.png
│   │   ├── Enemies/
│   │   │   ├── squirrel_placeholder.png
│   │   │   └── human_placeholder.png
│   │   ├── Collectibles/
│   │   │   └── bone_placeholder.png
│   │   └── Tiles/
│   │       └── grass_tile_placeholder.png
│   ├── Audio/
│   │   ├── Music/
│   │   └── SFX/
│   └── Fonts/
├── Scenes/
│   ├── Player/
│   │   └── Tux.tscn (CharacterBody2D + Sprite2D + CollisionShape2D)
│   ├── Enemies/
│   │   ├── Squirrel.tscn
│   │   └── Human.tscn
│   ├── Collectibles/
│   │   └── Bone.tscn
│   ├── Areas/
│   │   ├── WashingtonDC_Area1.tscn
│   │   ├── WashingtonDC_Area2.tscn
│   │   └── WashingtonDC_Area3.tscn
│   └── UI/
│       ├── HUD.tscn
│       └── MainMenu.tscn
├── Scripts/
│   ├── Player/
│   │   ├── movement.gd
│   │   └── double_jump.gd
│   ├── Enemies/
│   │   └── squirrel_ai.gd
│   ├── Collectibles/
│   │   └── bone_pickup.gd
│   └── Managers/
│       ├── game_manager.gd
│       └── save_system.gd
└── project.godot (updated with autoloads)
```

---

## Teknisk Arkitektur

### Stack Decision: GDScript EditorPlugin (INTE GDExtension)

**Varför GDScript:**
- ✅ Native `HTTPRequest` för AI API calls
- ✅ Built-in JSON parsing
- ✅ `PackedScene` + `ResourceSaver` för scene generation
- ✅ `DirAccess` + `FileAccess` för file operations
- ✅ EditorPlugin API fullt tillgängligt
- ✅ Snabbare iteration (ingen C++ compilation)
- ✅ Enklare för community att bidra

**GDExtension skulle vara overkill här** - all funktionalitet vi behöver finns i GDScript.

---

## Projektstruktur

```
addons/
└── story_builder/
    ├── plugin.gd                    # EditorPlugin entry point
    ├── plugin.cfg                   # Plugin metadata
    ├── icon.svg                     # Plugin icon
    │
    ├── ui/
    │   ├── chat_panel.gd           # Main chat UI (EditorDock)
    │   ├── chat_panel.tscn
    │   ├── message_bubble.gd       # Chat message component
    │   ├── message_bubble.tscn
    │   ├── settings_dialog.gd      # API key settings
    │   └── settings_dialog.tscn
    │
    ├── ai/
    │   ├── ai_provider.gd          # Abstract base class
    │   ├── anthropic_provider.gd   # Claude integration
    │   ├── openai_provider.gd      # GPT integration
    │   ├── gemini_provider.gd      # Gemini integration
    │   └── conversation_manager.gd # Manages chat state
    │
    ├── scaffolding/
    │   ├── project_generator.gd    # Orchestrates generation
    │   ├── folder_builder.gd       # Creates directory structure
    │   ├── scene_builder.gd        # Generates .tscn files
    │   ├── script_builder.gd       # Generates .gd files
    │   ├── asset_builder.gd        # Creates placeholder assets
    │   └── project_updater.gd      # Updates project.godot
    │
    ├── prompts/
    │   ├── system_prompt.txt       # Main system prompt
    │   ├── clarification_prompt.txt
    │   └── structure_prompt.txt
    │
    └── templates/
        ├── player_movement.gd.template
        ├── enemy_ai.gd.template
        ├── collectible.gd.template
        └── game_manager.gd.template
```

---

## Implementation Roadmap

### Fas 1: EditorPlugin Foundation (Dag 1-2)
**Mål:** Få upp basic UI i Godot Editor

#### Tasks
- [ ] Skapa `addons/story_builder/` struktur
- [ ] Implementera `plugin.gd` (EditorPlugin)
- [ ] Skapa `plugin.cfg`
- [ ] Bygg `chat_panel.tscn` (VBoxContainer med chat history + input)
- [ ] Implementera `chat_panel.gd` (add_message, send_message)
- [ ] Registrera dock panel i editor
- [ ] Test: Verifiera att panel visas i editor

#### Deliverables
- ✅ Plugin aktiverbar i Project Settings
- ✅ Chat panel synlig i editor bottom dock
- ✅ Kan skriva meddelanden (ingen AI än)

---

### Fas 2: AI Integration - Anthropic Claude (Dag 3-5)
**Mål:** Få AI conversation att fungera

#### Tasks
- [ ] Implementera `ai_provider.gd` (abstract base)
- [ ] Implementera `anthropic_provider.gd`
  - [ ] HTTPRequest wrapper
  - [ ] API key management
  - [ ] Request/response parsing
  - [ ] Error handling
- [ ] Skapa `system_prompt.txt`
  - [ ] Game design understanding
  - [ ] Clarification questions
  - [ ] Structured JSON output schema
- [ ] Implementera `conversation_manager.gd`
  - [ ] Message history
  - [ ] Context management
  - [ ] State machine (clarifying → confirmed → generating)
- [ ] Skapa `settings_dialog.gd` för API keys
- [ ] Test: Chat med Claude och få structured response

#### API Integration Details

**Anthropic Claude API:**
```gdscript
# anthropic_provider.gd
var API_URL = "https://api.anthropic.com/v1/messages"
var MODEL = "claude-3-5-sonnet-20241022"

func chat(messages: Array) -> Dictionary:
    var headers = [
        "Content-Type: application/json",
        "x-api-key: " + api_key,
        "anthropic-version: 2023-06-01"
    ]
    var body = {
        "model": MODEL,
        "max_tokens": 4096,
        "messages": messages,
        "system": system_prompt
    }
    # ... HTTPRequest logic
```

**System Prompt Structure:**
```
You are a game design assistant for Godot Engine. Your role is to:
1. Understand the user's game concept through clarifying questions
2. Generate a detailed project structure in JSON format
3. Ensure the structure follows Godot best practices

Output Format (after confirmation):
{
  "project_name": "tux_adventure",
  "game_type": "2d_platformer",
  "folders": [...],
  "scenes": [...],
  "scripts": [...],
  "assets": [...]
}
```

#### Deliverables
- ✅ Kan chatta med Claude via plugin
- ✅ AI ställer clarifying questions
- ✅ AI genererar structured JSON för project
- ✅ Settings dialog för API key

---

### Fas 3: Project Scaffolding Engine (Dag 6-9)
**Mål:** Generera faktiska Godot-projekt från AI output

#### Tasks
- [ ] Implementera `folder_builder.gd`
  - [ ] `DirAccess` för folder creation
  - [ ] Recursive directory structure
  - [ ] Error handling (permissions, existing files)
- [ ] Implementera `scene_builder.gd`
  - [ ] `PackedScene` generation
  - [ ] Node hierarchy creation (CharacterBody2D, Sprite2D, etc.)
  - [ ] `ResourceSaver` för .tscn files
  - [ ] Scene templates för common patterns
- [ ] Implementera `script_builder.gd`
  - [ ] Template system (`.gd.template` files)
  - [ ] Variable substitution ({{CHARACTER_NAME}}, etc.)
  - [ ] `FileAccess` för script writing
- [ ] Implementera `asset_builder.gd`
  - [ ] Placeholder sprite generation (ColorRect → PNG)
  - [ ] Placeholder audio (silent .ogg)
  - [ ] Placeholder fonts
- [ ] Implementera `project_updater.gd`
  - [ ] Update `project.godot` (autoloads, input map)
  - [ ] ConfigFile parsing/writing
- [ ] Implementera `project_generator.gd` (orchestrator)
  - [ ] Parse AI JSON
  - [ ] Call builders in correct order
  - [ ] Progress reporting
  - [ ] Rollback on error

#### Scene Generation Example
```gdscript
# scene_builder.gd
func create_player_scene(data: Dictionary) -> void:
    var scene_root = CharacterBody2D.new()
    scene_root.name = data.get("name", "Player")
    
    # Add Sprite2D
    var sprite = Sprite2D.new()
    sprite.name = "Sprite"
    scene_root.add_child(sprite)
    sprite.owner = scene_root
    
    # Add CollisionShape2D
    var collision = CollisionShape2D.new()
    collision.name = "CollisionShape"
    var shape = RectangleShape2D.new()
    shape.size = Vector2(32, 64)
    collision.shape = shape
    scene_root.add_child(collision)
    collision.owner = scene_root
    
    # Attach script
    var script_path = data.get("script_path", "")
    if script_path:
        scene_root.set_script(load(script_path))
    
    # Save scene
    var packed = PackedScene.new()
    packed.pack(scene_root)
    var save_path = data.get("scene_path", "res://Player.tscn")
    ResourceSaver.save(packed, save_path)
```

#### Script Template Example
```gdscript
# templates/player_movement.gd.template
extends CharacterBody2D

@export var speed: float = 200.0
@export var jump_velocity: float = -400.0
@export var double_jump_enabled: bool = {{DOUBLE_JUMP}}

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var jumps_remaining: int = {{MAX_JUMPS}}

func _physics_process(delta: float) -> void:
    # Gravity
    if not is_on_floor():
        velocity.y += gravity * delta
    else:
        jumps_remaining = {{MAX_JUMPS}}
    
    # Jump
    if Input.is_action_just_pressed("jump") and jumps_remaining > 0:
        velocity.y = jump_velocity
        jumps_remaining -= 1
    
    # Movement
    var direction = Input.get_axis("move_left", "move_right")
    velocity.x = direction * speed
    
    move_and_slide()
```

#### Deliverables
- ✅ Kan generera folder structure från JSON
- ✅ Kan generera .tscn scenes programmatically
- ✅ Kan generera .gd scripts från templates
- ✅ Kan skapa placeholder assets
- ✅ Kan uppdatera project.godot

---

### Fas 4: UI Polish & Workflow (Dag 10-11)
**Mål:** Smooth user experience

#### Tasks
- [ ] Implementera confirmation dialog
  - [ ] Visa preview av vad som ska genereras
  - [ ] "Generate", "Modify", "Cancel" buttons
- [ ] Implementera progress bar
  - [ ] Show current step (folders, scenes, scripts, assets)
  - [ ] Percentage completion
- [ ] Implementera error handling
  - [ ] API errors (rate limits, invalid key)
  - [ ] File system errors (permissions)
  - [ ] Rollback mechanism
- [ ] Implementera chat history save/load
  - [ ] Save conversation to .json
  - [ ] Load previous conversations
- [ ] Styling
  - [ ] Custom theme för chat panel
  - [ ] Syntax highlighting för code snippets
  - [ ] Icons för message types

#### Deliverables
- ✅ Polished UI
- ✅ Clear progress feedback
- ✅ Robust error handling
- ✅ Conversation persistence

---

### Fas 5: Multi-Provider Support (Dag 12-13)
**Mål:** Support för OpenAI och Gemini

#### Tasks
- [ ] Implementera `openai_provider.gd`
  - [ ] GPT-4 API integration
  - [ ] Structured output via function calling
- [ ] Implementera `gemini_provider.gd`
  - [ ] Gemini API integration
  - [ ] JSON mode
- [ ] Provider selection i settings
- [ ] Unified response format
- [ ] Test alla providers

#### Deliverables
- ✅ 3 AI providers fungerar
- ✅ User kan välja provider
- ✅ Consistent output från alla

---

### Fas 6: Testing & Documentation (Dag 14-15)
**Mål:** Production-ready plugin

#### Tasks
- [ ] Skapa test cases
  - [ ] 2D platformer
  - [ ] Top-down RPG
  - [ ] Visual novel
  - [ ] Puzzle game
- [ ] Skapa README.md
  - [ ] Installation instructions
  - [ ] API key setup
  - [ ] Usage guide
  - [ ] Examples
- [ ] Skapa video tutorial
- [ ] Bug fixes
- [ ] Performance optimization

#### Deliverables
- ✅ Tested med multiple game types
- ✅ Complete documentation
- ✅ Ready för release

---

## AI System Prompt Design

### Main System Prompt
```
You are an expert game design assistant for Godot Engine 4.x. Your role is to help users scaffold complete game projects from natural language descriptions.

CONVERSATION FLOW:
1. UNDERSTAND: Ask clarifying questions about:
   - Game genre (platformer, RPG, puzzle, etc.)
   - Core mechanics
   - Number of levels/areas
   - Main characters/entities
   - Art style (2D/3D, pixel art, etc.)

2. CONFIRM: Present a detailed project structure and ask for confirmation

3. GENERATE: Output structured JSON for project generation

OUTPUT FORMAT (after user confirms):
{
  "project_name": "string",
  "game_type": "2d_platformer|top_down_rpg|visual_novel|puzzle|other",
  "description": "string",
  "folders": [
    {"path": "res://Assets/Sprites/Player", "description": "Player sprites"}
  ],
  "scenes": [
    {
      "path": "res://Scenes/Player/Player.tscn",
      "type": "CharacterBody2D",
      "children": ["Sprite2D", "CollisionShape2D"],
      "script": "res://Scripts/Player/movement.gd"
    }
  ],
  "scripts": [
    {
      "path": "res://Scripts/Player/movement.gd",
      "template": "player_movement",
      "variables": {
        "DOUBLE_JUMP": true,
        "MAX_JUMPS": 2,
        "SPEED": 200
      }
    }
  ],
  "assets": [
    {
      "path": "res://Assets/Sprites/Player/idle.png",
      "type": "placeholder_sprite",
      "size": [32, 64],
      "color": "#4A90E2"
    }
  ],
  "autoloads": [
    {"name": "GameManager", "path": "res://Scripts/Managers/game_manager.gd"}
  ],
  "input_map": [
    {"action": "move_left", "keys": ["A", "Left"]},
    {"action": "move_right", "keys": ["D", "Right"]},
    {"action": "jump", "keys": ["Space", "W"]}
  ]
}

BEST PRACTICES:
- Follow Godot naming conventions (PascalCase for scenes, snake_case for scripts)
- Organize by feature, not by type
- Include essential managers (GameManager, SaveSystem)
- Set up input map with sensible defaults
- Create placeholder assets with descriptive names
```

---

## JSON Schema för AI Output

```json
{
  "$schema": "http://json-schema.org/draft-07/schema#",
  "type": "object",
  "required": ["project_name", "game_type", "folders", "scenes", "scripts"],
  "properties": {
    "project_name": {
      "type": "string",
      "pattern": "^[a-z0-9_]+$"
    },
    "game_type": {
      "type": "string",
      "enum": ["2d_platformer", "top_down_rpg", "visual_novel", "puzzle", "other"]
    },
    "description": {
      "type": "string"
    },
    "folders": {
      "type": "array",
      "items": {
        "type": "object",
        "required": ["path"],
        "properties": {
          "path": {"type": "string"},
          "description": {"type": "string"}
        }
      }
    },
    "scenes": {
      "type": "array",
      "items": {
        "type": "object",
        "required": ["path", "type"],
        "properties": {
          "path": {"type": "string"},
          "type": {"type": "string"},
          "children": {"type": "array", "items": {"type": "string"}},
          "script": {"type": "string"}
        }
      }
    },
    "scripts": {
      "type": "array",
      "items": {
        "type": "object",
        "required": ["path", "template"],
        "properties": {
          "path": {"type": "string"},
          "template": {"type": "string"},
          "variables": {"type": "object"}
        }
      }
    },
    "assets": {
      "type": "array",
      "items": {
        "type": "object",
        "required": ["path", "type"],
        "properties": {
          "path": {"type": "string"},
          "type": {"type": "string"},
          "size": {"type": "array", "items": {"type": "integer"}},
          "color": {"type": "string"}
        }
      }
    },
    "autoloads": {
      "type": "array",
      "items": {
        "type": "object",
        "required": ["name", "path"],
        "properties": {
          "name": {"type": "string"},
          "path": {"type": "string"}
        }
      }
    },
    "input_map": {
      "type": "array",
      "items": {
        "type": "object",
        "required": ["action", "keys"],
        "properties": {
          "action": {"type": "string"},
          "keys": {"type": "array", "items": {"type": "string"}}
        }
      }
    }
  }
}
```

---

## Script Templates

### Player Movement Template
```gdscript
# templates/player_movement.gd.template
extends CharacterBody2D

@export var speed: float = {{SPEED}}
@export var jump_velocity: float = {{JUMP_VELOCITY}}
@export var double_jump_enabled: bool = {{DOUBLE_JUMP}}

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var jumps_remaining: int = {{MAX_JUMPS}}

func _physics_process(delta: float) -> void:
    if not is_on_floor():
        velocity.y += gravity * delta
    else:
        jumps_remaining = {{MAX_JUMPS}}
    
    if Input.is_action_just_pressed("jump") and jumps_remaining > 0:
        velocity.y = jump_velocity
        jumps_remaining -= 1
    
    var direction = Input.get_axis("move_left", "move_right")
    velocity.x = direction * speed
    
    move_and_slide()
```

### Collectible Template
```gdscript
# templates/collectible.gd.template
extends Area2D

signal collected(value: int)

@export var value: int = {{VALUE}}
@export var auto_collect: bool = {{AUTO_COLLECT}}

func _ready() -> void:
    body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node2D) -> void:
    if body.is_in_group("player"):
        collect()

func collect() -> void:
    collected.emit(value)
    queue_free()
```

### Game Manager Template
```gdscript
# templates/game_manager.gd.template
extends Node

signal score_changed(new_score: int)
signal game_over()

var score: int = 0
var is_paused: bool = false

func _ready() -> void:
    process_mode = Node.PROCESS_MODE_ALWAYS

func add_score(amount: int) -> void:
    score += amount
    score_changed.emit(score)

func pause_game() -> void:
    is_paused = true
    get_tree().paused = true

func resume_game() -> void:
    is_paused = false
    get_tree().paused = false

func restart_game() -> void:
    score = 0
    get_tree().reload_current_scene()
```

---

## Technical Challenges & Solutions

### Challenge 1: AI API Rate Limits
**Problem:** Free tiers har låga rate limits  
**Solution:**
- Implementera request queuing
- Show "Thinking..." indicator
- Fallback till annan provider
- Cache common responses

### Challenge 2: Scene Generation Complexity
**Problem:** Godot scenes kan vara komplexa med många nodes  
**Solution:**
- Start med simple templates (CharacterBody2D + Sprite + Collision)
- Expandera gradvis med fler node types
- Använd scene inheritance för variants

### Challenge 3: Asset Placeholder Quality
**Problem:** Placeholder assets ser dåliga ut  
**Solution:**
- Generera simple colored shapes (ColorRect → PNG)
- Använd Godot's built-in icons
- Future: Integrera DALL-E för AI-generated sprites

### Challenge 4: User Intent Ambiguity
**Problem:** User description kan vara vag  
**Solution:**
- AI ställer targeted clarifying questions
- Show preview innan generation
- Allow modification av structure

### Challenge 5: Project Overwrites
**Problem:** Risk att overwrite existing files  
**Solution:**
- Check för existing files innan generation
- Prompt user för overwrite confirmation
- Backup option
- Rollback mechanism

---

## Future Extensions (Post-MVP)

### Phase 2 Features
- [ ] **Asset Generation Integration**
  - DALL-E för sprite generation
  - ElevenLabs för voice/SFX
  - Suno för music
- [ ] **Code Generation**
  - Custom mechanic implementation
  - State machine generation
  - Inventory system
- [ ] **Dialog System**
  - Dialog tree generation från story outline
  - Character relationship graphs
- [ ] **Quest System**
  - Quest structure från narrative
  - Objective tracking
- [ ] **Level Design**
  - Tilemap generation från description
  - Enemy placement
  - Collectible distribution

### Phase 3 Features
- [ ] **Multiplayer Scaffolding**
  - Network sync setup
  - Lobby system
- [ ] **Localization Setup**
  - Translation keys
  - CSV structure
- [ ] **Analytics Integration**
  - Event tracking setup
  - Telemetry boilerplate

---

## Success Metrics

### MVP Success Criteria
- [ ] Plugin installeras utan errors
- [ ] Chat UI fungerar smooth
- [ ] AI conversation känns natural
- [ ] Genererat projekt är runnable
- [ ] Genererade scripts har no syntax errors
- [ ] User kan börja utveckla direkt efter generation

### User Experience Goals
- **Time to First Playable:** < 5 minuter från chat start
- **Conversation Length:** 3-5 messages innan confirmation
- **Generation Time:** < 30 sekunder för standard project
- **Success Rate:** > 90% av generationer fungerar first try

---

## Development Timeline

| Fas | Duration | Deliverable |
|-----|----------|-------------|
| 1. EditorPlugin Foundation | 2 dagar | Working chat UI |
| 2. AI Integration | 3 dagar | Claude conversation |
| 3. Scaffolding Engine | 4 dagar | Project generation |
| 4. UI Polish | 2 dagar | Smooth UX |
| 5. Multi-Provider | 2 dagar | 3 AI providers |
| 6. Testing & Docs | 2 dagar | Production ready |
| **Total** | **15 dagar** | **v1.0 Release** |

---

## Getting Started (Development)

### Prerequisites
- Godot 4.3+
- API keys för:
  - Anthropic Claude (required)
  - OpenAI GPT (optional)
  - Google Gemini (optional)

### Setup
```bash
# 1. Clone/create addons folder
mkdir -p addons/story_builder

# 2. Create plugin.cfg
# 3. Create plugin.gd
# 4. Enable in Project Settings → Plugins

# 5. Add API key in plugin settings
```

### First Test
1. Open Story Builder panel (bottom dock)
2. Enter API key in settings
3. Type: "I want to make a simple platformer"
4. Follow AI conversation
5. Click "Generate Project"
6. Verify generated structure

---

## Conclusion

Story Builder har potential att revolutionera hur folk börjar sina Godot-projekt. Genom att kombinera AI's förmåga att förstå naturligt språk med Godot's kraftfulla editor API kan vi skapa ett verktyg som:

- **Sänker inträdesbarriären** för nya utvecklare
- **Accelererar prototyping** för erfarna utvecklare
- **Enforcar best practices** genom AI-genererad struktur
- **Inspirerar kreativitet** genom AI-drivna förslag

Med en solid implementation i GDScript (inte GDExtension) kan vi leverera detta snabbt och iterera baserat på user feedback.

**Next Step:** Börja med Fas 1 - EditorPlugin Foundation.
