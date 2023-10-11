extends AnimatedSprite2D

# This scene is where the AI logic happens, and compared to the dude running
# after the cursor on the first example, the script is much longer.

var ai:UtilityAIAgent # This is the AI agent which handles reasoning.

# These are sensors we will use to update the AI agent's understanding
# of the game world.
var sensor_distance_to_closest_enemy:UtilityAISensor
var sensor_distance_to_second_closest_enemy:UtilityAISensor
var sensor_distance_to_closest_friendly:UtilityAISensor
var sensor_friendlies_need_for_healing:UtilityAISensor
var sensor_i_have_a_weapon:UtilityAISensor
var sensor_i_am_near_a_weapon:UtilityAISensor
var sensor_i_just_got_hit:UtilityAISensor
var sensor_i_am_a_leader:UtilityAISensor
var sensor_my_health:UtilityAISensor
var sensor_my_ammo:UtilityAISensor
var sensor_is_enemy_in_weaponsrange:UtilityAISensor
var sensor_am_i_dead:UtilityAISensor
var sensor_enemy_is_dead:UtilityAISensor
var sensor_do_i_have_followers:UtilityAISensor
var sensor_do_i_have_an_enemy_as_target:UtilityAISensor
var sensor_my_leader_forces_retreat:UtilityAISensor

# These 2 helpers are used to get info about what the AI agent would like
# to do.
var current_behaviour:UtilityAIBehaviour
var current_action:UtilityAIAction

# These are just helpers.
var team_label:Label
var weaponsound_label:Label
var current_weapon_sprite:AnimatedSprite2D

# This timer is used to mark some timed actions as finished.
var action_duration_timer:Timer

# These are variables that are used to update the sensors.
var team_alignment:int = 0
var move_target_position:Vector2 
var shoot_target_position:Vector2 
var closest_weapon_location:Vector2
var is_leader:bool = false
var is_near_weapon:bool = false
var is_hit_this_frame:bool = false
var is_leader_forced_retreat:bool = false
var wait_time:float = 1.0
var health:float = 100.0 
var ammo:float = 0.0 
var weapon_id:int = -1 # -1 = no weapon
var weapon_range:float = 0.0

var nearest_weapon_node = null
var nearest_enemy_node = null
var nearest_friendly_node = null
var leader_node = null 
var follower_nodes:Array

var viewport_size:Vector2

# Called when the node enters the scene tree for the first time.
func _ready():
	# Set a random position.
	viewport_size = get_viewport_rect().end 
	position.x = viewport_size.x * randf()
	position.y = viewport_size.y * randf()
	
	# Get references to various nodes.
	ai = $UtilityAIAgent
	team_label = $TeamLabel
	weaponsound_label = $WeaponSoundLabel
	current_weapon_sprite = $CurrentWeaponSprite
	action_duration_timer = $ActionDurationTimer
	
	# Get references to the sensors.
	sensor_my_health = $UtilityAIAgent/CombatSensors/MyHealth
	sensor_my_ammo = $UtilityAIAgent/CombatSensors/MyAmmo
	sensor_i_am_a_leader = $UtilityAIAgent/CombatSensors/IAmALeader
	sensor_i_am_near_a_weapon = $UtilityAIAgent/CombatSensors/IAmNearAWeapon
	sensor_i_have_a_weapon = $UtilityAIAgent/CombatSensors/IHaveAWeapon
	sensor_distance_to_closest_enemy = $UtilityAIAgent/CombatSensors/DistanceToClosestEnemy
	sensor_distance_to_second_closest_enemy = $UtilityAIAgent/CombatSensors/DistanceToSecondClosestEnemy
	sensor_distance_to_closest_friendly = $UtilityAIAgent/CombatSensors/DistanceToClosestFriendly
	sensor_friendlies_need_for_healing = $UtilityAIAgent/CombatSensors/FriendliesNeedForHealing
	sensor_is_enemy_in_weaponsrange = $UtilityAIAgent/CombatSensors/EnemyIsInWeaponsRange
	sensor_i_just_got_hit = $UtilityAIAgent/CombatSensors/IJustGotHit
	sensor_am_i_dead = $UtilityAIAgent/CombatSensors/AmIDead
	sensor_enemy_is_dead = $UtilityAIAgent/CombatSensors/EnemyIsDead
	sensor_do_i_have_followers = $UtilityAIAgent/CombatSensors/IHaveFollowers
	sensor_do_i_have_an_enemy_as_target = $UtilityAIAgent/CombatSensors/IHaveEnemyAsMyTarget
	sensor_my_leader_forces_retreat = $UtilityAIAgent/CombatSensors/MyLeaderForcesRetreat
	
	# Set the label for the alignment.
	if team_alignment == 0:
		team_label.text = "RED"
	else:
		team_label.text = "blue"
	
	# Clear the leader follower list.
	follower_nodes = []

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	# We use a 3 step process: 
	# 1. Sense
	# 2. Think, and
	# 3. Act
	
	# 1. Sense
	# In this first step we update the sensors with current values of the 
	# variables. The sensors are used by the Consideration-nodes that are
	# in the Behaviours, and a value of a sensor may have different 
	# interpretations depending on what a consideration is about.
	#
	# For an example, see the Pickup Weapon Behaviour and the Reload Weapon
	# Behaviour nodes. 
	#   * The Pickup Weapon Behaviour has a consideration IDoNotHaveAWeapon
	#     that uses the sensor IHaveAWeapon and uses it to determine if the
	#     dude doesn't have a weapon yet. 
	#   * The Reload Weapon Behaviour has a consideration DoIHaveAWeapon 
	#     that uses the same snesor, but inverted.
	# 
	# The sensors always have a float-value between 0 and 1. You can see
	# some booleans there too, and for those false = 0.0, and true = 1.0.
	sensor_am_i_dead.sensor_value = float(health <= 0)
	sensor_i_am_a_leader.sensor_value = float(is_leader)
	sensor_i_am_near_a_weapon.sensor_value = float(is_near_weapon)
	sensor_i_have_a_weapon.sensor_value = float(weapon_id > -1)
	sensor_my_health.sensor_value = health / 100.0
	sensor_my_leader_forces_retreat.sensor_value = float(is_leader_forced_retreat)
	is_leader_forced_retreat = false
	sensor_enemy_is_dead.sensor_value = 0.0
	
	sensor_i_just_got_hit.sensor_value = is_hit_this_frame 
	if is_hit_this_frame:
		is_hit_this_frame = false 
	
	sensor_do_i_have_an_enemy_as_target.sensor_value = float(nearest_enemy_node != null)
	
	var vec_to_enemy:Vector2 = Vector2.ZERO
	var distance_to_enemy = 9999.9
	if nearest_enemy_node != null:
		vec_to_enemy = (nearest_enemy_node.position - position)
		distance_to_enemy = vec_to_enemy.length()
		
		sensor_enemy_is_dead.sensor_value = float(nearest_enemy_node.health <= 0.0)
	
	sensor_distance_to_closest_enemy.sensor_value = distance_to_enemy / 1000.0 
	
	var weapon_range = 0.0
	if weapon_id == 0: 
		# Pistol, 9 rounds per clip.
		sensor_my_ammo.sensor_value = ammo / 9.0
		weapon_range = 150.0
	elif weapon_id == 1:
		# SMG, 30 rounds per clip.
		sensor_my_ammo.sensor_value = ammo / 30.0
		weapon_range = 200.0
	else:
		# No weapon, no ammo.
		sensor_my_ammo.sensor_value = 0.0
	
	sensor_is_enemy_in_weaponsrange.sensor_value = float(distance_to_enemy <= weapon_range)
	
	var new_followers = []
	for follower in follower_nodes:
		if follower.health > 0:
			new_followers.push_back(follower)
	follower_nodes = new_followers
	
	sensor_do_i_have_followers.sensor_value = float(len(follower_nodes) > 0)
	
	# 2. Think
	# The think-step is very simple in terms of code: just 2 lines. 
	# Here the AI Agent uses the node structure of sensors, behaviours, 
	# considerations and actions to determine which behaviour it should
	# choose of all the alternatives. 
	#
	# Note that a lot of the logic is done by the behaviour, consideration
	# and action nodes, so examine them. For behaviours the order is important,
	# especially if you choose only the highest scoring action. The first one
	# with the highest score is then chosen. Also the Can Be Interrupted property
	# and cooldown settings can make a big difference to your results.  
	# For considerations the Curve that is set to them is important.
	# For condideration groups it is the evaluation method.
	# For action groups the execution rule.
	#
	# Once a behaviour has been chosen by calling the evaluate_options 
	# method, the update_current_behaviour method starts stepping through
	# the actions defined for the behaviour. 
	ai.evaluate_options(delta)
	ai.update_current_behaviour()
	
	# 3. Act
	# The exact implementation of the last step, act, depends on the actions
	# that have been defined for the behaviours. In this case I chose to just
	# use the action node name choose what to do with each action, but you can
	# also use the action_id property to do it, or even use the action nodes 
	# themselves for handling the action logic.
	# What is important, however, is that when the current action has been
	# completed, you have a set_is_finished(true) call for the current action. 
	# Once you've called this method, you've set the flag that the action has
	# how done everything it should and during the next update_current_behaviour()
	# call the AI agent will choose the next action that should be taken.
	
	var new_action = ai.get_current_action_node()
	if new_action != current_action and new_action != null:
		current_action = new_action
	
	if current_action == null:
		return 
	
	# This is where the logic for all the actions is defined.
	match current_action.get_name():
		"ChooseRandomLocation":
			play("default")
			move_target_position = Vector2(randf()*viewport_size.x, randf()*viewport_size.y)
			current_action.set_is_finished(true)
			weaponsound_label.text = ""
		
		"ChooseWeaponLocation":
			play("default")
			move_target_position = closest_weapon_location
			current_action.set_is_finished(true)
			weaponsound_label.text = ""
		
		"PickupWeapon":
			# The action will start the timer, and with this check we 
			# won't try and start the action again until it has finished.
			if !action_duration_timer.is_stopped():
				return
			play("attack")
			if nearest_weapon_node != null:
				if nearest_weapon_node.visible == true:
					weapon_id = nearest_weapon_node.weapon_id
					nearest_weapon_node.visible = false
					nearest_weapon_node.queue_free()
					nearest_weapon_node = null
					$CurrentWeaponSprite.visible = true
					if weapon_id == 0:
						$CurrentWeaponSprite.play("handgun")
						ammo = 9
					elif weapon_id == 1:
						$CurrentWeaponSprite.play("smg")
						ammo = 30
			action_duration_timer.start(1.0)
		
		"FireWeapon":
			if !action_duration_timer.is_stopped():
				return
			
			if nearest_enemy_node != null:
				if nearest_enemy_node.health <= 0.0:
					current_action.set_is_finished(true)
					return
			
			play("attack")
			if weapon_id == 0:
				weaponsound_label.text = "BANG!"
				ammo -= 1
			elif weapon_id == 1:
				weaponsound_label.text = "Ratata!"
				ammo -= 3
			if ammo < 0:
				ammo = 0
			action_duration_timer.start(0.5 + randf() * 0.5)
			
			# Give a 50% chance of hitting.
			if randf() < 0.5:
				if nearest_enemy_node != null:
					nearest_enemy_node.get_hit_by_a_shot( randf() * 10.0 )
		
		"ReloadWeapon":
			if !action_duration_timer.is_stopped():
				return
			play("attack")
			if weapon_id == 0:
				ammo = 9
			elif weapon_id == 1:
				ammo = 30
			action_duration_timer.start(3.0)
		
		"MoveToLocation":
			play("move")
			weaponsound_label.text = ""
			# Move towards move to target.
			var direction = (move_target_position - position)
			position += delta * 100.0 * direction.normalized()
			flip_h = (direction.x < 0.0) # Flip the sprite if needed
			if direction.length() < 8.0:
				current_action.set_is_finished(true)
		
		"MoveTowardsEnemy":
			if nearest_enemy_node == null:
				current_action.set_is_finished(true)
			play("move")
			weaponsound_label.text = ""
			# Move towards the enemy.
			var direction = (nearest_enemy_node.position - position)
			position += delta * 100.0 * direction.normalized()
			flip_h = (direction.x < 0.0) # Flip the sprite if needed
			if direction.length() < 0.8 * weapon_range:
				current_action.set_is_finished(true)
		
		"TakeDamage":
			if !action_duration_timer.is_stopped():
				return
			play("take_damage")
			action_duration_timer.start(2.0)
		
		"FindRandomLocation":
			move_target_position = Vector2(randf()*viewport_size.x, randf()*viewport_size.y)
			current_action.set_is_finished(true)
		
		"Flee":
			play("move")
			weaponsound_label.text = ""
			# Move towards move to target.
			var direction = (move_target_position - position)
			position += delta * 140.0 * direction.normalized()
			flip_h = (direction.x < 0.0) # Flip the sprite if needed
			if direction.length() < 8.0:
				current_action.set_is_finished(true)
		
		"OrderAttackMyTarget":
			if !action_duration_timer.is_stopped():
				return
			if nearest_friendly_node == null or nearest_enemy_node == null:
				current_action.set_is_finished(true)
			
			weaponsound_label.text = "ATTACK MY TARGET!"
			
			for follower in follower_nodes:
				follower.nearest_enemy_node = nearest_enemy_node
			
			action_duration_timer.start(4.0)
		
		"OrderRetreat":
			if is_leader == false:
				current_action.set_is_finished(true) 
			if !action_duration_timer.is_stopped():
				return
			
			for follower in follower_nodes:
				follower.is_leader_forced_retreat = true
			weaponsound_label.text = "RETREAT!!!"
			action_duration_timer.start(4.0)
		
		"Die":
			if weaponsound_label.text != "Died!":
				play("die")
				weaponsound_label.text = "Died!"
		
		_: # Default choice
			play("default")
			weaponsound_label.text = ""

# This is a helper method to allow leaders to get followers they
# can bark orders to.
func add_follower( new_follower ) -> void:
	follower_nodes.push_back(new_follower)
	new_follower.leader_node = self

# Handles hits for the target.
func get_hit_by_a_shot(damage:float) -> void:
	is_hit_this_frame = true 
	health -= damage 
	#if health <= 0.0:
	#	print("Died!")

# This helper is used to calculate distances between dudes and weapons.
func evaluate_distances(node_list:Array) -> void:
	var closest_weapon_distance = 9999.9
	var closest_enemy_distance = 9999.9
	var closest_friendly_distance = 9999.9
	for node in node_list:
		if node == self:
			continue 
		
		if node.has_method("evaluate_distances"):
			# A dude.
			if node.team_alignment == team_alignment:
				# Check if this is the closest friendly
				var vec = node.position - position
				var distance = vec.length() 
				if distance < closest_friendly_distance:
					closest_friendly_distance = distance
					nearest_friendly_node = node
				continue
			if node.health <= 0:
				continue 
			
			if leader_node != null:
				continue # Leader tells who to attack
			
			var vec = node.position - position
			var distance = vec.length() 
			if distance < closest_enemy_distance:
				closest_enemy_distance = distance
				nearest_enemy_node = node

		else:
			# A weapon.
			var vec = node.position - position
			var distance = vec.length() 
			if distance < closest_weapon_distance:
				closest_weapon_distance = distance
				closest_weapon_location = node.position


# These handle checks if the dude is over a weapon that
# has not yet been picked up.

func _on_area_2d_area_entered(area):
	# Some weapon is nearby.
	is_near_weapon = true
	nearest_weapon_node = area.owner


func _on_area_2d_area_exited(_area):
	is_near_weapon = false
	nearest_weapon_node = null

# This updates the label when a behaviour changes.
func _on_utility_ai_agent_behaviour_changed(behaviour_node):
	if behaviour_node != null:
		$BehaviourLabel.text = behaviour_node.get_name()
	else:
		$BehaviourLabel.text = ""

# You can also use the on_action_changed to handle
# the actions. This signal is not connected in this
# example.
func _on_utility_ai_agent_action_changed(action_node):
	if action_node != null:
		print("Action is " + action_node.get_name())


# This is used for the timed actions. Once the timer runs out,
# the current action is set as finished (if there is one).
func _on_action_duration_timer_timeout():
	if current_action != null:
		current_action.set_is_finished(true)
	weaponsound_label.text = ""
	current_action = null
	


