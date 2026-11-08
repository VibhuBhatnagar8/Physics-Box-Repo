extends Node2D

@onready var area_2d = $Area2D
@onready var collision_shape = $Area2D/CollisionShape2D
@onready var sprite_2d = $Sprite2D
@onready var particles_burst = $GPUParticles2D
@onready var particles_idle = $GPUParticles2D2
@onready var audio = $AudioStreamPlayer2D

var is_collected: bool = false

func _on_area_2d_body_entered(body: Node2D) -> void:
	if is_collected:
		return
		
	if body is CharacterBody2D or body.is_in_group("player"):
		is_collected = true
		GameManager.flippy()
		
		# Play audio, handle particles, and hide the sprite
		audio.play()
		particles_burst.restart()
		particles_idle.emitting = false
		sprite_2d.visible = false
		collision_shape.set_deferred("disabled", true)
		
		# Wait for 3 seconds
		await get_tree().create_timer(3.0).timeout
		
		# Wait until the player moves away so it doesn't instantly re-trigger
		while true:
			var overlapping_bodies = area_2d.get_overlapping_bodies()
			var player_still_there = false
			for b in overlapping_bodies:
				if b is CharacterBody2D or b.is_in_group("player"):
					player_still_there = true
					break
			if not player_still_there:
				break
			await get_tree().process_frame
		
		# Respawn the coin
		sprite_2d.visible = true
		collision_shape.set_deferred("disabled", false)
		particles_idle.emitting = true
		is_collected = false
