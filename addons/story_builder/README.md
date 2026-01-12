# Story Builder for Godot Engine

Story Builder is an AI-powered project scaffolding plugin for Godot Engine 4.x. It allows you to describe your game idea in natural language and automatically generates the necessary folder structure, scenes, scripts, and placeholder assets to get you started in minutes.

## Features

- **AI Chat Interface**: Refine your game concept through a conversation with an AI assistant.
- **Multi-Provider Support**: Supports Anthropic Claude (3.5 Sonnet), OpenAI GPT-4o, and Google Gemini 1.5 Pro.
- **Automated Scaffolding**:
    - Creates organized folder structures (res://Assets, res://Scenes, res://Scripts, etc.).
    - Generates .tscn scenes with proper node hierarchies (CharacterBody2D, Area2D, etc.).
    - Produces starter GDScript files from templates (Movement, Collectibles, Managers).
    - Generates placeholder sprites (colored PNGs).
- **Project Integration**: Automatically updates Project Settings (Autoloads, Input Map).
- **Confirmation Workflow**: Review and approve the AI-proposed structure before any files are created.
- **Persistence**: Remembers your chat history and settings across sessions.

## Installation

1. Copy the `addons/story_builder` folder into your Godot project's `addons` directory.
2. Open Godot and go to **Project -> Project Settings -> Plugins**.
3. Enable the **Story Builder** plugin.
4. The Story Builder panel will appear in your **Bottom Panel** (next to Output, Debugger, etc.).

## Setup

1. Click the **Settings** button in the Story Builder panel.
2. Select your preferred AI provider.
3. Enter your API key for the chosen provider.
    - *Tip: You can also set the `ANTHROPIC_API_KEY` environment variable.*
4. Click **Save**.

## How to Use

1. **Describe your idea**: Type something like "I want to make a 2D platformer adventure game about a dog named Tux".
2. **Converse**: The AI will ask clarifying questions about mechanics, genre, and scope.
3. **Review**: Once satisfied, the AI will propose a project structure. A confirmation dialog will open.
4. **Generate**: Review the proposed files and click **Generate Project**.
5. **Explore**: Your new project structure is ready in the FileSystem dock!

## Technical Details

- **Language**: 100% GDScript.
- **Architecture**: Modular design with separate builders for folders, scenes, scripts, and assets.
- **Templates**: Easily customizable .gd.template files in `addons/story_builder/templates/`.

## License

MIT License - Feel free to use and modify for your own projects.
