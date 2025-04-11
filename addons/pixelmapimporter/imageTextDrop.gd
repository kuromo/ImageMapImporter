@tool
extends LineEdit
signal fileDroped

func _get_drag_data(position: Vector2):
	print("got data")
	
	
func _can_drop_data(_pos, data):
	return data["type"] == "files"


func _drop_data(_pos, data):
	#@TODO maybe add errorhandling for multiple files
	#@TODO  check if png
	#print(data.files)

	#text = data.files[0]
	fileDroped.emit(data.files[0])
