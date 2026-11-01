extends Area2D
func _on_body_entered(body: Node2D) -> void:
	if body is CharacterBody2D:
		if GameManager.score == 4:
			SceneTransition.change_scene("res://Scenes/level_3.tscn")
			%Stickman.queue_free()
