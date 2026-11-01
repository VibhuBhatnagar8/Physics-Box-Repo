extends Area2D
func _on_body_entered(body: Node2D) -> void:
	if body is CharacterBody2D:
		if GameManager.score == 7:
			SceneTransition.change_scene("res://Scenes/end.tscn")
			%Stickman.queue_free()
