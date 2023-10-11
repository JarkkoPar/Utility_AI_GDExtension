extends Node2D

# This example shows how the AI Agent and the other nodes can be used to create
# sevaral AI-driven entities.
# There are dudes and they can pick up weapons and shoot those who are not
# in the same team with them.
# A team can have a leader-dude, who can bark orders to the dudes in their
# team. 

@onready var dude_template = preload("res://example_2_dudes_in_combat/combat_dude.tscn")
@onready var weapon_template = preload("res://example_2_dudes_in_combat/weapon.tscn")


# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	# Add combat dudes. 
	
	# First team RED. No leader there.
	var dude = null
	for i in range(0,3):
		dude = dude_template.instantiate()
		dude.team_alignment = 0
		add_child(dude)
		
	# Then team blue. They have a leader.
	var leaderdude = dude_template.instantiate()
	leaderdude.team_alignment = 1
	leaderdude.is_leader = true
	add_child(leaderdude)
	
	for i in range(0,2):
		dude = dude_template.instantiate()
		dude.team_alignment = 1
		add_child(dude)
		leaderdude.add_follower(dude)
		
	
	# Add 16 weapons
	for i in range(0,16):
		var weapon = weapon_template.instantiate()
		add_child(weapon)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	update_dude_distances()


# This function lets all the dudes evalute distances and do some
# other examination of other nodes to gather data for the AI to 
# make decisions.
func update_dude_distances() -> void:
	for child in get_children():
		if child.has_method("evaluate_distances"):
			# A dude 
			child.evaluate_distances(get_children())
		else:
			# A weapon 
			pass

