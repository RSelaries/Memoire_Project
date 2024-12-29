@tool
extends Node3D
class_name RustedMetro


@export var metro_gltf : Node3D
@export var light_fixture_material : StandardMaterial3D
@export var lights_parent_node : Node3D

@export var lights_color : Color = Color.WHITE
@export_range(0.0, 16.0, 0.01, "or_greater") var lights_energy : float = 1.0
@export_range(0.0, 16.0, 0.5, "or_greater") var lights_material_emission_intensity : float = 1

@export var update_preview_button : bool = false:
	set(value):
		if value == true:
			update_material_and_lights()
			value = false

@onready var light_fixtures_material_unique : StandardMaterial3D = light_fixture_material.duplicate(true)

func _ready() -> void:
	if metro_gltf.get_child(0) is MeshInstance3D:
			var metro_mesh : MeshInstance3D = metro_gltf.get_child(0)
			if light_fixtures_material_unique:
				metro_mesh.set_surface_override_material(0, light_fixtures_material_unique)
				light_fixtures_material_unique.emission_enabled = true
			
	update_material_and_lights()


func update_material_and_lights() -> void:
	if light_fixtures_material_unique:
		if lights_color:
			light_fixtures_material_unique.albedo_color = lights_color
			light_fixtures_material_unique.emission = lights_color
			light_fixtures_material_unique.emission_energy_multiplier = lights_material_emission_intensity
	
	if lights_parent_node and lights_parent_node.get_children():
		var lights : Array[Node] = lights_parent_node.get_children()
		for light in lights:
			if light is OmniLight3D:
				var omni_light :OmniLight3D = light
				omni_light.light_energy = lights_energy
				omni_light.light_color = lights_color
