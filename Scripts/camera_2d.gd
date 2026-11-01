extends Camera2D

@export var player: CharacterBody2D
@export var look_ahead_distance: float = 60.0
@export var look_ahead_speed: float = 3.0

var target_offset: Vector2 = Vector2.ZERO

func _process(delta):
	if not player:
		return
	
	# Detect player movement direction and shift look-ahead offset
	if abs(player.velocity.x) > 10.0:
		var direction = sign(player.velocity.x)
		target_offset.x = direction * look_ahead_distance
	
	# Smoothly glide the camera offset toward the target look-ahead position
	offset.x = lerp(offset.x, target_offset.x, look_ahead_speed * delta)
