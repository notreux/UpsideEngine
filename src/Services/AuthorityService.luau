local upsideEngine = script.Parent.Parent
local eventEmitter = require(upsideEngine.Classes.Internal.EventEmitter)

local authorityService = {}
authorityService.__index = authorityService

function authorityService.new()
	local self = eventEmitter.new()
	self:SetClassName(script.Name)
	self.AuthorityAssignments = {}

	return setmetatable(self, authorityService)
end

--[[={
	@desc Assigns authority for a specific object to a given authority type. This determines who has control 
	over the object's state and behavior in the networked environment. AuthorityType can be "Client" or "Server".
}=]]
function authorityService:SetAuthority(object: BaseObject, authorityType: AuthorityType)
	self.AuthorityAssignments[object.Id] = authorityType
end

--[[={
	@desc Retrieves the current authority assignment for a specific object. Returns the authority type 
	that has control over the object, defaulting to "Server" authority when not explicitly set.
}=]]
function authorityService:GetAuthority(object: BaseObject): AuthorityType
	return self.AuthorityAssignments[object.Id] or "Server"
end

--[[={
	@desc This service manages authority assignments for objects in the game. Authority determines which client or server 
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

	@about
		@AuthorityAssignments A table that stores the authority assignments for objects, indexed by object Id
}=]]

return setmetatable(authorityService, eventEmitter).new() :: AuthorityService
