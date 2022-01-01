local Vertex = require 'vertex'
local Edge = require 'edge'
local Triangle = require 'triangle'

--https://en.wikipedia.org/wiki/Bowyer%E2%80%93Watson_algorithm
function BowyerWatson(pointList)
	local triangulation = {}

	local minX, minY = bit.lshift(1,28), bit.lshift(1, 28)
	local maxX, maxY = -minX, -minY
	for i = 1, #pointList do
		local v = pointList[i]

		if v.x > maxX then
			maxX = v.x
		end
		if v.y > maxY then
			maxY = v.y
		end
		if v.x < minX then
			minX = v.x
		end
		if v.y < minY then
			minY = v.y
		end
	end

	local superTriangle = Triangle:new(
		Vertex:new(minX - 1000, minY - 1000),
		Vertex:new(maxX + 1000, minY - 1000),
		Vertex:new((maxX - minX) / 2, maxY + 1000)
	)
	table.insert(triangulation, superTriangle)

	for i = 1, #pointList do
		local point = pointList[i]

		local badTriangles = {}
		for j = 1, #triangulation do
			local triangle = triangulation[j]
			if triangle:inCircumcircle(point) then
				table.insert(badTriangles, triangle)
			end
		end

		local polygon = {}
		for j = 1, #badTriangles do
			local triangle = badTriangles[j]
			local edges = triangle:getEdges()

			for k = 1, #edges do
				local success = true
				-- this is gross
				for l = 1, #badTriangles do
					if triangle ~= badTriangles[l] then
						local tempEdges = badTriangles[l]:getEdges()
						for m = 1, #tempEdges do
							if (tempEdges[m].v1 == edges[k].v1 and tempEdges[m].v2 == edges[k].v2) or (tempEdges[m].v2 == edges[k].v1 and tempEdges[m].v1 == edges[k].v2) then
								success = false
							end
						end
					end
				end
				if success then
					table.insert(polygon, edges[k])
				end
			end
		end
		for j = 1, #badTriangles do
			for k = #triangulation, 1, -1 do
				if triangulation[k] == badTriangles[j] then
					table.remove(triangulation, k)
				end
			end
		end
		for j = 1, #polygon do
			local e = polygon[j]
			local newTri = Triangle:new(e.v1, e.v2, point)
			table.insert(triangulation, newTri)
		end
	end

	for i = #triangulation, 1, -1 do
		local triangle = triangulation[i]
		local vertices = triangle:getVertices()

		for j = 1, #vertices do
			if vertices[j] == superTriangle.v1 or vertices[j] == superTriangle.v2 or vertices[j] == superTriangle.v3 then
				table.remove(triangulation, i)
				break
			end
		end
	end

	return triangulation
end

function love.load()
	local rand = love.math.random
	local screenWidth = love.graphics.getWidth()
	local screenHeight = love.graphics.getHeight()
	points = {}
	Delaunay = points
end

function love.draw()
	if #points < 3 then
		for i = 1, #points do
			love.graphics.circle('fill', points[i].x, points[i].y, 3)
		end
	end

	for i = 1, #Delaunay do
		local t = Delaunay[i]
		t:draw()
	end
end

function love.mousepressed(x, y, button)
	if button == 1 then
		points[#points+1] = Vertex:new(x, y)
		Delaunay = BowyerWatson(points)
	end
end