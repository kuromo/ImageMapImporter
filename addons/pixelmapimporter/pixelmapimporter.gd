@tool
extends EditorPlugin

var dock

func _enter_tree():
	# Initialization of the plugin goes here.
	# Add the new type with a name, a parent type, a script and an icon.
	add_custom_type("importer", "Node", preload("importerNode.gd"), preload("res://icon.svg"))
	
	dock = preload("res://addons/pixelmapimporter/importerDock.tscn").instantiate()
	#dock.add_child(EditorResourcePicker.new())
	add_control_to_dock(DOCK_SLOT_RIGHT_BL, dock)

func _exit_tree():
	# Clean-up of the plugin goes here.
	# Always remember to remove it from the engine when deactivated.
	remove_custom_type("testBtn")
	
	remove_control_from_docks(dock)
	dock.free()
