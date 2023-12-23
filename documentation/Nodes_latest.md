# Utility AI GDExtension Nodes

This section describes the nodes, their properties and methods in detail. After each property and method you can find the version tag when the given property/method was introduced or last changed.

This document describes the version **1.5** of Utility AI GDExtension. 

Documentation of earlier versions: [1.4](Nodes_v1_4.md),[1.3](Nodes_v1_3.md), [1.2](Nodes_v1_2.md)


## The four node groups - Agent behaviours, Behaviour Tree, State Tree and the Node Query System

There are four main node groups in Utility AI GDExtension: Agent behaviours, Behaviour Tree, State Tree, and the Node Query System (NQS). All are utility-based systems for implementing robust AI systems to your games. 

The *Agent behaviours*, *State Tree* and *Utility enabled Behaviour Tree* focus on defining *behaviours* for AI agents. They answer the question "What is the best *behaviour* for the current situation?". Use these nodes when you want to choose what an AI should do. 

The *Node Query System* focuses on using utility functions to score and filter any type of Godot nodes. They answer the question "What is the *best node* for the job?". Use the NQS when you want to choose the best tile to move to, the biggest threat to attack, the best healing item to consume, for example.


# Agent Behaviours

## 


## Agent behaviour nodes

### UtilityAIAgent 

This is the main node that is used to manage the UtilityAI. A UtilityAIAgent node represents an AI entity that can reason based in `sensor` input and then choose `behaviours` to react to the sensor input.

#### Properties

|Type|Name|Description|Version|
|--|--|--|--|
|bool|is_active|This property can be used to include or exlude the node from processing.|v1.0|
|int|num_behaviours_to_select|Pick a behaviour out of top `num_behaviours_to_select` behaviours found after reasoning.|v1.0|
|float|thinking_delay_in_seconds|Delay time forced between calls to the method `evaluate_options`.|v1.0|
|String|top_scoring_behaviour_name|This property shows what was the top scoring behaviour after the latest `evaluate_options()` method call.|v1.0|
|string|current_behaviour_name|This property shows what was the selected behaviour after the latest `evaluate_options()` method call.|v1.0|
|int|total_evaluate_options_usec|This property shows how many microseconds (usec) the latest `evaluate_options()` method call required to complete.|v1.4|


#### Methods 

|Return value|Name|Description|Version|
|--|--|--|--|
|void|evaluate_options(float delta)|Gathers input from sensors and evaluates all the available behaviours by calculating a score for each of them and then choosing a random behaviour from the top `num_behaviours_to_select` behaviours.|v1.0|
|void|update_current_behaviour()|Updates the currently selected behaviour and if the current `action` has been marked as finished, returns the next action.|v1.0|
|void|abort_current_behaviour()|Immediately stops the currently selected behaviour and action. Used for stopping behaviours that have `Can Be Interrupted` property as `false`.|v1.0|

#### Signals

|Signal|Parameters|Description|Version|
|--|--|--|--|
|behaviour_changed|behaviour_node|Emitted when the behaviour changes during `evaluate_options` or after a behaviour has completed during the `update_current_behaviour` call.|v1.0|
|action_changed|action_node|Emitted when the current action changes during a `update_current_behaviour` call.|v1.0|


### UtilityAISensor and UtilityAISensorGroup

These two node types should be added as child nodes of the `UtilityAIAgent` node. They are used to give input data to `consideration` nodes. A `sensor` is used by one or more `consideration` nodes. A `sensor group` is a node that can be used to aggregate input from several sensors (or sensor groups) for a higher-level input to the consideration nodes. 

Why use sensors in the first place? Consider the situation where you have several behaviours that use the "IsPlayerClose" consideration and maybe different variations, such as "IsPlayerAboutMidDistanceFromMe" or what ever. With the sensor nodes you can calculate the distance once and set it to a sensor, and then all the various considerations can make use of the distance in a relatively easy way and the distance only needs to be calculated once.

#### Properties

The `UtilityAISensor` has the following properties:

|Type|Name|Description|Version|
|--|--|--|--|
|bool|is_active|This property can be used to include or exlude the node from processing. Note that even a deactivated sensor can be used as valid input for the Considerations.|v1.0|
|float|sensor_value|A floating point value in the range of 0..1.|v1.0|

The `UtilityAISensorGroup` has the following properties:

|Type|Name|Description|Version|
|--|--|--|--|
|bool|is_active|This property can be used to include or exlude the node from processing. Note that even a deactivated sensor can be used as valid input for the Considerations.|v1.0|
|float|sensor_value|A floating point value in the range of 0..1.|v1.0|
|float|evaluation_method|A choice of how the sensors and sensor groups that are childs of the node are aggregated. Can be one of the following: Sum:0,Min:1,Max:2,Mean:3,Multiply:4,FirstNonZero:5.|v1.1|
|bool|invert_sensor_value|This inverts the group sensor_value by calculating: sensor_value = 1.0 - sensor_value. It is applied after all the child nodes have been evaluated.|v1.1| 


#### Methods 

None.

### Specialized Sensors 

There are also a number of specialized sensors that make it more convinient to use the sensors with certain common input types. They automatically convert the specialized input value to a sensor value in the 0..1 range.

#### UtilityAIBooleanSensor
This sensor accepts a boolean value and scales it to 0..1 range.

##### Properties

|Type|Name|Description|Version|
|--|--|--|--|
|bool|is_active|This property can be used to include or exlude the node from processing.|v1.0|
|float|sensor_value|A floating point value in the range of 0..1.|v1.0|
|bool|boolean_value|Input value for the sensor.|v1.2|


##### Methods 

None

#### UtilityAIAngleVector2Sensor and UtilityAIAngleVector3Sensor
This sensor accepts two vectors, calculates the angle between them and scales it to 0..1 range.

##### Properties

|Type|Name|Description|Version|
|--|--|--|--|
|bool|is_active|This property can be used to include or exlude the node from processing.|v1.0|
|float|sensor_value|A floating point value in the range of 0..1.|v1.0|
|Vector2/3|from_vector|Input value for the sensor. Base value for the angle calculation, for example the direction of an AI entity.|v1.2|
|Vector2/3|to_vector|Input value for the sensor. The other vector to compare from-vector to, for example direction to closest enemy entity.|v1.2|
|float|max_angle_radian|The maximum value for the angle between from and to in radians, this corresponds to 1.0 for the sensor_value. Updates the euler angle automatically.|v1.2|
|float|max_angle_euler|The maximum value for the angle between from and to in eulers, this corresponds to 1.0 for the sensor_value. Updates the radian angle automatically.|v1.2|
|float|min_angle_radian|Only for Vector2 - The minimum value for the angle between from and to in radians, this corresponds to 0.0 for the sensor_value. Updates the euler angle automatically.|v1.2|
|float|min_angle_euler|Only for Vector2 - The minimum value for the angle between from and to in eulers, this corresponds to 0.0 for the sensor_value. Updates the radian angle automatically.|v1.2|

##### Methods 

None

#### UtilityAIFloatRangeSensor and UtilityAIIntRangeSensor
This sensor accepts a minimum and maximum value that defines a value range. The input value given is scaled to 0..1 range within the given min and max values.

##### Properties

|Type|Name|Description|Version|
|--|--|--|--|
|bool|is_active|This property can be used to include or exlude the node from processing.|v1.0|
|float|sensor_value|A floating point value in the range of 0..1.|v1.0|
|float/int|range_value|Input value for the sensor.|v1.2|
|float/int|range_min_value|The minimum value for the range.|v1.2|
|float/int|range_max_value|The maximum value for the range.|v1.2|


##### Methods 

None


#### UtilityAIDistanceVector2Sensor and UtilityAIDistanceVector3Sensor
As the name suggests, these are distance sensors. Uses the squared distance when scaling the values to 0..1 range.

##### Properties

|Type|Name|Description|Version|
|--|--|--|--|
|bool|is_active|This property can be used to include or exlude the node from processing.|v1.0|
|float|sensor_value|A floating point value in the range of 0..1.|v1.0|
|Vector2/3|from_vector|The start point of the distance vector.|v1.2|
|Vector2/3|to_vector|The end point of the distance vector.|v1.2|
|Vector2/3|from_to_vector|Vector obtained by calculating to_vector - from_vector.|v1.2|
|Vector2/3|direction_vector|Optionally calculated direction vector.|v1.2|
|float|distance|Optionally calculated non-squared distance.|v1.2|
|float|distance_squared|Squared distance.|v1.2|
|bool|is_distance_calculated|If true, the non-squared distance is calculated.|v1.2|
|bool|is_direction_vector_calculated|Optionally calculated direction vector.|v1.2|


##### Methods 

None

#### UtilityAIArea2DVisibilitySensor and UtilityAIArea3DVisibilitySensor
This sensor is used for visibility queries based on Area3D's. It returns the number of entities seen by the AI Agent and the sensor value is scaled to 0..1 by comparing the number of seen entities to a defined, expected, maximum number. 

The sensor will store a list of the found Area3D's that are within the defined visibility volume and a separate list with only those that are not occluded by other geometry. 

##### Properties

|Type|Name|Description|Version|
|--|--|--|--|
|bool|is_active|This property can be used to include or exlude the node from processing.|v1.0|
|float|sensor_value|A floating point value in the range of 0..1.|v1.0|
|Vector2/3|from_vector|Input value for the sensor. The location of the AI entity's eyes in global coordinates (global_position).|v1.2|
|NodePath|visibility_volume|An Area2D/Area3D node defining the visibility volume for the sensor.|v1.2|
|uint32_t|collision_mask|The collision mask used for occlusion. Usually this is set to match the layers for your level geometry and props.|v1.2|
|int|max_expected_entities_found|The maximum number of entities expected to be found using the visibility volume. Scales the sensor value.|v1.2|
|int|num_entities_found|Number of entities found within the visibility volume. If `do_occlusion_test` is set to `true`, this will be the number of unoccluded entities within the `visibility_volume`.|v1.2|
|TypedArray<Area2/3D>|intersecting_areas|Areas that are within or intersect with the `visibility_volume`.|v1.2|
|TypedArray<float>|squared_distances_to_intersecting_areas|Squared distances from the `from_vector` to an area's `global_position` within or intersecting with the visibility_volume.|v1.2|
|int|closest_intersecting_area_index|Index of the closest area to `from_vector` within the `intersecting_areas` array.|v1.2|
|TypedArray<Area2/3D>|unoccluded_areas|Populated if `do_occlusion_test` is set to `true`. Areas that are within or intersect with the `visibility_volume` and that are not blocked by any geometry that is set to the layer(s) defined in `collision_mask`.|v1.2|
|TypedArray<float>|squared_distances_to_unoccluded_areas|Squared distances from the `from_vector` to an area's `global_position` within or intersecting with the `visibility_volume` and that are not blocked by any geometry that is set to the layer(s) defined in `collision_mask`.|v1.2|
|int|closest_unoccluded_area_index|Index of the closest area to `from_vector` within the `unoccluded_areas` array.|v1.2|
|TypedArray<RID>|occlusion_test_exclusion_list|Used during occlusion testing to exclude listed nodes from the raycast collision test.|v1.2|
|bool|use_owner_global_position|If set, the `owner` node's global position is used. IMPORTANT! The scene root node must in that case be a node that has the global_position property.|v1.3|



##### Methods 

None


### UtilityAIBehaviour

This node type should be added as child node of the `UtilityAIAgent` node or the `UtilityAIBehaviourGroup`, preferably after any `sensor` and `sensor group` nodes. There can be several behaviour nodes as childs of the `UtilityAIAgent` or the `UtilityAIBehaviourGroup` node.

As you may have guessed from the name, the purpose of the behaviour nodes is to define what the `AI agent` will do based on different inputs given using the `sensor` nodes. To accomplish this each behaviour node must have one or more `consideration` or `consideration group` nodes as its childs, and also one or more `action` or `action group` nodes. 

The behaviour node will use the  `consideration` nodes that are its childs to determine a `score` for itself. Basically it just sums up the scores from the considerations. When the behaviour is chosen by the `AI agent` as the one to execute, the `action` nodes are stepped through.

The behaviour has also two "cooldown" properties: `cooldown_seconds` and `cooldown_turns`. These can be used to temporarily exclude some behaviours from subsequent `AI agent`'s `evaluate_options` calls once they have been chosen. The `cooldown_seconds` is meant to be used with real-time games and the `cooldown_turns` with turn based games but both can be used even at the same time. The difference in the cooldown countdown is that the `cooldown_seconds` counts down regardless of how many times the `AI agent`'s `evaluate_options` method is called, and the `cooldown_turns` counts down only when the `evaluate_options` method is called. 

#### Properties

The `UtilityAIBehaviour` has the following properties:

|Type|Name|Description|Version|
|--|--|--|--|
|bool|is_active|This property can be used to include or exlude the node from processing.|v1.0|
|bool|can_be_interrupted|A boolean value to determine if the behaviour can be interrupted or not. If a behaviour cannot be interrupted, the `evaluate_options` method of the `UtilityAIAgent` will not execute until the behaviour has completed all its actions.|v1.0|
|float|score|The score for the behaviour after the behaviour has evaluated its considerations.|v1.0|
|float|cooldown_seconds|If > 0.0, after the behaviour is chosen it will a score of 0.0 during the `evaluate_options` until the time has passed.|v1.0|
|int|cooldown_turns|If > 0, after the behaviour is chosen it will a score of 0 during the `evaluate_options` until the given number of calls to the evaluation function has been done.|v1.0|


#### Methods 

None.

### UtilityAIBehaviourGroup

The `UtilityAIBehaviourGroup` node type should be added as child node of the `UtilityAIAgent` node, preferably after any `sensor` and `sensor group` nodes. There can only be one level of child nodes, which means you cannot have nested Behaviour Group nodes.

The purpose of the behaviour group nodes is to allow logical grouping if behaviours and also to allow group-based activation and deactivation of Behaviour nodes.

The behaviour group node will use the  `consideration` nodes that are its childs to determine a `score` for itself. If this `score` is greater or equal to the set `activation score` or if there are no considerations added to the behaviour group, the child behaviours will be evaluated during the AI Agent's `evaluate_options` call. 


#### Properties

The `UtilityAIBehaviourGroup` has the following properties:

|Type|Name|Description|Version|
|--|--|--|--|
|bool|is_active|This property can be used to include or exlude the node from processing.|v1.0|
|float|score|The score for the behaviour group after the considerations that are its child nodes have been evaluated. If no consideration nodes have been added as the childs of the Behaviour Group, the score will be 0.0 but the child behaviours of the Behaviour Group will still be evaluated.|v1.0|
|float|activation_score|The score must be greater or equal to the activation score for the behaviour group to allow for evaluation of the behaviour nodes that are its children.|v1.0|


#### Methods 

None.


### UtilityAIConsideration and UtilityAIConsiderationGroup

These two node types should be added as child nodes of the `UtilityAIBehaviour` node. They are used when a `behaviour` is being scored by the `AI agent`. 

Each consideration node can contain an `activation curve` that can be defined in the node properties. If no curve has been set, the consideration nodes input value will be used as the consideration result as-is.

If a `sensor` or a `sensor group` is used as the input value for a consideration the input for the consideration will be the `sensor_value` property of the sensor node. Otherwise the value of the consideration's `activation_input_value` property will be used.

Consideration groups can be used to aggregate the input from several considerations or consideration groups to create more complex consideration logic. 

A custom evaluation method can be defined for the `UtilityAIConsideration` node by extending the node with a script and defining a method named `eval`: 

```gdscript
func eval() -> void:
    # Your code here. 
    score = 0.0
```

In your custom `eval` method you should set the `score` property to a value between 0 and 1. You can sample the `activation_curve` using the method `sample_activation_curve(double input_value)`. Also, you can set the `has_vetoed` property by using your custom function. If `has_vetoed` property is true, it causes the Behaviour to receive a score of 0.0 and the behaviour immediately ends evaluating other considerations. Note that the `has_vetoed` property will not be reset back to false automatically, so if you set it to true in your custom evaluation method, you will also need to set it to false when you want the veto-state to end.

If you need to override the `_ready()` method for your custom consideration, you need to add the `initialize_consideration()` method call to your `_ready()` method:
```gdscript
func _ready():
    initialize_consideration()
    # Your code here. 
    
```

#### Properties

The `UtilityAIConsideration` has the following properties:

|Type|Name|Description|Version|
|--|--|--|--|
|bool|is_active|This property can be used to include or exlude the node from processing.|v1.0|
|float|activation_input_value|A floating point value in the range of 0..1.|v1.0|
|NodePath|input_sensor_node_path|A nodepath to a sensor or a sensor group node that will set the `activation_input_value`.|v1.0|
|Curve|activation_curve|A godot curve property that defines how the `activation_input_value` will be translated to a `score`.|v1.0|
|float|score|The resulting score for the consideration after evaluation.|v1.0|
|bool|has_vetoed|If this is set to `true`, the consideration forces the score to be 0.0 and ends the evaluation immediately.|v1.0|

The `UtilityAIConsiderationGroup` has the following properties:

|Type|Name|Description|Version|
|--|--|--|--|
|int|evaluation_method|A choice of how the considerations and consideration groups that are childs of the node are aggregated. Can be one of the following: Sum:0,Min:1,Max:2,Mean:3,Multiply:4,FirstNonZero:5.|v1.1|
|float|score|The resulting score for the consideration group after evaluation.|v1.0|
|bool|has_vetoed|If this is set to `true`, the consideration group forces the score to be 0.0 and ends the evaluation immediately. The consideration group can receive this value from any of the considerations that are its childs.|v1.0|
|bool|invert_score|This inverts the group score by calculating: score = 1.0 - score. It is applied after all the child nodes have been evaluated.|v1.1| 


#### Methods 

The `UtilityAIConsideration` has the following methods:

|Type|Name|Description|Version|
|--|--|--|--|
|void|initialize_consideration()|If you override the _ready() method, you have to call initialize_consideration() in your _ready() method.|v1.1|
|double|sample_activation_curve(double input_value)|Use the input_value to get the resulting Y-value for the `activation_curve`. If no valid curve is set, this method will return 0.0.|v1.1|

### UtilityAIAction and UtilityAIActionGroup

These two node types should be added as child nodes of the `UtilityAIBehaviour` node. They are used when a `behaviour` is being executed by the `AI agent`. 

Action groups can be used create sequences of actions, or to pick one random action from several choices. This allows for more complex actions to be performed by a behaviour.

*NOTE!* When the `AI agent` has chosen a behaviour, the action step function is called to find the first action to execute. The action that is being executed must be set as finished for the `AI agent` step function to be able to go to the next action. The action logic itself can be implemented anywhere else.

#### Properties

The `UtilityAIAction` has the following properties:

|Type|Name|Description|Version|
|--|--|--|--|
|bool|is_active|This property can be used to include or exlude the node from processing.|v1.0|
|int|action_id|A user-definable numeric ID for the action. Provided as an alternative to using action node names for identifying which is the current action the `AI agent` is currently executing.|v1.0|
|bool|is_finished|Use this property only to let the `AI agent` know when the chosen action is finished. The stepper function will immediately set it back to false once it has moved on to the next action.|v1.0|
|bool|has_failed|Use this property only to let the `AI agent` know when the chosen action has failed. You will also need to set the is_finished property! The stepper function will immediately set it back to false once it has handled the failed event.|v1.3|


The `UtilityAIActionGroup` has the following properties:

|Type|Name|Description|Version|
|--|--|--|--|
|bool|is_finished|Set internally by the stepper, visible only for debugging purposes.|v1.0|
|bool|has_failed|Use this property only to let the `AI agent` know when the chosen action has failed. You will also need to set the is_finished property! The stepper function will immediately set it back to false once it has handled the failed event.|v1.3|
|int|execution_rule|A choice of how the actions that are child nodes are executed: Sequence:0,PickOneAtRandom:1,IfElse:2,CustomRule:3. The Sequence choice will execute the actions from top to bottom, the Pick One At Random does what it says it will, the IfElse rule uses the `if_else_boolean_value` property to decide if the first or the second child node of the `UtilityAIActionGroup` will be chosen. Finally, the CustomRule choice allows you to write your own `eval` method that is responsible for setting the `current_action_index` property to choose what action should be executed.|v1.2|
|int|error_handling_rule|A choice of how the `has_failed` property of the child nodes is handled: EndExecution:0,ContinueExecution:1.|v1.2|
|int|current_action_index|Exposed for the use with a custom `eval` method to choose a child action/action group node to execute.|v1.2|

#### Methods 

None.

# Utility enabled Behaviour Tree

**Behaviour Trees** are a commonly used structure that can be used to create artificial intelligence in games for the non-playable characters. A behaviour tree has a *root node* and under it a tree structure, where the branches of the tree define the behaviour for the AI.

The **utility enabled Behaviour Trees** in Utility AI GDExtension extend the traditional Behaviour Tree with utility functions. The Behaviour Tree nodes *can* be used as a regular behaviour tree, but the extended utility features allow you to add utility-based branch selection and execution of the *Node Query System* queries within your trees. 

As an example, in a traditional behaviour tree the prioritization of branches under a Selector is usually done by setting the order of the child nodes so that the highest priority node is first and the priority of the following nodes is less than the ones before them. While this works for many situations, there are times when more flexible and situation-aware criteria for branch selection is needed. 

Consider a situation you may bump in to a game like Fortnite. One of your teammates has been downed and the other team is pinning you down with active fire. You've lost some health and are soon out of ammo. You have many choices in this situation, for instance: revive your teammate, attack the opposing team, heal yourself, pickup your team mate and carry them to safety, find ammo, use some item in your inventory, etc. What you pick depends on things like how far away the opposing team are, how many of them are still fighting, how much health you have, what items you have in your inventory, what kind of gear you have, and the list goes on. 

For traditional behaviour trees the prioritization of the various choices would be static and encoded in the tree using various conditions and branches. With Utility enabled behaviour tree, the various choices can be scored by the afore mentioned metrics and the choice made more flexibly based on the situation at hand.




## Utility enabled Behaviour Tree nodes

### Shared properties

All the Behaviour Tree nodes have the following shared properties.

|Type|Name|Description|Version|
|--|--|--|--|
|bool|is_active|This property can be used to include or exlude the node from processing.|v1.4|
|int|evaluation_method|Used with Utility-based Behaviour Tree nodes. This defines how the `UtilityAIConsideration` nodes (assigned as child nodes of the behaviour tree node) are evaluated to calculate the score for the node.|v1.4|
|int|reset_rule|Defines how the Behaviour Tree node is reset. The following choices are possible: "WhenTicked:0,WhenCompleted:1,WhenTickedAfterBeingCompleted:2,Never:3".|v1.4|
|float|score|The score this node received from the Utility-based evaluation.|v1.4|
|int|tick_result|Result after the tick. The following choices are possible: "Running:0,Success:1,Failure:-1,Skip:-2".|v1.4|
|int|internal status|The current internal status of the node, useful for debugging and seeing how the execution progresses. The following choices are possible: "Unticked:0,Ticked:1,Completed:2".|v1.4|

#### Shared methods 

All the Behaviour Tree nodes have the following shared methods:

|Type|Name|Description|Version|
|--|--|--|--|
|void|_tick(Variant user_data, float delta)|This is the internal behaviour tree tick-method. You can provide any Godot variant type as a parameter (usually a node used as an actor or a dictionary used as a blackboard), along with a delta-time. These parameters are passed to all the child nodes of the behaviour tree during ticks. This method starts with an underscore as you usually don't need to call it.|v1.4|


### UtilityAIBTRoot

This is the main node for the Utility AI Behaviour Tree nodes. The root node is ticked to update the state of the behaviour tree.

#### Properties

The `UtilityAIBTRoot` has the following properties:

|Type|Name|Description|Version|
|--|--|--|--|
|bool|is_active|This property can be used to include or exlude the node from processing.|v1.4|
|int|total_tick_usec|This is the total time in microseconds the call to the `tick()` method used.|v1.4|


#### Methods 

The `UtilityAIBTRoot` has the following methods:

|Type|Name|Description|Version|
|--|--|--|--|
|void|tick(Variant user_data, float delta)|This is the behaviour tree tick-method you should be using to tick the tree. You can provide any Godot variant type as a parameter (usually a node used as an actor or a dictionary used as a blackboard), along with a delta-time. These are passed to all the child nodes of the behaviour tree during ticks.|v1.4|

## Composite nodes

### UtilityAIBTSequence and UtilityAIBTRandomSequence

These two node types are used to create sequences. 

The UtilityAIBTSequence node executes its child nodes from top-to-bottom order until either all of the succeed (returning 1) or one of them fails (returning -1). If a child returns running (0) the sequence will return running to its parent.

The UtilityAIBTRandomSequence works similarly, it just shuffles the nodes into a random order before ticking them.
 

### UtilityAIBTSelector and UtilityAIBTRandomSelector

These two node types are used to create fallbacks. 

The UtilityAIBTSelector node executes its child nodes from top-to-bottom order until one of them succeeds (returning 1) or all of them fail (returning -1). If a child returns running (0) the selector will return running to its parent.

The UtilityAIBTRandomSelector works similarly, it just shuffles the nodes into a random order before ticking them.


### UtilityAIBTParallel

The parallel node ticks all its child nodes. If any of the nodes returns failure (-1) or running (0), the parallel node returns it back to its parent. If the child nodes return both failure and running statuses, the running status is returned to the parent node.


### UtilityAIBTScoreBasedPicker

The score based picker node evaluates its direct child nodes and calculates a score for each of them based on `UtilityAIConsideration` and `UtilityAIConsiderationGroup` nodes that are set as the childs of them. The direct child node with the highest score is chosen and then ticked.


## Decorator nodes

### UtilityAIBTCooldownMsec, UtilityAICooldownUsec and UtilityAICooldownTicks

The cooldown nodes can be used to set a branch of the behaviour tree into a cooldown after it has been ticked. The types are cooldown in milliseconds (msec), cooldown in microseconds (usec) and cooldown for a given number of ticks. All of them work similarly: when the cooldown node is ticked, it ticks its child node, starts the cooldown and returns what ever the child node returned. It will return the set `cooldown_return_value` until the cooldown expires. 
 

#### Properties

|Type|Name|Description|Version|
|--|--|--|--|
|int|cooldown_msec/usec/tics|The cooldown period after the cooldown node is ticked.|v1.4|
|int|cooldown_return_value|The result that is returned during cooldown. Can be either -1=Failure, 0=Running or 1=Success.|v1.4|


### UtilityAIBTFixedResult

The fixed result node ticks the first behaviour tree child node it has and regardless of what the child returns, the fixed result node returns what ever value you have set as its `fixed_result` property back to its parent. This node can also be used as a leaf-node.
 

#### Properties

|Type|Name|Description|Version|
|--|--|--|--|
|int|fixed_result|The result that should always be returned. Can be either -1=Failure, 0=Running or 1=Success.|v1.4|

### UtilityAIBTInverter

The inverter node ticks the first behaviour tree child node it has and returns back to its parent the result of the child node, inverted. So success becomes failure, a failure a success. If Running is returned, the inverter returns running back to its parent.


### UtilityAIBTLimiter

The limiter node ticks its child for `max_repeat_times` and then returns -1 (failure) until the node is reset.
 

#### Properties

|Type|Name|Description|Version|
|--|--|--|--|
|int|max_repeat_times|The maximum times the limiter node can be ticked.|v1.4|


### UtilityAIBTPassThrough

The passthrough node calls the user-defined tick-method and then calls the tick-method of its child node, returning what ever the child node tick result is. If no child node has been defined, it returns what ever you choose for the tick-result.

You can use this node to do preparations for a behaviour tree branch, for instance calculate some angles or distances that all the nodes within a branch will be using and putting them to user_data.


### UtilityAIBTRepeatUntil

The RepeatUntil node ticks its child either until the `expected_tick_result` is returned by its child or `max_repeat_times`. If `max_repeat_times` is set to -1, only the `expected_tick_result` will end the loop.


#### Properties

|Type|Name|Description|Version|
|--|--|--|--|
|int|max_repeat_times|The maximum times the limiter node can be ticked.|v1.4|
|int|expected_tick_result|The result that the child node should return to end the loop. Can be either -1=Failure, 0=Running or 1=Success.|v1.4|


### UtilityAIBTRepeater

The Repeater node ticks its child until `max_repeat_times` is reached. If `max_repeat_times` is set to -1 the child will be ticked indefinitely.


#### Properties

|Type|Name|Description|Version|
|--|--|--|--|
|int|max_repeat_times|The maximum times the limiter node can be ticked.|v1.4|


## Task nodes


### UtilityAIBTLeaf

The leaf node is used for conditions and actions. You should define your own `tick()` method where you do your logic. 

You can either return the tick result or set the `tick_result` property. Examples:

```gdscript

func tick(blackboard, delta) -> int:
    return 1

```


```gdscript

func tick(blackboard, delta):
    tick_result = 1

```


### UtilityAIBTNodeReference

The node reference node can be used to reference any behaviour tree node type anywhere in your scene. This gives a lot of flexibility when designing your AI behaviours.

For instance, you can have an AI agent that has a node reference in its behaviour tree for any items it picks up. Each item can then contain a sub behaviour tree that describes how the item can be used by the AI. When the AI picks up an item, the node reference is set to point to the sub-tree within the item node, and immediately the AI agent can use the item. 
 

#### Properties

|Type|Name|Description|Version|
|--|--|--|--|
|NodePath|node_reference_nodepath|A nodepath to a behaviour tree node.|v1.4|



### UtilityAIBTPassBy

The PassBy node can be used to run a user-defined `tick()` method without returning any result value. The purpose of this node is to allow running any additional logic during a `tick()` without affecting the flow of the Behaviour Tree. In essence, the functionality is similar to the PassThrough node, but this node can be placed within a sequence, for example.


### UtilityAIBTRunNQSQuery

The Run NQS Query node can be used to initialite Node Query System queries. They return running until the query has completed.
 

#### Properties

|Type|Name|Description|Version|
|--|--|--|--|
|NodePath|nqs_search_space_nodepath|A nodepath to a NQS Search Space node.|v1.4|
|int|top_n_to_find|The number of results the search should return. Overrides the setting on the search space.|v1.4|

## The State Tree

The Utility AI State Tree is just two nodes: `UtilityAISTRoot` and `UtilityAISTNode`. Together they enable you to create hierarchical state machines with a similar node structure and state selection to a Behaviour Tree. The Utility AI State Tree nodes are utility-enabled, which means that if desired, the node selection for a state can be done by using UtilityAIConsideration nodes or resources. Alternatively a `on_enter_condition()` method can be defined for the State Tree nodes for the selection.

A StateTree is a state management structure that is a hybrid of a behaviour tree and a hierarchical state machine. When the tree is *ticked* for the first time, a set of active states is selected by evaluating the child nodes of the root node, and the childs of the child nodes, until a *leaf node* is found that can be activated. All the State Tree nodes from the root node all the way down to the leaf node are then considered as "active". On subsequent calls to the root node `tick()` method, all the active nodes are ticked in top-to-down order from the root to the leaf node. This allows you to create a hierarchy of states with shared logic on the top-level nodes and more specific logic on the leaf nodes. 

User-defined methods `on_enter_condition(user_data, delta) -> bool`, `on_enter_state(user_data, delta)`, `on_exit_state(user_data, delta)` and `on_tick(user_data, delta)` can be defined to create your custom state activation and handling logic.

The states are changed by calling the `transition_to()` method and by providing a *NodePath* to a child node of the State Tree root node as a target state. The child nodes of the target node are evaluated, all the way down the tree, until a leaf State Tree node is activated. If no active leaf node is found, the state transition fails and the State Tree remains in the existing state.

> [!NOTE]
> When a scene with a State Tree is first run, during the first call to the `tick()` method the State Tree will automatically transition to the root node to find the initial set of active states. 

When the state changes, the `on_exit_state()` method is called for existing state nodes that are not included in the new state. Similarly, for new state nodes that were not included in the existing state, the `on_enter_state()` method is called. 

During a tick, the `on_tick()` method is called for all the active states.

You construct a State Tree by first adding a `UtilityAISTRoot` node to your scene. Under the root node you add `UtilityAISTNode`s, and you can keep adding further `UtilityAISTNode`s until you have the state structure you need. 



### Shared properties for all the State Tree nodes

All the State Tree nodes have the following shared properties:

|Type|Name|Description|Version|
|--|--|--|--|
|int|child_state_selection_rule|Defines how the child state is chosen. Can be one of the following: "OnEnterConditionMethod:0,UtilityScoring:1", where "OnEnterConditionMethod" means that the user-defined `on_enter_condition()` method is called and if it returns true, the state is selected. "UtilityScoring" option uses the considerations set in the properties of the state and/or as child nodes. The highest-scoring state will be chosen.|v1.5|
|int|evaluation_method|Defines how the considerations are aggregated. Can be one of the following: "Sum:0,Min:1,Max:2,Mean:3,Multiply:4,FirstNonZero:5".|v1.5|
|Array<UtilityAIConsiderationResources>|considerations|Considerations set as a property of the state. These are used if the "UtilityScoring" option is selected for the `child_state_selection_rule`.|v1.5|


#### Shared methods for all the State Tree nodes

All the State Tree nodes have the following shared methods:

|Type|Name|Description|Version|
|--|--|--|--|
|void|transition_to(NodePath new_state_nodepath, Variant user_data, float delta)|This method is used to transition between states in the Stae Tree. You must provide the NodePath (relative to the State Tree root node) for the target state and you can provide any Godot variant type as a parameter (usually a node used as an actor or a dictionary used as a blackboard), along with a delta-time. User_data and delta are passed to the `on_enter_condition()`-method when selecting the active states.|v1.5|


### UtilityAISTRoot

This is the root node for a State Tree. To update the tree, you call the `tick()`-method of its root node. This will tick all the child nodes.

#### Properties

|Type|Name|Description|Version|
|--|--|--|--|
|int|total_tick_usec|The time to complete a tick in usec.|v1.5|

#### Methods

|Type|Name|Description|Version|
|--|--|--|--|
|void|tick(Variant user_data, float delta)|The `tick()`-method is used to update the State Tree state. You can provide any Godot variant type as a parameter (usually a node used as an actor or a dictionary used as a blackboard), along with a delta-time. User_data and delta are passed to the `on_enter_state()`, `on_exit_state()`, `on_tick()` and `on_enter_condition()` methods of the child nodes.|v1.5|


## The Node Query System (NQS)

The Utility AI Node Query System is a set of nodes that can be used to score and filter any set of Godot nodes to find the top N best nodes given a set of search criteria. The two main node types for the Node Query System are `UtilityAINQSSearchSpaces` and `UtilityAINQSSearchCriteria`. The *Search Spaces* nodes define a set of nodes as a "search space". The `execute_query()` method of the Search Space is used to apply the child *Search Criteria* nodes to filter and score the nodes within the "search space". Similarly to Considerations an *activation curve* can be set to further customize the scoring of each criteria to fit the needs of your game.

The Node Query System has been designed to be as flexible as possible and to allow **any** node property to be used as a scoring or filtering criterion. This allows the use of the system for spatial reasoning ("what is the best cover point/tile to move to?"), but also any other type of quantitative reasoning or ranking a game could need for the AI ("what is the best inventory item to use?, "who is the biggest threat?"). 

### NodeQuerySystem-singleton

A singleton has been added that allows *time budgeting* for the NQS queries. See the included example project for an example of how to use the singleton.

The NodeQuerySystem-singleton has the following properties:

|Type|Name|Description|Version|
|--|--|--|--|
|int|run_queries_time_budget_per_frame|This is the time the `run_queries()` method is allowed to run per frame.|v1.4|
|float|time_allocation_pct_to_high_priority_queries|Value between 0..1, determines how much of the `run_queries_time_budget_per_frame` is used for high-priority queries.|v1.4|


And the following methods:

|Type|Name|Description|Version|
|--|--|--|--|
|void|post_query(Node search_space, bool is_high_priority)|This adds the given search space to the list of queries to be executed when the method `run_queries()` is called.|v1.4|
|void|run_queries()|Runs the posted queries. Call this once per frame in your main scene.|v1.4|
|void|clear_queries()|Empties the list of queries to run per frame. Call this when you need to clean up, i.e. in the `_ready()` and `_exit_tree()` methods.|v1.4|
|void|initialize_performance_counters()|Initializes the counters that can then be seen in the Debug/Monitors tab in the editor.|v1.4|

### UtilityAISearchSpaces nodes 

The search space nodes are used to define the set of nodes that will be included in the search. The following nodes have been implemented:

**General search spaces**

 * UtilityAINodeGroupSearchSpace
 * UtilityAINodeChildrenSearchSpace

**2D search spaces** 

* UtilityAIArea2DSearchSpace

**3D search spaces** 

* UtilityAIArea3DSearchSpace


The search space nodes need to have the `UtilityAISearchCriteria` nodes as their children. For performance, when adding the search criteria add the **filtering** criteria first if possible to reduce the number of nodes as early as possible. After those, add the score-based criteria to filter and rank the remaining nodes. 

When the query finishes, the search spaces emit the `query_completed`-signal.
The search spaces fill in a TypedArray `_query_results` and a PackedFloat64Array `_query_result_scores`. These are sorted by the score in a descending order. This means that the first node in the `_query_results` array is also the one with the highest score.

The `execute_query()` method average runtime and other metrics (see below) are available for debugging and finetuning your queries. 

Each search space can be run by itself, by calling its `execute_query()` method until it returns true (completed), or by using the `NodeQuerySystem`-singleton. If the singleton is used, you should not use the `execute_query()` method at all, but simply post the query using `NodeQuerySystem.post_query()`-method instead.
 

#### Shared properties

All the search spaces have the following general properties.

|Type|Name|Description|Version|
|--|--|--|--|
|bool|is_active|This property can be used to include or exlude the node from processing.|v1.3|
|int|top_n_to_find|The number of nodes to return (at maximum)|v1.3|
|TypedArray<Node>|_query_results|The resulting array of nodes, sorted in descending order based on the score.|v1.3|
|PackedFloat64Array|_query_result_scores|The resulting array of node scores.|v1.3|
|int|average_call_runtime_usec|Used for debugging and tuning, the average time a single call to `execute_query()` method takes.|v1.4|
|int|total_query_runtime_usec|The total time to complete the query. Note that this calculates the time from starting the query to finishing it, which means that for queries that take several frames this includes processing time used **outside** of the `execute_query()` method (i.e. *all* your other code you run per frame).|v1.4|
|int|completed_signal_time_usec|The time it takes to handle the `query_completed` signal (i.e. your result handling code).|v1.4|
|int|search_space_fetch_time_usec|The time it takes to fetch all the nodes that will be filtered and scored in the query.|v1.4|
|int|total_query_node_visits|The total number of node visits done when running the query.|v1.4|
|int|total_query_call_count|The number of times the `execute_query()` method was called to finish the query.|v1.4|


#### Shared methods

|Type|Name|Description|Version|
|--|--|--|--|
|void|initialize_search_space()|If you override the `_ready()` method, you have to call `initialize_search_space()` in your overridden _ready() method.|v1.3|
|bool|execute_query(int time_budget_usec)|The `execute_query()` method fetches the search space nodes based on its configuration and then applies the search criteria in top-down order. A time budget can be set to limit the time the method uses for the query. Returns false if the query hasn't finished (time has run out) and true otherwise.|v1.4|
|void|start_query()|The `start_query()` method prepares the search space for a query, but does not yet apply any criteria.|v1.4|


#### Shared signals

|Signal|Parameters|Description|Version|
|--|--|--|--|
|query_completed|search_space|Emitted when the query execution is completed.|v1.4|



### UtilityAINodeGroupSearchSpace

This node uses the node grouping property of the Godot Engine to construct the search space. All the nodes in the given group are returned as the search space.

#### Properties

|Type|Name|Description|Version|
|--|--|--|--|
|StringName|group_name|The group name to use in the search.|v1.3|


#### Methods 

None.


### UtilityAINodeChildrenSearchSpace

This node uses the children of a node to construct the search space. The direct children of the given node are returned as the search space.

#### Properties

|Type|Name|Description|Version|
|--|--|--|--|
|NodePath|parent_node|The parent node to use in the search.|v1.3|


#### Methods 

None.


### UtilityAIArea2DSearchSpace and UtilityAIArea3DSearchSpace

These nodes use an Area2D or Area3D to define the search space. All the nodes that are within or intersecting with the Area2D/area3D are returned as the search space. The search space uses the on_area_entered and on_area_exited signals to determine which other Area2D/3D nodes are intersecting with the set area.

#### Properties

|Type|Name|Description|Version|
|--|--|--|--|
|NodeName|area2d/3d_nodepath|The nodepath to the Area3D node to use.|v1.3|
|TypedArray<Area2D/3D>|intersecting_areas|The areas intersecting or within the set area. Useful when debugging the search space.|v1.3|


#### Methods 

None.


### UtilityAISearchCriteria nodes 

The search criteria nodes are used to filter and score the nodes fetched using the search spaces. There are general criterias that can be used with any Godot node and specific criteria for 2D and 3D related search spaces.

Each criterion has an internal `apply_criterion()` method that is applied to the node passed to it. This method updates the `is_filtered` and `score` properties of the criterion and the results are visible in the Godot Engine editor inspector.

#### Properties

All the criterion nodes share the following general properties.

|Type|Name|Description|Version|
|--|--|--|--|
|bool|use_for_scoring|If true, the criterion will be used for scoring.|v1.3|
|bool|use_for_filtering|If true, the criterion will be used for filtering.|v1.3|
|bool|is_filtered|Used in `apply_criterion()`. If set to true, the will be filtered out.|v1.3|
|float|score|Used in `apply_criterion()`. The score calculated by `apply_criterion()`. Default value: 1.0.|v1.3|


### UtilityAIAngleToVector2SearchCriterion and UtilityAIAngleToVector3SearchCriterion

The Vector2/3 angle search criterion can be used to score and filter based on the node minimum and maximum angle compared to the set `angle_to_direction_vector`. For Node2D the search space direction is the (1,0) vector rotated by the global rotation amount, and for Node3D the node direction (`-global_transform.basis.z`).

#### Properties

|Type|Name|Description|Version|
|--|--|--|--|
|Vector2/3|angle_to_direction_vector|The direction vector compare the search space node facing to.|v1.3|
|float|min_angle_degrees|Minimum angle in degrees. If the angle is less than this and filtering is applied, the tested node is filtered out.|v1.3|
|float|max_angle_degrees|Maximum angle in degrees. If the angle is more than this and filtering is applied, the tested node is filtered out.|v1.3|


#### Methods 

None.

### UtilityAIAngleToVector3XZSearchCriterion

The Vector3 XZ angle search criterion can be used to score and filter based on the angle on the xz-plane between the search space node direction (`-global_transform.basis.z`) compared to the given `angle_to_direction_vector`.


#### Properties

|Type|Name|Description|Version|
|--|--|--|--|
|Vector2/3|angle_to_direction_vector|The direction vector compare the search space node facing to.|v1.3|
|float|min_angle_degrees|Minimum angle in degrees. If the angle is less than this and filtering is applied, the tested node is filtered out.|v1.3|
|float|max_angle_degrees|Maximum angle in degrees. If the angle is more than this and filtering is applied, the tested node is filtered out.|v1.3|


#### Methods 

None.


### UtilityAICustomSearchCriterion

With the custom search criterion you can define a method `apply_criterion()` that will be called to execute the filtering. You need to set the `is_filtered` and `score` properties in the method.

#### Properties

None.


#### Methods 

None.


### UtilityAIDistanceToNode2DSearchCriterion and UtilityAIDistanceToNode3DSearchCriterion

The Node2D/Node3D distance search criterion can be used to score and filter based on minimum and maximum distance to the set `distance_to` node.

#### Properties

|Type|Name|Description|Version|
|--|--|--|--|
|NodePath|distance_to_nodepath|The path to the node to which you want to compare the distance to.|v1.3|
|float|min_distance|Minimum distance. If the distance is less than this and filtering is applied, the tested node is filtered out.|v1.3|
|float|max_distance|Maximum distance. If the distance is more than this and filtering is applied, the tested node is filtered out.|v1.3|


#### Methods 

None.


### UtilityAIDistanceToVector2SearchCriterion and UtilityAIDistanceToVector3SearchCriterion

The Vector2/3 distance search criterion can be used to score and filter based on minimum and maximum distance to the set `distance_to` vector.

#### Properties

|Type|Name|Description|Version|
|--|--|--|--|
|Vector2/3|distance_to_vector|The global position to compare the search space node distance to.|v1.3|
|float|min_distance|Minimum distance. If the distance is less than this and filtering is applied, the tested node is filtered out.|v1.3|
|float|max_distance|Maximum distance. If the distance is more than this and filtering is applied, the tested node is filtered out.|v1.3|


#### Methods 

None.


### UtilityAIDotProductVector2SearchCriterion and UtilityAIDotProductVector3SearchCriterion

The Vector2/3 dot product search criterion can be used to score and filter based the angle the set `dot_product_vector` has compared to the search space node direction (`-global_transform.basis.z` for 3D, Vector2(1,0) rotated by rotation for 2D).

#### Properties

|Type|Name|Description|Version|
|--|--|--|--|
|Vector2/3|dot_product_vector|The global direction vector to compare the search space node direction vectors to.|v1.3|
|float|filtering_value|If filtering is in use, the result given by the dot product is compared to this value for filtering.|v1.3|
|int|filtering_rule|If filtering is in use, this is the comparison that is done to decide on the filtering. The choices are: "LessThan:0,LessOrEqual:1,Equal:2,MoreOrEqual:3,MoreThan:4". For instance, if LessThan is chosen then any node that gets a dot product value of less than the value of `filtering_value` will be filtered out.|v1.3|


#### Methods 

None.


### UtilityAIDotProductToPositionVector2SearchCriterion and UtilityAIDotProductToPositionVector3SearchCriterion

The Vector2/3 dot product to position search criterion can be used to check if a specific position is in front of or behind a search space node. It calculates a direction vector using the  `dot_product_position` and the node global position. Then, it calculates a dot product using the direction vector and the search space node direction (`-global_transform.basis.z` for 3D, Vector2(1,0) rotated by rotation for 2D).


#### Properties

|Type|Name|Description|Version|
|--|--|--|--|
|Vector2/3|dot_product_position|The global position to use in the dot product calculation.|v1.3|
|float|filtering_value|If filtering is in use, the result given by the dot product is compared to this value for filtering.|v1.3|
|int|filtering_rule|If filtering is in use, this is the comparison that is done to decide on the filtering. The choices are: "LessThan:0,LessOrEqual:1,Equal:2,MoreOrEqual:3,MoreThan:4". For instance, if LessThan is chosen then any node that gets a dot product value of less than the value of `filtering_value` will be filtered out.|v1.3|


#### Methods 

None.


### UtilityAIMetadataSearchCriterion

The metadata search criterion can be used to filter out nodes that do not contain certain metadata.


#### Properties

|Type|Name|Description|Version|
|--|--|--|--|
|StringName|metadata|The name of the metadata field to find||v1.3|


#### Methods 

None.


