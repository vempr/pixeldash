extends Area2D

@export var gamemode := G.GAMEMODE.CUBE


func _ready() -> void:
	match gamemode:
		G.GAMEMODE.CUBE:
			%Indicator.text = "cube"
			%Indicator.add_theme_color_override("font_color", Color(0.0, 0.925, 0.0))
		G.GAMEMODE.SHIP:
			%Indicator.text = "ship"
			%Indicator.add_theme_color_override("font_color", Color(1.0, 0.0, 0.816))
		G.GAMEMODE.BALL:
			%Indicator.text = "ball"
			%Indicator.add_theme_color_override("font_color", Color(1.0, 0.0, 0.259))
		G.GAMEMODE.WAVE:
			%Indicator.text = "wave"
			%Indicator.add_theme_color_override("font_color", Color(0.09, 0.718, 0.816))


func _on_body_entered(body: Node2D) -> void:
	if body is CharacterBody2D:
		body.emit_signal("change_gamemode", gamemode)
