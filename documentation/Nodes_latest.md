# Utility AI GDExtension Nodes

This section describes the nodes, their properties and methods in detail. After each property and method you can find the version tag when the given property/method was introduced or last changed.

This document describes the version 1.2 of Utility AI GDExtension. 


### UtilityAIAgent 

This is the main node that is used to manage the UtilityAI. A UtilityAIAgent node represents an AI entity that can reason based in `sensor` input and then choose `behaviours` to react to the sensor input.

#### Properties

|Type|Name|Description|Version|
|--|--|--|--|
|bool|is_active|This property can be used to include or exlude the node from processing.|v1.0|
|int|num_behaviours_to_select|Pick a behaviour out of top `num_behaviours_to_select` behaviours found after reasoning.|v1.0|
|float|thinking_delay_in_seconds|Delay time forced between calls to the method `evaluate_options`.|v1.0|

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

The `UtilityAIActionGroup` has the following properties:

|Type|Name|Description|Version|
|--|--|--|--|
|bool|is_finished|Set internally by the stepper, visible only for debugging purposes.|v1.0|
|int|execution_rule|A choice of how the actions that are child nodes are executed: Sequence:0,PickOneAtRandom:1,IfElse:2,CustomRule:3. The Sequence choice will execute the actions from top to bottom, the Pick One At Random does what it says it will, the IfElse rule uses the `if_else_boolean_value` property to decide if the first or the second child node of the `UtilityAIActionGroup` will be chosen. Finally, the CustomRule choice allows you to write your own `eval` method that is responsible for setting the `current_action_index` property to choose what action should be executed.|v1.2|
|int|current_action_index|Exposed for the use with a custom `eval` method to choose a child action/action group node to execute.|v1.2|

#### Methods 

None.


