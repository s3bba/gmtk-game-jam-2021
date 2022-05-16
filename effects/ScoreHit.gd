extends Node2D

class_name ScoreHit

var scene = preload("res://effects/ScoreHitContainer.tscn")

func create(value: float, pos: Vector2) -> void:
	var instance = scene.instance()
	
	call_deferred("_append_instanc_as_a_child", instance)
	
	instance.get_node("Label").text = value as String
	
	var modified_pos: Vector2 = pos
	modified_pos.y -= 8
	
	global_position = pos

func _append_instanc_as_a_child(instance) -> void:
	add_child(instance)
