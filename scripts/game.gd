extends Node2D


func _ready() -> void:
	pass


func _process(_delta: float) -> void:
	pass


func _on_player_restart() -> void:
	if get_tree():
		get_tree().reload_current_scene()
