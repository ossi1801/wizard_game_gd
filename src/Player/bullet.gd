extends Weapon
class_name Bullet
var v = Vector2(0,0)
@export var b_speed = 1000
signal player_vector_changed(vector)
# Called when the node enters the scene tree for the first time.
func _ready():
	self.despawn_on_hit = true
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position += v.normalized()*delta*b_speed
	#move_and_collide( v.normalized()*delta*speed)
	pass

func _on_player_vector_changed(vector):
	v=vector
	pass # Replace with function body.


func _on_area_entered(area): # if hit enemy despawn bullet
	if area is Player:
		pass
	if area.get_parent() is Enemy:
		queue_free()
	#print_debug(area.name)

