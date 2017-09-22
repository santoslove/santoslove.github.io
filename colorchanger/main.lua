function love.load()
    state={pieceY=3,inert={{" "," "," "," "," "," "," "," "," "," "},{" "," "," "," "," "," "," "," "," "," "},{" "," "," "," "," "," "," "," "," "," "},{" "," "," "," "," "," "," "," "," "," "},{" "," "," "," "," "," "," "," "," "," "},{" "," "," "," "," "," "," "," "," "," "},{" "," "," "," "," "," "," "," "," "," "},{" ","j"," ","z","z"," "," "," "," "," "},{" ","j","o","o","z","z"," ","s"," "," "},{"o","o","s","s","z","z","i","t","s"," "},{"t","z","z","s","j","j","i","t","t"," "},{"s","l","j","j"," ","z","s","o","o","l"},{"s","s","j","l","z","z"," ","o","o","i"},{"t","s","j","l","z","j"," ","o","o","i"},{"t","t","i","l","l","j"," ","s"," ","i"},{" ","t","i"," "," "," ","j","s","s","i"},{"t","t","t","l","l","l","j","s"," ","i"},{"i","j"," ","z","o","o","t","l","l","l"}},pieceX=8,pieceRotation=2}
        
    colors = {
        [' '] = {.87, .87, .87},
        i = {.47, .76, .94},
        j = {.93, .91, .42},
        l = {.49, .85, .76},
        o = {.92, .69, .47},
        s = {.83, .54, .93},
        t = {.97, .58, .77},
        z = {.66, .83, .46},
        preview = {.75, .75, .75},
        background = {1, 1, 1},
    }

    require('colorchanger')(colors)

    pieceStructures = {
        {
            {
                {' ', ' ', ' ', ' '},
                {'i', 'i', 'i', 'i'},
                {' ', ' ', ' ', ' '},
                {' ', ' ', ' ', ' '},
            },
            {
                {' ', 'i', ' ', ' '},
                {' ', 'i', ' ', ' '},
                {' ', 'i', ' ', ' '},
                {' ', 'i', ' ', ' '},
            },
        },
        {
            {
                {' ', ' ', ' ', ' '},
                {' ', 'o', 'o', ' '},
                {' ', 'o', 'o', ' '},
                {' ', ' ', ' ', ' '},
            },
        },
        {
            {
                {' ', ' ', ' ', ' '},
                {'j', 'j', 'j', ' '},
                {' ', ' ', 'j', ' '},
                {' ', ' ', ' ', ' '},
            },
            {
                {' ', 'j', ' ', ' '},
                {' ', 'j', ' ', ' '},
                {'j', 'j', ' ', ' '},
                {' ', ' ', ' ', ' '},
            },
            {
                {'j', ' ', ' ', ' '},
                {'j', 'j', 'j', ' '},
                {' ', ' ', ' ', ' '},
                {' ', ' ', ' ', ' '},
            },
            {
                {' ', 'j', 'j', ' '},
                {' ', 'j', ' ', ' '},
                {' ', 'j', ' ', ' '},
                {' ', ' ', ' ', ' '},
            },
        },
        {
            {
                {' ', ' ', ' ', ' '},
                {'l', 'l', 'l', ' '},
                {'l', ' ', ' ', ' '},
                {' ', ' ', ' ', ' '},
            },
            {
                {' ', 'l', ' ', ' '},
                {' ', 'l', ' ', ' '},
                {' ', 'l', 'l', ' '},
                {' ', ' ', ' ', ' '},
            },
            {
                {' ', ' ', 'l', ' '},
                {'l', 'l', 'l', ' '},
                {' ', ' ', ' ', ' '},
                {' ', ' ', ' ', ' '},
            },
            {
                {'l', 'l', ' ', ' '},
                {' ', 'l', ' ', ' '},
                {' ', 'l', ' ', ' '},
                {' ', ' ', ' ', ' '},
            },
        },
        {
            {
                {' ', ' ', ' ', ' '},
                {'t', 't', 't', ' '},
                {' ', 't', ' ', ' '},
                {' ', ' ', ' ', ' '},
            },
            {
                {' ', 't', ' ', ' '},
                {' ', 't', 't', ' '},
                {' ', 't', ' ', ' '},
                {' ', ' ', ' ', ' '},
            },
            {
                {' ', 't', ' ', ' '},
                {'t', 't', 't', ' '},
                {' ', ' ', ' ', ' '},
                {' ', ' ', ' ', ' '},
            },
            {
                {' ', 't', ' ', ' '},
                {'t', 't', ' ', ' '},
                {' ', 't', ' ', ' '},
                {' ', ' ', ' ', ' '},
            },
        },
        {
            {
                {' ', ' ', ' ', ' '},
                {' ', 's', 's', ' '},
                {'s', 's', ' ', ' '},
                {' ', ' ', ' ', ' '},
            },
            {
                {'s', ' ', ' ', ' '},
                {'s', 's', ' ', ' '},
                {' ', 's', ' ', ' '},
                {' ', ' ', ' ', ' '},
            },
        },
        {
            {
                {' ', ' ', ' ', ' '},
                {'z', 'z', ' ', ' '},
                {' ', 'z', 'z', ' '},
                {' ', ' ', ' ', ' '},
            },
            {
                {' ', 'z', ' ', ' '},
                {'z', 'z', ' ', ' '},
                {'z', ' ', ' ', ' '},
                {' ', ' ', ' ', ' '},
            },
        },
    }

    gridXCount = 10
    gridYCount = 18

    state.pieceXCount = 4
    state.pieceYCount = 4

    timerLimit = 0.5

    function canPieceMove(testX, testY, testRotation)
        for x = 1, state.pieceXCount do
            for y = 1, state.pieceYCount do
                local testBlockX = testX + x
                local testBlockY = testY + y

                if pieceStructures[pieceType][testRotation][y][x] ~= ' '
                and (
                    testBlockX < 1
                    or testBlockX > gridXCount
                    or testBlockY > gridYCount
                    or state.inert[testBlockY][testBlockX] ~= ' '
                ) then
                    return false
                end
            end
        end

        return true
    end

    function newSequence()
        sequence = {}
        for pieceTypeIndex = 1, #pieceStructures do
            local position = love.math.random(#sequence + 1)
            table.insert(
                sequence,
                position,
                pieceTypeIndex
            )
        end
    end

    function newPiece()
        state.pieceX = 3
        state.pieceY = 0
        state.pieceRotation = 1
        pieceType = table.remove(sequence)

        if #sequence == 0 then
            newSequence()
        end
    end

    function reset()
        --[[
        state.inert = {}
        for y = 1, gridYCount do
            state.inert[y] = {}
            for x = 1, gridXCount do
                state.inert[y][x] = ' '
            end
        end
        --]]

        newSequence()
        --newPiece()
        pieceType = 1

        timer = 0
    end

    reset()
end

function love.update(dt)
    if true then
        return
    end
    timer = timer + dt
    if timer >= timerLimit then
        timer = timer - timerLimit

        local testY = state.pieceY + 1
        if canPieceMove(state.pieceX, testY, state.pieceRotation) then
            state.pieceY = testY
        else
            -- Add piece to state.inert
            for y = 1, state.pieceYCount do
                for x = 1, state.pieceXCount do
                    local block = pieceStructures[pieceType][state.pieceRotation][y][x]
                    if block ~= ' ' then
                        state.inert[state.pieceY + y][state.pieceX + x] = block
                    end
                end
            end

            -- Find complete rows
            for y = 1, gridYCount do
                local complete = true
                for x = 1, gridXCount do
                    if state.inert[y][x] == ' ' then
                        complete = false
                    end
                end

                if complete then
                   for removeY = y, 2, -1 do
                        for removeX = 1, gridXCount do
                            state.inert[removeY][removeX] = state.inert[removeY - 1][removeX]
                        end

                    end

                    for removeX = 1, gridXCount do
                        state.inert[1][removeX] = ' '
                    end
                end
            end

            newPiece()

            if not canPieceMove(state.pieceX, state.pieceY, state.pieceRotation) then
                reset()
            end
        end
    end
end

function love.draw()
    love.graphics.setBackgroundColor(colors.background)
    local function drawBlock(block, x, y)
        local color = colors[block]
        love.graphics.setColor(color)

        local blockSize = 20
        local blockDrawSize = blockSize - 1
        love.graphics.rectangle(
            'fill',
            (x - 1) * blockSize,
            (y - 1) * blockSize,
            blockDrawSize,
            blockDrawSize
        )
    end

    local offsetX = 2
    local offsetY = 5

    for y = 1, gridYCount do
        for x = 1, gridXCount do
            drawBlock(state.inert[y][x], x + offsetX, y + offsetY)
        end
    end

    for y = 1, state.pieceYCount do
        for x = 1, state.pieceXCount do
            local block = pieceStructures[pieceType][state.pieceRotation][y][x]
            if block ~= ' ' then
                drawBlock(block, x + state.pieceX + offsetX, y + state.pieceY + offsetY)
            end
        end
    end

    for y = 1, state.pieceYCount do
        for x = 1, state.pieceXCount do
            local block = pieceStructures[sequence[#sequence]][1][y][x]
            if block ~= ' ' then
                drawBlock('preview', x + 5, y + 1)
            end
        end
    end
end

function love.keypressed(key)
    if key == 'x' then
        local testRotation = state.pieceRotation + 1
        if testRotation > #pieceStructures[pieceType] then
            testRotation = 1
        end

        if canPieceMove(state.pieceX, state.pieceY, testRotation) then
            state.pieceRotation = testRotation
        end

    elseif key == 'z' then
        local testRotation = state.pieceRotation - 1
        if testRotation < 1 then
            testRotation = #pieceStructures[pieceType]
        end

        if canPieceMove(state.pieceX, state.pieceY, testRotation) then
            state.pieceRotation = testRotation
        end

    elseif key == 'left' then
        local testX = state.pieceX - 1

        if canPieceMove(testX, state.pieceY, state.pieceRotation) then
            state.pieceX = testX
        end

    elseif key == 'right' then
        local testX = state.pieceX + 1

        if canPieceMove(testX, state.pieceY, state.pieceRotation) then
            state.pieceX = testX
        end

    elseif key == 'c' then
        while canPieceMove(state.pieceX, state.pieceY + 1, state.pieceRotation) do
            state.pieceY = state.pieceY + 1
            timer = timerLimit
        end
    end
end
