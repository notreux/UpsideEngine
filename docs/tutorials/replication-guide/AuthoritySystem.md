# Authority System

The Authority System is one of the most important features introduced in Upside Engine v3.1.0. It determines who has control over objects and prevents conflicts in multiplayer environments.

## What is authority?

Authority determines which entity (client or server) has the right to modify an object and send updates. Think of it as "ownership" or "control rights" over an object.

## Authority types

There are two types of authority:

| Authority | Description | Can modify object | Updates are sent |
|-----------|-------------|------------------|------------------|
| `"Server"` | Server controls the object | Only server | Server → Clients |
| `"Client"` | Client controls the object | Specific client + server | Client → Server → Other clients |

## How authority works

### Default behavior

When the server accepts the first replication request, **the server automatically takes authority**:

```lua title="Server Code - Default Behavior"
-- Server code
networkingService:On("ReplicationRequest", function(request)
    local object = request:Accept()
    -- At this point, server has authority
    -- ReplicationRequest won't fire again for this object!
end)
```

!!! warning "Important"
    Without client authority, `ReplicationRequest` fires **only once** (when the object is created). The client cannot send more replication updates.

### Granting client authority

To allow clients to continue sending replication updates, you must explicitly grant authority:

```lua title="Server Code - Grant Authority"
-- Server code
networkingService:On("ReplicationRequest", function(request)
    local object = request:Accept()
    authorityService:SetAuthority(object, "Client")
    -- Now ReplicationRequest will fire on every property change
    -- You must continue to accept each request!
end)
```

!!! info "With Client Authority"
    With client authority, `ReplicationRequest` fires **on every property change**. You must call `Accept()` each time to apply the changes.

## Practical examples

### Example 1: Player characters (Client authority)

Players should control their own characters:

```lua title="Server Code - Player Characters"
-- Server code
networkingService:On("ReplicationRequest", function(request)
    if request.Content.ClassName == "Character" then
        local character = request:Accept()
        -- Give control back to the client
        authorityService:SetAuthority(character, "Client")
    end
end)
```

!!! success "Result"
    - :white_check_mark: Players can move freely
    - :white_check_mark: Movement is synchronized to all clients
    - :white_check_mark: Smooth multiplayer experience

### Example 2: Server-controlled NPCs (Server authority)

NPCs should be controlled by the server:

```lua title="Server Code - NPCs"
-- Server code
local npc = UpsideEngine.new("Character")
npc:SetScene(scene)
-- Configure NPC...

-- Server objects replicate automatically to all clients
-- No need to call ReplicateOnChange() - it's automatic!
-- Server keeps authority (default)
-- Server can move NPC, clients just see updates
```

!!! success "Result"
    - :white_check_mark: Server controls NPC behavior
    - :white_check_mark: Clients can't manipulate NPCs
    - :white_check_mark: Prevents cheating
    - :white_check_mark: Automatic replication to all clients

### Example 3: Temporary server control

Sometimes you need to temporarily take control from a client:

```lua title="Server Code - Temporary Control"
-- Server code
local function applyKnockback(character, force)
    -- Take temporary control
    authorityService:SetAuthority(character, "Server")
    
    -- Apply physics force
    character:ApplyForce(force)
    
    -- Let physics settle
    task.wait(0.5)
    
    -- Give control back to client
    authorityService:SetAuthority(character, "Client")
end
```

!!! tip "Use cases"
    - Knockback effects
    - Server-validated teleportation
    - Forced movement (wind, conveyor belts)
    - Stuns or crowd control effects

## Authority and the replication flow

Let's see the complete flow with authority:

### For client-created objects:

```
1. CLIENT creates object and calls ReplicateOnChange()
   │
   ├──> ReplicationRequest sent to server (first time)
   │
2. SERVER receives ReplicationRequest event
   │
   ├──> request:Accept() called
   │
   ├──> Object created on server
   │
   ├──> ⚠️ Server automatically has authority
   │
   ├──> authorityService:SetAuthority(object, "Client")
   │
   ├──> ✅ Client now has authority
   │
3. CLIENT modifies a property
   │
   ├──> ReplicationRequest sent to server (with changes)
   │
4. SERVER receives ReplicationRequest event again
   │
   ├──> request:Accept() called
   │
   ├──> Changes applied
   │
   ├──> Server distributes changes to all other clients
   │
5. REPEAT steps 3-4 for every property change
   │
   ├──> Each change triggers new ReplicationRequest
   │
   ├──> Server must Accept() each one
```

### For server-created objects:

```
1. SERVER creates object
   │
   ├──> Object automatically replicates to all clients
   │
   ├──> Server has authority (default)
   │
2. SERVER modifies a property
   │
   ├──> Changes automatically replicate to all clients
   │
   ├──> No ReplicationRequest events
```

## Checking authority

You can check who has authority over an object:

```lua title="Check Authority"
local authority = authorityService:GetAuthority(object)
-- Returns "Server" or "Client"

if authority == "Server" then
    print("Server controls this object")
elseif authority == "Client" then
    print("Client controls this object")
end
```

## Common mistakes

### ❌ Mistake 1: Forgetting to set authority

```lua title="Server Code - WRONG!"
-- Server code - WRONG!
networkingService:On("ReplicationRequest", function(request)
    request:Accept()
    -- No authority set - client can't update!
end)
```

!!! danger "Problem"
    Players can't move, or only they see their own movement locally.

### ❌ Mistake 2: Setting authority on the wrong side

```lua title="Client Code - WRONG!"
-- Client code - WRONG!
authorityService:SetAuthority(character, "Client")
-- This does nothing! Authority can only be set on the server
```

!!! danger "Problem"
    Authority management is server-only. Clients can't set authority.

### ❌ Mistake 3: Constantly switching authority

```lua title="Server Code - WRONG!"
-- Server code - WRONG!
while true do
    authorityService:SetAuthority(object, "Server")
    task.wait(0.1)
    authorityService:SetAuthority(object, "Client")
    task.wait(0.1)
end
```

!!! danger "Problem"
    Creates synchronization issues and lag. Set authority once and only change it when necessary.

## Best practices

!!! success "Best Practices"
    1. **Set authority once**: Set it in the `ReplicationRequest` handler and leave it

    2. **Client authority for player objects**: Players should control their own characters

    3. **Server authority for game objects**: NPCs, items, and world objects should be server-controlled

    4. **Temporary server control is okay**: It's fine to temporarily take control for specific events

    5. **Don't overthink it**: For most games, simply giving clients authority over their characters is enough

## Authority and security

The authority system is designed to prevent unauthorized modifications:

!!! quote "Security Benefits"
    - Clients can only send updates for objects they have authority over
    - The server validates that the client has authority before accepting updates
    - Other clients cannot modify objects they don't have authority over

This means:

- :white_check_mark: Players can't modify other players' characters
- :white_check_mark: Players can't modify server-controlled objects
- :white_check_mark: Server has final say on authority assignments

## Summary

| Scenario | Authority | Who sets it | When to set it | ReplicationRequest fires | Replication type |
|----------|-----------|-------------|----------------|------------------------|------------------|
| Player character | Client | Server | After first Accept() | On every property change | Client → Server → Clients |
| Server NPC | Server | Default | No action needed | No | Server → Clients (automatic) |
| Temporary control | Server ↔ Client | Server | As needed | Depends on current authority | Varies |
| World objects | Server | Default | No action needed | No | Server → Clients (automatic) |

!!! summary "Remember"
    - Server objects replicate automatically - no `ReplicateOnChange()` needed
    - Client objects need `ReplicateOnChange()` to send updates to server
    - Authority determines how often `ReplicationRequest` fires (for client objects only)
    - Without client authority: Fires **once** (object creation)
    - With client authority: Fires **on every property change**
    - You must call `Accept()` on **every** request to apply changes
    - Set authority on the server, after accepting the first request

---

**Next:** [Practical Example](PracticalExample.md)
