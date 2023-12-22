# Utility_AI_GDExtension
<p align="center">
Utility AI | Behaviour Tree with Utility support | State Tree with Utility support | Node Query System
</p>
This repository contains the binaries and example project for the Utility AI GDExtension for Godot Engine.

The extension contains Utility AI Agent Behaviour, Behaviour Tree with Utility support, State Tree with Utility support and Node Query System nodes. Together these nodes can be used to create versatile AI to your games.

If you don't know what Utility AI is, here is what Wikipedia says about it:

*"...Utility AI, is a simple but effective way to model behaviours for non-player characters. Using numbers, formulas and scores to rate the relative benefit of possible actions, one can assign utilities to each action. A behaviour can then be selected based on which one scores the highest 'utility'...* - [Wikipedia - Utility system](https://en.wikipedia.org/wiki/Utility_system)

If you want the source code, you can find it here: [Utility AI Source Code repository](https://github.com/JarkkoPar/Utility_AI).

# Features

 - [x] Utility based AI Agent and Behaviour nodes to allow reasoning for situation-approriate behaviours
 - [x] Sensors for visibility, distance, angle, and other information gathering for the AI Agent
 - [x] Node Query System (NQS) for flexible utility-based node selection amongs **any** Godot node within a scene
 - [x] Time Budgeting support for NQS to allocate a set time per frame for Utility based queries 
 - [x] Behaviour Tree with Utility and Node Query System support
 - [x] Properties in Behaviour Tree nodes to control node reset rules, to see debug status
 - [x] Behaviour Tree Sub-tree referencing support that allows easy, run-time tree changes and modularity
 - [x] State Tree nodes with Utility for flexible, hierarchical state management


# Compatibility
Works on Godot 4.1.2 or newer versions. 
Currently 64bit Windows and Linux versions are available.


# Installation

Just copy the addons-folder with all its contents to your Godot project root folder. 


# Documentation

You can find the documentation [here](documentation/Nodes_latest.md) and the tutorials [here](tutorial/readme.md).

# Authors

JarkkoPar with [Contributors](https://github.com/JarkkoPar/Utility_AI/graphs/contributors). Big thank you to all of you who've helped out!

# Example project

The example project contains example scenes that show how to use the various nodes. With these examples you get to know the nodes of the Utility AI GDExtension: 


**Agent behaviour nodes**

 * UtilityAIAgent node that is the "main" node for using the AI
 * UtilityAISensor and UtilityAISensorGroup nodes that gives information to the AI about the game world
 * UtilityAIBehaviour node that is used to define behaviours for the AI activating them in a simple way based on considerations
 * UtilityAIBehaviourGroup node that is used to group behaviours and activate/deactivate them
 * UtilityAIConsideration and UtilityAIConsiderationGroup nodes that define what score the behaviours will get based on sensor input
 * UtilityAIAction and UtilityAIActionGroup nodes that make up the actual steps the AI should take to realize a behaviour

There are also specialized sensor nodes for adding vision to the AI agents, handling ranges, booleans, for instance.


**Utility enabled Behaviour Tree nodes**

The UtilityAI Behaviour Tree nodes can be used independelty as a regular behaviour tree. However, they have been designed to work with Utility based Considerations and the Node Query System, which allows for more complex behaviour for your AI agents. The available nodes are:

 * UtilityAIBTRoot node that is the "main" node when using the Utility enabled Behaviour Trees
 * UtilityAIBTSequence node and UtilityAIBTRandomSequence node 
 * UtilityAIBTSelector node and UtilityAIBTRandomSelector node
 * UtilityAIBTParallel node
 * UtilityAIBTScoreBasedPicker node for picking child nodes based on their utility
 * UtilityAIBTRunNQSQuery node for running NQS Queries
 * UtilityAIBTInverter node
 * UtilityAIBTRepeater and UtilityAIBTRepeatUntil nodes
 * UtilityAIBTLimiter node
 * UtilityAIBTLeaf node you use to create your own actions
 * UtilityAIBTFixedResult node that serves as both AlwaysSucceed and AlwaysFail nodes
 * UtilityAIBTNodeReference node to allow referencing subtrees and modular behaviour tree development
 * UtilityAIBTPassThrough node and UtilityAIBTPassBy node 
 * UtilityAIBTCooldownMsec, UtilityAIBTCooldownUsec and UtilityAICooldownTicks nodes


**Utility enabled State Tree nodes**

The UtilityAI State Tree nodes can be used independently as a regular state tree. However, similarly to the Behaviour Tree nodes, they have been designed to work with Utility based Considerations. The available nodes are:

 * UtilityAISTRoot node that is the "main" node when using the Utility enabled State Trees
 * UtilityAISTNode that is used to define the state hierarchy


**Node Query System nodes**

The UtilityAI Node Query System is used to perform utility based queries to find Top N nodes that fit the set criteria. It as two types of nodes: Search Spaces and Search Criteria. A NodeQuerySystem-singleton can be used to set a per physics frame time budget for all the queries and to control the CPU-time of all the queries.

A Search Space defines a set of nodes you will use in your query: 

 * UtilityAINodeGroupSearchSpace
 * UtilityAINodeChildrenSearchSpace
 * UtilityAIArea2DSearchSpace and UtilityAIArea3DSearchSpace

A Search Criterion filters and scores the nodes in a search space to find the top N nodes:

 * UtilityAIAngleToDirectionVector2SearchCriterion
 * UtilityAIAngleToDirectionVector3SearchCriterion
 * UtilityAICustomSearchCriterion
 * UtilityAIXZAngleToDirectionVector3SearchCriterion
 * UtilityAIDistanceToVector2SearchCriterion and UtilityAIDistanceToVector3SearchCriterion
 * UtilityAIDistanceToNode2DSearchCriterion and UtilityAIDistanceToNode3DSearchCriterion
 * UtilityAIDotProductVector2SearchCriterion and UtilityAIDotProductVector3SearchCriterion
 * UtilityAIDotProductToPositionVector2SearchCriterion and UtilityAIDotProductToPositionVector3SearchCriterion
 * UtilityAIMetadataSearchCriterion


## Example 1 - A dude following the mouse cursor

The first example is a simple one, where one AI controlled entity follows the mouse cursor. When it gets close enough to the cursor, it stops and waits. It is a gentle introduction to Utility AI. 
 
|Example 1|
|---------|
|![Example 1 - A dude following the mouse cursor](https://raw.githubusercontent.com/JarkkoPar/Utility_AI_GDExtension/main/screenshots/example_1.png)|
 
## Example 2 - Dudes in combat
The second example provides a more elaborate example with several behaviours and behaviour groups for the AI agent with a multitude of sensors. In this example a blue and a red team of dudes pick up weapons and battle it out until only one team remains standing. 

|Example 2|
|---------|
|![Example 2 - Dudes in combat](https://raw.githubusercontent.com/JarkkoPar/Utility_AI_GDExtension/main/screenshots/example_2.png)|
 
## Example 3 - Making (better) use of Actions
The third example shows a better, more re-usable way of using actions. In the earlier two examples the actions have been used only as an ID for an action. In this example the actions are extended with a script to contain the methods start_action(), execute_action() and end_action(). As a result the action node itself can be used perform what ever an action does, which both simplifies the AI Entity code and makes each action easier to share between different AI entities.
|Example 3|
|---------|
|![Example 3 - Making use of Actions](https://raw.githubusercontent.com/JarkkoPar/Utility_AI_GDExtension/main/screenshots/example_3.png)|
 
## Example 4 - Adding perception
The fourth example shows how to add vision and hearing sensors to an AI agent, this time a Baddie. It uses a specialized sensor, UtilityAIArea2DVisibilitySensor, to achieve this. In the example a Baddie will chase you, the player, and investigate if you make too much noise.
|Example 4|
|---------|
|![Example 4 - Adding perception](https://raw.githubusercontent.com/JarkkoPar/Utility_AI_GDExtension/main/screenshots/example_4.png)|

## Example 5 - Behaviour Tree with Utility
The fifth example is a 2D example that shows how to use the Utility enabled Behaviour Trees together with the Node Query System.
|Example 5|
|---------|
|![Example 5 - Behaviour Tree with Utility](https://raw.githubusercontent.com/JarkkoPar/Utility_AI_GDExtension/main/screenshots/example_5.png)|
 
## Example 6 - Hide and seek
The sixth example is a 3D example that shows how to use the Node Query System to find a cover point to hide from the player. It uses the NodeQuerySystem-singleton to manage time budget of the queries and an Area3D Search Space with a set of criteria to find the best places for the AI to hide from you. Utility AI Agent behaviours are used to select the main behaviour and one of these behaviours uses a Behaviour Tree to handle the how the behaviour is realized and how errors are handled.
|Example 6|
|---------|
|![Example 6 - Hide and seek](https://raw.githubusercontent.com/JarkkoPar/Utility_AI_GDExtension/main/screenshots/example_6.png)|


