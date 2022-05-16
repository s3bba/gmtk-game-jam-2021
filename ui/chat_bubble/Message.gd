extends Label

class_name Message

onready var timer: Timer = $Timer

var show_time: int = 5

func send() -> void:
	visible = true
	timer.start(show_time)
	
func show_for(time: int) -> void:
	show_time = time

func clr() -> void:
	text = ""

func set_text(data: String) -> void:
	text = data

func add_text(data: String) -> void:
	text = text + data

func new_line(data: String) -> void:
	text = text + "\n" + data

func br() -> void:
	text = text + "\n"


func _on_Timer_timeout():
	visible = false
