@tool
extends Node

var image:Image
var colorLib : Dictionary[Color, int] = {}
var gMap : GridMap


func _enter_tree():
	#var testPick = EditorResourcePicker.new()
	
	#testPick.base_type = "Node"
	#testPick.custom_minimum_size = Vector2(100,10)
	#add_child(testPick)
	pass





func loadImg(path):
	image = load(path)
	var width = image.get_width()
	var height = image.get_height()
	
	print("image is "+str(width)+"x"+str(height)+"px")
	var pixel = image.get_pixel(1,6)
	print(pixel)
	
	getImageColors()

	

func getImageColors():
	var imageColors = []
	colorLib = {}
	print(colorLib)
	for x in image.get_width():
		for y in image.get_height():
			#print(str(x)+","+str(y))
			#print(image.get_pixel(x,y))
			var pixelColor = image.get_pixel(x,y)
			#print(pixelColor)
			#print(imageColors)
			if not imageColors.has(pixelColor):
				#print("color not in arr")
				imageColors.append(pixelColor)
				colorLib[pixelColor] = 0
	#print(imageColors)
	#colorPopup(imageColors)
	print(colorLib)
	checkMapInputs()

func checkMapInputs():
	if colorLib != {} && gMap:
		populateColorAsign()



func populateColorAsign():
		
	print(colorLib)
	#$ImporterPopup.show()
	print("colorPop")
	#print($ImporterPopup.visible)
	
	var grid = find_child("ColorAssignCont")
	for n in grid.get_children():
		grid.remove_child(n)
		n.queue_free() 
	
	
	
	var meshLib : MeshLibrary = gMap.mesh_library
	print(meshLib.get_item_list())
	
	var testSc = PackedScene.new()
	var meshSel = OptionButton.new()
	meshSel.set_anchors_preset(Control.PRESET_FULL_RECT)
#
	for i in meshLib.get_item_list():
		var name = meshLib.get_item_name(i)
		var img = meshLib.get_item_preview(i)
		print(img.get_class())
		img.set_size_override(Vector2(20,20))
		meshSel.add_icon_item(img, name)
		
		#meshSel.add_item(name)
		
	testSc.pack(meshSel)
	
	
	
	var lineRes = preload("res://addons/pixelmapimporter/colorAsignLine.tscn")
	for i in colorLib:
		var curLine = lineRes.instantiate()
		curLine.get_node("ColorDisplay").color = i
		curLine.get_node("ColorValue").text = i.to_html()
		var testSel = testSc.instantiate()
		#@TODO scene causes:  ERROR: scene/main/node.cpp:1396 - Condition "name.is_empty()" is true.
		testSel.item_selected.connect(selChange.bind(testSel))
		testSel.selected = colorLib[i]
		curLine.add_child(testSel)

		grid.add_child(curLine)
		
		find_child("CollapsibleContainer").visible = true
		find_child("CollapsibleContainer").get_child(0).text = "Assign Mesh to Colors"
		find_child("GenerateBtn").visible = true


func selChange(e,d):
	#print(e)
	#print(d)
	var curColHtml = d.get_parent().find_child("ColorValue").text
	var curCol = Color.from_string(curColHtml, Color.DEEP_PINK)
	if(colorLib.has(curCol)):
		colorLib[curCol] = e
	else:
		print("color not found in lib")



func _on_button_button_down() -> void:
	#$Popup.show()
	#print("show")
	print(colorLib)
	

func _on_image_input_image_selected(path: String) -> void:
	print("emit worked")
	print(path)
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
