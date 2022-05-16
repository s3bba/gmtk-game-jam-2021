extends RigidBody2D

var velocity: Vector2 = Vector2.ZERO
var is_thrown = false

static func rand_point_in_circle(p_radius = 1.0):
	var r = sqrt(rand_range(0.2, 1.0)) * p_radius
	r = abs(r) * -1
	var t = rand_range(0.2, 1.0) * TAU
	t = abs(t) * -1
	return Vector2(r * cos(t), r * sin(t))

func _process(delta):
	if !is_thrown: 
		velocity = rand_point_in_circle(30)
		is_thrown = true
		$Timer.start(1)
	
	apply_impulse(Vector2.UP, velocity)


func _on_Timer_timeout():
	queue_free()
