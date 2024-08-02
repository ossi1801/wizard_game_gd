extends "res://Enemies/enemy.gd" #CharacterBody2D
@onready var animations = $AnimatedSprite2D
@export var slime_damage: int = 10;
@export var slime_hp: int = 2;
const SPEED = 300.0
const JUMP_VELOCITY = -400.0

func _ready():
	super.set_enemy_damage(slime_damage)
	super.set_enemy_hp(slime_hp)
	pass # Replace with function body.
func _physics_process(delta):
	move_and_slide()
	animate()
	
func animate():
	animations.play("jumping")
#func enemy()->int:
	#return _enemy_damage;
	##pass
#func enemy_damage()->int:
	#return _enemy_damage;
