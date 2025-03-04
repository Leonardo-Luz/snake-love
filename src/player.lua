local INCREASE_RATE = 1

PAUSED = 0
UP = 1
RIGHT = 2
DOWN = 3
LEFT = 4

local player = {
	direc = PAUSED,
	head = {
		x = 0,
		y = 0,
	},
	body = {},
}

local M = {}

M.getBody = function()
	return player.body
end

M.getHead = function()
	return player.head
end

M.getDirec = function()
	return player.direc
end

M.setDirec = function(direc)
	if
		(M.getDirec() == UP and direc == DOWN)
		or (M.getDirec() == RIGHT and direc == LEFT)
		or (M.getDirec() == DOWN and direc == UP)
		or (M.getDirec() == LEFT and direc == RIGHT)
	then
		return
	end

	player.direc = direc
end

M.setPos = function(tile, x, y)
	tile.x = x
	tile.y = y
end

M.increase = function()
	local new = {
		x = player.head.x,
		y = player.head.y,
	}

	table.insert(player.body, new)
end

M.autoHit = function()
	for _, part in pairs(player.body) do
		if player.head.x == part.x and player.head.y == part.y then
			love.event.quit()
			return
		end
	end
end

M.hitBoundaries = function()
	local x, y, w, h = love.window.getSafeArea()

	if player.head.x < x then
		player.head.x = w
	elseif player.head.x > w then
		player.head.x = x
	elseif player.head.y < y then
		player.head.y = h
	elseif player.head.y > h then
		player.head.y = y
	end
end

M.move = function()
	local before = {
		x = player.head.x,
		y = player.head.y,
	}

	for _, part in pairs(player.body) do
		local aux = {
			x = part.x,
			y = part.y,
		}

		M.setPos(part, before.x, before.y)

		before = {
			x = aux.x,
			y = aux.y,
		}
	end

	if M.getDirec() == UP then
		M.setPos(player.head, player.head.x, player.head.y - TILE_SIZE)
	elseif M.getDirec() == RIGHT then
		M.setPos(player.head, player.head.x + TILE_SIZE, player.head.y)
	elseif M.getDirec() == DOWN then
		M.setPos(player.head, player.head.x, player.head.y + TILE_SIZE)
	elseif M.getDirec() == LEFT then
		M.setPos(player.head, player.head.x - TILE_SIZE, player.head.y)
	end
end

M.draw = function()
	love.graphics.setColor(0.6, 0.5, 0.5)
	love.graphics.rectangle("fill", player.head.x + TILE_SIZE, player.head.y + TILE_SIZE, TILE_SIZE, TILE_SIZE)

	for _, part in pairs(player.body) do
		love.graphics.setColor(0, 0.8, 0.8)
		love.graphics.rectangle("fill", part.x + TILE_SIZE, part.y + TILE_SIZE, TILE_SIZE, TILE_SIZE)
	end
end

return M
