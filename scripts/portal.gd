extends Area2D

@export var gamemode := G.GAMEMODE.CUBE


func _ready() -> void:
	match gamemode:
		G.GAMEMODE.CUBE:
			%Indicator.text = "cube"
		G.GAMEMODE.SHIP:
			%Indicator.text = "ship"


func _on_body_entered(body: Node2D) -> void:
	if body is CharacterBody2D:
		body.emit_signal("change_gamemode", gamemode)
