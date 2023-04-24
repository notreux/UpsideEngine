return function(scene, deltaTime)
    local cl = os.clock()
    for _, particle in scene.ParticleEnvironment.Content do
        if cl - particle.Clock < particle.LifeTime/particle.Rate then
            continue
        end

        particle.Clock = cl
        particle:Emit(particle.Rate * deltaTime)
    end
end