extends Node2D

var use_white_sprite := true
var bigger := false

func _ready() -> void:
	if bigger:
		%GraySprite.texture.width = 60
		%GraySprite.texture.height = 60
		%WhiteSprite.texture.width = 60
		%WhiteSprite.texture.height = 60
	else:
		%GraySprite.texture.width = 30
		%GraySprite.texture.height = 30
		%WhiteSprite.texture.width = 30
		%WhiteSprite.texture.height = 30
	
	if use_white_sprite:
		%WhiteSprite.visible = true
		%GraySprite.visible = false
		%DecayTimer.start(5.0)
	else:
		%WhiteSprite.visible = false
		%GraySprite.visible = true
		%DecayTimer.start(0.2)


func _on_decay_timer_timeout() -> void:
	queue_free()
