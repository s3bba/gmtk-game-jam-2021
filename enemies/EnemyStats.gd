extends Node

class_name EnemyStats

export(int) var max_health: int = 4
export(int) var friction: int = 100
export(int) var acceleration: int = 50
export(int) var max_speed: int = 80
export(int) var gravity: int = 200

onready var health: float = max_health
	
signal no_health
	
func get_health() -> float:
	return health

func damage(value: float):
	health -= value
	if health <= 0:
		emit_signal("no_health")

func heal(value: float):
	var new_health: float = health + value

	if new_health > max_health:
		health = max_health
	else:
		health = new_health
