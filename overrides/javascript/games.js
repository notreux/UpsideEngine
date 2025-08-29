const games = [
    {
        name: "The Slime Game",
        description: `This is the final result of the getting started tutorial, you can play or edit the place. You can also donate buying a gamepass.`,
        banner: "https://tr.rbxcdn.com/180DAY-503fe13dae372b328ca2a1c5e1881bd6/768/432/Image/Webp/noFilter",
        game_url: "https://www.roblox.com/games/13021482729/Upside-Engine-Getting-Started",
    },
        {
        name: "Space Fighter",
        description: `This is the demo of Upside Engine v3.0.0, you can play or edit the place. You can also donate inside the game.`,
        banner: "https://tr.rbxcdn.com/180DAY-fb163f069d3a80f8874c01440e54dd3a/768/432/Image/Webp/noFilter",
        game_url: "https://www.roblox.com/games/99502143707226/Space-Fighter",
    }
]

function createGameCard(data) {
    const div = document.createElement("div")
    div.className = "gameCard"

    const banner = document.createElement("div")
    banner.style.backgroundImage = `url(${data.banner})`;
    banner.className = "banner"

    const hr = document.createElement("hr")
    hr.className = "no-margin"

    const title = document.createElement("p")
    title.className = "title theme-color"
    title.innerText = data.name

    const description = document.createElement("p")
    description.className = "description generic"
    description.innerText = data.description

    const button = document.createElement("a")
    button.className = "md-button viewButton md-basic-button md-button--primary"
    button.href = data.game_url
    button.innerText = "View"

    div.append(banner, hr, title, description, button)
    document.getElementById("games-grid").append(div)
}

games.forEach(createGameCard);