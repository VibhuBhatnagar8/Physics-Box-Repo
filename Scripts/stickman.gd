extends CharacterBody2D
@export var top_speed = 600.0
@export var acceleration_weight = 12
@export var friction_weight: float = 15.0
@export var jump_height: float = 256
@export var jump_time_to_peak: float = 0.4 
@export var jump_time_to_fall: float = 0.35 
@export var coyote_time: float = 0.15
@export var jump_buffer_time: float = 0.15
@export var push_force: float = 3.0
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
var grabbed_body: RigidBody2D = null
var jump_buffer_counter: float = 0.0
var was_on_floor: bool = true
var jump_velocity: float
var jump_gravity: float
var fall_gravity: float
var coyote_timer: float = 0.0
var default_scale: Vector2
var is_interacting_with_box = false
var push_buffer: float = 0.0

var initial_grab_dist: float = 0.0
func _ready() -> void:
	jump_velocity = -((2.0 * jump_height) / jump_time_to_peak)
	jump_gravity =((-2.0 * jump_height) / (jump_time_to_peak * jump_time_to_peak)) * -1.0
	fall_gravity =((-2.0 * jump_height) / (jump_time_to_fall * jump_time_to_fall)) * -1.0
	default_scale = $AnimatedSprite2D.scale

var direction: float = 0.0
func _physics_process(delta: float) -> void:
	# Check if gravity is flipped according to GameManager
	
	
	# Apply gravity
	up_direction = Vector2.DOWN if GameManager.x else Vector2.UP

	var gravity_direction: float = -1.0 if GameManager.x else 1.0

	if not is_on_floor():
		velocity.y += get_current_gravity() * gravity_direction * delta

	# Flip only the animated sprite visually without touching node scales
	if animated_sprite:
		animated_sprite.flip_v = GameManager.x
		# Adjust this offset value (e.g., 2.0 or 4.0) if it sinks too deep or floats
		animated_sprite.offset.y = 20.0 if GameManager.x else 0.0

	$AnimatedSprite2D.scale = $AnimatedSprite2D.scale.lerp(default_scale, 12.0 * delta)
	
	if is_on_floor():
		coyote_timer = coyote_time  
	else:
		if coyote_timer > 0:
			coyote_timer -= delta
	if jump_buffer_counter > 0:
		jump_buffer_counter -= delta	
	# Handle jump.
	if Input.is_action_just_pressed("jump"):
		jump_buffer_counter = jump_buffer_time
	if (is_on_floor() or coyote_timer > 0) and jump_buffer_counter > 0:
		velocity.y = jump_velocity * gravity_direction  # <-- Multiply by gravity_direction here
		jump_buffer_counter = 0.0 
		coyote_timer = 0.0
		$AnimatedSprite2D.scale = default_scale * Vector2(0.7, 1.2)
		$JumpParticles.restart()
		$AudioStreamPlayer2D.play()
	if is_on_floor() and direction != 0:
		if not $WalkSound.playing:
			$WalkSound.play()
	else:
		if $WalkSound.playing:
			$WalkSound.stop()	
	if Input.is_action_just_released("jump") and velocity.y < 0.0:
		velocity.y *= 0.5
		
	direction = Input.get_axis("left", "right")
	if direction!= 0:
		var target_speed = direction * top_speed
		velocity.x = lerp(velocity.x, target_speed, 1.0 - exp(-acceleration_weight * delta))
		if Input.is_action_pressed("grab") and grabbed_body:
			$AnimatedSprite2D.flip_h = grabbed_body.global_position.x < global_position.x
		else:
			$AnimatedSprite2D.flip_h = direction < 0
	else:
		velocity.x = lerp(velocity.x, 0.0, 1.0 - exp(-friction_weight * delta))
	move_and_slide()
	is_interacting_with_box = false
	
	if push_buffer > 0.0:
		push_buffer -= delta

	# 1. Automatic Pushing (Walking into the box normally)
	for i in get_slide_collision_count():
		var c = get_slide_collision(i)
		var collider = c.get_collider()
		if collider is RigidBody2D:
			if abs(c.get_normal().x) > 0.7:
				collider.sleeping = false
				if direction != 0.0 and not Input.is_action_pressed("grab"):
					is_interacting_with_box = true
					push_buffer = 0.15
					# Replace apply_central_impulse with this:
					collider.linear_velocity.x = direction * (top_speed * 0.7)
					collider.linear_velocity.x = clamp(collider.linear_velocity.x/ collider.mass, -top_speed, top_speed)

	# 2. Manual Pulling (Holding grab key)
	if Input.is_action_pressed("grab"):
		# Lock onto the box if we touch it while holding grab
		if not grabbed_body:
			for i in get_slide_collision_count():
				var c = get_slide_collision(i)
				var collider = c.get_collider()
				if collider is RigidBody2D and abs(c.get_normal().x) > 0.7:
					add_collision_exception_with(collider)
					grabbed_body = collider
					break
		
		if grabbed_body:
			grabbed_body.sleeping = false
			if direction != 0.0:
				is_interacting_with_box = true
				push_buffer = 0.15
				
				# Match velocity smoothly
				grabbed_body.linear_velocity.x = velocity.x
			else:
				# Stop the box when you stand still while grabbing
				grabbed_body.linear_velocity.x = lerp(grabbed_body.linear_velocity.x, 0.0, 0.2)
			
			# Strict position boundary so you can never walk inside the box
			var offset_x = global_position.x - grabbed_body.global_position.x
			var min_dist = 132.0 # Adjust this value if your box/player sprites are wider or narrower
			if abs(offset_x) < min_dist:
				global_position.x = grabbed_body.global_position.x + (sign(offset_x) * min_dist)
				velocity.x = 0.0
	else:
		# Release the box and restore collision when you let go of grab
		if grabbed_body:
			remove_collision_exception_with(grabbed_body)
			grabbed_body = null

	if push_buffer > 0.0:
		is_interacting_with_box = true
	
	animation_controller()

func animation_controller():
	if is_on_floor():
		if is_interacting_with_box and grabbed_body:
			var box_dir = sign(grabbed_body.global_position.x - global_position.x)
			var is_pushing = (sign(direction) == box_dir)
			
			if is_pushing:
				$AnimatedSprite2D.speed_scale = 1.0
				if $AnimatedSprite2D.animation != "push":
					$AnimatedSprite2D.play("push")
			else:
				# Play push animation in reverse when pulling
				$AnimatedSprite2D.speed_scale = -1.0
				if $AnimatedSprite2D.animation != "push":
					$AnimatedSprite2D.play("push")
		elif direction != 0:
			$AnimatedSprite2D.speed_scale = 1.0
			if $AnimatedSprite2D.animation != "run":
				$AnimatedSprite2D.play("run")
		else:
			$AnimatedSprite2D.speed_scale = 1.0
			if $AnimatedSprite2D.animation != "idle":
				$AnimatedSprite2D.play("idle")
	else:
		$AnimatedSprite2D.speed_scale = 1.0
		if velocity.y < 0.0:
			if $AnimatedSprite2D.animation != "jump":
				$AnimatedSprite2D.play("jump")
		else:
			if $AnimatedSprite2D.animation != "fall":
				$AnimatedSprite2D.play("fall")
func get_current_gravity() -> float:
	var gravity_direction: float = -1.0 if GameManager.x else 1.0
	# Check if velocity is moving in the direction of gravity
	if velocity.y * gravity_direction > 0.0:
		return fall_gravity
	else:
		return jump_gravity
