@tool
extends HBoxContainer
signal imageSelected

func _on_image_browser_btn_down() -> void:
	$ImageBrowserBtn/ImageBrowser.visible = true


func _on_image_browser_file_selected(path: String) -> void:
	$ImageText.text = path 
	imageSelected.emit(path)
