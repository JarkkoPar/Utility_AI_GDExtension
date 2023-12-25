# Getting started with Behaviour Trees

In this beginner tutorial, you will learn how Behaviour Trees work and you will build a simple AI entity that reacts to some input. Once you have completed this tutorial, you will have understanding of the following: 

 * What a Behaviour Tree is
 * How a Behaviour Tree works
 * What *ticking the tree* means, and
 * How to construct a behaviour tree using Utility AI GDExtension

For this tutorial, we'll start with an empty Godot 4.1  project. 

**Contents:**

 1. [Project creation and installation of Utility AI GDExtension](Getting_started_with_Behaviour_Trees.md#1-project-creation-and-installation-of-utility-ai-gdextension)
 2. [Setting up the project and assets](Getting_started_with_Behaviour_Trees.md#2-setting-up-the-project-and-assets)
 3. [About Behaviour Trees](Getting_started_with_Behaviour_Trees.md#3-about-behaviour-trees)
 4. [Utility enabled Behaviour Trees in Utility AI GDExtension](Getting_started_with_Behaviour_Trees.md#4-utility-enabled-behaviour-trees-in-utility-ai-gdextension)
 5. [Creating the scenes](Getting_started_with_Behaviour_Trees.md#5-creating-the-scenes)


## 1. Project creation and installation of Utility AI GDExtension

Before we can begin, we need to create and setup the project, and add the assets we are going to use. To create a new Godot Engine project that uses Utility AI GDExtension, follow these steps: 


1. Open Godot Engine.


2. Click **Create project**.

![Create project](images/create_project_1.png)


3. Then give the project a name and click the **Create folder** button.

![Create project folder](images/create_project_2.png)


4. Choose the renderer you want to use, and then click **Create & Edit**.


5. The Godot Engine Editor main scene will open up.


To install the Utility AI GDExtension addon, follow the [installation instructions](How_to_install_Utility_AI_GDExtension.md).

Once you have installed the extension, we are ready to set up the project and prepare the assets.


## 2. Setting up the project and assets

For this project we are going to use the assets used in the *example project*. Go to the [Releases](https://github.com/JarkkoPar/Utility_AI_GDExtension/releases) and download the latest version of the example project.

1. Open your Godot project and create a folder named **Assets** in the project root folder.

2. Open the example project folder you downloaded and copy the **"Standard sprites upd.png"** file to your own project, the Assets-folder.


You now have all the assets we need for this tutorial. The setup in your FileSystem tab should look like this:

![FileSystem](images/getting_started_bt_1_assets.png)<br>


Before we get started with development, it is good review what Behaviour Trees are. If you already are experienced in using behaviour trees, you can hop on to [4. Utility enabled Behavour Trees in Utility AI GDExtension](Getting_started_with_Behaviour_Trees.md#4-utility-enabled-behaviour-trees-in-utility-ai-gdextension) to learn how the utility enabled behaviour trees in Utility AI GDExtension expand the classical Behaviour Tree functionality. Otherwise, read on.


## 3. About Behaviour Trees

Behaviour trees are probably the most popular system for AI in games today. They are easy to understand and intuitive to create for many and it is easy to make changes to them. You can think of a behaviour tree as a *plan* on how to reach a certain goal by choosing and executing various tasks. Its structure is modular and it is possible to execute very complex tasks just by composing them from simpler tasks. 

While behaviour trees are very good at choosing which tasks to execute at each moment, they aren't very good at handling (or visually representing) *states*. Moving between states is usually **cyclic**, meaning that you can transition between various states and even go back and forth between them. For instance, your AI can start in a *Patrol* state and transition to *Idle* or *Combat* states and back to *Patrol* state again. Behaviour Trees are **acyclic**. They start from the root node and then land on some task that may be within a branch that realizes *Patrol*, *Idle* or *Combat* behaviour. 

If you find yourself wanting to move between states while building your behaviour tree, you should read up on [**State Trees**](Getting_started_with_State_Trees.md) and consider implementing your logic there instead. 


### 3.1 The structure of a Behaviour Tree

A behaviour tree consists of a **root node** that is the basis of the tree. The tree branches are created using **composite nodes** that define how the tree is traversed together with **decorator nodes**, and finally the branches of the behaviour tree end with **task nodes** that execute various actions. Using a behaviour tree a non-player character can make choices on what are the best actions it can take in the situation where it finds itself in.

A behaviour tree is updated by **ticking** the tree. Simplified, this means that the root node of the tree is first run, which in turn runs its child node, and the child node runs its own child nodes and so on, until one or more task nodes are reached. You can think of ticking as *running what ever code the behaviour tree nodes have and returning if it succeeded or not*.

The ticking of the child nodes is done in a top-to-down order. The higher the node is in the list, the higher its priority. 

![Behaviour Tree node priority order](images/getting_started_bt_1.png)<br>
*Node priority is highest on the top, lowest on the bottom.*<br>

### 3.2 The return values of the Behaviour Tree nodes

Each behaviour tree node returns a value, which is either *success*, *failure* or *running*. Usually it is one of the task nodes that ultimately sets what value is returned but the decorator and composite nodes can affect the value that is returned to the root node in the end.
 
> [!NOTE]
> In Utility AI GDExtension the nodes can also return the *skip* value, but for the purposes of this tutorial we will only focus on the *success*, *failure* and *running* values. 

### 3.3 Commonly used nodes

All behaviour trees need the **root** node. The root node is the *main node* for behaviour trees. The root node always has only one behaviour tree child node (in Utility AI GDExtension it may have **Sensor** nodes as well, though).

In addition to the root node, **task** or **leaf** nodes are always needed. As the *task* node's name implies, these nodes usually execute actions and other logic.

The most commonly used *composite* nodes are the **selector** (also known as the *fallback*) node and the **sequence** node. 

 * The selector *ticks* (= runs the code) its child nodes one by one and checks if any of its child nodes succeeds. When one does, it stops ticking and returns *success* back to its parent node. If all fail, it returns back *failure* to its parent.  
 * The sequence *ticks* its child nodes one by one until one of them fails or until it has ticked all its child nodes. If a child node fails, the sequence returns *failure* back to its parent. If all succeed, it returns back *success*.

Both the selector and sequence return back *running* if a child node they tick returns back running. Handing the *running* state can vary between Behaviour Tree implementations. In Utility AI GDExtension the default is that during the next tick the tree continues ticking from the node that returned running until it either succeeds or fails. This can be changed by changing the node settings, though.

There are also *decorator* nodes, which usually have only one child node. The **inverter** is a very common one, and it changes the return value of its child node to the opposite value (a *success* becomes a *failure* and a *failure* a *success*). Other common decorator nodes are the **repeat until** node that repeats its child node until it either succeeds or fails, **cooldown** nodes run their child nodes and then allow it only to run after a certain cooldown period.

> [!NOTE]
> The *AlwaysSucceed* and *AlwaysFail* nodes are replaced by the **FixedResult** decorator node in Utility AI GDExtension, where you can choose what result the node always returns.


## 4. Utility enabled Behaviour Trees in Utility AI GDExtension

You can use the utility enabled Behaviour Trees as the sole AI reasoning component, or as a sub-component of the AI Agent Behaviours or State Trees. Utility-based considerations can be attached to all of the nodes in Utility AI GDExtension, including the Behaviour Tree nodes. The considerations can be attached either as child nodes or in the Inspector as a property.

<img src="images/getting_started_bt_2.png" height="256px"><img src="images/getting_started_bt_3.png" height="256px"><br>
*Considerations can be child nodes or in the Inspector as properties.*<br>

The **score based picker** node can be placed anywhere in the behaviour tree and during a *tick* it will first evaluate the *considerations* attached to its child nodes to find out which child node scores the highest, and then proceed to tick that node. 

It is possible to start **Node Query System** queries from the Behaviour Trees by using the **RunNQSQuery** node. To do this, you need a *Search Space* that has been setup elsewhere in your scene. The RunNQSQuery node will post the query and return *running* until the query completes, in which case the RunNQSQuery node returns *success*.

> [!NOTE]
> When using the RunNQSQuery node, it is expected that you call the `NodeQuerySystem.run_queries()` method once per physics frame in your main scene.


## 5. Creating the scenes

The behaviour tree nodes work with both 2D and 3D scenes. For this tutorial we are creating everything in 2D because setting up the assets for 2D scenes is much quicker.


1. In your Godot Project, create a Node2D-based scene, name it as **tutorial_scene** and save it.

![Creating the tutorial_scene](images/getting_started_bt_4.png)<br>

This will be our *main scene* and we will *instantiate* the AI entities in to this scene. 
The AI entity itself will be a separate AnimatedSprite2D scene with a behaviour tree.

2. Create a new AnimatedSprite2D-based scene and name it as **ai_entity**.

![Creating the tutorial_scene](images/getting_started_bt_5.png)<br>


3. In the **ai_entity** scene, click the ai_entity AnimatedSprite2D and expand the **Animation** group in the **Inspector**.

![Creating the tutorial_scene](images/getting_started_bt_6.png)<br>


4. In the popup menu, choose New SpriteFrames.

![Creating the tutorial_scene](images/getting_started_bt_7.png)<br>


5. In the popup menu, choose New SpriteFrames, and then click the created SpriteFrames again to select it. This will open up the SpriteFrames menu on the bottom of the Godot Editor. The next steps will take place in that menu.

<img src="images/getting_started_bt_8.png" height="256px"><br>


6. Make sure the "default" animation is selected, then click on the "Add frames from sprite sheet" icon.

![Creating the tutorial_scene](images/getting_started_bt_9.png)<br>


6. Make sure the "default" animation is selected, then click on the "Add frames from sprite sheet" icon.

![Creating the tutorial_scene](images/getting_started_bt_9.png)<br>


7. Open file dialog will open up. Go to the Assets-folder and select the file **Standard sprites upd.png**, then click **Open**.

![Creating the tutorial_scene](images/getting_started_bt_10.png)<br>




