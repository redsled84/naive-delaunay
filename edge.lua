local class = require 'middleclass'
local Edge = class('Edge')

function Edge:initialize(a, b)
	self.v1, self.v2 = a, b
end

function Edge:setVertices(a, b)
	self.v1, self.v2 = a, b
end

function Edge:getWeight()
	return math.sqrt(math.pow(self.v1.x - self.v2.x, 2) +
		math.pow(self.v1.y - self.v2.y, 2))
end

function Edge:getVertices()
	return self.v1, self.v2
end

return Edge