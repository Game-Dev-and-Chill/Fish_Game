extends AudioStreamPlayer

@export var play_on_launch : bool


func _ready():
	process_mode = Node.PROCESS_MODE_ALWAYS
	if play_on_launch:
		play()

func _on_main_game_game_started():
	if !playing:
		play()
