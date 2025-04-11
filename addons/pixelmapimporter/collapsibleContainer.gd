@tool
extends Control

func _enter_tree() -> void:
	var gui = EditorInterface.get_base_control()
	$CollapseBtn.icon = gui.get_theme_icon("GuiTreeArrowRight", "EditorIcons")
	pass
	


func _on_collapse_button_down() -> void:
	print("collapse pressed")
	if get_child_count() > 1:
		print(get_children())
		get_child(1).visible = !get_child(1).visible
		var gui = EditorInterface.get_base_control()
		if get_child(1).visible:
			$CollapseBtn.icon = gui.get_theme_icon("GuiTreeArrowDown", "EditorIcons")
		else:
			$CollapseBtn.icon = gui.get_theme_icon("GuiTreeArrowRight", "EditorIcons")
	
