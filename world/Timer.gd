extends ProgressBar

onready var player_stats: EmStats = EmStats

func _ready():
	player_stats.connect("soul_progressbar_update", self, "_render_soul_progress")
	player_stats.connect("em_progressbar_update", self, "_render_em_progress")

func _render_soul_progress() -> void:
	value = player_stats.soul_progress_info

func _render_em_progress() -> void:
	value = player_stats.em_progress_info
