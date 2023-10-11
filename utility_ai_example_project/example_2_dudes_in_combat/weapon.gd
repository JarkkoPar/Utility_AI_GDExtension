extends AnimatedSprite2D

var weapon_id = 0
var is_picked_up = false

# Called when the node enters the scene tree for the first time.
func _ready():
	# Randomize the weapon
	if randf() < 0.5:
		weapon_id = 1
		play("smg")
	else:
		play("default")
	
	# And the position.
	var viewport_size = get_viewport_rect().end 
	position.x = viewport_size.x * randf()
	position.y = viewport_size.y * randf()
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
