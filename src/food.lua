local player = require('src.player')
local foods = {}

SPAWN_RATE = 5
MAX_FOODS = 3

local M = {}

M.spawn = function()
	local new
	local _, _, w, h = love.window.getSafeArea()

	::continue::

	local x = math.ceil(math.random(w) - 20)
	local y = math.ceil(math.random(h) - 20)

	new = {
		x = x - x % 20,
		y = y - y % 20,
	}

	for _, food in pairs(foods) do
		if food.x == new.x and food.y == new.y then
			goto continue
		end
	end

	if player.getHead().x == new.x and player.getHead().y == new.y then
		goto continue
	end

	for _, part in pairs(player.getBody()) do
		if part.x == new.x and part.y == new.y then
			goto continue
		end
	end

	table.insert(foods, new)
end

M.consume = function()
	for _, pos in pairs(M.getFoods()) do
		if player.getHead().x == pos.x and player.getHead().y == pos.y then
			player.increase()
			M.remove(pos.x, pos.y)
		end
	end
end


M.remove = function(x, y)
	local remove

	for key, food in pairs(foods) do
		if food.x == x and food.y == y then
			remove = key
		end
	end

	if not remove then
		return
	end

	table.remove(foods, remove)
end

M.getFoods = function()
	return foods
end

M.draw = function()
	for _, food in pairs(foods) do
		love.graphics.setColor(0, 1, 0.5)
		love.graphics.rectangle("fill", food.x + TILE_SIZE, food.y + TILE_SIZE, TILE_SIZE, TILE_SIZE)
	end
end

return M
