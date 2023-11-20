# Tutorial 1 - General concepts and guidelines
 
This tutorial focuses on general concepts you need to know when working with Utility AI GDExtension and some guidelines about using the nodes.


## The Sense - Think - Act loop

The basic loop that Utility AI GDExtension builds upon is the classic **Sense - Think - Act paradigm**. The Sense - Think - Act paradagim, which is sometimes also called Sense - Plan - Act as well, is decades old and is used in things like robots, self-driving cars and of course with AI. Together these three steps help define what the behaviour of the AI will be.
 
**Sensing** is about getting information about the "world state", which for a game may mean that the AI you are creating should know for instance how far away it is from the player, does the AI see the player or not, and how much health the AI currently has. In Utility AI GDExtension we use *Sensors* for sensing and gathering data about the "world state". In addition to the sensors, the Node Query System can be used to sense the world and feed information to the AI agents.

**Thinking** is about using the information gathered during the sensing step and coming up with a viable plan, or a behaviour, to react to the situation at hand. In Utility AI GDExtension thinking is done by using *Behaviours* with *Considerations*. The Considerations interpret the Sensors to help decide which Behaviour is valid for the situation.

**Acting** is about actually doing something that likely will change the "world state" somehow. In Utility AI GDExtension we use the *Action* nodes set to a *Behaviour* to tell the AI what it should do. 

How frequently you run this loop depends on your game. For a real-time game your AI agents will likely be running it a few times a second. For a turn-based game you will likely run it for a unit once at the beginning of its turn. 


## At what detail level does our AI think?

In my view, for most people it is easiest to think about what an AI agent would do in terms of "If this - Then that". For example: "If the AI gets shot at, it should take cover and shoot back", or "If the AI sees a coin, it should pick it up". Your natural way of thinking could be more detailed than that or maybe more abstract. Use it as a guide to yourself when you are creating the Sensor, Behaviour, Consideration and Action nodes. This will make it more intuitive for you to work with your AI's behaviours and the actions are at a detail level you are confortable with. 

If we continue with the example "If the AI gets shot, it should take cover and shoot back" we could break it down to nodes we have available for us in Utility AI GDExtension as follows:
 * The Behaviour could be called "Shoot back from cover". 
 * The Considerations to choose this behaviour could be "I just got shot at" and "I am not in cover". 
 * The Actions could be "Take cover" and "Shoot at the Player". 
 * The Sensors could be the time since the AI last got shot at and a boolean if the AI is in cover or not.

You should then implement the "Take cover" and "Shoot at the Player" actions in such a way that they achieve the goal in their name. And you can of course revise them later on to go to a more detailed level if it seems the best option for you. The key thing is to find a level of abstraction for the AI behaviours and actions that feels best for your project. 


## AI Agent updates and Calculating the Utility of a Behaviour

When the AI Agent evaluates its options it updates its child nodes from top-to-down order. You should therefore have the sensors as the first child nodes of the AI Agent and after the sensors add your Behaviours. This way the sensors will be up-to-date when the Behaviours start running their considerations. If you have multiple behaviours that could score the same high score and have set the AI Agent to only pick one top-scoring Behaviour, the top-most highest scoring Behaviour will be chosen. So place your default Behaviours last in the list or make sure they always get a low score.

In most cases it makes sense to group your Behaviours using Behaviour groups and then setting the is_active property for the groups based on your AI Agent's state. Let's say you have an AI Agent that can drive a car. When the AI Agent isn't in the drivers seat, you can disable all the driving-related behaviours easily by placing them in to a Behaviour Group and deactivating the group. This is more effective than just using the considerations. So use the Behaviour Groups and is_active property to activate/deactivate behaviours based on their relevance. Use Considerations to choose between relevant actions.


## Failing actions

In the real world, things fail. And this can happen also to your AI Agents when they are executing actions for a behaviour - in fact it can happen quite easily when your AI agent is navigating to a new position, for instance. When going through GDC talks and material about Utility-based AI, I noticed that this implementation detail doesn't seem to come up often (or at least I wasn't able to find much information about it). 

To handle this situation in Utility AI GDExtension, the `has_failed` property is included as an assignable property for actions. If you set `has_failed=true` the action is marked as a failed action. Note that you still need to assign `is_finished=true` to allow UtilityAIAgent to step forward on the next behaviour update. When the action finishes and `has_failed=true`, the action emits a signal that it has failed and then you can decide what to do with the fail-situation. The ActionGroups also have a property `error_handling_rule` that you can use to define how they handle the situation when an action fails: should they just stop (EndExecution) or keep going and maybe let the following action node handle the error (ContinueExecution). 

Together the `has_failed` property of actions and the `error_handling_rule` of the action groups allow you to handle errors in various ways. If you decide to have the AI behaviours to have very simple action sequences, you can simply end the execution, maybe set some weights for the considerations, and let the AI agent decide what should be the next behaviour to choose. If you want to have your behaviours more high-level and choose to use more complex action sequences, you can define the error handling logic using the action groups and actions. 

You can see one way of handling failures in the Example 5 scene. As the AI agents run about and try and find a place to hide, they can bump into eachother and get stuck for a moment. If that happens, the movement action sets the `has_failed` property to `true`. The ActionGroup where the movement action is, has been set to continue on errors. The node after the movement action is another ActionGroup that is set to have an `execution_rule` IfElse, and when the "enemy" AI handles the has_failed-signal it sets the boolean value for the IfElse-actiongroup to true. As a result IfElse-ActionGroup chooses what to execute based on if the movement action failed or not. 

Another way could be to just use your actions to handle the failures. You add a property to your AI agent's scene, say `did_previous_action_fail` and set this to true or false when you are executing your action logic. Then in each action you check if `did_previous_action_fail` is true or not, and decide what to do then. For the movement example it could look like this:
 
 * Action: ChooseTargetPositionForMovement
 * Action: MoveToTargetPosition
 * Action: HandleFailureOrEndMovement

So in this case the last action, HandleFailureOrEndMovement, on the sequence would decide what it needs to do if the MoveToTargetPosition action failed.


## Fiddling with the Curves

Sometimes it can be tricky to find the correct Curves for the considerations. A relatively common problem with Utility systems is *oscillation*, where the chosen behaviour changes between a couple of options (you can see this happening occationally in the example 4). In such situations it is good to remember that the curve maximum value doesn't have to be 1. It can be anything. And maybe you should actually use the ConsiderationGroup and more than one Consideration for the thing you are trying to accomplish? At times you need to add some lag to your sensor values so that they change slower than the actual value. In some cases adding a cooldown to a Behaviour is an easy solution to prevent it from being chosen for a while, or even adding a little score boost to the currently selected behaviour to make sure it keeps getting selected more easily for some minimum amount of time. 


## Utility of... Anything?

In a game there are many situations where you may want to know the utility of things other than the behaviour an AI agent should choose. A very common example is choosing a movement or attack target tile in a tile-based game. The AI Agent and the behaviours alone can be cumbersome in this situation. That is why the **Node Query System** was added to Utility AI GDExtension. 

The Node Query System is a generalized solution for calculating the utility of any type of node in a scene. For most games the likely use is to find the best movement targets, the enemies to attack or friendlies to heal or buff, or to find the best cover point nearby. My aim was to make as generalized a system as possible for Godot, so that you can decide what you want to measure for its utility for your game.


## So... How does it work in practice? 

To start learning adding the nodes to your Godot project, go to [Tutorial 2](Tutorial_2.md) or just download the example project and see what's going on in there.

