extends TileMap

func _on_area_2d_pressed() -> void:
	visible = true
	# If TileMap2 is a TileMapLayer in Godot 4, uncomment the line below:
	# collision_enabled = true

func _on_area_2d_released() -> void:
	visible = false
	# collision_enabled = false
