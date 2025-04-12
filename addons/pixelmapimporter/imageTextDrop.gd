@tool
extends LineEdit
signal fileDroped


func _can_drop_data(_pos, data):
	return data["type"] == "files"


func _drop_data(_pos, data):
	#@TODO maybe add errorhandling for multiple files
	#@TODO  check if png
	fileDroped.emit(data.files[0])
