# Changelog

All notable changes to Godot Custom Plugins.

## [Unreleased]

### Added
- **Story Builder Plugin** - AI-driven game project scaffolding
  - Multi-provider support (Anthropic, OpenAI, Gemini)
  - Model selection per provider
  - Chat panel in bottom dock
  - Settings dialog for API keys
  - Confirmation dialog with tree preview
  - Console debugging with prefixed logging
  - Clear History, Copy Chat, Clear Generated buttons
  - Auto-create directories during scaffolding
  - ROADMAP.md with v1.0 status and v2.0 plans

- **GDExtension Plugin Structure**
  - Example plugin with SConstruct
  - GDEXTENSION_STANDARDS.md coding guide
  - create-plugin.md workflow

### Changed
- Anthropic provider max_tokens: 4096 → 8192
- System prompt updated for compact JSON

### Fixed
- Confirmation dialog now closes after generate
- Asset/script builders create parent directories
- JSON parsing for long responses

---

## [0.1.0] - 2026-01-12

### Added
- Initial Story Builder plugin implementation
- Initial GDExtension plugin structure
