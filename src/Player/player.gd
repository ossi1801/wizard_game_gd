class_name Player
extends CharacterBody2D

@onready var game_manager = %GameManager
@onready var animations = $AnimationPlayer
@onready var effects = $effects
@export var ghost_node : PackedScene
@onready var ghost_timer = $ghost_timer
const BULLET = preload("res://Player/bullet.tscn")
@export var player_speed:float = 150
@export var player_dash_multiplier: float = 5;
@export var player_max_health:int = 100;
var player_dash:float = 1;
var player_can_dash:bool=true;
var player_invincible: bool = false;
var player_health: int = player_max_health;
var player_facing_left:bool = true;
#@export var player_acceleration_speed:float = 1  
@onready var hit_sound = $hit_sound
var can_shoot : bool = true;
var _enemy_knockback = Vector2(0,0)
var knockback_mult = 10

func shoot():
	var shoot_dir = Input.get_vector("shoot_left","shoot_right","shoot_up","shoot_down")
	if shoot_dir.length()>0 && can_shoot:
		var bullet = BULLET.instantiate()
		bullet.player_vector_changed.emit(shoot_dir)	
		get_parent().add_child(bullet)
		if player_facing_left :
			bullet.position = global_position+Vector2(-16,-16);
		else:
			bullet.position = global_position+Vector2(16,-16);
		can_shoot=false
		await get_tree().create_timer(0.5).timeout 
		can_shoot=true

	#TODO instansiate smth here
	#print(shoot_dir)
	
func movement():
	var move_dir = Input.get_vector("move_left","move_right","move_up","move_down")
	if(Input.is_action_just_pressed("Dash")):
		dash()
	velocity = (move_dir*player_speed) * player_dash+_enemy_knockback;

	#velocity.x = move_toward(velocity.x,player_speed*move_dir.x,player_acceleration_speed)
	#velocity.y = move_toward(velocity.y,player_speed*move_dir.y,player_acceleration_speed)
	#No need for delta wtf???? *delta
func animate_movement():
	if velocity.length() ==0:
		animations.play("idle")
		#if animations.is_playing():
			#animations.stop()
	else:
		var dir: String = "down"
		if 	velocity.x < 0: 
			flip_animation_h(true) #dir = "left"
		elif 	velocity.x > 0: 
			flip_animation_h(false) #dir = "right"
		if 	velocity.y > 0: dir = "down"
		elif 	velocity.y < 0: dir = "up"
		
		animations.play("walk_"+dir)
		
func flip_animation_h(is_going_left:bool):
	player_facing_left =is_going_left;
	for child in get_children():
			if child is Sprite2D:
				child.flip_h = !is_going_left;
			if child.name == "weapon":
				var c =  child as Node2D
				if is_going_left:c.rotation = -45
				else:c.rotation = 45;
				
				
				  #= is_going_left;  
func dash():
	if player_can_dash:
		ghost_timer.start()
		player_dash = player_dash_multiplier;
		#Todo set immortality here to true to create "iframe"
		player_invincible = true;
		#Reset dash and set immortality to false after x amount of time
		#await returns from function until timer done and return to point where it returned
		await get_tree().create_timer(0.1).timeout 
		player_dash = 1;
		player_can_dash = false;
		player_invincible = false;
		ghost_timer.stop();
		#Then set cool down for dash (this can be done as animation later
		await get_tree().create_timer(0.3).timeout
		player_can_dash = true;
		
func add_ghost():
	var ghost = ghost_node.instantiate()
	ghost.set_property(position, $Sprite2D.scale,$Sprite2D.frame,player_facing_left)
	get_tree().current_scene.add_child(ghost)
	
func _on_ghost_timer_timeout():
	add_ghost()
 
func get_mouse_pos():
	if(Input.is_action_just_pressed("cursor_click")):
		var pos= global_position.direction_to(get_global_mouse_position())
		print_debug(pos)
func handle_collisions():
	for i in get_slide_collision_count():
		var collider:Object = get_slide_collision(i).get_collider()
		#print_debug(collider.name)
func _physics_process(delta):
	movement()
	shoot()
	get_mouse_pos() #Todo import here sword and other stuff
	move_and_slide()
	handle_collisions()
	animate_movement()

func hurt_animation(time:float):
	effects.play("hurt_blink")
	await get_tree().create_timer(time).timeout
	effects.play("RESET")
	
func _on_hurt_box_area_entered(area:Area2D):
	if area.get_parent() is Enemy and area.name == "hitBox":
		var enemy = area.get_parent() as Enemy
		if player_invincible == false:
			player_health-=enemy.get_enemy_damage();
			knockback(enemy.velocity)
			update_health_to_gui()
			hurt_animation(0.7)
			hit_sound.play()


func knockback(vel:Vector2):
	_enemy_knockback = vel*knockback_mult
	await get_tree().create_timer(0.1).timeout 
	_enemy_knockback = Vector2(0,0)
	
	

func update_health_to_gui():
	game_manager.update_gui(str(player_health))
