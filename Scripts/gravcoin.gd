extends Node2D


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is CharacterBody2D:
		GameManager.flip()
		$Area2D.queue_free()
		$GPUParticles2D.emitting = true
		$GPUParticles2D2.emitting = false
		$AudioStreamPlayer2D.play()
