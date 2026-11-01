extends Area2D

@export var forward_target_position: Vector2 = Vector2(-1000, 400) # Coordinates when moving right
@export var backward_target_position: Vector2 = Vector2(562, 309.0)  # Coordinates when moving left

func _ready() -> void:
	body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node2D) -> void:
	if body.name == "Stickman":
		var cam = %Camera2D
		if not cam:
			return
			
		# Moving left (negative X velocity) means moving forward into the level
		var moving_left = false
		if body.has_method("get_real_velocity"):
			moving_left = body.get_real_velocity().x < 0
		elif "velocity" in body:
			moving_left = body.velocity.x < 0
		else:
			moving_left = body.global_position.x < global_position.x

		# Shift forward when moving left, backward when retreating right
		if moving_left:
			cam.shift_camera(forward_target_position)
		else:
			cam.shift_camera(backward_target_position)
