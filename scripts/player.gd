extends CharacterBody2D

@warning_ignore("unused_signal")
signal change_gamemode(gm: G.GAMEMODE)

var SPEED := 800.0
const CUBE_JUMP_VELOCITY := -1300.0
const SHIP_BOOST_FORCE := -7000.0
const SHIP_MAX_UP_SPEED := -1600.0
const SHIP_MAX_FALL_SPEED := 2000.0
const SHIP_ROTATION_LIMIT := deg_to_rad(45)

var is_playing_spin_anim := false
var gamemode: G.GAMEMODE = G.GAMEMODE.CUBE


func _ready() -> void:
	velocity.x = SPEED
	
	hide_all_sprites()
	call_deferred("disable_all_colliders")
	%Cube.visible = true
	call_deferred("enable_collider", %CubeCollisionShape)


func _physics_process(delta: float) -> void:
	match gamemode:
		G.GAMEMODE.CUBE:
			process_gamemode_cube(delta)
		G.GAMEMODE.SHIP:
			process_gamemode_ship(delta)


func _on_change_gamemode(gm: G.GAMEMODE) -> void:
	if gm == gamemode:
		return
	
	hide_all_sprites()
	call_deferred("disable_all_colliders")
	
	match gm:
		G.GAMEMODE.CUBE:
			%Cube.visible = true
			call_deferred("enable_collider", %CubeCollisionShape)
		G.GAMEMODE.SHIP:
			%Ship.visible = true
			call_deferred("enable_collider", %ShipCollisionShape)
	
	gamemode = gm


func hide_all_sprites() -> void:
	%Cube.visible = false
	%Ship.visible = false


func disable_all_colliders() -> void:
	%CubeCollisionShape.disabled = true
	%ShipCollisionShape.disabled = true


func enable_collider(c: CollisionShape2D) -> void:
	c.disabled = false


func process_gamemode_cube(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta * 4.0
	
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = CUBE_JUMP_VELOCITY
		%CubeSpriteAP.play("spin")
		is_playing_spin_anim = true
	elif is_on_floor() and is_playing_spin_anim:
		%CubeSpriteAP.stop()
		%CubeSpriteAP.play("RESET")
		is_playing_spin_anim = false
		
	move_and_slide()
 

func process_gamemode_ship(delta: float) -> void:
	velocity += get_gravity() * delta * 3.0
	
	if Input.is_action_pressed("jump"):
		velocity.y += SHIP_BOOST_FORCE * delta
	
	if velocity.y < SHIP_MAX_UP_SPEED:
		velocity.y = SHIP_MAX_UP_SPEED
	if velocity.y > SHIP_MAX_FALL_SPEED:
		velocity.y = SHIP_MAX_FALL_SPEED
	
	move_and_slide()
	
	var t = clamp(velocity.y / SHIP_MAX_FALL_SPEED, -1.0, 1.0)
	%Ship.rotation = lerp(-SHIP_ROTATION_LIMIT, SHIP_ROTATION_LIMIT, (t + 1.0) * 0.5)
