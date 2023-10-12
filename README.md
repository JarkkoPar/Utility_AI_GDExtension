# Utility_AI_GDExtension
This repository contains the binaries and example project for the Utility AI GDExtension for Godot Engine.

If you don't know what Utility AI is, here is what Wikipedia says about it:

*"...Utility AI, is a simple but effective way to model behaviours for non-player characters. Using numbers, formulas and scores to rate the relative benefit of possible actions, one can assign utilities to each action. A behaviour can then be selected based on which one scores the highest 'utility'...* - [Wikipedia - Utility system](https://en.wikipedia.org/wiki/Utility_system)

If you want the source code, you can find it here: [Utility AI Source Code repository](https://github.com/JarkkoPar/Utility_AI).

# Compatibility
Works on Godot 4.1 or newer versions. 
Currently 64bit Windows and Linux versions are available.

# Installation
Just copy the bin-folder with all its contents to your Godot project root folder. 

# Example project
The example project contains two example scenes. With these examples you get to know the nodes of the Utility AI GDExtension: 

 * UtilityAIAgent node that is the "main" node for using the AI
 * UtilityAISensor and UtilityAISensorGroup nodes that gives information to the AI about the game world
 * UtilityAIBehaviour node that is used to define behaviours for the AI
 * UtilityAIConsideration and UtilityAIConsiderationGroup nodes that define what score the behaviours will get based on sensor input
 * UtilityAIAction and UtilityAIActionGroup nodes that make up the actual steps the AI should take to realize a behaviour

## Example 1 - A dude following the mouse cursor

The first example is a simple one, where one AI controlled entity follows the mouse cursor. When it gets close enough to the cursor, it stops and waits. It is a gentle introduction to Utility AI. 
 
|Example 1|
|---------|
|![Example 1 - A dude following the mouse cursor](https://raw.githubusercontent.com/JarkkoPar/Utility_AI_GDExtension/main/screenshots/example_1.png)|
 
## Example 2 - Dudes in combat
The second example provides a more elaborate example with several behaviours for the AI agent with a multitude of sensors. In this example a blue and a red team of dudes pick up weapons and battle it out until only one team remains standing. 

|Example 2|
|---------|
|![Example 1 - Dudes in combat](https://raw.githubusercontent.com/JarkkoPar/Utility_AI_GDExtension/main/screenshots/example_2.png)|
 
 