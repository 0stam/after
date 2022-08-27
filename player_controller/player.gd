extends CharacterBody3D


var speed: float = 5
var acceleration: float = 1
var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity")
var jump_velocity: float = 5.2

var mouse_sensitivity: float = 0.003
var target_rotation: Vector2 = Vector2.ZERO  # Used to store x and y rotation values, not a basis

@onready var pivot = $Pivot
@onready var camera: Camera3D = $Pivot/Camera3D



func _process(delta: float) -> void:
	# TODO: implement camera smoothing
	rotation.y = target_rotation.y
	camera.rotation.x = target_rotation.x


func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity.y -= gravity * delta
	
	if Input.is_action_pressed("jump") and is_on_floor():
		velocity.y = jump_velocity
	
	var input_dir: Vector2 = Input.get_vector("left", "right", "forward", "backward")
	var direction: Vector3 = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	velocity.x = move_toward(velocity.x, direction.x * speed, acceleration)
	velocity.z = move_toward(velocity.z, direction.z * speed, acceleration)
	
	move_and_slide()


func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		target_rotation.y -= event.relative.x * mouse_sensitivity
		target_rotation.x -= event.relative.y * mouse_sensitivity
		target_rotation.x = clampf(target_rotation.x, deg2rad(-70), deg2rad(80))


func _init() -> void:
	References.player = self
