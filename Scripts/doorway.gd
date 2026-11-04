extends Node2D
var c = 0
func _physics_process(delta: float) -> void:
		if GameManager.score == 2:
			c+=1
			if c == 1:
				$AnimationPlayer.play("RESET")
		if Input.is_action_just_pressed("reset"):
			SceneTransition.change_scene("res://Scenes/main.tscn")
			GameManager.score = 0
			GameManager.x = false
				

		
		
	
		
	
