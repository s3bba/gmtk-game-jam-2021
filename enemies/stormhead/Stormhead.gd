extends KinematicBody2D

class_name Stormhead

var death_effect_scene = preload("res://enemies/stormhead/StormheadDeathEffect.tscn")

onready var animated_sprite: AnimatedSprite = $AnimatedSprite
onready var player_detection_zone: PlayerDetectionZone = $PlayerDetectionZone
onready var stats: EnemyStats = $EnemyStats
onready var bubble: Node2D = $Bubble
onready var timer: Timer = $Timer
onready var player_stats: EmStats = EmStats

var velocity: Vector2 = Vector2.ZERO
var rest_timer: float = 0

enum EnemyState {
	IDLE, ATTACKING, RUNNING, RESTING
}

var state = EnemyState.IDLE
var is_in_hitbox_area: bool = false

func _ready() -> void:
	animated_sprite.playing = true
	animated_sprite.play("idle")

func _physics_process(delta: float) -> void:
	var on_ground: bool = is_on_floor()
	
	match state:
		EnemyState.RESTING:
			rest_timer += delta
		
			if rest_timer > 0.4: 
				state = EnemyState.IDLE
				rest_timer = 0
			return
		EnemyState.IDLE:
			if player_detection_zone.can_see_player(): state = EnemyState.RUNNING
			animated_sprite.play("idle", false)
		EnemyState.RUNNING:
			if !player_detection_zone.can_see_player(): state = EnemyState.IDLE
			move_toward_player(delta, on_ground)
			animated_sprite.play("run", false)
		EnemyState.ATTACKING:
			if !player_detection_zone.can_see_player(): state = EnemyState.IDLE


func move_toward_player(delta: float, on_ground: bool):
	var player = player_detection_zone.get_player()
	if player == null:
		state = EnemyState.IDLE
		return
	
	var player_location: Vector2 = (player.global_position - global_position).normalized()
	if !on_ground:
		player_location.y = stats.gravity * delta
		
	velocity = velocity.move_toward(player_location * stats.max_speed, stats.acceleration * delta)
		
	velocity = move_and_slide(velocity, Vector2.UP)
	
	if is_in_hitbox_area: 
		state = EnemyState.ATTACKING
		_on_Hitbox_area_entered(null)

func _on_EnemyStats_no_health():
	queue_free()
	
	var death_effect = death_effect_scene.instance()
	call_deferred("_deffer_fn", death_effect)
	
	var death_position_vector: Vector2 = self.position
	death_position_vector.y = death_position_vector.y - 128
	death_effect.position = death_position_vector

func _deffer_fn(instance) -> void:
	get_parent().add_child(instance)

func _on_Hurtbox_area_entered(_area):
	var hit_score_effect: ScoreHit = ScoreHit.new()
	get_parent().add_child(hit_score_effect)
	hit_score_effect.create(player_stats.get_attack_power(),  global_position)
	
	animated_sprite.play("damaged", false)
	stats.damage(player_stats.get_attack_power())
	bubble.set_text("HP left: " + stats.get_health() as String)
	
func _on_Timer_timeout():
	animated_sprite.play("attack", false)
	if is_in_hitbox_area: player_stats.damage(8)
	state = EnemyState.RESTING
	
	timer.stop()

func _on_Hitbox_area_entered(_area):
	is_in_hitbox_area = true
	if timer.is_stopped():
		state = EnemyState.ATTACKING
		velocity = move_and_slide(velocity, Vector2.UP)
		timer.start(2)

func _on_Hitbox_area_exited(_area):
	is_in_hitbox_area = false
