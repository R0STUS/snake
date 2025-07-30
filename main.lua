local function clamp(n)
    return math.max(1, math.min(mapSize, n))
end

function love.load()
    Resl = {love.graphics.getWidth(), love.graphics.getHeight()}
    if Resl[1] < Resl[2] then
        sqs = Resl[1]
    else
        sqs = Resl[2]
    end
    Map = {}
    mapSize = 16
    for xx = 1, mapSize do
        Map[xx] = {}
        for yy = 1, mapSize do
            Map[xx][yy] = 0
        end
    end
    time = 0
    speed = 0.15
    dir = {1, 0}
    snake = {
        {3, 3, 1},
        {4, 2, 1},
        {4, 1, 1}
    }
    posx = (Resl[1] * 0.5) - (sqs * 0.5)
    posy = (Resl[2] * 0.5) - (sqs * 0.5)
    keyy = "."
    applePos = {math.floor(clamp(love.math.random() * mapSize)), clamp(math.floor(love.math.random() * mapSize))}
    Map[applePos[1]][applePos[2]] = 2
end

function love.draw()
    love.graphics.setColor(0.5, 0.5, 0.5, 1)
    love.graphics.rectangle("fill", posx, posy, sqs, sqs)
    for i = 1, mapSize do
        for j = 1, mapSize do
            if Map[i][j] == 1 then
                love.graphics.setColor(0, 0, 0, 1)
            elseif Map[i][j] == 2 then
                love.graphics.setColor(1, 0, 0, 1)
            elseif Map[i][j] == 3 then
                love.graphics.setColor(0.5, 1, 0, 1)
            elseif Map[i][j] == 4 then
                love.graphics.setColor(0, 1, 0, 1)
            else
                goto continue
            end
            love.graphics.rectangle("fill", posx + ((i - 1) * (sqs / mapSize)), posy + ((j - 1) * (sqs / mapSize)), sqs / mapSize, sqs / mapSize)
            ::continue::
        end
    end
end

function love.update(dt)
    time = time + dt
    if time >= speed then
        if Map[applePos[1]][applePos[2]] ~= 2 then
            applePos = {math.floor(clamp(love.math.random() * mapSize)), clamp(math.floor(love.math.random() * mapSize))}
            Map[applePos[1]][applePos[2]] = 2
        end
        time = 0
        local lastposx
        local lastposy
        for i, s in ipairs(snake) do
            Map[s[2]][s[3]] = 0
            local tmpx = s[2]
            local tmpy = s[3]
            if lastposx == nil then
                s[2] = s[2] + dir[1]
            else
                s[2] = lastposx
            end
            if lastposy == nil then
                s[3] = s[3] + dir[2]
            else
                s[3] = lastposy
            end
            if (s[2] > mapSize) then s[2] = 1 end
            if (s[2] < 1) then s[2] = mapSize end
            if (s[3] > mapSize) then s[3] = 1 end
            if (s[3] < 1) then s[3] = mapSize end
            if Map[s[2]][s[3]] == 2 then
                dtx = snake[#snake][2] - snake[#snake - 1][2]
                dty = snake[#snake][3] - snake[#snake - 1][3]
                dtx = snake[#snake][2] + dtx
                dty = snake[#snake][3] + dty
                if (dtx < 1) then dtx = mapSize end
                if (dtx > mapSize) then dtx = 1 end
                if (dty < 1) then dty = mapSize end
                if (dty > mapSize) then dty = 1 end
                table.insert(snake, {4, dtx, dty})
                applePos = {math.floor(clamp(love.math.random() * mapSize)), clamp(math.floor(love.math.random() * mapSize))}
                Map[applePos[1]][applePos[2]] = 2
                Map[math.floor(clamp(love.math.random() * mapSize))][clamp(math.floor(love.math.random() * mapSize))] = 1
            elseif (Map[s[2]][s[3]] == 4 or Map[s[2]][s[3]] == 1) and s[1] == 3 then
                os.exit(1)
            end
            Map[s[2]][s[3]] = s[1]
            lastposx = tmpx
            lastposy = tmpy
        end
    end
end

function love.resize(x, y)
    Resl = {x, y}
    if x < y then
        sqs = x
    else
        sqs = y
    end
    posx = (Resl[1] * 0.5) - (sqs * 0.5)
    posy = (Resl[2] * 0.5) - (sqs * 0.5)
end

function love.keypressed(key, scancode, isrepeat)
    if key == "escape" then
        os.exit(0)
    end
    if key == "up" then
        if dir[2] ~= 1 then
            dir = {0, -1}
        end
    elseif key == "down" then
        if dir[2] ~= -1 then
            dir = {0, 1}
        end
    elseif key == "right" then
        if dir[1] ~= -1 then
            dir = {1, 0}
        end
    elseif key == "left" then
        if dir[1] ~= 1 then
            dir = {-1, 0}
        end
    end
end
