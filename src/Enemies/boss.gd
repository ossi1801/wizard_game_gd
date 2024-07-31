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



func _on_hurt_box_area_entered(area:Area2D):
	if area.get_parent() is Enemy and area.name == "hitBox":
		return;
		
	if area is Weapon: #and area.name == "hitBox":
		print_debug("Enemy WEAPON HIT"+ area.get_parent().name)
		var weapon = area as Weapon;
		super.damage_enemy_hp(weapon.get_weapon_damage())
		
	else:
		print_debug("Enemy got hit by"+ area.get_parent().name)
		print_debug("Enemy got hit by"+ area.name)
	pass # Replace with function body.
