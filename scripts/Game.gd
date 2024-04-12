extends Node

@export var player_fish : PackedScene
@export var enemy_fish : PackedScene
var player
var spawning = false
var fish_count = 0
var score:int = 0:
	set(value):
		score = value
		$HBoxContainer/Label.text = value


func _ready() -> void:
	$HBoxContainer/Label.text = str(0)

func _physics_process(delta):
	if $Player.has_node("Player"):
		player = $Player.get_node("Player")
		while player.get_node("Body").alive == true and spawning == false:
			#add enemies
			_spawn_enemy_fish()
			spawning = true

func game_start():
	var spawn_player_fish = player_fish.instantiate()
	$Player.add_child(spawn_player_fish)


func _on_start_button_pressed():
	$"Main Menu".hide()
	game_start()


func _spawn_enemy_fish():
	if fish_count < 60:
		var spawn_enemy_fish = enemy_fish.instantiate()
		var fish_size = randf_range(.1, clamp(3 * get_node("Player/Player/Body").size, 3, 20))
		spawn_enemy_fish.get_node("Body").set("scale", Vector2(fish_size, fish_size))
		var side = randi_range(1,2)
		if side == 1:
			spawn_enemy_fish.set("position", Vector2(randf_range(-860, -960), randf_range(-540, 540)))
			spawn_enemy_fish.get_node("Body").direction = 1
			spawn_enemy_fish.scale.x *= -1
		else:
			spawn_enemy_fish.set("position", Vector2(randf_range(860, 960), randf_range(-540, 540)))
			spawn_enemy_fish.get_node("Body").direction = 2
		$Enemies.add_child(spawn_enemy_fish)
		var new_speed = 540/(spawn_enemy_fish.get_node("Body").scale.x+.8)
		if new_speed < 50:
			spawn_enemy_fish.get_node("Body").Speed = 5
		else:
			spawn_enemy_fish.get_node("Body").Speed = new_speed
		var timer_duration = 5 - (5 * Time.get_ticks_msec() / 7200000.0)
		if timer_duration < 5.0:
			timer_duration = 5.0
		if fish_count < 40:
			timer_duration = 1
		await get_tree().create_timer(timer_duration).timeout
		spawning = false
		fish_count += 1
