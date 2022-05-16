extends AnimatedSprite

class_name SingletonEffect

func _ready():
	self.connect("animation_finished", self, "_free_animation")
	frame = 0
	play("effect")

func _free_animation():
	queue_free()
