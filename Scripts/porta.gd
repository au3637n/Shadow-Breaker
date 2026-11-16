
extends Area2D

@export_file("*.tscn") var cenas: String

func _on_body_entered(body: Node2D) -> void:
	print("Corpo detectado: ", body.name)
	print("Grupos: ", body.get_groups())

	if body.is_in_group("player"):
		print("PLAYER RECONHECIDO!")
		get_tree().change_scene_to_file("res://Fases/fase_1_paladino.tscn")
