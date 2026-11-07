extends Node2D

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is CharacterBody2D or body.is_in_group("player"):
		GameManager.flippy()
		
		# Play audio, burst collection particles, and stop idle particles
		$AudioStreamPlayer2D.play()
		$GPUParticles2D.restart()
		$GPUParticles2D2.emitting = false
		
		# Hide the coin sprite and disable collection
		$Sprite2D.visible = false
		$Area2D.monitoring = false
		
		# Wait for 3 seconds
		await get_tree().create_timer(3.0).timeout
		
		# Make the coin reappear, turn collision back on, and resume idle particles
		$Sprite2D.visible = true
		$Area2D.monitoring = true
		$GPUParticles2D2.emitting = true
