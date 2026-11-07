extends StaticBody2D

@export var point_a: Vector2

@export var point_b: Vector2

@export var move_duration: float = 2.0




func _on_area_2d_3_pressed() -> void:
	var tween = create_tween().set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)

	tween.tween_property(self, "position", point_b, move_duration)
	


func _on_area_2d_3_released() -> void:
	var tween = create_tween().set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)

	tween.tween_property(self, "position", point_a, move_duration)
