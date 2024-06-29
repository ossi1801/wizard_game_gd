extends CharacterBody2D

@onready var animations = $AnimationPlayer
@export var player_speed:float = 150
#@export var player_acceleration_speed:float = 1  

func  movement():
	var move_dir = Input.get_vector("ui_left","ui_right","ui_up","ui_down")
	velocity = move_dir*player_speed 
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
	
func _physics_process(delta):
	movement()
	move_and_slide()
	animate_movement()
	
