extends Node


const debug_screenshots_directory = "E:/Bureau - Racourcis/Ensaama/Mémoire/Lafont/screenshots"
const DEBUG_MENU = preload("res://gui/debug_menu.tscn")


@onready var debug_menu_node : CanvasLayer = DEBUG_MENU.instantiate() if DEBUG_MENU else null

func _ready() -> void:
	get_window().size = Vector2(1545, 937)
	get_window().position = Vector2(7, 135)
	toggle_debug_menu("on")


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("debug_screenshot"):
		take_screenshot(debug_screenshots_directory)
		
	if event.is_action_pressed("debug_menu"):
		toggle_debug_menu()


func take_screenshot(directory: String) -> void:
	var screenshot := get_viewport().get_texture().get_image()
	if !DirAccess.open(directory):
		DirAccess.open(debug_screenshots_directory.rsplit("/", true, 1)[0]).make_dir("screenshots")
	
	var screenshot_nbr := get_nbr_of_files_in_dir(debug_screenshots_directory, "screenshot")
	while DirAccess.open(directory).file_exists("screenshot_" + str(screenshot_nbr) + ".png"):
		screenshot_nbr += 1
	screenshot.save_png(debug_screenshots_directory + "/screenshot_" + str(screenshot_nbr) + ".png")


func get_nbr_of_files_in_dir(directory: String, file_name: String = "") -> float:
	var number : float = 0.0
	
	var folder := DirAccess.open(directory)
	folder.list_dir_begin()
	while true:
		var file := folder.get_next()
		if file == "":
			break
		elif not file.begins_with("."):
			if file_name == "":
				number += 1
			elif file.begins_with(file_name):
				number += 1
	
	return number

## Can be either "toggle", "on" or "off"
func toggle_debug_menu(mode : String = "toggle") -> void:
	if debug_menu_node == null:
		return
	
	if !get_child_count() > 0:
		add_child(debug_menu_node)
		debug_menu_node.visible = false
	
	var child := get_child(0) as CanvasLayer
	match mode:
		"toggle":
			child.visible = !child.visible
		"on":
			child.visible = true
		"off":
			child.visible = false
