extends CanvasLayer



@onready var continuar: Button = $Painel_Principal/VBoxContainer/Continuar
@onready var opções: Button = $Painel_Principal/VBoxContainer/Opções
@onready var sair: Button = $Painel_Principal/VBoxContainer/Sair

func _ready():
	process_mode = Node.PROCESS_MODE_ALWAYS
	visible = false

	continuar.pressed.connect(continuar_jogo)
	opções.pressed.connect(abrir_opções)
	sair.pressed.connect(sair_jogo)


func continuar_jogo():
		get_tree().paused = false
		visible = false

func abrir_opções():
		print("abrindo opções")

func sair_jogo():
		get_tree().paused = false
		get_tree().change_scene_to_file("res://menu/menu_principal.tscn")

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		if visible:
			continuar_jogo()
		else:
			visible = true
			get_tree().paused = true

		get_viewport().set_input_as_handled()
