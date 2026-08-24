extends CharacterBody2D


const SPEED = 40.0
const JUMP_VELOCITY = -300.0

# Variables
@export var speed: float = 120.0
@export var max_health: int = 100
var current_health: int
var enemy_state: String = "idle" # "idle", "walking", "attacking", "hit", "dead"

@export var player_node: Node2D # Drag your Player node here in the Inspector
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var hitbox_collision: CollisionShape2D = $Hitbox/CollisionShape2D

func _ready() -> void:
	current_health = max_health
	enemy_state = "idle"
	hitbox_collision.disabled = true

func _physics_process(delta: float) -> void:
	if enemy_state == "dead" or enemy_state == "hit":
		return
		
	if player_node and enemy_state != "attacking":
		# 1. Flip Sprite & Face Player
		var direction_to_player = player_node.global_position.x - global_position.x
		if direction_to_player > 0:
			animated_sprite.flip_h = false
		else:
			animated_sprite.flip_h = true
			
		# 2. Distance Calculation
		var distance = abs(direction_to_player)
		
		# 3. AI Movement & Attack Decision
		if distance > 60.0:
			enemy_state = "walking"
			velocity.x = sign(direction_to_player) * speed
			animated_sprite.play("walk")
		else:
			velocity.x = 0
			if enemy_state != "attacking":
				enemy_state = "idle"
				animated_sprite.play("idle")
				
				# Try to attack
				if $AttackTimer.is_stopped():
					execute_attack()

	move_and_slide()

# Attack Logic
func execute_attack() -> void:
	enemy_state = "attacking"
	velocity.x = 0
	animated_sprite.play("punch")
	
	# Enable Hitbox mid-animation (frame specific)
	await get_tree().create_timer(0.2).timeout
	if enemy_state == "attacking":
		hitbox_collision.disabled = false
		
	# Disable Hitbox after impact
	await get_tree().create_timer(0.2).timeout
	hitbox_collision.disabled = true
	
	# End Attack
	await animated_sprite.animation_finished
	enemy_state = "idle"
	$AttackTimer.start(1.0) # Cooldown before next attack

# Damage Logic (Call this function when Player attacks)
func take_damage(amount: int) -> void:
	if enemy_state == "dead":
		return
		
	current_health -= amount
	enemy_state = "hit"
	hitbox_collision.disabled = true
	
	# Knockback effect
	var knockback_dir = -1 if animated_sprite.flip_h == false else 1
	velocity.x = knockback_dir * 150.0
	move_and_slide()
	
	if current_health <= 0:
		die()
	else:
		animated_sprite.play("hurt")
		await animated_sprite.animation_finished
		enemy_state = "idle"

func die() -> void:
	enemy_state = "dead"
	velocity.x = 0
	animated_sprite.play("ko")
	$CollisionShape2D.set_deferred("disabled", true)
