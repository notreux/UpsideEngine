export type PluginSupportService = EventEmitter & {
LoadPluginContent: (self: PluginSupportService) -> nil,
SavePluginContent: (self: PluginSupportService, content: {}) -> nil,
}


return {}