
extends Area2D
class_name Hurtbox

@export var owner_entity: CharacterBody2D
@export var health: HealthComponent

func receive_attack(
	attack: AttackData,
	direction: Vector2,
	attacker: Node2D
) -> void:
	if health == null:
		push_warning("HealthComponent não configurado!")
		return

	if attack == null:
		return

	var damage: float = attack.calculate_damage()

	health.take_damage(damage)

	print(
		owner_entity.name,
		" recebeu ",
		damage,
        " de dano!"
	)
