local class = require 'middleclass'

local Vertex = class('Vertex')

function Vertex:initialize(x, y)
	self.x, self.y = x, y
end

function Vertex:getX()
	return x
end

function Vertex:getY()
	return y
end

function Vertex:setPosition(x, y)
	self.x, self.y = x, y
end

function Vertex:getSquared()
	return self.x * self.x + self.y * self.y
end

return Vertex