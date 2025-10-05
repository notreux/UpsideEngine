# Understanding Replication in Upside Engine

Welcome to the comprehensive guide on replication in Upside Engine! This tutorial will teach you how to create multiplayer games by understanding how objects are synchronized across clients.

## What is replication?

Replication is the process of synchronizing game objects and their properties across multiple clients in a multiplayer environment. When a player moves their character, jumps, or performs any action, that information needs to be:

1. Sent to the server
2. Validated by the server
3. Distributed to all other connected clients

This ensures that all players see a consistent game state.

## Prerequisites

Before starting this tutorial, you should have:

!!! info "Requirements"
    - Upside Engine installed in your project. Follow the [installation guide](https://notreux.github.io/UpsideEngine/tutorials/get-started/Installation.html)
    - Basic understanding of Luau/Lua programming
    - Basic knowledge of Roblox's client-server architecture

## Tutorial structure

This guide is divided into several sections:

!!! tip "Guide Sections"
    1. **How Replication Works** - Understanding the core concepts and flow
    2. **Client Setup** - Setting up your client-side replication
    3. **Server Setup** - Handling replication requests on the server
    4. **Authority System** - Understanding and managing object authority
    5. **Practical Example** - Building a complete multiplayer game

Let's get started! :rocket:

---

**Next:** [How Replication Works](HowItWorks.md)
