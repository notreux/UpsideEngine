local internal, data = setmetatable({}, {}), require(script.Parent.data);

function internal.updateSpace(this)
	
	for _, meta in pairs(data.space) do
		
		if meta.canCollide and meta.loaded and this.index ~= meta.index then
			
			local cp, cs, mp, ms = this.properties.position,
			
				  this.properties.hitbox.X > 0 and this.properties.hitbox or this.properties.size,
			
				 	 meta.properties.position, 
			
						  meta.properties.hitbox.X > 0 and this.properties.hitbox or meta.properties.size;
	
			if cp.X < (mp.X + ms.X) 
				
				and(cp.X + cs.X) > mp.X
				
					and cp.Y < (mp.Y + ms.Y) 
				
						and(cs.Y + cp.Y) > mp.Y 
				
							and not this.collisions[meta.index] then
				
								this.fire("collision", meta);
									meta.fire("collision", this);
								
										meta.collisions[this.index] = this;
											this.collisions[meta.index] = meta;

							elseif this.collisions[meta.index] then
				
								this.fire("collisionEnded", meta);
									meta.fire("collisionEnded", this);

										meta.collisions[this.index] = nil;
											this.collisions[meta.index] = nil;
					
						end
			
				end
	
		end
	
end

return internal;
