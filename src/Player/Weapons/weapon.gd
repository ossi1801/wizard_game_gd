class_name Weapon
extends Area2D

var _weapon_damage: int = 10;
@export var despawn_on_hit: bool = false;
#var _weapon_hp: int = 10;


#func enemy():pass # acts an enemy identifier
func _ready():pass #default func
func _process(delta):pass #default func

#Todo as signal?
#func damage_weapon_hp(damage:int): 
	#_weapon_hp -= damage;
	#print_debug("ouch damage to enemy"+str(_weapon_hp))

#get set
#func get_weapon_hp()->int:return _weapon_hp;
#func set_weapon_hp(hp:int):_weapon_hp = hp;

func get_weapon_damage()->int:return _weapon_damage;
func set_weapon_damage(damage:int):_weapon_damage = damage;
