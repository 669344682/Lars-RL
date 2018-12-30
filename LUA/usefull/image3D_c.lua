--
-- file: c_image3D_manual.lua
-- version: v1.51
-- author: Ren712
-- This class allows creation of screen space dxImages in 3d world space.
--

local scx,scy = guiGetScreenSize ()
    
CImg3DMan = { }
CImg3DMan.__index = CImg3DMan
     
function CImg3DMan: create()
	local scX, scY = guiGetScreenSize()
	local cShader = {
		shader = dxCreateShader( "files/shaders/image3D.fx" ),
		color = tocolor(255, 255, 255, 255),
		texCoord = {Vector2(1, 1),Vector2(0, 0)},
		position = Vector3(0, 0, 0),
		rotation = Vector3(0,0,0),
		texture = nil,
		size = Vector2(0,0),
		billboard = false,
		flipVertex = false,
		cullMode = 1
	}
	if cShader.shader then
		-- screen resolution also to scale image size and proportions to 1x1 world unit
		cShader.shader:setValue( "sScrRes", {scX, scY} )
		-- pass position and a forward vector to recreate gWorld matrix
		cShader.shader:setValue( "sElementRotation", 0, 0, 0)
		cShader.shader:setValue( "sElementPosition", 0, 0, 0 )
		cShader.shader:setValue( "sElementSize", 0, 0 )
		cShader.shader:setValue( "sFlipTexture", false )
		cShader.shader:setValue( "sFlipVertex", cShader.flipVertex )
		cShader.shader:setValue( "sIsBillboard", cShader.billboard )
		cShader.shader:setValue( "uvMul", cShader.texCoord[1].x, cShader.texCoord[1].y )
		cShader.shader:setValue( "uvPos", cShader.texCoord[2].x, cShader.texCoord[2].y )
		cShader.shader:setValue( "fCullMode", cShader.cullMode )	
		-- recreate gProjection
		local fov = ({getCameraMatrix()})[8]
		cShader.shader:setValue( "sFov", math.rad( fov ) )
		cShader.shader:setValue( "sClip", getNearClipDistance(), getFarClipDistance() )
		cShader.shader:setValue( "sFarClipMultiplier", 1 )
		
		self.__index = self
		setmetatable( cShader, self )
		return cShader
	else
		outputDebugString('CImg3DMan:Create error')
		return false
	end
end

function CImg3DMan: setScreenRes( resX,resY )
	if self.shader then
		self.texture = texture
		self.shader:setValue( "sScrRes", resX,resY )
	end
end

function CImg3DMan: setTexture( texture )
	if self.shader then
		self.texture = texture
		self.shader:setValue( "sTexColor", self.texture )
	end
end

function CImg3DMan: setCullMode( cull )
	if self.shader then
		self.cullMode = cull
		self.shader:setValue( "fCullMode", cull )
	end
end

function CImg3DMan: setFlipVertex( flip )
	if self.shader then
		self.flipVertex = flip
		self.shader:setValue( "sFlipVertex", flip )
	end
end

function CImg3DMan: setPosition( pos )
	if self.shader then
		self.position = pos
		self.shader:setValue( "sElementPosition", pos.x, pos.y, pos.z )
	end
end

-- rotation order "ZXY"
function CImg3DMan: setRotation( rot )
	if self.shader then
		self.rotation = rot
		self.shader:setValue( "sElementRotation", math.rad( rot.x ), math.rad( rot.y ), math.rad( rot.z ))
	end
end

function CImg3DMan: setSize( siz )
	if self.shader then
		self.size = siz
		self.shader:setValue( "sElementSize", siz.x, siz.y )
	end
end

function CImg3DMan: setTexCoord( uvMul, uvPos )
	if self.shader then
		self.texCoord = { uvMul, uvPos }		
		self.shader:setValue( "uvMul", uvMul.x, uvMul.y )
		self.shader:setValue( "uvPos", uvPos.x, uvPos.y )
	end
end

function CImg3DMan: setBillboard( isBill )
	if self.shader then
		self.billboard = isBill
		self.shader:setValue( "sIsBillboard", self.billboard )
	end
end

function CImg3DMan: setColor( col )
	if self.shader then
		self.color = tocolor( col.x, col.y, col.z, col.w )
	end
end

function CImg3DMan: setCameraPosition( cam )
	if self.shader then	
		self.shader:setValue( "sCameraPosition", cam.x, cam.y, cam.z )
	end
end

function CImg3DMan: setCameraForward( dir )
	if self.shader then
		self.shader:setValue( "sCameraForward", dir.x, dir.y, dir.z )
	end
end

function CImg3DMan: setCameraUp( dir )
	if self.shader then
		self.shader:setValue( "sCameraUp", dir.x, dir.y, dir.z )
	end
end

function CImg3DMan: setFovAspect( aspect )
	if self.shader then	
		self.shader:setValue( "sAspect", aspect )
	end
end

function CImg3DMan: setBillboard( sIsBillboard )
	if self.shader then	
		self.shader:setValue( "sIsBillboard", sIsBillboard )
	end
end

	
function CImg3DMan: setClipDistance( nearC, farC )
	if self.shader then	
		self.shader:setValue( "sClip", nearC, farC )
	end
end

function CImg3DMan: setFOV( fov )
	if self.shader then	
		self.shader:setValue( "sFov", math.rad( fov ) )
	end
end	

function CImg3DMan: draw()
	if self.shader then
		-- draw the outcome
		dxDrawImage( 0, 0, scx, scy, self.shader, 0, 0, 0, self.color )	
	end
end

function CImg3DMan: export()
	if self.shader then
		return self.shader
	end
end
   
function CImg3DMan: destroy()
	if self.shader then
		destroyElement( self.shader )
	end
	self = nil
end
