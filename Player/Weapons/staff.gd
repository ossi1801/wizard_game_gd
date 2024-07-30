extends Weapon

@export var staff_damage: int =5;
# Called when the node enters the scene tree for the first time.
func _ready():
	super.set_weapon_damage(staff_damage);
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
