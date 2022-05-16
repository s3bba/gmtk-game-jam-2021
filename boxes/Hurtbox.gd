extends Area2D

class_name Hurtbox

signal hit_signal

func _on_Hurtbox_area_entered(_area):
	emit_signal("hit_signal")
