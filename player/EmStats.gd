extends Node

export(int) var max_health: int = 20
export(int) var friction: int = 900
export(int) var acceleration: int = 900
export(int) var max_speed: int = 160
export(int) var gravity: int = 200
export(int) var jump_power: int = -260
export(int) var body_swap_cooldown: int = 30
export(int) var soul_body_control_lenght: int = 30
export(int) var body_transition_lenght: int = 2
export(int) var soul_player_buff: int = 40
export(float) var healing_power: float = 0.08
export(float) var attack_power: float = 1.0

onready var health: float = max_health
	
signal no_health
signal took_damage
signal update_health
signal soul_progressbar_update
signal em_progressbar_update
signal use_remains

enum BodyOwner {
	EM, SOUL
}

var score = 1
var check_point_pos: Vector2 = Vector2.ZERO

var body_owner: int = BodyOwner.EM

var trans_timer: float = 0
var auto_change_timer: float = 0
var regen_timer: float = 100

var soul_progress_info: float = 0
var em_progress_info: float = 0

func ownership_process(delta: float, velocity: Vector2) -> void:
	if body_owner == BodyOwner.SOUL:
		auto_change_timer += delta
		
		# Progressbar
		soul_progress_info = (auto_change_timer / soul_body_control_lenght) * 100
		emit_signal("soul_progressbar_update")
		
		if soul_body_control_lenght < auto_change_timer:
			body_owner = BodyOwner.EM
			set_owner_em()
			auto_change_timer = 0
	
	if body_owner == BodyOwner.EM:
		regen_timer += delta
		
		# heal the em
		game_loop_heal_provider(healing_power * delta)
		
		# Progressbar
		em_progress_info = (regen_timer / body_swap_cooldown) * 100
		emit_signal("em_progressbar_update")
	
	if Input.is_action_pressed("change_owner"):
		trans_timer += delta
	else: 
		trans_timer = 0
		return
	
	if velocity != Vector2.ZERO: trans_timer = 0
	if body_owner == BodyOwner.EM && regen_timer < body_swap_cooldown:
		trans_timer = 0
	
	if trans_timer >= body_transition_lenght: 
		trans_timer = 0
		regen_timer = 0
		auto_change_timer = 0
		
		if body_owner == BodyOwner.EM: set_owner_soul()
		else: set_owner_em()

func set_last_checkpoint(pos: Vector2): 
	check_point_pos = pos

func get_attack_power() -> float:
	return attack_power * score

func set_max_health(value: int) -> void:
	max_health = value
	emit_signal("update_health")
	
func get_health() -> float:
	return health

func damage(value: float) -> void:
	health -= value
	if health <= 0:
		emit_signal("no_health")
		emit_signal("update_health")
	else: 
		emit_signal("took_damage")
		emit_signal("update_health")

func heal(value: float) -> void:
	health = clamp(value + health, 0.00000001, max_health)
	emit_signal("update_health")
	

func game_loop_heal_provider(value: float) -> void:
	if health >= max_health: return
	heal(value)

func reset() -> void:
	heal(max_health)
	
	set_owner_em()
	trans_timer = 0
	auto_change_timer = 0
	regen_timer = 100
	
	score = 1
	
	em_progress_info = 100
	emit_signal("em_progressbar_update")

func set_owner_soul() -> void:
	jump_power = jump_power - soul_player_buff
	max_speed = max_speed + soul_player_buff
	acceleration = acceleration + soul_player_buff
	friction = friction + soul_player_buff
	body_owner = BodyOwner.SOUL

func set_owner_em() -> void:
	jump_power = jump_power + soul_player_buff
	max_speed = max_speed - soul_player_buff
	acceleration = acceleration - soul_player_buff
	friction = friction - soul_player_buff
	body_owner = BodyOwner.EM
	
func upgrade() -> void:
	regen_timer += 5
	score += 0.1
	heal(3)

func signal_remains_usage() -> void:
	emit_signal("use_remains")
