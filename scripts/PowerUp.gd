class_name Powerup extends Area2D


func _on_area_entered(area):
	if area.is_in_group("player_collider"):
		owner.queue_free()
	if area.is_in_group("bottom"):
		queue_free()
