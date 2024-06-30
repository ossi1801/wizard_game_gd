extends CharacterBody2D

@onready var animations = $AnimationPlayer
@export var player_speed:float = 150
@export var player_dash_multiplier: float = 5;
var player_dash:float = 1;
var player_can_dash:bool=true;
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
		if animations.is_playing():
			animations.stop()
	else:
		var dir: String = "down"
		if 	velocity.x < 0: dir = "left"
		elif 	velocity.x > 0: dir = "right"
		elif 	velocity.y > 0: dir = "down"
		elif 	velocity.y < 0: dir = "up"
		
		animations.play("walk_"+dir)
	
func dash():
	if player_can_dash:
		player_dash = player_dash_multiplier;
		#Todo set immortality here to true to create "iframe"
		
		#Reset dash and set immortality to false after x amount of time
		#await returns from function until timer done and return to point where it returned
		await get_tree().create_timer(0.1).timeout 
		player_dash = 1;
		player_can_dash = false;
		#Then set cool down for dash (this can be done as animation later
		await get_tree().create_timer(0.3).timeout
		player_can_dash = true;
		
		
	
func _physics_process(delta):
	movement()
	move_and_slide()
	animate_movement()
	
