# [Extended from EventEmitter](EventEmitter.md) AuthorityService 
This service manages authority assignments for objects in the game. Authority determines which client or server 
 has control over specific objects. This is essential for network synchronization and preventing conflicts in 
 multiplayer environments. Only the server can manage authority assignments.

	Example usage:
```lua
-- Set authority for an object to server
AuthorityService:SetAuthority(myObject, "Server")

-- Check authority
local authority = AuthorityService:GetAuthority(myObject)
if authority then
	print("Authority is assigned to:", authority)
end
```

	 
# Properties

## [table](table.md) AuthorityAssignments 
A table that stores the authority assignments for objects, indexed by object Id
 
```lua
{ }
```


# Methods
## [void](void.md) SetAuthority(`object: BaseObject, authorityType: AuthorityType`) 
 Assigns authority for a specific object to a given authority type. This determines who has control 
	over the object's state and behavior in the networked environment. AuthorityType can be "Client" or "Server".

## [AuthorityType](AuthorityType.md) GetAuthority(`object: BaseObject`) 
 Retrieves the current authority assignment for a specific object. Returns the authority type 
	that has control over the object, defaulting to "Server" authority when not explicitly set.



# Events
There is no events for this class


