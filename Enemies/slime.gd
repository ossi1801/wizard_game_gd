extends CharacterBody2D
@onready var animations = $AnimatedSprite2D

const SPEED = 300.0
const JUMP_VELOCITY = -400.0

func _physics_process(delta):
	move_and_slide()
	animate()
	
func animate():
	animations.play("jumping")
