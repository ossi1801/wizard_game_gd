extends Node

@onready var hearts_container = $GUI/heart_container

func update_gui(text:String):
		for child in hearts_container.get_children():
			if child is Panel:
				for c in child.get_children():
					if c is Label:
						c.text = text;
# Called when the node enters the scene tree for the first time.
#func _ready():
#	pass # Replace with function body.
#
#
## Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	quit_game()
	pass

func quit_game():
	if Input.is_action_just_pressed("ui_cancel"):
		get_tree().quit()
