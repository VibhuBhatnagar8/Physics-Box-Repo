extends Camera2D

@export var initial_room_position: Vector2 = Vector2(-1000.0, 400.0) 
@export var transition_duration: float = 0.4 # Time in seconds the pan takes

func _ready() -> void:
	global_position = initial_room_position

func shift_camera(new_room_position: Vector2) -> void:
	# Stop any ongoing tween so they don't conflict if you cross triggers fast
	var tween = create_tween().set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(self, "global_position", new_room_position, transition_duration)
