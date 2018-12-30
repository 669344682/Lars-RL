texture gOverlay;

technique TexOverlay
{
	pass P0
	{
	
	}
	
	pass P1
	{		
		Texture[0] = gOverlay;		
		AlphaBlendEnable = TRUE;
		SrcBlend = SRCALPHA;
		DestBlend = INVSRCALPHA;
	}
}