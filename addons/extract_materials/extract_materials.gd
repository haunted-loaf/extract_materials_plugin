@tool
extends EditorPlugin

var import_plugin : ExtractMaterialsPlugin

func _enter_tree() -> void:
  if not import_plugin:
    import_plugin = ExtractMaterialsPlugin.new()
  add_scene_post_import_plugin(import_plugin)

func _exit_tree() -> void:
  remove_scene_post_import_plugin(import_plugin)
