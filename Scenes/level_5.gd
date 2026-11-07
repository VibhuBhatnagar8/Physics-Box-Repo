extends Node2D

func _on_area_2d_pressed() -> void:
	$TileMap2.visible = true
   


func _on_area_2d_released() -> void:
	$TileMap2.visible = false




var c = 0
func _physics_process(delta: float) -> void:
		if GameManager.score == 13:
			c+=1
			if c == 1:
				$AnimationPlayer2.play("RESET")
		if Input.is_action_just_pressed("reset"):
			SceneTransition.change_scene("res://Scenes/level_5.tscn")
			GameManager.score = 9
			
