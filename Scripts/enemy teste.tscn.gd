extends CharacterBody2D

const SPEED = 40.0
const JUMP_VELOCITY = -300.0

@export var max_health: float = 300.0

var current_health: float
var is_dead: bool = false
var hurt_id: int = 0

@onready var anim: AnimatedSprite2D = $AnimatedSprite2D


func _ready() -> void:
	current_health = max_health
	anim.play("idle")


func take_damage(amount: float) -> void:
	if is_dead:
		return

	current_health -= amount
	current_health = max(0.0, current_health)

	print("HP do inimigo: ", current_health)

	if current_health <= 0:
		die()
		return

	play_hurt()


func play_hurt() -> void:
	hurt_id += 1
	var this_hurt_id := hurt_id

	anim.stop()
	anim.play("hurt")

	await anim.animation_finished

	
	if not is_dead and this_hurt_id == hurt_id:
		anim.play("idle")


func die() -> void:
	if is_dead:
		return

	is_dead = true
	hurt_id += 1

	anim.stop()
	anim.play("death")

	await anim.animation_finished

	queue_free()
