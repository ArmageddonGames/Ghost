//Frame for how to handle weapon death
void WeaponDeathEffect(int type)
{
	int clk, basetile;

	switch (type)
	{
		case foo:
		{
			clk = n, where n is based on type:
			combodata c = Game->GetCombo("fooeffect");
			basetile = c->Tile; break;
		}
		//other cases for clk.
	}
	//do animation

	while(--clk>0)  
	{
		draw_tile_frame(clk, type, basetile); //this will have a switch for types and a list of tiles for the clk;
		Waitframe();
	}
  
}

void draw_tile_frame(clk, type, basetile)
{
	switch(type)
	{
		//define animations based on type, clk, and basetileoffsets
	}
}