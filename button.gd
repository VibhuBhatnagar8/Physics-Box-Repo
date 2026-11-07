extends Area2D

@onready var button: Sprite2D = $Button

@export_range(-100.0, 100.0, 0.5) var manual_y_offset: float = 45.0 

var original_position: Vector2
var original_scale: Vector2 = Vector2(1.0, 1.0)
var squashed_scale: Vector2 = Vector2(1.2, 0.5)

# Track whether the button is currently pressed down
var is_depressed: bool = false

# Define custom signals
signal pressed
signal released

func _ready() -> void:
	original_position = button.position
	original_scale = button.scale
	
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)

func _is_valid_body(body: Node2D) -> bool:
	return body.name == "Stickman" or body is RigidBody2D

func _on_body_entered(body: Node2D) -> void:
	if _is_valid_body(body):
		# Only press if it wasn't already pressed down
		if not is_depressed:
			is_depressed = true
			pressed.emit()
			
			var tween = create_tween().set_parallel(true)
			
			var scale_tween = tween.tween_property(button, "scale", squashed_scale, 0.1)
			scale_tween.set_trans(Tween.TRANS_BACK)
			scale_tween.set_ease(Tween.EASE_OUT)
			
			var target_pos = original_position + Vector2(0, manual_y_offset)
			var pos_tween = tween.tween_property(button, "position", target_pos, 0.1)
			pos_tween.set_trans(Tween.TRANS_BACK)
			pos_tween.set_ease(Tween.EASE_OUT)
			
			tween.tween_property(button, "modulate", Color(2.0, 2.0, 2.0, 1.0), 0.1)

func _on_body_exited(body: Node2D) -> void:
	if _is_valid_body(body):
		# Check if ANY other valid body is still sitting on the plate
		var still_occupied = false
		for overlapping_body in get_overlapping_bodies():
			if _is_valid_body(overlapping_body):
				still_occupied = true
				break
		
		# Only release if NO valid objects remain on the plate
		if not still_occupied and is_depressed:
			is_depressed = false
			released.emit()
			
			var tween = create_tween().set_parallel(true)
			
			var scale_tween = tween.tween_property(button, "scale", original_scale, 0.15)
			scale_tween.set_trans(Tween.TRANS_SPRING)
			scale_tween.set_ease(Tween.EASE_OUT)
			
			var pos_tween = tween.tween_property(button, "position", original_position, 0.15)
			pos_tween.set_trans(Tween.TRANS_SPRING)
			pos_tween.set_ease(Tween.EASE_OUT)
			
			tween.tween_property(button, "modulate", Color(1.0, 1.0, 1.0, 1.0), 0.15)
