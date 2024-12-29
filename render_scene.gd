@tool
extends Control
class_name RenderScene


@export var sub_viewport_container : SubViewportContainer
@export var sub_viewport : SubViewport
@export var post_processing_control_node : Control

@export var metro_scene_themes : Array[RustedMetroTheme] = []
@export var current_theme := 0:
	set(value):
		current_theme = value
		if ready_executed:
			update_theme()


var ready_executed := false

var time_acumulator : float = 0.0

func _ready() -> void:
	get_viewport().size_changed.connect(viewport_size_changed)
	sub_viewport.size = get_viewport_rect().size

	update_theme()
	ready_executed = true


func _process(_delta: float) -> void:
	if OS.is_debug_build() and !Engine.is_editor_hint():
		update_theme()


func viewport_size_changed() -> void:
	sub_viewport.size = get_viewport_rect().size


func update_theme() -> void:
	var metro_theme : RustedMetroTheme = metro_scene_themes[current_theme]

	# Metro lights and world environment
	if metro_scene_themes[current_theme] and metro_theme.world_environment:
		var world_environment : WorldEnvironment = sub_viewport.find_child("WorldEnvironment", true, false)
		world_environment.environment = metro_theme.world_environment

		var rusted_metro : RustedMetro = find_child("RustedMetro", true, false)
		rusted_metro.lights_color = metro_theme.lights_color
		rusted_metro.lights_energy = metro_theme.lights_energy
		rusted_metro.lights_material_emission_intensity = metro_theme.lights_material_emission_intensity

		rusted_metro._ready()

	# Psx Dithering
	var sub_material : ShaderMaterial = sub_viewport_container.material
	sub_material.set_shader_parameter("enabled", metro_theme.psx_dithering)

	# RGB Threshold
	var threshold_node : ColorRect = post_processing_control_node.find_child("ThresholdShader")
	var threshold_material : ShaderMaterial = threshold_node.material
	threshold_material.set_shader_parameter("enabled", metro_theme.color_threshold)
	if metro_theme.color_threshold:
		threshold_material.set_shader_parameter("threshold_r", metro_theme.thresh_r)
		threshold_material.set_shader_parameter("threshold_g", metro_theme.thresh_g)
		threshold_material.set_shader_parameter("threshold_b", metro_theme.thresh_b)
