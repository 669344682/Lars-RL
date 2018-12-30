----------------------------------------------------
----------------------------------------------------
------ Copyright (c) 2014-2018 FirstOne Media ------
----------------------------------------------------
------ Commercial use or Copyright removal is ------
------ strictly prohibited without permission ------
----------------------------------------------------
----------------------------------------------------

local JobID					= 0

local BusRoutes = {
	"L1" => {
		{
			name			=> "SkyKea",
			shelterPos		= {x,y,z,rx,ry,rz},
			colPos			= {x,y,z,size},
		},
		{
			name			=> "Verona Mall",
			shelterPos		= {x,y,z,rx,ry,rz},
			colPos			= {x,y,z,size},
		},
		{
			name			=> "ASG-Hospital",
			shelterPos		= {x,y,z,rx,ry,rz},
			colPos			= {x,y,z,size},
		},
		{
			name			=> "Ammunation Market",
			shelterPos		= {x,y,z,rx,ry,rz},
			colPos			= {x,y,z,size},
		},
		{
			name			=> "Bank of SA",
			shelterPos		= {x,y,z,rx,ry,rz},
			colPos			= {x,y,z,size},
		},
		{
			name			=> "BurgerShot Temple",
			shelterPos		= {x,y,z,rx,ry,rz},
			colPos			= {x,y,z,size},
		},
		{
			name			=> "Tankstelle Temple",
			shelterPos		= {x,y,z,rx,ry,rz},
			colPos			= {x,y,z,size},
		},
		{
			name			=> "Friedhof Temple",
			shelterPos		= {x,y,z,rx,ry,rz},
			colPos			= {x,y,z,size},
		},
		{
			name			=> "Market-Station",
			shelterPos		= {x,y,z,rx,ry,rz},
			colPos			= {x,y,z,size},
		},
		{
			name			=> "Interglobal TV",
			shelterPos		= {x,y,z,rx,ry,rz},
			colPos			= {x,y,z,size},
		},
		{
			name			=> "Rodeo Hotel",
			shelterPos		= {x,y,z,rx,ry,rz},
			colPos			= {x,y,z,size},
		},
		{
			name			=> "BurgerShot Marina",
			shelterPos		= {x,y,z,rx,ry,rz},
			colPos			= {x,y,z,size},
		},
		{
			name			=> "SA - Flint County Grenze",
			shelterPos		= {x,y,z,rx,ry,rz},
			colPos			= {x,y,z,size},
		},
		{
			name			=> "Santa Maria Beach",
			shelterPos		= {x,y,z,rx,ry,rz},
			colPos			= {x,y,z,size},
		},
		{
			name			=> "Verona Beach Pier",
			shelterPos		= {x,y,z,rx,ry,rz},
			colPos			= {x,y,z,size},
		},
	},
	
	
	
	--
	
	
	
	"L3" => {
		{
			name			=> "Stadthalle",
			shelterPos		= {x,y,z,rx,ry,rz},
			colPos			= {x,y,z,size},
		},
		{
			name			=> "Unity-Station",
			shelterPos		= {x,y,z,rx,ry,rz},
			colPos			= {x,y,z,size},
		},
		{
			name			=> "Alhambra",
			shelterPos		= {x,y,z,rx,ry,rz},
			colPos			= {x,y,z,size},
		},
		{
			name			=> "PizzaStack Idlewood",
			shelterPos		= {x,y,z,rx,ry,rz},
			colPos			= {x,y,z,size},
		},
		{
			name			=> "Ten Green Bottles",
			shelterPos		= {x,y,z,rx,ry,rz},
			colPos			= {x,y,z,size},
		},
		{
			name			=> "Ganton",
			shelterPos		= {x,y,z,rx,ry,rz},
			colPos			= {x,y,z,size},
		},
		{
			name			=> "Ammunation Willowfield",
			shelterPos		= {x,y,z,rx,ry,rz},
			colPos			= {x,y,z,size},
		},
		{
			name			=> "Hafen",
			shelterPos		= {x,y,z,rx,ry,rz},
			colPos			= {x,y,z,size},
		},
		{
			name			=> "Gabelstapler?",
			shelterPos		= {x,y,z,rx,ry,rz},
			colPos			= {x,y,z,size},
		},
		{
			name			=> "Müllverbrennungsanlage",
			shelterPos		= {x,y,z,rx,ry,rz},
			colPos			= {x,y,z,size},
		},
		{
			name			=> "Flughafen",
			shelterPos		= {x,y,z,rx,ry,rz},
			colPos			= {x,y,z,size},
		},
	}
	
	
	
	--
	
	
	
	"L5" => {
		{
			name			=> "Verona Beach Cinema",
			shelterPos		= {x,y,z,rx,ry,rz},
			colPos			= {x,y,z,size},
		},
		{
			name			=> "ZIP Downtown",
			shelterPos		= {x,y,z,rx,ry,rz},
			colPos			= {x,y,z,size},
		},
		{
			name			=> "Glen Park",
			shelterPos		= {x,y,z,rx,ry,rz},
			colPos			= {x,y,z,size},
		},
		{
			name			=> "Coutt and Schutz",
			shelterPos		= {x,y,z,rx,ry,rz},
			colPos			= {x,y,z,size},
		},
		{
			name			=> "The Pig Pen",
			shelterPos		= {x,y,z,rx,ry,rz},
			colPos			= {x,y,z,size},
		},
		{
			name			=> "Recycling Center",
			shelterPos		= {x,y,z,rx,ry,rz},
			colPos			= {x,y,z,size},
		},
		{
			name			=> "Jefferson Church",
			shelterPos		= {x,y,z,rx,ry,rz},
			colPos			= {x,y,z,size},
		},
		{
			name			=> "County General Hospital",
			shelterPos		= {x,y,z,rx,ry,rz},
			colPos			= {x,y,z,size},
		},
		{
			name			=> "Downton Tower",
			shelterPos		= {x,y,z,rx,ry,rz},
			colPos			= {x,y,z,size},
		},
		{
			name			=> "Commerce",
			shelterPos		= {x,y,z,rx,ry,rz},
			colPos			= {x,y,z,size},
		},
		{
			name			=> "Alhambra",
			shelterPos		= {x,y,z,rx,ry,rz},
			colPos			= {x,y,z,size},
		},
		{
			name			=> "Unity-Station",
			shelterPos		= {x,y,z,rx,ry,rz},
			colPos			= {x,y,z,size},
		},
		{
			name			=> "Stadthalle",
			shelterPos		= {x,y,z,rx,ry,rz},
			colPos			= {x,y,z,size},
		},
		
	}
}