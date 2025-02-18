# Upside Engine Project Structure

In this guide, we'll explain the recommended project structure for a basic game scenario using Upside Engine. The structure is designed to keep your code modular, maintainable, and scalable.

This is an example how the project structure of a game should look:
```
UpsideEngineGame/
├── client/
│   ├── main.client.luau
│   ├── ui/**
│   └── modules/
│       ├── globals/
│       │   ├── sword.luau
│       │   └── player.luau
│       ├── city/
│       │   ├── car.luau
│       │   ├── building.luau
│       │   ├── shop.luau
│       │   └── etc.
│       └── forest/
│           ├── item.luau
│           ├── tree.luau
│           ├── enemy.luau
│           └── etc.
├── server/
│   ├── main.server.luau
│   └── modules/
│       ├── networking.luau
│       ├── gameLogic.luau
│       ├── dataStore.luau
│       └── etc.
├── shared/
│   ├── util/
│   │   ├── setup.luau
│   │   └── etc.
│   └── etc.
└── packages/
    └── UpsideEngine       
```

