
texture import_texture;

technique TexReplace
{
    pass P0
    {
        Texture[0] = import_texture;
    }
}
