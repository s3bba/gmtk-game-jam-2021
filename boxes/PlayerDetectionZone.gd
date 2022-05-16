extends Area2D

class_name PlayerDetectionZone

var player = null

func get_player():
	return player

func can_see_player() -> bool: 
	return player != null

func _on_PlayerDetectionZone_body_exited(_body):
	player = null


func _on_PlayerDetectionZone_body_entered(body):
	player = body
