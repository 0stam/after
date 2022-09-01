extends CharacterBody3D
class_name Player

signal dialogue_setup_finished(id: String)

enum Tool {TABLET, WEAPON, GUN}

# Movement parameters
var speed: float = 5
var acceleration: float = 1
var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity")
var jump_velocity: float = 5.2

# Movement modifiers
var speed_multiplier: float = 1
var acceleration_multiplier: float = 1
var gravity_multiplier: float = 1
var jump_velocity_multiplier: float = 1

# Camera settings
var mouse_sensitivity: float = 0.003
var target_rotation: Vector2 = Vector2.ZERO  # Used to store x and y rotation values, not a directional vector

# Current values
var current_tool: Tool = Tool.TABLET
var ui_activated: bool = false

# HP
var max_hp: float = 100
var hp: float = max_hp
var healing_speed: float = 1
var out_of_combat: bool = true

@onready var pivot = $Pivot
@onready var camera: Camera3D = $Pivot/Camera3D
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var ray_cast: RayCast3D = $Pivot/Camera3D/RayCast3D
@onready var out_of_combat_timer: Timer = $OutOfCombatTimer

@onready var tablet: Node3D = $Pivot/Camera3D/Hand/Tablet
@onready var weapon: Weapon = $Pivot/Camera3D/Hand/Miner
@onready var gun: Node3D = $Pivot/Camera3D/Hand/Gun
@onready var tools: Array = [tablet, weapon, gun]


func set_tool(val: Tool) -> void:
	if val > Tool.GUN:
		current_tool = Tool.TABLET
	elif val < Tool.TABLET:
		current_tool = Tool.GUN
	else:
		current_tool = val
	
	for i in range(len(tools)):
		tools[i].visible = i == current_tool


func set_ui_activated(val: bool) -> void:
	ui_activated = val
	
	if val:
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	else:
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED


func start_dialogue(owner: String) -> void:
	set_tool(Tool.TABLET)
	animation_player.play("show_tablet")
	
	set_ui_activated(true)
	
	await animation_player.animation_finished
	dialogue_setup_finished.emit(owner)


func end_dialogue() -> void:
	animation_player.play_backwards("show_tablet")
	set_ui_activated(false)


func take_damage(val: float) -> void:
	hp -= val
	out_of_combat = false
	out_of_combat_timer.start()
	
	if hp <= 0:
		get_tree().paused = true
		# TODO: add death handling


func heal(val: float) -> void:
	hp = clamp(hp + val, 0, max_hp)


func _on_out_of_combat_timer_timeout() -> void:
	out_of_combat = true


func _process(delta: float) -> void:
	# TODO: implement camera smoothing
	rotation.y = target_rotation.y
	camera.rotation.x = target_rotation.x


func _physics_process(delta: float) -> void:
	if out_of_combat:
		heal(healing_speed * delta)
	
	if not is_on_floor():
		velocity.y -= gravity * gravity_multiplier * delta
	
	if ui_activated:
		return
	
	if Input.is_action_pressed("jump") and is_on_floor():
		velocity.y = jump_velocity * jump_velocity_multiplier
	
	var input_dir: Vector2 = Input.get_vector("left", "right", "forward", "backward")
	var direction: Vector3 = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	velocity.x = move_toward(velocity.x, direction.x * speed * speed_multiplier, acceleration)
	velocity.z = move_toward(velocity.z, direction.z * speed * speed_multiplier, acceleration)
	
	move_and_slide()


func _input(event: InputEvent) -> void:
	if ui_activated:
		return
	
	if event is InputEventMouseMotion:
		target_rotation.y -= event.relative.x * mouse_sensitivity
		target_rotation.x -= event.relative.y * mouse_sensitivity
		target_rotation.x = clampf(target_rotation.x, deg2rad(-70), deg2rad(80))
	
	elif event.is_action_pressed("next_tool"):
		set_tool(current_tool + 1)
	
	elif event.is_action_pressed("previous_tool"):
		set_tool(current_tool - 1)
	
	elif event.is_action_pressed("use_tool"):
		if current_tool == Tool.WEAPON:
			weapon.trigger()
	
	elif event.is_action_released("use_tool"):
		if current_tool == Tool.WEAPON:
			weapon.release()
	
	elif event.is_action_pressed("interact"):
		var target = ray_cast.get_collider()
		if target != null and target.has_method("action"):
			target.action()


func _init() -> void:
	References.player = self


func _ready() -> void:
	set_tool(Tool.TABLET)
	weapon.initialize(self)
