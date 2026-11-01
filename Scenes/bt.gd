extends Button



func _on_pressed() -> void:
	SceneTransition.change_scene("res://Scenes/main.tscn")
	GameManager.score = 0
	GameManager.x = false
	
