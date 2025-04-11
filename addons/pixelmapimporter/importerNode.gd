@tool
extends Node
@export_global_file("*.png") var pixelImage
#@export_node_path() var testMap

@export_tool_button("Generate", "Callable") var generate_action = generate
@export_tool_button("Popup", "Callable") var popup_action = colorPopup
@export_tool_button("Test", "Callable") var test_action = test

var popup : Window
var colorLib : Dictionary[Color, int] = {}

func _enter_tree():
	#var popup = preload("res://addons/pixelmapimporter/importerPopup.tscn").instantiate()
	#add_child(popup)
	#print("added popup")
	pass


func generate():
	if(pixelImage):
		var image:Image = load(pixelImage)
		var width = image.get_width()
		var height = image.get_height()
		
		print("image is "+str(width)+"x"+str(height)+"px")
		var pixel = image.get_pixel(1,6)
		print(pixel)
		
		getImageColors(image)
	else:
		print("no img provided")
	

func getImageColors(image:Image):
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
	colorPopup()
	print(colorLib)

	
	
func colorPopup():
	print(colorLib)
	#$ImporterPopup.show()
	print("colorPop")
	#print($ImporterPopup.visible)
	popup = Window.new()
	popup.name = "importPop"
	popup.initial_position = Window.WINDOW_INITIAL_POSITION_CENTER_PRIMARY_SCREEN
	popup.size = Vector2i(800, 400)
	popup.exclusive = true
	popup.borderless = false
	popup.close_requested.connect(popup.queue_free)
	var scroll = ScrollContainer.new()
	scroll.set_anchors_preset(Control.PRESET_FULL_RECT)
	var grid = VBoxContainer.new()
	grid.name = "meshAsignList"
	grid.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	grid.set_anchors_preset(Control.PRESET_FULL_RECT)
	scroll.add_child(grid)
	
	var gMap : GridMap = get_parent()
	var meshLib : MeshLibrary = gMap.mesh_library
	print(meshLib.get_item_list())
	
	var testSc = PackedScene.new()
	var meshSel = OptionButton.new()
	meshSel.set_anchors_preset(Control.PRESET_FULL_RECT)

	for i in meshLib.get_item_list():
		var name = meshLib.get_item_name(i)
		var img = meshLib.get_item_preview(i)
		meshSel.add_icon_item(img, name)
		
	testSc.pack(meshSel)
	
	
	
	var lineRes = preload("res://addons/pixelmapimporter/colorAsignLine.tscn")
	for i in colorLib:
		var curLine = lineRes.instantiate()
		#var cRect = ColorRect.new()
		#cRect.size = Vector2(10,10)
		#cRect.custom_minimum_size = Vector2(10,10)
		#cRect.color = i
		curLine.get_node("ColorDisplay").color = i
		curLine.get_node("ColorValue").text = i.to_html()
		#curLine.get_node("DropdownPlaceholder").add_child(testSc.instantiate())
		var testSel = testSc.instantiate()
		testSel.item_selected.connect(selChange.bind(testSel))
		testSel.selected = colorLib[i]
		curLine.add_child(testSel)
		#grid.add_child(cRect)
		grid.add_child(curLine)
	
	
	var runBtn = Button.new()
	runBtn.text = "run gen"
	runBtn.pressed.connect(genMap)
	grid.add_child(runBtn)
	
	
	popup.add_child(scroll)
	EditorInterface.popup_dialog(popup)

func genMap():
	print(get_viewport().get_parent().get_parent().get_parent())
	print(popup.find_child("ColorAsignLine"))
	print(popup.find_child("ColorAsignLine", true, false ))

func selChange(e,d):
	#print(e)
	#print(d)
	var curColHtml = d.get_parent().find_child("ColorValue").text
	var curCol = Color.from_string(curColHtml, Color.DEEP_PINK)
	if(colorLib.has(curCol)):
		colorLib[curCol] = e
	else:
		print("color not found in lib")
	
func test():
	#$ImporterPopup.show()
	#print(get_children())
	#print($ImporterPopup.visible)
	popup = Window.new()
	popup.initial_position = Window.WINDOW_INITIAL_POSITION_CENTER_PRIMARY_SCREEN
	popup.size = Vector2i(150, 50)
	popup.exclusive = true
	popup.borderless = false
	popup.close_requested.connect(popup.queue_free)
	
	EditorInterface.popup_dialog(popup)
	
