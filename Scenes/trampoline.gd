extends Area2D

@export var bounce_force: float = 1200.0  # Speed at which it pushes the object left
@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var sprite: Sprite2D = $Sprite2D

var default_scale: Vector2 = Vector2.ONE

func _ready() -> void:
	if sprite:
		default_scale = sprite.scale
	body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node2D) -> void:
	# Always force the direction to the left (-1.0) no matter what
	var push_dir: float = -1.0
	
	# Apply force to the X-axis to shoot them left
	if body is CharacterBody2D:
		body.velocity.x = bounce_force * push_dir
	elif body is RigidBody2D:
		body.linear_velocity.x = bounce_force * push_dir * 0.65
	else:
		return # Ignore non-movable physics bodies

	# 1. Trampoline's horizontal squash and stretch animation
	if sprite:
		var tween = create_tween()
		tween.tween_property(sprite, "scale", Vector2(default_scale.x * 0.6, default_scale.y * 1.3), 0.05)
		tween.tween_property(sprite, "scale", default_scale, 0.25).set_trans(Tween.TRANS_SPRING).set_ease(Tween.EASE_OUT)
		$AudioStreamPlayer2D.play()

	# 2. Dynamic squish effect for anything that hits the trampoline
	_squish_object(body)


func _squish_object(body: Node2D) -> void:
	var target_sprite: Node2D = null
	
	for child in body.get_children():
		if child is Sprite2D or child is AnimatedSprite2D:
			target_sprite = child
			break
			
	if target_sprite:
		var base_scale: Vector2 = Vector2.ONE
		if "default_scale" in body:
			base_scale = body.default_scale
		elif "default_scale" in target_sprite:
			base_scale = target_sprite.default_scale
		
		# Squish horizontally on impact
		target_sprite.scale = Vector2(base_scale.x * 0.6, base_scale.y * 1.3)
		
		if body.name != "Stickman":
			var body_tween = create_tween()
			body_tween.tween_property(target_sprite, "scale", base_scale, 0.25).set_trans(Tween.TRANS_SPRING).set_ease(Tween.EASE_OUT)
