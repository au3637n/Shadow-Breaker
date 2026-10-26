
extends Area2D
class_name Hitbox

@export var attack_data: AttackData
@export var attacker: Node2D
@export var target_group: StringName = &"enemy"

var active: bool = false

func _ready() -> void:
	monitoring = true
	area_entered.connect(_on_area_entered)

func activate() -> void:
	active = true

func deactivate() -> void:
	active = false

func _on_area_entered(area: Area2D) -> void:
	if not active:
		return

	if area is Hurtbox:
		if area.owner_entity == attacker:
			return

		if not area.owner_entity.is_in_group(target_group):
			return

		area.receive_attack(
			attack_data,
			Vector2.RIGHT,
			attacker
		)


func _on_animated_sprite_2d_animation_finished() -> void:
	pass 
