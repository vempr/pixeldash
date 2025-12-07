extends Node2D

@onready var MainMenuScene = preload("res://scenes/main_menu.tscn")


func _ready() -> void:
	%Win.visible = false


func _process(_delta: float) -> void:
	pass


func _on_player_restart() -> void:
	if get_tree():
		G.attempts += 1
		get_tree().reload_current_scene()


func _on_player_win() -> void:
	%Attempts.text = "after " + str(G.attempts) + " attempts"
	%Win.visible = true


func _on_main_menu_pressed() -> void:
	if get_tree():
		G.attempts = 1
		get_tree().change_scene_to_packed(MainMenuScene)


func _on_replay_pressed() -> void:
	G.attempts = 0
	_on_player_restart()
