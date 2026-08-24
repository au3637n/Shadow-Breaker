extends CharacterBody2D

@onready var anim: AnimatedSprite2D = $AnimatedSprite2D
@onready var attack_hitbox: Area2D = $AttackHitbox

var is_attacking: bool = false
var maxHp = 100
var hp = 100

const SPEED = 60.0
const JUMP_VELOCITY = -250.0


func _physics_process(delta: float) -> void:

	if not is_on_floor():
		velocity += get_gravity() * delta

	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	var direction := Input.get_axis("left", "right")

	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	if Input.is_action_just_pressed("attack") and not is_attacking:
		attack()

	if is_attacking:
		move_and_slide()
		return

	if not is_on_floor():
		anim.play("jump")
	elif direction > 0:
		anim.flip_h = false
		anim.play("walk")
	elif direction < 0:
		anim.flip_h = true
		anim.play("walk")
	else:
		anim.play("idle")

	move_and_slide()


func attack() -> void:
	is_attacking = true

	attack_hitbox.monitoring = true

	anim.play("attack")

	await get_tree().physics_frame

	for body in attack_hitbox.get_overlapping_bodies():
		if body.has_method("take_damage"):
			body.take_damage(100)

	await anim.animation_finished

	attack_hitbox.monitoring = false
	is_attacking = false
