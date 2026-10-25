
extends Node
class_name HealthComponent

signal health_changed(current_health: float)
signal died

@export var max_health: float = 100.0

var current_health: float

func _ready() -> void:
	current_health = max_health

func take_damage(amount: float) -> void:
	if current_health <= 0:
		return

	current_health = maxf(current_health - amount, 0.0)

	health_changed.emit(current_health)

	print("Vida restante: ", current_health)

	if current_health <= 0:
		died.emit()
