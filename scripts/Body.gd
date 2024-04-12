extends CharacterBody2D

const JUMP_VELOCITY = -400.0

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var Speed = 300.0
var alive = true
var size = scale.x
@onready var collision_polygon_2d: CollisionPolygon2D = $Area/CollisionPolygon2D
@onready var animation_player: AnimationPlayer = $"../AnimationPlayer"

func _ready():
	var area = get_node("Area") as Area2D
	area.connect("body_entered", _on_Body_area_entered)

func _physics_process(delta):
	var direction = Vector2.ZERO
	if Input.is_action_pressed("up"):
		direction.y -= 1
	if Input.is_action_pressed("down"):
		direction.y += 1
	if Input.is_action_pressed("left"):
		direction.x -= 1
	if Input.is_action_pressed("right"):
		direction.x += 1

	if direction.x > 0:
		if $Sprite2D.flip_h == false:
			collision_polygon_2d.scale *= -1
		$Sprite2D.flip_h = true
	elif direction.x < 0 :
		if $Sprite2D.flip_h == true:
			collision_polygon_2d.scale *= -1
		$Sprite2D.flip_h = false


	if direction.length_squared() > 0:
		direction = direction.normalized()
		velocity = direction * Speed
	else:
		velocity.x = move_toward(velocity.x, 0, Speed)
		velocity.y = move_toward(velocity.y, 0, Speed)

	move_and_slide()

	global_position.x = clampf(global_position.x, 10, 1905)
	global_position.y = clampf(global_position.y, 10, 1000)

func _on_Body_area_entered(body):
	var enemySize = body.scale
	if enemySize.x < size:
		size = size * (1+enemySize.x/100)
		var new_speed = 540/(size+.8)
		if new_speed < 5:
			Speed = 5
		else:
			Speed = new_speed
		get_tree().current_scene.get_node("HBoxContainer/Label").text = str(int((size-1)*1000))
		scale = Vector2(size,size)
		print(scale)
		evolve_fish()
		body.get_parent().queue_free()
		get_tree().current_scene.fish_count -= 1
		print(get_tree().current_scene.fish_count)
	else:
		print("score = ", get_tree().current_scene.get_node("HBoxContainer/Label").text)
		get_tree().quit()

func evolve_fish():
	if scale.x > 1.5:
		animation_player.play("first_evolution")
	elif scale.x > 2.0:
		animation_player.play("second_evolution")
	elif scale.x > 2.5:
		animation_player.play("third_evolution")
