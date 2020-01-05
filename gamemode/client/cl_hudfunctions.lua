function surface.DrawTexturedRectRotatedPoint( x, y, w, h, rot, x0, y0 )

	local c = math.cos( math.rad( rot ) )
	local s = math.sin( math.rad( rot ) )

	local newx = y0 * s - x0 * c
	local newy = y0 * c + x0 * s

	surface.DrawTexturedRectRotated( x + newx, y + newy, w, h, rot )

end

function surface.DrawCenterRect(x, y, width, height)

	local newx = x - width / 2
	local newy = y - height / 2

	surface.DrawRect(newx, newy, width, height)

end

function LerpColor(t, a, b)

	local cr = (1 - t) * a.r + t * b.r
	local cg = (1 - t) * a.g + t * b.g
	local cb = (1 - t) * a.b + t * b.b
	local ca = (1 - t) * a.a + t * b.a

	return Color(cr, cg, cb, ca)

end

function surface.DrawCenterTexturedRect(x, y, width, height)

	local newx = x - width / 2
	local newy = y - height / 2

	surface.DrawTexturedRect(newx, newy, width, height)

end

function draw.Circle( x, y, radius, seg )
	local cir = {}

	table.insert( cir, { x = x, y = y, u = 0.5, v = 0.5 } )
	for i = 0, seg do
		local a = math.rad( ( i / seg ) * -360 )
		table.insert( cir, { x = x + math.sin( a ) * radius, y = y + math.cos( a ) * radius, u = math.sin( a ) / 2 + 0.5, v = math.cos( a ) / 2 + 0.5 } )
	end

	local a = math.rad( 0 ) -- This is needed for non absolute segment counts
	table.insert( cir, { x = x + math.sin( a ) * radius, y = y + math.cos( a ) * radius, u = math.sin( a ) / 2 + 0.5, v = math.cos( a ) / 2 + 0.5 } )

	surface.DrawPoly( cir )
end