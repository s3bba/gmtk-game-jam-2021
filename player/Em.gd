extends KinematicBody2D

class_name Em

var on_ground: bool = false
var velocity: Vector2 = Vector2(0, 0)

onready var animation_player: AnimationPlayer = $AnimationPlayer
onready var em_animation_sprite: Sprite = $EmAnimationSprite
onready var stats: EmStats = $"/root/EmStats"
onready var hitbox: Area2D = $Hitbox
onready var message: Message = $MessageContainer/Message

var s_attacking: bool = false

func _ready() -> void:
	animation_player.play("em_idle")
	stats.connect("no_health", self, "_respawn")
	message.set_text("Move with arrow keys")
	message.new_line("Left [<] [>] Right")
	message.show_for(7)
	message.send()
	message.show_for(5)

func _physics_process(delta: float) -> void:
	on_ground = is_on_floor()
	
	if Input.get_action_strength("ui_up") == 1 && on_ground:
		if stats.body_owner == stats.BodyOwner.EM: play_ani("em_jump")
		else: play_ani("soul_jump")
		velocity.y = stats.jump_power
		velocity = move_and_slide(velocity)
		mv_plyr()
		return
	
	if on_ground: em_running_idling(delta)
	else: em_jumping(delta)
	
	if Input.is_action_just_pressed("attack") && stats.body_owner == stats.BodyOwner.SOUL: attacking()
	elif Input.is_action_just_pressed("attack") && stats.body_owner == stats.BodyOwner.EM: stats.signal_remains_usage()
		
	stats.ownership_process(delta, velocity)

# Handle player actions
func attacking() -> void:
	s_attacking = true
	animation_player.play("soul_attack")
	
func attacking_done():
	s_attacking = false

func em_jumping(delta: float) -> void:
	if on_ground == true: 
		if stats.body_owner == stats.BodyOwner.EM: play_ani("em_idle")
		else: play_ani("soul_idle")
		em_running_idling(delta)
		return
	
	var input: Vector2 = ems_direction();
	input.x = input.x * 3
	input = input.normalized()
	input.y = stats.gravity * delta
	
	velocity = velocity.move_toward(input * stats.max_speed * 0.8, stats.acceleration * delta)
	mv_plyr()

func em_running_idling(delta: float) -> void:
	if on_ground == false:
		em_jumping(delta)
		return
	
	var input: Vector2 = ems_direction();
	input.y = 0
	
	if input.x == 1 || input.x == -1:
		velocity = velocity.move_toward(input * stats.max_speed, stats.acceleration * delta)
		if stats.body_owner == stats.BodyOwner.EM: play_ani("em_run")
		else: play_ani("soul_run")
	elif input.x == 0:
		velocity = velocity.move_toward(Vector2.ZERO, stats.friction * delta)
		if stats.body_owner == stats.BodyOwner.EM: play_ani("em_idle")
		else: play_ani("soul_idle")
	
	mv_plyr()

var on_right: bool = true

func ems_direction() -> Vector2:
	var input: Vector2 = Vector2.ZERO
	input.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input.y = Input.get_action_strength("ui_up") - Input.get_action_strength("ui_down")
	
	if input.x < 0:
		em_animation_sprite.flip_h = true
		if on_right: 
			hitbox.position.x = hitbox.position.x - 16
			on_right = false
	elif input.x > 0:
		em_animation_sprite.flip_h = false
		if !on_right:
			hitbox.position.x = hitbox.position.x + 16
			on_right = true
	
	return input

func mv_plyr() -> void:
	velocity = move_and_slide(velocity, Vector2.UP)

func play_ani(ani_name) -> void:
	if s_attacking == true:
		return
	else:
		animation_player.play(ani_name)
		

func _on_Hurtbox_hit_signal() -> void:
	#stats.damage(1)
	#bubble.set_text(stats.get_health() as String)
	pass

func _respawn() -> void:
	global_position = stats.check_point_pos
	stats.reset()

