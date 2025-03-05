local player = require("src.player")
local food = require("src.food")

TILE_SIZE = 20

function love.load()
	math.randomseed(os.time())
end

local loop = 0
local spawn = 0

function love.update(dt)
	::continue::

	loop = loop + 1

	local direc = player.getDirec()

	if love.keyboard.isDown("q") or love.keyboard.isDown("escape") then
		love.event.quit()
	end

	if love.keyboard.isDown("h") then
		direc = 4
	elseif love.keyboard.isDown("j") then
		direc = 3
	elseif love.keyboard.isDown("k") then
		direc = 1
	elseif love.keyboard.isDown("l") then
		direc = 2
	end

	local speedUp, speedDown = false, false

	if love.keyboard.isDown("u") then
		speedUp = true
	elseif love.keyboard.isDown("d") then
		speedDown = true
	end

	if loop >= player.getSpeed() then
		loop = 0

		player.setDirec(direc)

		if player.getDirec() == 0 then
			goto continue
		end

		if speedUp then
			player.setSpeed(player.getSpeed() - 1)
		end
		if speedDown then
			player.setSpeed(player.getSpeed() + 1)
		end

		spawn = spawn + 1

		if #food.getFoods() == MAX_FOODS then
			spawn = 0
		end

		if spawn == SPAWN_RATE then
			food.spawn()
			spawn = 0
		end

		player.move()
		player.autoHit()
		player.hitBoundaries()

		food.consume()
	end
end

function love.draw()
	love.graphics.setBackgroundColor(0.9, 0.9, 0.9)

	player.draw()
	food.draw()
end
