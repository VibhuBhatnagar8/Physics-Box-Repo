extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GameManager.x = true
	$AnimationPlayer.play("RESET")


var c = 0
func _physics_process(delta: float) -> void:
		if GameManager.score == 9:
			c+=1
			if c == 1:
				$AnimationPlayer2.play("RESET")
		if Input.is_action_just_pressed("reset"):
			SceneTransition.change_scene("res://Scenes/level_4.tscn")
			GameManager.score = 7
			GameManager.x = true
