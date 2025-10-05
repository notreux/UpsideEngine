# How Replication Works

Understanding the replication flow is crucial for building robust multiplayer games. Let's break down exactly what happens when you replicate an object.

## The replication flow

Here's the complete flow of how replication works in Upside Engine v3.1.0:

### Client to Server replication (Client-created objects)

```
CLIENT                          SERVER                          OTHER CLIENTS
  │                               │                                    │
  ├─ Create object                │                                    │
  ├─ ReplicateOnChange()          │                                    │
  │   (Tells server about object) │                                    │
  │                               │                                    │
  ├──── ReplicationRequest ──────>│                                    │
  │     (First time - new object) │                                    │
  │                               ├─ ReplicationRequest event fires    │
  │                               ├─ request:Accept()                  │
  │                               ├─ Object created on server          │
  │                               ├─ Server takes authority            │
  │                               │                                    │
  │                               ├──── Replicate to all clients ─────>│
  │                               │                                    ├─ Build event fires
  │                               │                                    ├─ Object created
  │                               │                                    │
  │         ⚠️ PROBLEM: Client can't send more updates!                │
  │         ReplicationRequest won't fire again without authority      │
  │                               │                                    │
  │                               ├─ SetAuthority(object, "Client")    │
  │                               │   ✅ NOW client can send updates   │
  │                               │                                    │
  ├──── ReplicationRequest ──────>│                                    │
  │     (Every property change!)  ├─ ReplicationRequest event fires    │
  │                               ├─ request:Accept()                  │
  │                               ├──── Updates to all clients ───────>│
  │                               │                                    │
  ├──── ReplicationRequest ──────>│                                    │
  │     (Another change)          ├─ ReplicationRequest event fires    │
  │                               ├─ request:Accept()                  │
  │                               ├──── Updates to all clients ───────>│
  │                               │                                    │
```

### Server to Client replication (Server-created objects)

```
SERVER                          ALL CLIENTS
  │                                    │
  ├─ Create object                     │
  │  (Automatically replicates)        │
  │                                    │
  ├───── Replicate to all clients ────>│
  │                                    ├─ Build event fires
  │                                    ├─ Object created
  │                                    │
  ├─ Modify object property            │
  │  (Automatically replicates)        │
  │                                    │
  ├───── Updates to all clients ──────>│
  │                                    ├─ Property updated
  │                                    │
```

!!! warning "Important"
    Server objects replicate to clients automatically by default - no `ReplicateOnChange()` needed!

## Key concepts

### 1. ReplicateOnChange (Client-side)

`ReplicateOnChange()` is used by **clients** to tell the server about objects they want to replicate:

```lua title="Client Code"
-- Client code
local character = UpsideEngine.new("Character")
character:SetScene(scene)
-- Tell server to replicate this object
networkingService:ReplicateOnChange(character)
```

!!! note "Server Objects"
    Server objects replicate automatically without calling `ReplicateOnChange()`.

### 2. ReplicationRequest (Server-side only)

The `ReplicationRequest` event is **only fired on the server** when a client sends replication data.

```lua title="Server Code - ONLY works on the server!"
-- This ONLY works on the server!
networkingService:On("ReplicationRequest", function(request)
    -- You must accept each request
    request:Accept()
end)
```

!!! danger "Critical Understanding"
    - **Without client authority**: `ReplicationRequest` fires **only once** (when the object is first created)
    - **With client authority**: `ReplicationRequest` fires **on every property change** that the client sends

### 3. How ReplicationRequest behavior changes with authority

This is the most important concept to understand:

=== "Without client authority (default)"

    ```lua
    networkingService:On("ReplicationRequest", function(request)
        request:Accept()
        -- Server has authority, ReplicationRequest won't fire again
    end)
    ```

    - :white_check_mark: First `ReplicationRequest` fires → Object created
    - :x: No more `ReplicationRequest` events → Client can't update
    - :x: Object appears frozen to other players

=== "With client authority"

    ```lua
    networkingService:On("ReplicationRequest", function(request)
        local object = request:Accept()
        authorityService:SetAuthority(object, "Client")
        -- Client has authority, ReplicationRequest will fire on every change
    end)
    ```

    - :white_check_mark: First `ReplicationRequest` fires → Object created
    - :white_check_mark: Client modifies object → `ReplicationRequest` fires again
    - :white_check_mark: You call `request:Accept()` → Changes applied and distributed
    - :white_check_mark: Every property change → New `ReplicationRequest` → Must accept
    - :white_check_mark: Smooth continuous replication

### 4. Authority system

Authority determines who can send replication updates:

| Authority Type | Who can send updates | ReplicationRequest behavior |
|---------------|---------------------|---------------------------|
| `"Server"` | Only the server | Fires once (object creation only) |
| `"Client"` | Specific client + server | Fires on every property change |

!!! warning "Critical Point"
    When the server accepts the first replication request of a new object, it **automatically takes authority**. You must explicitly grant authority to the client if you want them to continue sending replication updates.

## Why authority assignment is critical

Let's see what happens without proper authority management:

=== "❌ BAD: Without Authority"

    ```lua
    -- ReplicationRequest won't fire again after the first time
    networkingService:On("ReplicationRequest", function(request)
        request:Accept()
        -- Server has authority, ReplicationRequest won't fire again!
    end)
    ```

    **What happens:**
    
    1. :white_check_mark: First `ReplicationRequest` fires → Object created
    2. :x: Client modifies object → No `ReplicationRequest` sent
    3. :x: `ReplicationRequest` event never fires again
    4. :x: Player's character appears frozen to other players
    5. :x: Player sees their own movement locally but others can't

=== "✅ GOOD: With Authority"

    ```lua
    -- ReplicationRequest will fire on every property change
    networkingService:On("ReplicationRequest", function(request)
        local object = request:Accept()
        authorityService:SetAuthority(object, "Client")
        -- Now ReplicationRequest fires on every change!
    end)
    ```

    **What happens:**
    
    1. :white_check_mark: First `ReplicationRequest` fires → Object created → Authority granted
    2. :white_check_mark: Client modifies object → `ReplicationRequest` fires again
    3. :white_check_mark: Server calls `Accept()` → Changes applied and distributed
    4. :white_check_mark: Every property change → New `ReplicationRequest` → You must accept it
    5. :white_check_mark: Smooth synchronized multiplayer experience

## Understanding the Accept method

The `request:Accept()` method is crucial - it's what actually applies the changes:

```lua
networkingService:On("ReplicationRequest", function(request)
    -- This applies the changes from the client and distributes to other clients
    request:Accept()
end)
```

!!! info "Important"
    You must call `Accept()` on **every** `ReplicationRequest`:
    
    - **First request**: Creates the object
    - **Subsequent requests** (with client authority): Applies property changes
    - If you don't call `Accept()`, the changes are rejected and not applied

## Summary

| Event/Method | Where it's used | When it's used | Purpose |
|--------------|-----------------|----------------|---------|
| `ReplicateOnChange()` | Client only | For client-created objects | Tell server to replicate object |
| `ReplicationRequest` | Server only | Once per new client object | Accept/reject replication |
| Automatic replication | Server only | For server-created objects | Objects replicate automatically |
| Property updates | Automatic | Continuous | Sync object changes |

!!! summary "Remember"
    - :red_circle: Client objects need `ReplicateOnChange()` to be sent to the server
    - :green_circle: Server objects replicate automatically - no `ReplicateOnChange()` needed
    - :red_circle: `ReplicationRequest` fires **once** per client object, not per update
    - :red_circle: Server gets authority by default after accepting for the first time
    - :red_circle: You **must** set client authority for continuous updates from client
    - :green_circle: Once authority is set, updates happen automatically

---

**Next:** [Client Setup](ClientSetup.md)
