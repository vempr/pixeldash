extends Area2D

@export var speed := G.SPEED.NORMAL


func _ready() -> void:
	$"0_5xCS".disabled = true
	$"1xCS".disabled = true
	$"2xCS".disabled = true
	$"3xCS".disabled = true
	
	$"0_5x".visible = false
	$"1x".visible = false
	$"2x".visible = false
	$"3x".visible = false
	
	match speed:
		G.SPEED.SLOW:
			$"0_5xCS".disabled = false
			$"0_5x".visible = true
		G.SPEED.NORMAL:
			$"1xCS".disabled = false
			$"1x".visible = true
		G.SPEED.FAST:
			$"2xCS".disabled = false
			$"2x".visible = true
		G.SPEED.FASTER:
			$"3xCS".disabled = false
			$"3x".visible = true


func _on_body_entered(body: Node2D) -> void:
	if body is CharacterBody2D:
		body.emit_signal("change_speed", speed)
