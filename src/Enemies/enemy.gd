class_name Enemy # acts an enemy identifier
extends CharacterBody2D

@onready var player:Player = %Player #ref to player

var _enemy_damage: int = 10;
var _enemy_hp: int = 10;
var _enemy_speed: float = 100#0.5;

#path finding
@onready var tilemap:Astar = %TileMap
var current_path: Array[Vector2i]
#ref to gamemanager


#func _ready():pass #default func
#func _process(delta):pass #default func

signal enemy_hp_changed(hp)
#Todo as signal?
func damage_enemy_hp(damage:int): 
	_enemy_hp -= damage;
	enemy_hp_changed.emit(_enemy_hp)
	print_debug("ouch damage to enemy"+str(_enemy_hp))
	if(_enemy_hp<=0):
		queue_free()
		


#get set
func get_enemy_hp()->int:return _enemy_hp;
func set_enemy_hp(hp:int):_enemy_hp = hp;

func get_enemy_damage()->int:return _enemy_damage;
func set_enemy_damage(damage:int):_enemy_damage = damage

#Behavioral
func activity():
	#var player_pos = player.global_position;
	pass;


#path find
func _process(delta):
	update_enemy_pos();
	var hit= raycast(global_position,player.global_position)
	#todocheck length to match enemy vision
	if "collider" in hit:
		if(hit.collider is Player):
			find_path_to(player.global_position);
func raycast(from:Vector2,to:Vector2) -> Dictionary:
	var space_state = get_world_2d().direct_space_state
	var query = PhysicsRayQueryParameters2D.create(from, to)
	query.exclude = [self]
	var result = space_state.intersect_ray(query)
	return result;
	#result.values().
	#print_debug(result.collider is Player)

func update_enemy_pos():
	if current_path.is_empty():
		return		
	var target_position = tilemap.map_to_local(current_path.front())
	#global_position = global_position.move_toward(target_position,_enemy_speed)
	velocity = Vector2(target_position.x - global_position.x, target_position.y - global_position.y).normalized()*_enemy_speed
	#print_debug(global_position)
	if global_position == target_position:
		current_path.pop_front()
		
func find_path_to(vector2_pos: Vector2):
	if tilemap.is_point_walkable(vector2_pos):
		current_path = tilemap.astar.get_id_path(
			tilemap.local_to_map(global_position),
			tilemap.local_to_map(vector2_pos)
		).slice(1)
		#print_debug(current_path)


func _on_hurt_box_area_entered(area:Area2D):
	if area.get_parent() is Enemy and area.name == "hitBox":
		return;
	if area is Weapon: #and area.name == "hitBox":
		print_debug("Enemy WEAPON HIT"+ area.get_parent().name)
		var weapon = area as Weapon;
		damage_enemy_hp(weapon.get_weapon_damage())
	#else:
		#print_debug("Enemy got hit by"+ area.get_parent().name)
		#print_debug("Enemy got hit by"+ area.name)
	pass # Replace with function body.
