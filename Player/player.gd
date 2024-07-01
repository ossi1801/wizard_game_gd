class_name Player
extends CharacterBody2D
@onready var game_manager = %GameManager
@onready var animations = $AnimationPlayer
@onready var effects = $effects
@export var player_speed:float = 150
@export var player_dash_multiplier: float = 5;
@export var player_max_health:int = 100;
var player_dash:float = 1;
var player_can_dash:bool=true;
var player_invincible: bool = false;
var player_health: int = player_max_health;
var player_facing_left:bool = true;
#@export var player_acceleration_speed:float = 1  

func  movement():
	var move_dir = Input.get_vector("ui_left","ui_right","ui_up","ui_down")
	if(Input.is_action_just_pressed("Dash")):
		dash()
	velocity = (move_dir*player_speed) * player_dash;
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
		player_dash = player_dash_multiplier;
		#Todo set immortality here to true to create "iframe"
		player_invincible = true;
		#Reset dash and set immortality to false after x amount of time
		#await returns from function until timer done and return to point where it returned
		await get_tree().create_timer(0.1).timeout 
		player_dash = 1;
		player_can_dash = false;
		player_invincible = false;
		#Then set cool down for dash (this can be done as animation later
		await get_tree().create_timer(0.3).timeout
		player_can_dash = true;
		
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
			update_health_to_gui()
			hurt_animation(0.7)


func update_health_to_gui():
	game_manager.update_gui(str(player_health))
