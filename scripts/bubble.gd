extends Sprite2D

func _ready() -> void:
	var tween = get_tree().create_tween()
	tween.tween_property(self, "position:y", global_position.y + randf_range(-50.0, -2000.0), randi_range(1.0, 10.0))
	await tween.finished.connect(queue_free)
