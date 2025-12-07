extends Node2D

@onready var Level1Scene := preload("res://scenes/levels/level_1.tscn")
@onready var Level2Scene := preload("res://scenes/levels/level_2.tscn")
@onready var Level3Scene := preload("res://scenes/levels/level_3.tscn")


func _on_level_1_pressed() -> void:
	G.current_level = 1
	if get_tree():
		get_tree().change_scene_to_packed(Level1Scene)


func _on_level_2_pressed() -> void:
	G.current_level = 2
	if get_tree():
		get_tree().change_scene_to_packed(Level2Scene)


func _on_level_3_pressed() -> void:
	G.current_level = 3
	if get_tree():
		get_tree().change_scene_to_packed(Level3Scene)
