extends Enemy

var speed: float = 4.5

@onready var hitbox: EnemyHitbox = $EnemyHitbox


func _physics_process(delta: float) -> void:
	velocity = global_transform.origin.direction_to(player.global_transform.origin) * speed
	move_and_slide()


func _ready() -> void:
	hitbox.damage_taken.connect(take_damage)
