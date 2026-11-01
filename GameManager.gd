extends Node2D

var score = 0
var x = false

func _process(delta: float) -> void:
	pass
func add_score():
	score = score + 1
	print(score)
func flip():
	x = not x
	score = score + 1
