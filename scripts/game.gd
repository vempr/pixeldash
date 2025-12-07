extends Node2D


func _ready() -> void:
	%Win.visible = false
	%Atts.text = "attempt " + str(G.attempts)


func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("pause"):
		%Pause.visible = !%Pause.visible
		get_tree().paused = %Pause.visible


func _on_player_restart() -> void:
	if get_tree():
		G.attempts += 1
		get_tree().reload_current_scene()


func _on_player_win() -> void:
	%Attempts.text = "after " + str(G.attempts) + " attempts"
	%Win.visible = true
	
	if G.current_level == 3:
		%Thingy.visible = true
	else:
		%Thingy.visible = false


func _on_main_menu_pressed() -> void:
	if get_tree():
		get_tree().paused = false
	
	if get_tree():
		G.attempts = 1
		get_tree().change_scene_to_file("res://scenes/main_menu.tscn")


func _on_replay_pressed() -> void:
	G.attempts = 0
	_on_player_restart()


func _on_continue_pressed() -> void:
	%Pause.visible = false
	get_tree().paused = false
