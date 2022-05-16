extends AnimatedSprite

class_name LastingSingletonEffect

var is_player_on_my_fucking_remains: bool = false

onready var stats: EmStats = EmStats

func _ready() -> void:
	frame = 0
	play("effect")
	stats.connect("use_remains", self, "_reamains_usage")

func _on_Area2D_body_entered(body) -> void:
	is_player_on_my_fucking_remains = true


func _on_Area2D_body_exited(body) -> void:
	is_player_on_my_fucking_remains = false
	
func _reamains_usage() -> void:
	if is_player_on_my_fucking_remains:
		stats.upgrade()
		queue_free()
