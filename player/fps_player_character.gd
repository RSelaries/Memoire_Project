extends CharacterBody3D


@export var neck : Node3D
@export var camera : Camera3D

@export_group("Movement Settings")
@export var use_jump : bool = true
@export var speed : float = 5.0
@export var jump_velocity : float = 4.5
@export var mouse_sensitivity : float = 0.003
@export var action_names := {
	"frw" : "movement_forward",
	"lft" : "movement_left",
	"bck" : "movement_backward",
	"rgt" : "movement_right",
}

var health : float = 100.0


func _unhandled_input(event: InputEvent) -> void:
	# Handle mouse camera view
	if event is InputEventMouseMotion and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		var event_mouse_motion : InputEventMouseMotion = event
		
		neck.rotate_y( -event_mouse_motion.relative.x * mouse_sensitivity)
		camera.rotate_x( -event_mouse_motion.relative.y * mouse_sensitivity )
		camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(-90), deg_to_rad(90) )


func _physics_process(delta: float) -> void:
	# Add the gravity
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump
	if use_jump:
		if Input.is_action_just_pressed("ui_accept") and is_on_floor():
			velocity.y = jump_velocity

	# Get the input direction and handle the movement/deceleration
	@warning_ignore("unsafe_call_argument")
	var input_dir := Input.get_vector(action_names["lft"],action_names["rgt"], action_names["frw"], action_names["bck"])
	var direction := (neck.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * speed
		velocity.z = direction.z * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
		velocity.z = move_toward(velocity.z, 0, speed)

	move_and_slide()
