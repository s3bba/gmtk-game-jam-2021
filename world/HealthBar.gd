extends ProgressBar

onready var player_stats: EmStats = EmStats

func _ready():
	player_stats.connect("update_health", self, "_render_player_health")
	_render_player_health()

func _render_player_health() -> void:
	value = (player_stats.health / player_stats.max_health) * 100
	
	if value == 100: visible = false
	else: visible = true
