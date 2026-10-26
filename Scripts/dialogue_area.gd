extends Area2D

@export var painel_dialogo: Control
@export var texto_dialogo: Label

@export_multiline var mensagem: String = "Olá, aventureiro! Bem-vindo à vila."

func _ready() -> void:

	if painel_dialogo:
		painel_dialogo.visible = false

	# Conecta os sinais
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)
	
	
	checar_player_inicial()

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		mostrar_dialogo()

func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		esconder_dialogo()

func checar_player_inicial() -> void:
	# Pega todos os corpos que já estão encostados na área agora
	for body in get_overlapping_bodies():
		if body.is_in_group("player"):
			mostrar_dialogo()
			break

func mostrar_dialogo() -> void:
	if painel_dialogo and texto_dialogo:
		texto_dialogo.text = mensagem
		painel_dialogo.visible = true

func esconder_dialogo() -> void:
	if painel_dialogo:
		painel_dialogo.visible = false
