function love.load()
    initializeAllVariables()
    backgroundMusic = love.audio.newSource("backgroundMusic.mp3", "stream")
    backgroundMusic:setVolume(0.3)
    backgroundMusic:setLooping(true)

    blockDestroySoundEffect = love.audio.newSource("blockDestroy.wav", "static")
    blockDestroySoundEffect:setVolume(2.0)

    gameOverSound = love.audio.newSource("gameOverSound.mp3", "static")
    love.window.setMode(columns * cellHeight, rows * cellHeight)
end

function initializeAllVariables()
    cellWidth = 40
    cellHeight = 40
    rows = 20
    columns = 10
    elapsedTime = 0
    grid = {}
    shapeType = 0
    rotated = 0
    liveObject = newLiveObject()
    clickElapsedTime = 0
    gameMode = 3
    for i = 1, rows do
        grid[i] = {}
        for j = 1, columns do
            grid[i][j] = 0
        end
    end
end

function love.update(dt)
    elapsedTime = elapsedTime + dt
    clickElapsedTime = clickElapsedTime + dt
    if gameMode == 1 then
        if elapsedTime >= 0.3 then
            elapsedTime = 0
            progressLiveObject(1, 0, true)
        end
        if clickElapsedTime > 0.09 then
            if love.keyboard.isDown("d") then
                progressLiveObject(0, 1, false)
            end
            if love.keyboard.isDown("a") then
                progressLiveObject(0, -1, false)
            end
            if love.keyboard.isDown("w") then
                rotateShape()
            end
            if love.keyboard.isDown("m") then
                love.audio.stop(backgroundMusic)
                gameMode = 3
            end
            clickElapsedTime = 0
        end
    elseif gameMode == 2 then
        if love.keyboard.isDown("s") then
            love.audio.play(backgroundMusic)
            gameMode = 1
        end
    elseif gameMode == 3 then
        if love.keyboard.isDown("r") then
            love.audio.play(backgroundMusic)
            gameMode = 1
        end
        if love.keyboard.isDown("s") then
            saveGame("savedGame.txt")
        end
        if love.keyboard.isDown("l") then
            love.audio.play(backgroundMusic)
            loadGame("savedGame.txt")
            gameMode = 1
        end
    end
end

function love.draw()
    if gameMode == 1 then
        drawGrid()
        for _, pair in ipairs(liveObject) do
            local i = pair[1]
            local j = pair[2]
            drawSquare(i, j)
        end
    elseif gameMode == 2 then
        love.graphics.setColor(1, 0.2, 0.5, 1)
        love.graphics.rectangle("fill", 50, 100, 300, 200)
        love.graphics.setColor(1, 1, 1, 1)
        love.graphics.print("Youve lost, press s to start new game", 50, 100)
    elseif gameMode == 3 then
        love.graphics.setColor(1, 0.2, 0.5, 1)
        love.graphics.rectangle("fill", 50, 100, 300, 200)
        love.graphics.setColor(1, 1, 1, 1)
        love.graphics.print("To resume or start a new game press r", 50, 100)
        love.graphics.print("To save the game press s", 50, 120)
        love.graphics.print("To load a saved game press l", 50, 140)
    end
end

function saveGame(filename)
    local file = io.open(filename, "w")
    if not file then
        error("Could not open file: " .. filename)
    end
    for i = 1, rows do
        for j = 1, columns do
            file:write(grid[i][j], " ")
        end
    end
    file:write("\n")
    for _, pair in ipairs(liveObject) do
        local i = pair[1]
        local j = pair[2]
        file:write(i, " ")
        file:write(j, "\n")
    end
    file:write(shapeType, "\n")
    file:write(rotated, "\n")
    file:close()
end

function loadGame(filename)
    local file = io.open(filename, "r")
    if not file then
        error("Could not open file: " .. filename)
    end

    for i = 1, rows do
        grid[i] = {}
        for j = 1, columns do
            grid[i][j] = tonumber(file:read("*number"))
            if not grid[i][j] then
                error("Invalid data in file: " .. filename)
            end
        end
    end

    file:read("*line")

    liveObject = {}
    for i = 1, 4 do
        local i = tonumber(file:read("*number"))
        local j = tonumber(file:read("*number"))
        print(k, i, j)
        if not i or not j then
            error("Invalid data in file: " .. filename)
        end
        table.insert(liveObject, {i, j})
    end

    shapeType = tonumber(file:read("*number"))
    rotated = tonumber(file:read("*number"))
    if not shapeType or not rotated then
        error("Invalid data in file: " .. filename)
    end

    file:close()
end

function rotateShape()
    local temp = {}
    if shapeType == 1 then
        local startRow = liveObject[1][1]
        local startCol = liveObject[1][2]
        if rotated % 2 == 0 then
            temp = { liveObject[1], { startRow + 1, startCol }, { startRow +2, startCol}, {startRow+3, startCol} }
        else 
            temp = { liveObject[1], { startRow, startCol + 1}, { startRow, startCol+2}, {startRow, startCol+3}}
        end
    elseif shapeType == 2 then
        temp = liveObject
    elseif shapeType == 3 then
        local startRow = liveObject[1][1]
        local startCol = liveObject[1][2]
        if rotated % 4 == 0 then
            temp = { liveObject[1], {startRow + 1, startCol}, {startRow+2, startCol}, {startRow+1, startCol -1}}
        end
        if rotated % 4 == 1 then
            temp = { liveObject[1], {startRow, startCol-1}, {startRow, startCol-2}, {startRow+1, startCol-1}}
        end
        if rotated % 4 == 2 then
            temp = { liveObject[1], {startRow + 1, startCol}, {startRow+2, startCol}, {startRow+1, startCol +1}}
        end
        if rotated % 4 == 3 then
            temp = { liveObject[1], {startRow, startCol-1}, {startRow, startCol-2}, {startRow-1, startCol-1}}
        end
    elseif shapeType == 4 then
        local startRow = liveObject[1][1]
        local startCol = liveObject[1][2]
        if rotated % 4 == 0 then
            temp = { liveObject[1], {startRow - 1, startCol}, {startRow-2, startCol}, {startRow-2, startCol-1}}
        end
        if rotated % 4 == 1 then
            temp = { liveObject[1], {startRow, startCol-1}, {startRow, startCol-2}, {startRow+1, startCol-2}}
        end
        if rotated % 4 == 2 then
            temp = { liveObject[1], {startRow + 1, startCol}, {startRow+2, startCol}, {startRow+2, startCol +1}}
        end
        if rotated % 4 == 3 then
            temp = { liveObject[1], {startRow, startCol+1}, {startRow, startCol+2}, {startRow-1, startCol+2}}
        end
    end

    local legal = true
    for _, pair in ipairs(temp) do
        local i = pair[1]
        local j = pair[2]
        if nextCellLegal(i, j) == false then
            legal = false
        end
    end
    if legal == true then
        rotated = rotated + 1
        liveObject = temp
    end
end

function drawSquare(i, j)
    local xPixels = (j - 1) * cellWidth
    local yPixels = (i - 1) * cellHeight
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.rectangle("fill", xPixels, yPixels, cellWidth, cellHeight)
    love.graphics.setColor(0, 0, 0, 1)
    love.graphics.rectangle("line", xPixels, yPixels, cellWidth, cellHeight)
end

function drawGrid()
    love.graphics.setColor(1, 1, 1, 1)
    for col = 0, 10 do
        love.graphics.line(col * cellWidth + 0.5, 0, col * cellWidth + 0.5, love.graphics.getHeight())
    end

    for row = 0, 20 do
        love.graphics.line(0, row * cellHeight + 0.5, love.graphics.getWidth(), row * cellHeight + 0.5)
    end
    for i = 1, rows do
        for j = 1, columns do
            if grid[i][j] == 1 then
                drawSquare(i, j)
            end
        end
    end
end

function nextCellLegal(i, j) 
    if i < 1 or i > rows then
        return false
    end
    if j < 1 or j > columns then
        return false
    end
    if grid[i][j] == 1 then
        return false
    end
    return true
end

function randomInt(min, max)
    return math.floor(math.random() * (max - min + 1)) + min
end

function newLiveObject()
    local possibleShapes = {
        {{1, 4}, {1, 5}, {1, 6}, {1, 7}},
        {{1, 4}, {1, 5}, {2, 4}, {2, 5}},
        {{2, 4}, {2, 5}, {2, 6}, {1, 5}},
        {{2, 4}, {2, 5}, {2, 6}, {1, 6}},
    }
    rotated = 0
    shapeType = randomInt(1,#possibleShapes)
    return possibleShapes[shapeType]
end

function getFullRows(arr) 
  local result = {}
  for i = 1, rows do
      local counter = 0
      for j = 1, columns do
          counter = counter + arr[i][j]
      end
      if counter == 10 then
        table.insert(result, i)
      end
  end
  return result
end

function findInArray(arr, target)
  local founds = false
  for _, vals in ipairs(arr) do
      if vals == target then
          founds = true
          break
      end
  end
  return founds
end

function emptyRow()
  local res = {}
  for j = 1, columns do
    res[j] = 0
  end
  return res
end

function createEmptyGrid()
  local res = {}
  for i = 1, rows do
    res[i] = {}
    for j = 1, columns do
        res[i][j] = 0
    end
  end
  return res
end

function copyRow(src, srcRow, dest, destRow)
    print(srcRow, destRow)
    local row = src[srcRow]
    dest[destRow] = {}
    for _, value in ipairs(row) do
        table.insert(dest[destRow], value)
    end
end

function progressLiveObject(di, dj, final)
    local legalUpdate = true
    local gameOver = false
    for i, pair in ipairs(liveObject) do
        local i = pair[1]
        local j = pair[2]
        if nextCellLegal(i + di, j + dj) == false then
            legalUpdate = false
            if i == 2 then
                gameOver = true
            end
        end
    end
    if gameOver then
        gameMode = 2
        love.audio.stop(backgroundMusic)
        love.audio.play(gameOverSound)
        initializeAllVariables()
        return
    end
    if legalUpdate == false and final == true then
        for _, pair in ipairs(liveObject) do
            local i = pair[1]
            local j = pair[2]
            grid[i][j] = 1
        end
        local fullRows = getFullRows(grid)
        if #fullRows > 0 then
        love.audio.play(blockDestroySoundEffect)
          print(#fullRows)
          for _, value in ipairs(fullRows) do
              print(value)
          end
          local newGrid = createEmptyGrid()
          local currRow = 20
          for i = rows, 1, -1 do
            if findInArray(fullRows, i) == false  then
              copyRow(grid, i, newGrid, currRow)
              currRow = currRow - 1
            end
          end
          for i=1, rows do
             copyRow(newGrid, i, grid, i)
          end 
        end
        liveObject = newLiveObject()
    elseif legalUpdate == true then
        for i, pair in ipairs(liveObject) do
            pair[1] = pair[1] + di
            pair[2] = pair[2] + dj
        end
    end
end