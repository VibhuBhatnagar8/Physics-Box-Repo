extends CanvasLayer


func change_scene(target):
	$AnimationPlayer.play("dissolve")
	$AudioStreamPlayer.play()
	await $AnimationPlayer.animation_finished
	get_tree().change_scene_to_file(target)
	$AnimationPlayer.play_backwards("dissolve")
	$AudioStreamPlayer.play()
