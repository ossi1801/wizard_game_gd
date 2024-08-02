extends "res://Enemies/enemy.gd" #CharacterBody2D
@onready var animations = $AnimatedSprite2D
@export var boss_damage: int = 30;
@export var boss_hp: int = 100;
const SPEED = 75.0
const JUMP_VELOCITY = -400.0

func _ready():
	super.set_enemy_damage(boss_damage)
	super.set_enemy_hp(boss_hp)
	pass # Replace with function body.
func _physics_process(delta):
	move_and_slide()
	animate()
	
func animate():
	animations.play("move")
#func enemy()->int:
	#return _enemy_damage;
	##pass
#func enemy_damage()->int:
	#return _enemy_damage;
