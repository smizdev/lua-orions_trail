local Shiptest3 = {}

function Shiptest3:enter()
    require('game.components.position')
    require('game.components.box2dbody')
    require('game.components.blockentitylist')
    require('game.components.blocktype')
    require('game.components.blockgridposition')
    require('game.components.blocksprite')
    require('game.entities.ship')
    require('game.entities.shipblock')
    require('game.systems.coresystem')
    require('game.systems.entitydebug')
    require('game.systems.shiprenderer')
    
    -- Setup state globals
    G_BOX2DWORLD = love.physics.newWorld(0, 0, true)
    G_ECSMANAGER = Lecs.Manager:new() 
    G_CAMERA = Camera(love.graphics.getWidth()/2,love.graphics.getHeight()/2)
    G_VIEW = 0
    
    local ship = game.entities.Ship:new(200, 200, 0)
    ship:addShipBlock(
        game.entities.ShipBlock:new("HULL_BLOCK", 0, 0),
        game.entities.ShipBlock:new("HULL_BLOCK", 1, 0),
        game.entities.ShipBlock:new("HULL_BLOCK", -1, 0),
        game.entities.ShipBlock:new("HULL_BLOCK", 0, 1),
        game.entities.ShipBlock:new("HULL_BLOCK", 0, -1),
        game.entities.ShipBlock:new("HULL_BLOCK", 1, 1),
        game.entities.ShipBlock:new("HULL_BLOCK", 1, -1),
        game.entities.ShipBlock:new("HULL_BLOCK", 2, 1),
        game.entities.ShipBlock:new("HULL_BLOCK", 2, -1)
    )
    
    local ship2 = game.entities.Ship:new(500, 200, 0)
    ship2:addShipBlock(
        game.entities.ShipBlock:new("HULL_BLOCK", 0, 0),
        game.entities.ShipBlock:new("HULL_BLOCK", 1, 0),
        game.entities.ShipBlock:new("HULL_BLOCK", -1, 0),
        game.entities.ShipBlock:new("HULL_BLOCK", 0, 1),
        game.entities.ShipBlock:new("HULL_BLOCK", 0, -1)
    )
    
    G_ECSMANAGER:addEntity(
        ship,
        ship2
    )
    
    G_ECSMANAGER:addSystem(        
        game.systems.ShipRenderer:new(0)
    )
end

function Shiptest3:update(DT)
    G_BOX2DWORLD:update(DT)
    G_ECSMANAGER:update(DT)
    
    local THRUST_FORCE = 10000
    
    local body = G_ECSMANAGER:getEntitiesWithTag("ship")[1].box2dBody 
    
    if love.keyboard.isDown('q') then
        body:applyAngularImpulse( -1*THRUST_FORCE )        
    end
    
    if love.keyboard.isDown('e') then
        body:applyAngularImpulse( THRUST_FORCE )
    end
    
    if love.keyboard.isDown("w") then        
        local thrust_x = math.cos(body:getAngle())*THRUST_FORCE
        local thrust_y = math.sin(body:getAngle())*THRUST_FORCE        
        body:applyForce(thrust_x, thrust_y)
    end
    
    if love.keyboard.isDown("s") then
        local thrust_x = -1*math.cos(body:getAngle())*THRUST_FORCE
        local thrust_y = -1*math.sin(body:getAngle())*THRUST_FORCE        
        body:applyForce(thrust_x, thrust_y)
    end
    
    if love.keyboard.isDown("a") then
        local thrust_x = math.cos(body:getAngle()/2)*(THRUST_FORCE)
        local thrust_y = math.sin(body:getAngle()/2)*(THRUST_FORCE)
        body:applyForce(thrust_x, thrust_y)
    end
    if love.keyboard.isDown("d") then
        local thrust_x = math.cos(body:getAngle())*(THRUST_FORCE)
        local thrust_y = math.sin(body:getAngle())*(THRUST_FORCE)   
        body:applyForce(thrust_x, thrust_y)
    end
    
    if love.keyboard.isDown("down") then 
        G_CAMERA.y = G_CAMERA.y + 3
    end
    if love.keyboard.isDown("up") then 
        G_CAMERA.y = G_CAMERA.y - 3
    end
    if love.keyboard.isDown("right") then 
        G_CAMERA.x = G_CAMERA.x + 3
    end
    if love.keyboard.isDown("left") then 
        G_CAMERA.x = G_CAMERA.x - 3
    end
end

function Shiptest3:draw()
    
    G_CAMERA:attach()
    G_ECSMANAGER:draw(DT)
    G_CAMERA:detach()
end

function Shiptest3:mousepressed( x, y, mb )
   if mb == "wu" then
      G_CAMERA.scale = G_CAMERA.scale - 0.2
      
   end

   if mb == "wd" then
      G_CAMERA.scale = G_CAMERA.scale + 0.2
   end
end

function Shiptest3:keypressed(KEY, ISREPEAT)
    if KEY == "v" then
        if G_VIEW == 0 then
            G_VIEW = 1
        elseif G_VIEW == 1 then
            G_VIEW = 2            
        elseif G_VIEW == 2 then
            G_VIEW = 0
            G_CAMERA.rot = 0
        end
    end
end

game.states.Shiptest3 = Shiptest3