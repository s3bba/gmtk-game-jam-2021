extends ProgressBar

onready var player_stats: EmStats = EmStats

func _ready():
	player_stats.connect("soul_progressbar_update", self, "_render_soul_progress")
	player_stats.connect("em_progressbar_update", self, "_render_em_progress")

func _render_soul_progress() -> void:
	rect_rotation = 180
	if value == 100: visible = false
	else: visible = true
	
	value = player_stats.soul_progress_info

func _render_em_progress() -> void:
	rect_rotation = 0
	if value == 100: visible = false
	else: visible = true
	
	value = player_stats.em_progress_info
