@Author("Dimi")
ffc script cheatson
{
	void run()
	{
		Game->Cheat = 4;
	}
}

@Author("Dimi")
npc script G3_Example1
{
	using namespace ghost3;
	using namespace ghost3::flags;
	void run()
	{
		eweapon particle = CreateDummyEWeapon(EW_SCRIPT1, 0, 0, 32, 0, EWF_NO_COLLISION);
		SetEWeaponLifespan(particle, EWL_TIMER, 15);
		SetEWeaponDeathEffect(particle, EWD_VANISH, -1);
		SetEWeaponSparkleFrequency(particle, 4);
		particle->Behind = true;
		int shotcounter;
		int internal[8];
		GhostInit(this, internal);
		this->NoSlide = true;
		while(true)
		{
			Ghost_UpdateKnockback(this, 16, 4);
			++shotcounter;
			shotcounter%=((90*4)+(30*4)+30);
			if (shotcounter <= (90*4)+30)
			{
				this->ConstantWalk({this->Rate, this->Homing, 0});
				if (shotcounter % 90 == 0 && shotcounter > 0)
				{
					eweapon e = FireAimedEWeapon(EW_FIREBALL, this->X, this->Y, 0, 200, this->WeaponDamage, -1, -1, 0);
					SetEWeaponMovement(e, EWM_HOMING_REAIM, 1, 45);
					SetEWeaponLifespan(e, EWL_TIMER, 90);
					SetEWeaponDeathEffect(e, EWD_4_FIREBALLS_DIAG, -1);
					SetEWeaponSparkle(e, particle);
					SetEWeaponAttribute(e, GWI_PARTICLEOFFSET, 2);
				}
			}
			else
			{
				if (shotcounter % 30 == 0)
				{
					int angle = Angle(this->X, this->Y, Hero->X, Hero->Y);
					this->Dir = AngleDir4(angle);
					angle = DegtoRad(angle);
					for(int i = 0; i < 5; ++i)
					{
						eweapon e = FireEWeapon(EW_FIREBALL, this->X, this->Y, angle, 300, this->WeaponDamage, -1, -1, 0);
						SetEWeaponMovement(e, EWM_SINE_WAVE, 8, 6);
						eweapon e2 = FireEWeapon(EW_FIREBALL, this->X, this->Y, angle, 300, this->WeaponDamage, -1, -1, 0);
						SetEWeaponMovement(e2, EWM_SINE_WAVE, 8, 6);
						SetEWeaponAttribute(e2, GWI_MISC1, 120);
						eweapon e3 = FireEWeapon(EW_FIREBALL, this->X, this->Y, angle, 300, this->WeaponDamage, -1, -1, 0);
						SetEWeaponMovement(e3, EWM_SINE_WAVE, 8, 6);
						SetEWeaponAttribute(e3, GWI_MISC1, 240);
						repeat(5) Ghost_Waitframe(this, GHD_EXPLODE, true);
					}
				}
			}
			Ghost_Waitframe(this, GHD_EXPLODE, true);
		}
	}
}

@Author("Dimi")
npc script G3_Example2
{
	using namespace ghost3;
	using namespace ghost3::flags;
	void run()
	{
		int internal[8];
		GhostInit(this, internal);
		eweapon particle = CreateDummyEWeapon(EW_SCRIPT1, 0, 0, 97, 0, EWF_NO_COLLISION);
		SetEWeaponLifespan(particle, EWL_TIMER, 20);
		SetEWeaponDeathEffect(particle, EWD_VANISH, -1);
		SetEWeaponSparkleFrequency(particle, 4);
		particle->Behind = true;
		int shotcounter;
		while(true)
		{
			Ghost_MoveAtAngle(this, Angle(this->X, this->Y, Hero->X, Hero->Y), this->Step/100, 2);
			++shotcounter;
			if (shotcounter % 420 == 30)
			{
				eweapon e = FireAimedEWeapon(EW_SCRIPT1, this->X, this->Y, 0, 200, this->WeaponDamage, 96, -1, 0);
				SetEWeaponMovement(e, EWM_THROWCHASE, 3, 4);
				SetEWeaponDeathEffect(e, EWD_FIRE, -1);
				SetEWeaponSparkle(e, particle);
			}
			Ghost_Waitframe(this, GHD_EXPLODE, true);
		}
	}
}

@Author("Dimi")
npc script G3_Example3
{
	using namespace ghost3;
	using namespace ghost3::flags;
	void run()
	{
		int internal[8];
		GhostInit(this, internal);
		eweapon particle = CreateDummyEWeapon(EW_SCRIPT1, 0, this->WeaponDamage, 87, 0, 0);
		SetEWeaponLifespan(particle, EWL_TIMER, 30);
		SetEWeaponDeathEffect(particle, EWD_AIM_AT_LINK, 0);
		SetEWeaponSparkleFrequency(particle, 4);
		particle->Behind = true;
		int shotcounter;
		while(true)
		{
			this->ConstantWalk8({this->Rate, this->Homing, 0});
			++shotcounter;
			if (shotcounter % 180 == 60)
			{
				eweapon e = FireAimedEWeapon(EW_SCRIPT1, this->X, this->Y, 0, 300, this->WeaponDamage, 98, -1, 0);
				SetEWeaponSparkle(e, particle);
			}
			Ghost_Waitframe(this, GHD_SHRINK, true);
		}
	}
}

@Author("Dimi")
npc script G3_Example4
{
	using namespace ghost3;
	using namespace ghost3::flags;
	void run()
	{
		int internal[8];
		GhostInit(this, internal);
		int shotcounter;
		while(true)
		{
			this->ConstantWalk8({this->Rate, this->Homing, 0});
			++shotcounter;
			if (shotcounter % 60 == 30)
			{
				eweapon e = FireAimedEWeapon(EW_SCRIPT1, this->X, this->Y, DegtoRad(180)+Rand(-0.4, 0.4), 200, this->WeaponDamage, 13, -1, 0);
				SetEWeaponMovement(e, EWM_VEER, AngleDir8(this->X, this->Y, Hero->X, Hero->Y), 0.07);
			}
			Ghost_Waitframe(this, GHD_NONE, true);
		}
	}
}

@Author("Dimi")
npc script G3_Example5
{
	using namespace ghost3;
	using namespace ghost3::flags;
	void run()
	{
		int internal[8];
		GhostInit(this, internal);
		int shotcounter;
		while(true)
		{
			this->HaltingWalk({this->Rate, this->Homing, 0, this->Haltrate, 60});
			if (this-> Halt == 20)
			{
				eweapon e = FireAimedEWeapon(EW_SCRIPT1, this->X, this->Y, 0, this->Attributes[6], this->WeaponDamage, this->WeaponSprite, -1, 0);
				int flags = EWMF_DIE;
				if (this->Attributes[9] == 1 || this->Attributes[9] == 3) flags |= EWMF_SPEEDBOUNCE;
				if (this->Attributes[9] == 2 || this->Attributes[9] == 3) flags |= EWMF_SLOWBOUNCE;
				if (this->Attributes[8] == 1) flags |= EWMF_SCALEUP;
				if (this->Attributes[8] == 2) flags |= EWMF_SCALEDOWN;
				SetEWeaponMovement(e, EWM_WALLBOUNCE, this->Attributes[7], flags);
				SetEWeaponDeathEffect(e, EWD_SBOMB_EXPLODE, this->WeaponDamage*2);
			}
			Ghost_Waitframe(this, GHD_NONE, true);
		}
	}
}

int GetSlideTime(npc n)
{
	return (n->SlideClock&0xFF);
}

int GetSlideDir(npc n)
{
    return ((n->SlideClock>>8));
}  

void SetSlideDir(npc n, int newdir)
{
	if (Byte(newdir) > 3 )
	{
		printf("SetSlideDir: Direction must be 0-3. Attempted to use dir: %d\n", newdir);
		return;
	}
	int newval;
	int clk = (n->SlideClock&0xFF);
	newdir << 8;
	newval = (clk | (newdir<<8));
	n->SlideClock = newval;
}

void SetSlideTime(npc n, int newtime)
{
	if ( Word(newtime) > 255 )
	{
		printf("SetSlideTime: Direction must be 0-255. Attempted to use time: %d\n", newtime);
		return;
	}
	int newval;
	int dir = ((n->SlideClock>>8)<<8);
	newval = newtime | dir;
	n->SlideClock = newval;
}

void SetSlide(npc n, int newdir, int newtime)
{
	if ( Byte(newdir) > 3 )
	{
		printf("SetSlide: Direction must be 0-3. Attempted to use dir: %d\n", newdir);
		return;
	}
	if ( Word(newtime) > 255 )
	{
		printf("SetSlideTime: Direction must be 0-255. Attempted to use time: %d\n", newtime);
		return;
	}
	n->SlideClock = (newtime |= (newdir << 8));
}

void Ghost_UpdateKnockback(npc this, int frames, int speed)
{
	using namespace ghost3;
	this->NoSlide = true;
	if (Ghost_GotHit(this))
	{
		//this->Knockback(frames, AngleDir4(Hero->X, Hero->Y, this->X, this->Y), speed);
		if (this->HitBy[6])
		{
			lweapon hitby = Screen->LoadLWeaponByUID(this->HitBy[6]);
			if ((hitby->Dir & 2) == (this->Dir & 2))
			{
				this->Knockback(frames, hitby->Dir, speed);
			}
		}
	}
}

int AngleDir4(int x1, int y1, int x2, int y2) //Overload to do the Angle function
{
	return AngleDir4(Angle(x1, y1, x2, y2));
}
int AngleDir8(int x1, int y1, int x2, int y2) //Overload to do the Angle function
{
	return AngleDir8(Angle(x1, y1, x2, y2));
}
//FireEWeapon(int weaponID, int x, int y, float angle, int step, int damage, int sprite, int sound, int flags);