extends Enemy

var speed: float = 1.5

var bullet_scene: PackedScene = preload("res://entities/enemy_bullet/enemy_bullet.tscn")

@onready var hitbox: EnemyHitbox = $EnemyHitbox


func _physics_process(delta: float) -> void:
	# Make the enemy move faster is far away from the player
	var current_speed: float = global_transform.origin.distance_to(player.global_transform.origin)
	current_speed /= 20
	current_speed += speed
	
	velocity = global_transform.origin.direction_to(player.global_transform.origin) * current_speed
	move_and_slide()


func _ready() -> void:
	hitbox.damage_taken.connect(take_damage)


func _on_shot_timer_timeout() -> void:
	var bullet: Area3D = bullet_scene.instantiate()
	get_parent().add_child(bullet)
	bullet.global_transform.origin = global_transform.origin
	bullet.direction = global_transform.origin.direction_to(player.global_transform.origin)
	bullet.speed = 12
