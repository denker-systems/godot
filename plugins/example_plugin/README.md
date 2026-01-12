# Example Plugin

Minimal GDExtension plugin som template för nya plugins.

## Bygga

```bash
cd plugins/example_plugin
scons platform=windows target=template_release
```

Output: `bin/example_plugin.windows.template_release.x86_64.dll`

## Testa i Godot

1. Kopiera `example_plugin.gdextension` + `bin/` till ett Godot-projekt:
   ```
   my_project/
   └── addons/
       └── example_plugin/
           ├── example_plugin.gdextension
           └── bin/
               └── example_plugin.windows.template_release.x86_64.dll
   ```

2. Starta Godot och skapa en ny Node → sök efter `ExampleNode`

## Skapa Ny Plugin

1. Kopiera `example_plugin/` till `my_new_plugin/`
2. Byt namn i:
   - `SConstruct` (library name)
   - `.gdextension` (entry_symbol, library paths)
   - `register_types.cpp` (function names)
3. Bygg och testa
