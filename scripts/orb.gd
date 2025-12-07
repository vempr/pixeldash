extends Area2D

@export var orb := G.ORB.YELLOW

const JUMP_BUFFER_TIME := 0.2

var has_been_clicked := false
var can_click := false
var b: Node2D
var jump_buffer := 0.0


func _ready() -> void:
	%Yellow.visible = false
	%Pink.visible = false
	%Blue.visible = false
	
	match orb:
		G.ORB.YELLOW:
			%Yellow.visible = true
		G.ORB.PINK:
			%Pink.visible = true
		G.ORB.BLUE:
			%Blue.visible = true


func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("jump"):
		jump_buffer = JUMP_BUFFER_TIME
	else:
		jump_buffer -= delta
	
	if can_click && jump_buffer > 0.0 && b && !has_been_clicked:
		has_been_clicked = true
		b.emit_signal("click_orb", orb)
		%SpriteAP.play("expand")
		await %SpriteAP.animation_finished
		%SpriteAP.play("shrink")


func _on_body_entered(body: Node2D) -> void:
	if body is CharacterBody2D:
		b = body
		can_click = true


func _on_body_exited(body: Node2D) -> void:
	if body is CharacterBody2D:
		can_click = false
