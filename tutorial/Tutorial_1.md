# Tutorial 1 - General concepts and guidelines
 
This tutorial focuses on general concepts you need to know when working with Utility AI GDExtension and some guidelines about using the nodes.


## The Sense - Think - Act loop

The basic loop that Utility AI GDExtension builds upon is the classic **Sense - Think - Act paradigm**. The Sense - Think - Act paradagim, which is sometimes also called Sense - Plan - Act as well, is decades old and is used in things like robots, self-driving cars and of course with AI. Together these three steps help define what the behaviour of the AI will be.
 
**Sensing** is about getting information about the "world state", which for a game may mean that the AI you are creating should know for instance how far away it is from the player, does the AI see the player or not, and how much health the AI currently has. In Utility AI GDExtension we use *Sensors* for sensing and gathering data about the "world state".

**Thinking** is about using the information gathered during the sensing step and coming up with a viable plan, or a behaviour, to react to the situation at hand. In Utility AI GDExtension thinking is done by using *Behaviours* with *Considerations*. The Considerations interpret the Sensors to help decide which Behaviour is valid for the situation.

**Acting** is about actually doing something that likely will change the "world state" somehow. In Utility AI GDExtension we use the *Action* nodes set to a *Behaviour* to tell the AI what it should do. 

How frequently you run this loop depends on your game. For a real-time game your AI agents will likely be running it a few times a second. For a turn-based game you will likely run it for a unit once at the beginning of its turn. 


## At what level does our AI think?

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


## Fiddling with the Curves

Sometimes it can be tricky to find the correct Curves for the considerations. In such situations it is good to remember that the curve maximum value doesn't have to be 1. It can be anything. And maybe you should actually use the ConsiderationGroup and more than one Consideration for the thing you are trying to accomplish? At times you need to add some lag to your sensor values so that they change slower than the actual value. In some cases adding a cooldown to a Behaviour is an easy solution.


## So... How does it work in practice? 

To start learning adding the nodes to your Godot project, go to [Tutorial 2](Tutorial_2.md) or just download the example project and see what's going on in there.

