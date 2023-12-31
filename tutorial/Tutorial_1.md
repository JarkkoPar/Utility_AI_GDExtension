# Tutorial 1 - General concepts and guidelines
 
This tutorial focuses on general concepts you need to know when working with Utility AI GDExtension and some guidelines about using the nodes.


## The Sense - Think - Act loop

The basic loop that Utility AI GDExtension builds upon is the classic **Sense - Think - Act paradigm**. The Sense - Think - Act paradagim, which is sometimes also called Sense - Plan - Act as well, is decades old and is used in things like robots, self-driving cars and of course with AI. Together these three steps help define what the behaviour of the AI will be.
 
**Sensing** is about getting information about the "world state", which for a game may mean that the AI you are creating should know for instance how far away it is from the player, does the AI see the player or not, and how much health the AI currently has. In Utility AI GDExtension we use *Sensors* for sensing and gathering data about the "world state". In addition to the sensors, the Node Query System can be used to sense the world and feed information to the AI agents.

**Thinking** is about using the information gathered during the sensing step and coming up with a viable plan, or a behaviour, to react to the situation at hand. In Utility AI GDExtension thinking is done by using *Behaviours* with *Considerations*. The Considerations interpret the Sensors to help decide which Behaviour is valid for the situation.

**Acting** is about actually doing something that likely will change the "world state" somehow. In Utility AI GDExtension we use the *Action* nodes set to a *Behaviour* to tell the AI what it should do. 

How frequently you run this loop depends on your game. For a real-time game your AI agents will likely be running it a few times a second. For a turn-based game you will likely run it for a unit once at the beginning of its turn. 

## AI cannot have intelligence without a goal

What should the AI sense, think and act about then? You likely have some goals for the AI in your game. In a shooter game - or most games in general - the goal of the AI enemies is usually to kill the player or slow the player down. In a tactical shooter, some enemies may have goals such as healing and keeping their team mates alive, keeping the player on the move, and so on. Once you know the goals of your AI entities, it will be easier to plan what behaviours and actions they should take to reach their goals. 

Let's examine the tactical shooter example a bit more. Usually in these games you have AI enemies that have different roles, for example: 

 * Defenders that try and keep the player from reaching a certain position
 * Attackers, who charge the player
 * Flankers, who try to flank the player
 * Medics, who heal their team mates
 * Ambushers that wait for the player and try and surprise them 


These roles have some shared goals (for example the ever present "kill the player") but their strategies to achieve these goals may be different. They also have unique goals specific to their role: 

 * The defenders can have the goal of keeping the player away from the position they are defending and should not wander far away from the position.
 * The Attackers, on the other hand, would have the goal of making the player move. They would achieve this by moving towards the player while attacking and thus forcing the player to change positions. 
 * The Flankers would be much like the Attackers, but they would approach the player while avoiding the player's line-of-sight. 
 * The Medics have the goal of keeping their team mates alive. A secondary goal could be to act like a Defender if all the other team members are in good health.
 * The Ambushers have the goal of surprising the player with an unexpected attack. They would act like defenders, but they would seek a position to defend that is some distance away from the player's position, towards the the player's goal. They would keep hidden in the position until they can surprise the player. Once discovered they would either become Attackers or Defenders.


Once you have a clearer picture of the goals you need for your AI entities, you can start thinking about behaviours that they need to achieve their goals.


## At what detail level does our AI think?

In my view, for most people it is easiest to think about what an AI agent would do in terms of "If this - Then that". For example: "If the AI gets shot at, it should take cover and shoot back", or "If the AI sees a coin, it should pick it up". Your natural way of thinking could be more detailed than that or maybe more abstract. Use it as a guide to yourself when you are creating the Sensor, Behaviour, Consideration and Action nodes. This will make it more intuitive for you to work with your AI's behaviours and the actions are at a detail level you are confortable with. 

If we continue with the example "If the AI gets shot, it should take cover and shoot back" we could break it down to nodes we have available for us in Utility AI GDExtension as follows:
 * The Behaviour could be called "Shoot back from cover". 
 * The Considerations to choose this behaviour could be "I just got shot at" and "I am not in cover". 
 * The Actions could be "Take cover" and "Shoot at the Player". 
 * The Sensors could be the time since the AI last got shot at and a boolean if the AI is in cover or not.

You should then implement the "Take cover" and "Shoot at the Player" actions in such a way that they achieve the goal in their name. And you can of course revise them later on to go to a more detailed level if it seems the best option for you. The key thing is to find a level of abstraction for the AI behaviours and actions that feels best for your project. 

In terms of available components in Utility AI GDExtension, you can set use the Utility AI Behaviour nodes for selection of the goal related high-level behaviour and then the Behaviour Tree, State Tree and Action nodes to realize the actions.


## AI Agent updates and Calculating the Utility of a Behaviour

When the AI Agent evaluates its options it updates its child nodes from top-to-down order. You should therefore have the sensors as the first child nodes of the AI Agent and after the sensors add your Behaviours. This way the sensors will be up-to-date when the Behaviours start running their considerations. If you have multiple behaviours that could score the same high score and have set the AI Agent to only pick one top-scoring Behaviour, the top-most highest scoring Behaviour will be chosen. So place your default Behaviours last in the list or make sure they always get a low score.

In most cases it makes sense to group your Behaviours using Behaviour groups and then setting the is_active property for the groups based on your AI Agent's state. Let's say you have an AI Agent that can drive a car. When the AI Agent isn't in the drivers seat, you can disable all the driving-related behaviours easily by placing them in to a Behaviour Group and deactivating the group. This is more effective than just using the considerations. So use the Behaviour Groups and is_active property to activate/deactivate behaviours based on their relevance. Use Considerations to choose between relevant behaviours.


## Failing actions

In the real world, things fail. And this can happen also to your AI Agents when they are executing actions for a behaviour - in fact it can happen quite easily when your AI agent is navigating to a new position, for instance. 

To handle this situation in Utility AI GDExtension using the Actions, the `has_failed` property is included as an assignable property for actions. If you set `has_failed=true` the action is marked as a failed action. Note that you still need to assign `is_finished=true` to allow UtilityAIAgent to step forward during the next behaviour update. When the action finishes and `has_failed=true`, the action emits a signal that it has failed and then you can decide what to do with the fail-situation. The ActionGroups also have a property `error_handling_rule` that you can use to define how they handle the situation when an action fails: should they just stop (EndExecution) or keep going and maybe let the following action node handle the error (ContinueExecution). 

Together the `has_failed` property of the actions and the `error_handling_rule` of the action groups allow you to handle errors in various ways. If you decide to have the AI behaviours to have very simple action sequences, you can simply end the execution, maybe set some weights for the considerations, and then let the AI agent decide what should be the next behaviour to choose. If you want to have your behaviours more high-level and choose to use more complex action sequences, you can define the error handling logic using the action groups and actions. 

For more complex actions, the Behaviour Tree nodes are a good solution. They allow for better error handling and more flexibility for handling different game situations. 


## Fiddling with the Curves

Sometimes it can be tricky to find the correct Curves for the considerations. A relatively common problem with Utility systems is *oscillation*, where the chosen behaviour changes between a couple of options (you can see this happening occationally in the example 4). In such situations it is good to remember that the curve maximum value doesn't have to be 1. It can be anything. And maybe you should actually use the ConsiderationGroup and more than one Consideration for the thing you are trying to accomplish? At times you need to add some lag to your sensor values so that they change slower than the actual value. In some cases adding a cooldown to a Behaviour is an easy solution to prevent it from being chosen for a while, or even adding a little score boost to the currently selected behaviour to make sure it keeps getting selected more easily for some minimum amount of time. 


## Utility of... Anything?

In a game there are many situations where you may want to know the utility of things other than the behaviour an AI agent should choose. A very common example is choosing a movement or attack target tile in a tile-based game. The AI Agent and the behaviours alone can be cumbersome in this situation. That is why the **Node Query System** was added to Utility AI GDExtension. 

The Node Query System is a generalized solution for calculating the utility of any type of node in a scene. For most games the likely use is to find the best movement targets, the nastiest enemies to attack or friendlies to heal or buff, or to find the best cover point nearby. 


## So... How does it work in practice? 

To start learning adding the nodes to your Godot project, go to [Tutorial 2](Tutorial_2.md) for a simple Agent behaviour example, to [Tutorial 3](Tutorial_3.md) for a Node Query System example, or just download the example project and see what's going on in there. 


