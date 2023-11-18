# Utility_AI_GDExtension
This repository contains the binaries and example project for the Utility AI GDExtension for Godot Engine.

If you don't know what Utility AI is, here is what Wikipedia says about it:

*"...Utility AI, is a simple but effective way to model behaviours for non-player characters. Using numbers, formulas and scores to rate the relative benefit of possible actions, one can assign utilities to each action. A behaviour can then be selected based on which one scores the highest 'utility'...* - [Wikipedia - Utility system](https://en.wikipedia.org/wiki/Utility_system)

If you want the source code, you can find it here: [Utility AI Source Code repository](https://github.com/JarkkoPar/Utility_AI).


# Compatibility
Works on Godot 4.1.2 or newer versions. 
Currently 64bit Windows and Linux versions are available.

# Installation
Just copy the addons-folder with all its contents to your Godot project root folder. 
NOTE! If you have the version 1.1 bin-folder already installed in your Godot project root folder, you will need to delete it before you copy the addons folder to your project root folder.

# Documentation

You can find the documentation [here](documentation/Nodes_latest.md).

# Example project
The example project contains four example scenes. With these examples you get to know the nodes of the Utility AI GDExtension: 

**Agent behaviour nodes**

 * UtilityAIAgent node that is the "main" node for using the AI
 * UtilityAISensor and UtilityAISensorGroup nodes that gives information to the AI about the game world
 * UtilityAIBehaviour node that is used to define behaviours for the AI activating them in a simple way based on considerations
 * UtilityAIBehaviourGroup node that is used to group behaviours and activate/deactivate them
 * UtilityAIConsideration and UtilityAIConsiderationGroup nodes that define what score the behaviours will get based on sensor input
 * UtilityAIAction and UtilityAIActionGroup nodes that make up the actual steps the AI should take to realize a behaviour

There are also specialized sensor nodes for adding vision to the AI agents, handling ranges, booleans, for instance.

**Node Query System nodes**

The UtilityAI Node Query System is used to perform utility based queries to find Top N nodes that fit the set criteria. It as two types of nodes: Search Spaces and Search Criteria.

A Search Space defines a set of nodes you will use in your query: 

 * UtilityAINodeGroupSearchSpace
 * UtilityAINodeChildrenSearchSpace
 * UtilityAIArea2DSearchSpace and UtilityAIArea3DSearchSpace

A Search Criterion filters and scores the nodes in a search space to find the top N nodes:

 * UtilityAICustomSearchCriterion
 * UtilityAIMetadataSearchCriterion
 * UtilityAIAngleToDirectionVector2SearchCriterion
 * UtilityAIAngleToDirectionVector3SearchCriterion
 * UtilityAIXZAngleToDirectionVector3SearchCriterion
 * UtilityAIDistanceToVector2SearchCriterion and UtilityAIDistanceToVector3SearchCriterion
 * UtilityAIDistanceToNode2DSearchCriterion and UtilityAIDistanceToNode3DSearchCriterion


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
 
## Example 5 - Hide and seek
The fith example is a 3D example that shows how to use the Node Query System to find a cover point to hide from the player. It uses an Area3D Search Space with a set of criteria to find the best places to hide, and the AI agent will try and hide from you.
|Example 5|
|---------|
|![Example 5 - Hide and seek](https://raw.githubusercontent.com/JarkkoPar/Utility_AI_GDExtension/main/screenshots/example_4.png)|

 
