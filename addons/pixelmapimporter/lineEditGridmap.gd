@tool
extends LineEdit
signal gridmapDroped

func _get_drag_data(position: Vector2):
	print("got data")
	
	
func _can_drop_data(_pos, data):
	#return typeof(data) == TYPE_NODE
	return data["type"] == "nodes"


func _drop_data(_pos, data):
	#@TODO maybe add errorhandling for multiple nodes
	#@TODO  check if gridmap
	#print(data.nodes[0])
	#print(get_node(data.nodes[0]).name)
	text = get_node(data.nodes[0]).name
	gridmapDroped.emit(data.nodes[0])
	
