extends Node2D
var c = 0
func _physics_process(delta: float) -> void:
		if GameManager.score == 4:
			c+=1
			if c == 1:
				$AnimationPlayer2.play("RESET")
		if Input.is_action_just_pressed("reset"):
			SceneTransition.change_scene("res://Scenes/level_2.tscn")
			GameManager.score = 2
			GameManager.x = false
		
	
