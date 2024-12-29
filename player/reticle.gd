extends CenterContainer
class_name Reticle


@export var central_dot : bool = true
@export var lines : bool = true
@export var line_width : float = 1.5
@export var line_length : float = 12.0
@export var line_color : Color = Color.WHITE
@export var offset : float = 10.0


func _process(_delta: float) -> void:
	queue_redraw()


func _draw() -> void:
	if central_dot:
		draw_circle(Vector2(0, 0), line_width * 0.75, line_color, true)
	if lines:
		draw_line(Vector2(offset, 0), Vector2(offset + line_length, 0), line_color, line_width)
		draw_line(Vector2(-offset, 0), Vector2(-offset + -line_length, 0), line_color, line_width)
		draw_line(Vector2(0, offset), Vector2(0, offset + line_length), line_color, line_width)
		draw_line(Vector2(0, -offset), Vector2(0, -offset + -line_length), line_color, line_width)


func fade_out() -> void:
	var tween := create_tween()
	tween.set_parallel(true)
	tween.tween_property(self, "line_color", Color(line_color.r, line_color.g, line_color.b, 0), 0.1)

func fade_in() -> void:
	var tween := create_tween()
	tween.set_parallel(true)
	tween.tween_property(self, "line_color", Color(line_color.r, line_color.g, line_color.b, 1), 0.1)
