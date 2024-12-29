extends Camera3D


@export var camera : Camera3D

@export var shake_intensity : float = 0.01
@export var shake_frequency : float = 1.0
@export var shake_noise_scale : float = 0.1

var shake_oscillation_timer: float = 0.0
@export var shake_oscillation_speed: float = 0.5
@export var shake_oscillation_amplitude: float = 0.05

@onready var noise := FastNoiseLite.new()

var original_position: Vector3


func _ready() -> void:
	original_position = self.position
	#noise.seed = int(randf() * 10000)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	position = original_position
	apply_shake(delta)
	apply_oscillation(delta)


func apply_shake(delta: float) -> void:
	# Génère des secousses basées sur le bruit
	var shake_x := noise.get_noise_2d(Engine.get_physics_frames() * shake_noise_scale, 0) * shake_intensity * delta
	var shake_y := noise.get_noise_2d(0, Engine.get_physics_frames() * shake_noise_scale) * shake_intensity * delta
	translate_object_local(Vector3(shake_x, shake_y, 0))


func apply_oscillation(delta: float) -> void:
	# Ajoute une oscillation périodique pour imiter le roulis
	shake_oscillation_timer += delta
	var roll_angle := sin(shake_oscillation_timer * shake_oscillation_speed) * shake_oscillation_amplitude
	rotation_degrees.z = roll_angle
