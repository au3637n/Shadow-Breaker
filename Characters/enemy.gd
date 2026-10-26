
extends CharacterBody2D

@export var speed: float = 60.0
@export var patrol_distance: float = 100.0

var start_x: float
var direction: float = 1.0

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D


func _ready() -> void:
	start_x = global_position.x


func _physics_process(delta: float) -> void:
	# Gravidade
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Limites da patrulha
	if global_position.x >= start_x + patrol_distance:
		direction = -1.0
	elif global_position.x <= start_x - patrol_distance:
		direction = 1.0

	# Movimentação
	velocity.x = direction * speed

	move_and_slide()

	# Verifica se bateu numa parede do cenário
	for i in get_slide_collision_count():
		var collision := get_slide_collision(i)
		var collider := collision.get_collider()

		if collider is Node2D:
			# Ignora o Player
			if collider.is_in_group("player"):
				continue

			# Só vira em colisões laterais
			if absf(collision.get_normal().x) > 0.7:
				direction *= -1.0
				break

	# Direção visual
	sprite.flip_h = direction < 0.0

	# Animação
	sprite.play("walk")
