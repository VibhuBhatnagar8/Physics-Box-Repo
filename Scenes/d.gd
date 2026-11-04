extends Area2D

@export var forward_target_position: Vector2 = Vector2( 500.0, 100.0)
@export var backward_target_position: Vector2 = Vector2(600, -650)

func _ready() -> void:
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)

func _on_body_entered(body: Node2D) -> void:
	if body.name == "Stickman":
		var cam = %Camera2D
		if cam and body.velocity.y > 0:
			cam.shift_camera(forward_target_position)

func _on_body_exited(body: Node2D) -> void:
	if body.name == "Stickman":
		var cam = %Camera2D
		# When exiting to the left (negative velocity), shift back
		if cam and body.velocity.y < 0:
			cam.shift_camera(backward_target_position)
