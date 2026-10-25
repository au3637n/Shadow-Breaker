
extends CharacterBody2D

const SPEED = 50.0
const JUMP_VELOCITY = -300.0

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var hitbox: Hitbox = $Hitbox

var is_attacking: bool = false
var is_jump_starting: bool = false
var is_jump_transitioning: bool = false


func _physics_process(delta: float) -> void:
	# Gravidade
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Pulo
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		is_jump_starting = true
		is_jump_transitioning = false

		if not is_attacking:
			sprite.play("jump_start")

	# Movimentação
	var direction := Input.get_axis("ui_left", "ui_right")

	if direction:
		velocity.x = direction * SPEED
		sprite.flip_h = direction < 0
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()

	# Controle das animações
	if is_attacking:
		return

	if is_jump_starting or is_jump_transitioning:
		return

	if not is_on_floor():
		if velocity.y >= 0:
			sprite.play("jump_fall")
		else:
			sprite.play("jump_transition")
	elif direction != 0:
		sprite.play("walk")
	else:
		sprite.play("idle")


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("attack") and not is_attacking:
		is_attacking = true
		sprite.play("attack")
		hitbox.activate()



func _on_animated_sprite_2d_animation_finished() -> void:
	match sprite.animation:
		"attack":
			is_attacking = false
			hitbox.deactivate()

		"jump_start":
			is_jump_starting = false
			is_jump_transitioning = true
			sprite.play("jump_transition")

		"jump_transition":
			is_jump_transitioning = false
