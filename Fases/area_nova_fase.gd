extends Area2D

@export_file("*.tscn") var proxima_fase: String

func _ready() -> void:
	body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node2D) ->void:
	if str(body.name) == "Player" or body.is_in_group("player"):
		mudar_de_fase()

func mudar_de_fase() -> void:
	if proxima_fase !="":
		get_tree().change_scene_to_file("proxima_fase")
	else:
		print("nenhuma fase definida")
