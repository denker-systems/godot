# Godot Plugins

Denna mapp innehåller GDExtension-plugins som byggs separat från Godot engine.

## Struktur

```
plugins/
├── godot-cpp/          # Godot C++ bindings (submodule)
├── example_plugin/     # Exempel-plugin (template)
└── README.md
```

## Bygga en Plugin

```bash
cd plugins/my_plugin
scons platform=windows target=template_release
```

Output: `bin/my_plugin.windows.x86_64.dll`

## Använda en Plugin

1. Kopiera `.gdextension` + `bin/` till ett Godot-projekt under `res://addons/my_plugin/`
2. Aktivera i Project Settings → Plugins

## Skapa Ny Plugin

Kopiera `example_plugin/` som template och byt namn.

## Referenser
- GDExtension docs: https://docs.godotengine.org/en/stable/tutorials/scripting/gdextension/
- godot-cpp: https://github.com/godotengine/godot-cpp
