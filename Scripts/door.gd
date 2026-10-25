extends Area2D

@export var next_level : String = ""

func _read() -> void:
	self.body_entered.connect(_on_body_entered)
func _on_body_entered(body: Node2D):
	if body is Player:
		get_tree().call_deferred("change_scene_to_file", next_level)
