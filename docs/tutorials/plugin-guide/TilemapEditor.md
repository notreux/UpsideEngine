On this page, you will learn an essential tool to make scenarios.

![](../../assets/upsideenginebar.png)

## Introduction to Tilemap Editor
Click on the Tilemap Editor button, and a new window named "Tilemap Editor" will appear. In this interface, you can easily import any tilemap.

Within the Tilemap Editor, you'll find some buttons and fields:

- **Tilemap Name:** The name of the tilemap.
- **Tilemap URL:** The URL of your tilemap.
- **Tilemap Size:** Specify the dimensions to determine the size of your tile on the tile palette.
- **Tilemap Scale:** Specify how big the tile should be in scene
- **Open in Tile Palette:** Click here to open the Tile Palette window which based on the tilemap settings, a new window will appear, which you will be able to use to place your tiles in the scene
- **Save tilemap:** Click here to save your tilemap in the right section

![](../../assets/tilemapeditor.png)


## Tilemap Palette
For this example we will use a tile palette from this [itch.io asset pack](https://pixel-poem.itch.io/dungeon-assetpuck) made by [pixel poem](https://pixel-poem.itch.io/)
![](../../assets/tileeditorinfo.png)

Let's click 'Open in the tile palette', a window like this will appear:

![](../../assets/tilepalette.png)

If you move the mouse over the tiles you will see that every tile can be selected, the first tile is selected by default as you can see, that's why it has a more intense color, also as you saw on the screenshot, there is a section called "Tile Settings", this section represent the properties of the selected tile:

![](../../assets/tilepalettesettings.png)

As you can imagine, zIndex represent the z index of the selected tile, canCollide represent if the tile can collide or not, and the name, is just the tile name, anyway, if you want to use the MCP, it's highly recommended to set a name for the tiles, because the AI will not be able to see tiles without names

## A basic usage
Let's do a basic configuration, don't forget to enable the "grid" and "place tile" modes, this will create a new environment called "Tile Env" in the scene.

![](../../assets/tilepalette.png)


Now, Let's build something, select any tile you want and let's hold the left click while we move the mouse

<video width="700" controls>
  <source src="../../assets/drawingtiles.mp4" type="video/mp4">
</video>

You can delete any tile in the same way you place it, just hold ++left-shift++ this time

<video width="700" controls>
  <source src="../../assets/deletetiles.mp4" type="video/mp4">
</video>
this will delete any tile if it's the same tile, if you want to delete any tile hold ++left-ctrl++ instead.

___
##### Congratulations! you are ready to make any scenario. Let's move on to the next page 🎉🎉 

