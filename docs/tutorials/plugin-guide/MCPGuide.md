### Using the Upside Engine MCP Plugin

In this page, you will learn how to use the MCP (Model Context Protocol) for the Upside Engine plugin. If you are not interested in integrating the Upside Engine plugin with AI, you can skip this page.

To follow along, make sure you have **Claude Desktop** or **Cursor** installed, as they are required to connect the plugin with a Large Language Model (LLM).

---

### Setup

Once you have Claude Desktop or Cursor installed, follow the installation guide for the [Upside Engine MCP](https://github.com/notreux/UpsideEngineMCP). After completing the setup, open Claude Desktop or Cursor. You will find two new tools available:

- `get_tilemap`
- `place_tiles`

These tools allow the LLM to create scenarios using the plugin. Currently, only these two tools exist, but more may be added in the future.

---

### Important Notes

For the LLM to function correctly, **every tile you want it to use must have a name**. If a tile is unnamed, the LLM will not be able to see it.

In the image below, the first tile is named **"LeftWall"**. Be sure to give your tiles very descriptive names. For example, instead of simply **"LeftWall"**, a more informative name like **"LeftTopCornerWall"** provides much clearer context for the LLM. Since tile names are the only reference the LLM has for placement, descriptive naming is key.

![](../../assets/tilepalette.png)


## Example
The model that we recommend is `Claude 4.1 opus`, because it usually give better results than other models.

### Prompt
> Using Upside Engine, create a basic scenario for a 2D top-down game about a dungeon

!!! Output
    ![](../../assets/mcpresult.png)

As you can see, the result is not perfect, but it can be very useful to speed up the scenario building process.
