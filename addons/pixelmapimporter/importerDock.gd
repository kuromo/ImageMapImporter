@tool
extends Node

var image:Image
var colorLib : Dictionary[Color, int] = {}
var gMap : GridMap


func loadImg(path):
	image = load(path)
	getImageColors()


func getImageColors():
	var imageColors = []
	colorLib = {}
	for x in image.get_width():
		for y in image.get_height():
			var pixelColor = image.get_pixel(x,y)
			if not imageColors.has(pixelColor):
				imageColors.append(pixelColor)
				colorLib[pixelColor] = 0
	
	checkMapInputs()


func checkMapInputs():
	if colorLib != {} && gMap:
		populateColorAsign()


func populateColorAsign():
	#clear old content
	var vBox = find_child("ColorAssignCont")
	for n in vBox.get_children():
		vBox.remove_child(n)
		n.queue_free() 
	
	
	#create option button template with meshes of gridmap
	var meshLib : MeshLibrary = gMap.mesh_library
	var meshSel = OptionButton.new()
	meshSel.set_anchors_preset(Control.PRESET_FULL_RECT)
	for i in meshLib.get_item_list():
		var name = meshLib.get_item_name(i)
		var img = meshLib.get_item_preview(i)
		img.set_size_override(Vector2(20,20))
		meshSel.add_icon_item(img, name)	
	#add to packed scene so it can be instatiated
	var meshSelScene = PackedScene.new()
	meshSelScene.pack(meshSel)
	
	
	var lineRes = preload("res://addons/pixelmapimporter/colorAsignLine.tscn")
	for i in colorLib:
		var curLine = lineRes.instantiate()
		curLine.get_node("ColorDisplay").color = i
		curLine.get_node("ColorValue").text = i.to_html()
		var curSel = meshSelScene.instantiate()
		#@TODO scene causes:  ERROR: scene/main/node.cpp:1396 - Condition "name.is_empty()" is true.
		curSel.item_selected.connect(onMeshSelChange.bind(curSel))
		curSel.selected = colorLib[i]
		curLine.add_child(curSel)

		vBox.add_child(curLine)
		
		find_child("CollapsibleContainer").visible = true
		find_child("CollapsibleContainer").get_child(0).text = "Assign Mesh to Colors"
		find_child("GenerateBtn").visible = true


func onMeshSelChange(e,d):
	var curColHtml = d.get_parent().find_child("ColorValue").text
	var curCol = Color.from_string(curColHtml, Color.DEEP_PINK)
	if(colorLib.has(curCol)):
		colorLib[curCol] = e
	else:
		print("color not found in lib")



func _on_button_button_down() -> void:
	print(colorLib)
	

func _on_image_input_image_selected(path: String) -> void:
	loadImg(path)


func _on_map_assign_input_gridmap_droped(gridmapNode : NodePath) -> void:
	if get_node(gridmapNode).get_class() == "GridMap":
		gMap = get_node(gridmapNode)
		checkMapInputs()
	else:
		print("Wrong node type, must provide a gridmap")


func _on_generate_btn_down() -> void:
	gMap.clear()
	
	for x in image.get_width():
		for y in image.get_height():
			var col = image.get_pixel(x,y)
			gMap.set_cell_item(Vector3(x, 0, y),colorLib[col])
