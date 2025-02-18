# Tutorial: Creating Pixel Art Assets Using AI

Developers often face budget constraints that make it difficult to hire professional pixel artists. This tutorial shows you how to create pixel art assets using AI—an approach that, while not matching the finesse of a dedicated pixel artist, can still serve as an effective workaround.

## Tools & Resources

- **AI Model:** [pixel-art-3.5L](https://huggingface.co/nerijs/pixel-art-3.5L)  
  *(A LoRA model created by [nerijs](https://huggingface.co/nerijs))*
- **Image Editor:** GIMP (or any similar image editing software)
- **Hugging Face Space:** [Access the space here](https://huggingface.co/spaces/NotReux/nerijs-pixel-art-3.5L)

## Step-by-Step Guide

1. **Access the AI Model Space**  
   Visit the Hugging Face space provided above. This space has been specifically set up for this guide.

2. **Input Your Prompt**  
   In the prompt field, enter your desired description.
   After submitting the prompt, the AI will generate an image.

### Example
> "A pixel art house for a horror game side view"

![House](../../assets/house.webp){width="300"}
   

3. **Enhance the Image Resolution**  
   The initial output might appear blurry or of low quality because it isn’t rendered at the correct resolution. To fix this:
   
   - Open the generated image in GIMP.
   - Resize the image by dividing its dimensions by 8. By default, the output image is 1024×1024, resizing it to 128×128 will achieve a pixel-perfect result.
   
![House](../../assets/housepixelperfect.webp){width="300" .pixelated}


??? tip "Generating Detailed Prompts"
    If you’re struggling to come up with creative prompts, try using the following template with ChatGPT to generate more detailed descriptions:

    **Prompt Template:**

    "Given a brief concept or description, create a detailed pixel art sprite by expanding on the idea with visual elements, specific attributes, and design details that suit a 2D game environment. Focus on aspects like viewpoint (e.g., top-down), scale, textures, and colors. Ensure that the description explicitly mentions 'pixel art' and incorporates elements relevant to sprite creation, such as a clear perspective and detailed shading"

    **Example:**

    - **Input:** "A roadside store from above."
    - **Output:** "A pixel art sprite of a roadside store viewed from above, featuring a compact, quaint building with a tiled roof and a small, welcoming awning over the entrance. The storefront is accented with a glowing neon sign, rendered in vibrant colors that pop against the retro backdrop. Detailed pixel work outlines the windows and door frames, while subtle shading gives the structure depth and character. The scene includes hints of a paved road and minimal surrounding vegetation, all designed in a top-down perspective to capture the nostalgic charm of classic 2D games."

    ![House detailed](../../assets/housedetailed.webp){width="300" .pixelated}

## Conclusion

Using AI to generate pixel art assets can be a game-changer for developers on a budget. While it may not entirely replace the detailed work of a professional pixel artist, this method offers a quick and efficient way to produce nearly pixel-perfect assets with just a simple post-editing process.
