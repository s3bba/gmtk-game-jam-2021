extends Node2D

onready var message: Message = $Message
onready var timer: Timer = $Timer
onready var player_stats: EmStats = EmStats

var has_shown_message = false

func _on_Area2D_body_entered(_body):
	if has_shown_message: return
	
	player_stats.set_last_checkpoint(global_position)
	has_shown_message = true
	message.visible = true
	timer.start(8)


func _on_Timer_timeout():
	message.visible = false
