local class = require 'middleclass'
local Vertex = require 'vertex'
local Edge = require 'edge'
local Triangle = class("Triangle")

function Triangle:initialize(a, b, c)
	self.v1, self.v2, self.v3 = a, b, c
	self.e1, self.e2, self.e3 = Edge:new(a, b), Edge:new(b, c), Edge:new(a, c)
end

function Triangle:setVertices(a, b, c)
	self.v1, self.v2, self.v3 = a, b, c
	self.e1, self.e2, self.e3 = Edge:new(a, b), Edge:new(b, c), Edge:new(a, c)
end

function Triangle:getVertices()
	return {self.v1, self.v2, self.v3}
end

function Triangle:getEdges()
	return {self.e1, self.e2, self.e3}
end

function Triangle:inCircumcircle(target)
	local sqrt = math.sqrt
	local pow = math.pow

	local d = 2 * (self.v1.x * (self.v2.y - self.v3.y) +
		self.v2.x * (self.v3.y - self.v1.y) +
		self.v3.x * (self.v1.y - self.v2.y))
	local centerX = (1 / d) * (self.v1:getSquared() * (self.v2.y - self.v3.y) +
		self.v2:getSquared() * (self.v3.y - self.v1.y) +
		self.v3:getSquared() * (self.v1.y - self.v2.y))
	local centerY = (1 / d) * (self.v1:getSquared() * (self.v3.x - self.v2.x) +
		self.v2:getSquared() * (self.v1.x - self.v3.x) +
		self.v3:getSquared() * (self.v2.x - self.v1.x))

	local bnot = Vertex:new(self.v2.x - self.v1.x, self.v2.y - self.v1.y)
	local cnot = Vertex:new(self.v3.x - self.v1.x, self.v3.y - self.v1.y)
	local dnot = 2 * (bnot.x * cnot.y - bnot.y * cnot.x)
	local centerXnot = (1/dnot) * (cnot.y * bnot:getSquared() - bnot.y * cnot:getSquared())
	local centerYnot = (1/dnot) * (bnot.x * cnot:getSquared() - cnot.x * bnot:getSquared())
	local radius = sqrt(centerXnot * centerXnot + centerYnot * centerYnot)

	local delta = sqrt(pow(target.x - centerX, 2) + pow(target.y - centerY, 2))

	return delta <= radius
end

function Triangle:drawCircumcircle()
	local sqrt = math.sqrt
	local pow = math.pow

	local d = 2 * (self.v1.x * (self.v2.y - self.v3.y) +
		self.v2.x * (self.v3.y - self.v1.y) +
		self.v3.x * (self.v1.y - self.v2.y))
	local centerX = (1 / d) * (self.v1:getSquared() * (self.v2.y - self.v3.y) +
		self.v2:getSquared() * (self.v3.y - self.v1.y) +
		self.v3:getSquared() * (self.v1.y - self.v2.y))
	local centerY = (1 / d) * (self.v1:getSquared() * (self.v3.x - self.v2.x) +
		self.v2:getSquared() * (self.v1.x - self.v3.x) +
		self.v3:getSquared() * (self.v2.x - self.v1.x))

	local bnot = Vertex:new(self.v2.x - self.v1.x, self.v2.y - self.v1.y)
	local cnot = Vertex:new(self.v3.x - self.v1.x, self.v3.y - self.v1.y)
	local dnot = 2 * (bnot.x * cnot.y - bnot.y * cnot.x)
	local centerXnot = (1/dnot) * (cnot.y * bnot:getSquared() - bnot.y * cnot:getSquared())
	local centerYnot = (1/dnot) * (bnot.x * cnot:getSquared() - cnot.x * bnot:getSquared())
	local radius = sqrt(centerXnot * centerXnot + centerYnot * centerYnot)

	love.graphics.circle("line", centerX, centerY, radius)
end

function Triangle:draw()
	love.graphics.setColor(0, 1, 0)
	love.graphics.line(self.v1.x, self.v1.y, self.v2.x, self.v2.y)
	love.graphics.line(self.v2.x, self.v2.y, self.v3.x, self.v3.y)
	love.graphics.line(self.v1.x, self.v1.y, self.v3.x, self.v3.y)
end

return Triangle