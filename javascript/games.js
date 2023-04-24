const games = [
    {
        name: "The Slime Game",
        description: `This is the final result of the getting started tutorial, you can play or edit the place. You can also donate buying a gamepass.`,
        banner: "https://cdn.discordapp.com/attachments/886012037916930109/1093616927257153536/image.png",
        game_url: "https://www.roblox.com/games/12868051803",
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