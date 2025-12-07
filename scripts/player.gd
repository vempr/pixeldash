extends CharacterBody2D

@warning_ignore("unused_signal")
signal change_gamemode(gm: G.GAMEMODE)
@warning_ignore("unused_signal")
signal flip_gravity
@warning_ignore("unused_signal")
signal change_speed(s: G.SPEED)
@warning_ignore("unused_signal")
signal click_orb(o: G.ORB)

const JUMP_BUFFER_TIME := 0.15
var current_gravity_scale := 1.0

var gamemode: G.GAMEMODE = G.GAMEMODE.CUBE

const BASE_SPEED := 800.0
var SPEED := BASE_SPEED
var CUBE_JUMP_VELOCITY := -1300.0
var SHIP_BOOST_FORCE := -7000.0
var SHIP_MAX_UP_SPEED := -1600.0
var SHIP_MAX_FALL_SPEED := 2000.0
var SHIP_ROTATION_LIMIT := deg_to_rad(45)

var is_playing_spin_anim := false
var jump_buffer := 0.0
var pending_ball_kick := false


func _ready() -> void:
	velocity.x = BASE_SPEED
	
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
		G.GAMEMODE.BALL:
			process_gamemode_ball(delta)


func _on_change_gamemode(gm: G.GAMEMODE) -> void:
	if gm == gamemode:
		return
	
	hide_all_sprites()
	call_deferred("disable_all_colliders")
	
	match gm:
		G.GAMEMODE.CUBE:
			%Cube.visible = true
			call_deferred("enable_collider", %CubeCollisionShape)
			
			await get_tree().create_timer(0.05).timeout
			if current_gravity_scale > 0:
				%CubeSpriteAP.play("spin")
			else:
				%CubeSpriteAP.play_backwards("spin")
			is_playing_spin_anim = true
		G.GAMEMODE.SHIP:
			%Ship.visible = true
			call_deferred("enable_collider", %ShipCollisionShape)
		G.GAMEMODE.BALL:
			%Ball.visible = true
			call_deferred("enable_collider", %BallCollisionShape)
	
	gamemode = gm


func _on_flip_gravity() -> void:
	current_gravity_scale *= -1
	%Sprite.scale.y = current_gravity_scale
	if current_gravity_scale < 0:
		velocity.y = lerp(velocity.y, -velocity.y * 0.5, 0.15)


func _on_change_speed(s: int) -> void:
	var multi = G.SPEED_EFFECTS[s]
	velocity.x = multi * BASE_SPEED
	%CubeSpriteAP.speed_scale = multi
	%BallSpriteAP.speed_scale = multi


func _on_orb_clicked(o: int) -> void:
	match gamemode:
		G.GAMEMODE.CUBE:
			match o:
				G.ORB.YELLOW:
					jump_cube()
				G.ORB.PINK:
					jump_cube(0.75)
				G.ORB.BLUE:
					current_gravity_scale *= -1
					velocity.y = -velocity.y * 0.5
		G.GAMEMODE.SHIP:
			match o:
				G.ORB.YELLOW:
					jump_cube()
				G.ORB.PINK:
					jump_cube()
				G.ORB.BLUE:
					current_gravity_scale *= -1
					%Sprite.scale.y = current_gravity_scale
					velocity.y = -velocity.y * 0.5
		G.GAMEMODE.BALL:
			match o:
				G.ORB.YELLOW:
					ball_jump()
				G.ORB.PINK:
					ball_jump()
				G.ORB.BLUE:
					current_gravity_scale *= -1
					velocity.y = -velocity.y * 0.2
					if current_gravity_scale > 0:
						%BallSpriteAP.play("spin")
					else:
						%BallSpriteAP.play_backwards("spin")


func hide_all_sprites() -> void:
	%Cube.visible = false
	%Ship.visible = false
	%Ball.visible = false


func disable_all_colliders() -> void:
	%CubeCollisionShape.disabled = true
	%ShipCollisionShape.disabled = true
	%BallCollisionShape.disabled = true


func enable_collider(c: CollisionShape2D) -> void:
	c.disabled = false


func jump_cube(multi: float = 1.0) -> void:
	velocity.y = CUBE_JUMP_VELOCITY * current_gravity_scale * multi
	if current_gravity_scale > 0:
		%CubeSpriteAP.play("spin")
	else:
		%CubeSpriteAP.play_backwards("spin")
	is_playing_spin_anim = true
	jump_buffer = 0.0


func process_gamemode_cube(delta: float) -> void:
	var floored := (current_gravity_scale > 0 && is_on_floor()) || (current_gravity_scale < 0 && is_on_ceiling())
	
	if not floored:
		velocity += get_gravity() * delta * 4.0 * current_gravity_scale
	
	if Input.is_action_pressed("jump") and floored:
		jump_buffer = JUMP_BUFFER_TIME
	else:
		jump_buffer -= delta
	
	if floored and is_playing_spin_anim:
		%CubeSpriteAP.stop()
		%CubeSpriteAP.play("RESET")
		is_playing_spin_anim = false
	
	if jump_buffer > 0.0:
		jump_cube()
	
	move_and_slide()
	
	if current_gravity_scale > 0:
		if is_on_ceiling() && velocity.y < 0:
			velocity.y = 0
		elif is_on_floor() && velocity.y > 0:
			velocity.y = 0
	else:
		if is_on_ceiling() && velocity.y > 0:
			velocity.y = 0
		elif is_on_floor() && velocity.y < 0:
			velocity.y = 0
 

func process_gamemode_ship(delta: float) -> void:
	velocity += get_gravity() * delta * 3.0 * current_gravity_scale
	
	if Input.is_action_pressed("jump"):
		velocity.y += SHIP_BOOST_FORCE * delta * current_gravity_scale
	
	if current_gravity_scale > 0:
		velocity.y = clamp(velocity.y, SHIP_MAX_UP_SPEED, SHIP_MAX_FALL_SPEED)
	else:
		velocity.y = clamp(velocity.y, -SHIP_MAX_FALL_SPEED, -SHIP_MAX_UP_SPEED)
	
	move_and_slide()
	
	var normalized_velocity = clamp(
		velocity.y / SHIP_MAX_FALL_SPEED,
		-1.0,
		1.0
	) * sign(current_gravity_scale)
	%Sprite.rotation = lerp(
		-SHIP_ROTATION_LIMIT,
		SHIP_ROTATION_LIMIT,
		(normalized_velocity + 1.0) * 0.5
	) * sign(current_gravity_scale)


func process_gamemode_ball(delta: float) -> void:
	var floored := (current_gravity_scale > 0 && is_on_floor()) || (current_gravity_scale < 0 && is_on_ceiling())
	
	if not floored:
		velocity += get_gravity() * delta * 5.0 * current_gravity_scale
	
	if Input.is_action_just_pressed("jump"):
		jump_buffer = JUMP_BUFFER_TIME
	else:
		jump_buffer -= delta
	
	if floored && jump_buffer > 0.0:
		current_gravity_scale *= -1
		%Sprite.scale.y = current_gravity_scale
		
		pending_ball_kick = true
		jump_buffer = 0.0
	
	move_and_slide()
	
	if pending_ball_kick:
		velocity.y = 600.0 * current_gravity_scale
		pending_ball_kick = false


func ball_jump(multi: float = 1.0) -> void:
	velocity.y = CUBE_JUMP_VELOCITY * current_gravity_scale * multi
