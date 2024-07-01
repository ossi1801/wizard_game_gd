class_name Enemy # for visual so i see what f kin file im in
extends CharacterBody2D
var _enemy_damage: int = 10;
var _enemy_hp: int = 10;


#func enemy():pass # acts an enemy identifier
func _ready():pass #default func
func _process(delta):pass #default func

#Todo as signal?
func damage_enemy_hp(damage:int): 
	_enemy_hp -= damage;
	print_debug("ouch damage to enemy"+str(_enemy_hp))
	if(_enemy_hp<=0):
		queue_free()
		

#get set
func get_enemy_hp()->int:return _enemy_hp;
func set_enemy_hp(hp:int):_enemy_hp = hp;

func get_enemy_damage()->int:return _enemy_damage;
func set_enemy_damage(damage:int):_enemy_damage = damage
