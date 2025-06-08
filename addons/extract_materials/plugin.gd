class_name ExtractMaterialsPlugin extends EditorScenePostImportPlugin

func _get_import_options(path: String) -> void:
  add_import_option("materials/extract", false)
  add_import_option("materials/extract_path", path.get_base_dir().path_join("materials"))

func _pre_process(scene: Node) -> void:
  if not get_option_value("materials/extract"): return
  if not get_option_value("materials/extract_path"): return
  var sub := get_option_value("_subresources") as Dictionary
  if not sub.has("materials"):
    sub["materials"] = {}

  var dir := get_option_value("materials/extract_path") as String
  var materials := find_materials(scene, {})
  for name in materials:
    var path := dir.path_join(name.to_lower()) + ".tres"
    if not ResourceLoader.exists(path):
      var mat := materials[name]
      ResourceSaver.save(mat, path)
      sub["materials"][name] = {
        "use_external/enabled": true,
        "use_external/path": path
      }

func find_materials(node: Node, dict: Dictionary[String, Material]) -> Dictionary[String, Material]:
  if node is ImporterMeshInstance3D:
    var mesh := node.mesh as ImporterMesh
    for i in mesh.get_surface_count():
      var sname = mesh.get_surface_name(i)
      var smat = mesh.get_surface_material(i)
      dict[sname] = smat
  for child in node.get_children():
    find_materials(child, dict)
  return dict
