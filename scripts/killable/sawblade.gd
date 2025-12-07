extends Area2D


func _ready() -> void:
	if randi_range(0, 1):
		%AnimationPlayer.play("spin")
	else:
		%AnimationPlayer.play_backwards("spin")


func _on_body_entered(body: Node2D) -> void:
	if body is CharacterBody2D:
		body.emit_signal("die")
