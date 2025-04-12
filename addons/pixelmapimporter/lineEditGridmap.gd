@tool
extends LineEdit
signal gridmapDroped


func _can_drop_data(_pos, data):
	return data["type"] == "nodes"


func _drop_data(_pos, data):
	#@TODO maybe add errorhandling for multiple nodes
	#@TODO  check if gridmap
	text = get_node(data.nodes[0]).name
	gridmapDroped.emit(data.nodes[0])
	
