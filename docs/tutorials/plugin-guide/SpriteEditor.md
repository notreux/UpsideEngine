<link rel="stylesheet" href="../../stylesheet/plugin_guide.css">

In this page, you will learn an essential tool to create characters.

![](../../assets/upsideenginebar.png)

## Introduction to Sprite Editor
Click on the Sprite Editor button, and a new window named "Sprite Editor" will appear. In this interface, you can easily edit the animations of your character

![](../../assets/spriteeditorinterface.png)

Within the Sprite Editor, you'll find some fields:

- URL: Input the URL of your spritesheet here.
- Name: Specify the desired name for your animation in this field.
- Frames in X Axis: Enter the number of frames along the horizontal axis.
- Frames in Y Axis: Specify the number of frames along the vertical axis.

![](../../assets/spriteeditoranimempty.png)

## A basic usage
??? tip
    
    If you choose one of the following names from the list when setting your animation name, it will be played automatically with the proper direction (this only works if you use the integrated player movement):
    
    - idle
    - left
    - right
    - up
    - jump
    - down
Lets create a basic animation, for this, select an sprite and then click on "Add Sprite sheet", in this example we will fill the fields like this:

![](../../assets/spriteeditorfill.png)

In this case we are using this sprite (`rbxassetid://12970115106`):

![](../../assets/spriteeditorslime.png){ .spritesheet }

As you can see we have 1 row and 12 columns, thats why we specified 1 in the Y axe and 12 in the X axe.
The resolution for every frame in this case is 37x37, so we set the resolution in "ImageRectSize" property like this:

![](../../assets/spriteeditorrectsize.png)

Now we just have to play our animation

<video width="700" controls>
  <source src="../../assets/spriteeditor.mp4" type="video/mp4">
</video>

___
##### Congratulations! you are ready to edit any sprite, let's move on to the next page 🎉🎉 

