extends CanvasLayer


@export var fps_counter : Label
@export var theme_select : OptionButton

@onready var render_scene := get_tree().get_root().find_child("RenderScene", true, false) as RenderScene



func _ready() -> void:
	for theme in render_scene.metro_scene_themes:
		theme_select.add_item(theme.theme_name)
		
	


func _process(_delta: float) -> void:
	fps_counter.text = "FPS : " + str(Engine.get_frames_per_second())


func _on_themes_item_selected(index: int) -> void:
	print(index)


func _on_option_button_item_selected(index: int) -> void:
	print(render_scene)
	if render_scene and index <= render_scene.metro_scene_themes.size() - 1:
		render_scene.current_theme = index
	else: theme_select.select(0)
