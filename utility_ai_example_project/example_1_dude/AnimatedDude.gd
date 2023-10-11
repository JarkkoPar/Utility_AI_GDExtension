extends AnimatedSprite2D

# This first example just creates a dude that follows the cursor.
# When it is close enough, the dude will wait.
# Check the nodes to learn more on how this is achieved.

var ai:UtilityAIAgent # This is the brains of the operation
var sensor_distance_to_cursor:UtilityAISensor # Sensors are used to share data for considerations
var current_behaviour:UtilityAIBehaviour # Behaviours are what the ai wnats to do
var current_action:UtilityAIAction # The action is a single step in the behaviour
var current_behaviour_label:Label
var wait_time:float = 1.0

# Called when the node enters the scene tree for the first time.
func _ready():
	ai = $UtilityAIAgent
	current_behaviour_label = $CurrentBehaviourLabel
	sensor_distance_to_cursor = $UtilityAIAgent/CursorChasingSensors/DistanceToCursor


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
		# We use a 3 step process: 
	# 1. Sense
	# 2. Think, and
	# 3. Act
	
	# 1. Sense
	# Here we get the current cursor position and the dude's distance to it.
	# The distance goes to the only sensor we have.
	var cursor_pos = get_viewport().get_mouse_position()
	var dir_to_cursor = cursor_pos - position
	var distance = dir_to_cursor.length()
	sensor_distance_to_cursor.sensor_value = distance / 1000.0 # Put to 0..1 range
	
	# 2. Think
	# In the think-step the sensor values are used to consider what behaviours
	# would be the best options for the AI agent to take. One behaviour will
	# be chosen, and that is done by calling the evaluate_options() method.
	# Then update_current_behaviour() will fetch the next action to be performed.
	ai.evaluate_options(delta)
	ai.update_current_behaviour()
	
	# 3. Act
	# In the last step, act, the actions are implemented. When an action is
	# completed, the set_is_finished(true) must be called to let the AI 
	# agent know it is time to go to the next action, or if the action was
	# the last one on the list for a behaviour, to choose another behaviour.
	var new_action = ai.get_current_action_node()
	if new_action != current_action:
		current_action = new_action
		
	if current_action == null:
		return
	
	if current_action.get_name() == "Wait":
		play("default")
		if wait_time > 0.0:
			wait_time -= delta
		else: 
			current_action.set_is_finished(true)
		return
	else:
		play("move")
		# Normalize the direction for movement.
		dir_to_cursor = dir_to_cursor.normalized()
		position += delta * 200.0 * dir_to_cursor
		flip_h = (dir_to_cursor.x < 0.0)
		if distance < 2.0:
			current_action.set_is_finished(true)


# This is used to handle behaviour changes and to update the UI.
func _on_utility_ai_agent_behaviour_changed(behaviour_node):
	current_behaviour = behaviour_node
	if behaviour_node != null:
		current_behaviour_label.text = behaviour_node.get_name()
		wait_time = 0.5
