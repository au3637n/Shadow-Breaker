
extends Resource
class_name AttackData

@export_group("Dano")
@export var damage: float = 10.0
@export var critical_chance: float = 0.1
@export var critical_multiplier: float = 1.5

@export_group("Impacto")
@export var knockback_force: float = 250.0
@export var stun_duration: float = 0.2

@export_group("Combate")
@export var hit_cooldown: float = 0.0
@export var can_be_parried: bool = true

func calculate_damage() -> float:
	var final_damage: float = damage

	if randf() < critical_chance:
		final_damage *= critical_multiplier

	return final_damage
