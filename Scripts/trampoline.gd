extends Area2D

@export var bounce_force: float = -1500  
@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var sprite: Sprite2D = $Sprite2D


var default_scale: Vector2 = Vector2.ONE

func _ready() -> void:
	if sprite:
		default_scale = sprite.scale
	body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node2D) -> void:
	# Launch CharacterBody2D or RigidBody2D objects
	var direction: float = -1.0 if GameManager.x else 1.0
	
	if body is CharacterBody2D:
		body.velocity.y = bounce_force * direction
	elif body is RigidBody2D:
		body.linear_velocity.y = bounce_force * direction * 0.65
	else:
		return # If it's not a movable physics body, ignore it

	# 1. Trampoline's own squash and stretch animation
	if sprite:
		var tween = create_tween()
		tween.tween_property(sprite, "scale", Vector2(default_scale.x * 1.3, default_scale.y * 0.6), 0.05)
		tween.tween_property(sprite, "scale", default_scale, 0.25).set_trans(Tween.TRANS_SPRING).set_ease(Tween.EASE_OUT)
		$AudioStreamPlayer2D.play()

	# 2. Dynamic squish effect for ANYTHING that lands on the trampoline
	_squish_object(body)


func _squish_object(body: Node2D) -> void:
	# Find any Sprite2D or AnimatedSprite2D child inside the landing body
	var target_sprite: Node2D = null
	
	for child in body.get_children():
		if child is Sprite2D or child is AnimatedSprite2D:
			target_sprite = child
			break
			
	if target_sprite:
		# Use default_scale if stored on the body, otherwise read target_sprite's current scale
		var base_scale: Vector2 = Vector2.ONE
		if "default_scale" in body:
			base_scale = body.default_scale
		elif "default_scale" in target_sprite:
			base_scale = target_sprite.default_scale
		
		# 1. Instantly squish flat on impact
		target_sprite.scale = Vector2(base_scale.x * 1.3, base_scale.y * 0.6)
		
		# 2. If it's NOT the player (or has no lerp process), smooth return using a Tween
		if body.name != "Stickman":
			var body_tween = create_tween()
			body_tween.tween_property(target_sprite, "scale", base_scale, 0.25).set_trans(Tween.TRANS_SPRING).set_ease(Tween.EASE_OUT)
