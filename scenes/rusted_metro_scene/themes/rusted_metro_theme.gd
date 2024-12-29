extends Resource
class_name RustedMetroTheme

@export var theme_name : String

@export var lights_color : Color = Color.WHITE
@export_range(0.0, 16.0, 0.01, "or_greater") var lights_energy : float = 1.0
@export_range(0.0, 16.0, 0.5, "or_greater") var lights_material_emission_intensity : float = 1

@export var world_environment : Environment

@export_group("Post Processing")
@export var psx_dithering : bool = false
@export_subgroup("Color Threshold")
@export var color_threshold : bool = false
@export var thresh_r : float
@export var thresh_g : float
@export var thresh_b : float
