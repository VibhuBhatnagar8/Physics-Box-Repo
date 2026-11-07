extends Sprite2D

@export var angle_a: float = 0.0
@export var angle_b: float = 90.0
@export var move_duration: float = 2.0


func _on_area_2d_pressed() -> void:
	var tween = create_tween().set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)

	tween.tween_property(self, "rotation_degrees", angle_b, move_duration)
	

func _on_area_2d_released() -> void:
	var tween = create_tween().set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)

	tween.tween_property(self, "rotation_degrees", angle_a, move_duration)
