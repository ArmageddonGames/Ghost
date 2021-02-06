// ghost.zh
// Version 3.0.0 - Alpha 5

// Demo Scripts, v.3.0

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
	using namespace ghost3::flags;
	void run()
	{
		int data[ghost3::DATA_SIZE]; //Always first
		ghost3::init(this, data); //Always second
		
		eweapon fakeparticle = ghost3::CreateDummyEWeapon(EW_SCRIPT1, 0, 0, 32, 0, EWF_NO_COLLISION);
		ghost3::SetEWeaponLifespan(fakeparticle, ghost3::EWL_TIMER, 15);
		ghost3::SetEWeaponDeathEffect(fakeparticle, ghost3::EWD_VANISH, -1);
		ghost3::SetEWeaponSparkleFrequency(fakeparticle, 4);
		fakeparticle->Behind = true;
		int shotcounter;
		this->NoSlide = true;
		while(true)
		{
			ghost3::UpdateKnockback(this, 16, 4);
			++shotcounter;
			shotcounter%=((90*4)+(30*4)+30);
			if (shotcounter <= (90*4)+30)
			{
				this->ConstantWalk({this->Rate, this->Homing, 0});
				if (shotcounter % 90 == 0 && shotcounter > 0)
				{
					eweapon e = ghost3::FireAimedEWeapon(EW_FIREBALL, this->X, this->Y, 0, 200, this->WeaponDamage, -1, -1, 0);
					ghost3::SetEWeaponMovement(e, ghost3::EWM_HOMING_REAIM, 1, 45);
					ghost3::SetEWeaponLifespan(e, ghost3::EWL_TIMER, 90);
					ghost3::SetEWeaponDeathEffect(e, ghost3::EWD_4_FIREBALLS_DIAG, -1);
					ghost3::SetEWeaponSparkle(e, fakeparticle);
					ghost3::SetEWeaponAttribute(e, ghost3::GWI_PARTICLEOFFSET, 2);
				}
			}
			else
			{
				if ((shotcounter % 30) == 0)
				{
					int angle = Angle(this->X, this->Y, Hero->X, Hero->Y);
					this->Dir = AngleDir4(angle);
					angle = DegtoRad(angle);
					for(int i = 0; i < 5; ++i)
					{
						eweapon e = ghost3::FireEWeapon(EW_FIREBALL, this->X, this->Y, angle, 300, this->WeaponDamage, -1, -1, 0);
						ghost3::SetEWeaponMovement(e, ghost3::EWM_SINE_WAVE, 8, 6);
						eweapon e2 = ghost3::FireEWeapon(EW_FIREBALL, this->X, this->Y, angle, 300, this->WeaponDamage, -1, -1, 0);
						ghost3::SetEWeaponMovement(e2, ghost3::EWM_SINE_WAVE, 8, 6);
						ghost3::SetEWeaponAttribute(e2, ghost3::GWI_MISC1, 120);
						eweapon e3 = ghost3::FireEWeapon(EW_FIREBALL, this->X, this->Y, angle, 300, this->WeaponDamage, -1, -1, 0);
						ghost3::SetEWeaponMovement(e3, ghost3::EWM_SINE_WAVE, 8, 6);
						ghost3::SetEWeaponAttribute(e3, ghost3::GWI_MISC1, 240);
						repeat(5) ghost3::Ghost_Waitframe(this, ghost3::GHD_EXPLODE, true);
					}
				}
			}
			ghost3::Ghost_Waitframe(this, ghost3::GHD_EXPLODE, true);
		}
	}
}

@Author("Dimi")
npc script G3_Example2
{
	using namespace ghost3::flags;
	void run()
	{
		int data[ghost3::DATA_SIZE]; //Always first
		ghost3::init(this, data); //Always second
		
		eweapon fakeparticle = ghost3::CreateDummyEWeapon(EW_SCRIPT1, 0, 0, 97, 0, EWF_NO_COLLISION);
		ghost3::SetEWeaponLifespan(fakeparticle, ghost3::EWL_TIMER, 20);
		ghost3::SetEWeaponDeathEffect(fakeparticle, ghost3::EWD_VANISH, -1);
		ghost3::SetEWeaponSparkleFrequency(fakeparticle, 4);
		fakeparticle->Behind = true;
		int shotcounter;
		while(true)
		{
			ghost3::MoveAtAngle(this, Angle(this->X, this->Y, Hero->X, Hero->Y), this->Step/100, 2);
			++shotcounter;
			if (shotcounter % 420 == 30)
			{
				eweapon e = ghost3::FireAimedEWeapon(EW_SCRIPT1, this->X, this->Y, 0, 200, this->WeaponDamage, 96, -1, 0);
				ghost3::SetEWeaponMovement(e, ghost3::EWM_THROWCHASE, 3, 4);
				ghost3::SetEWeaponDeathEffect(e, ghost3::EWD_FIRE, -1);
				ghost3::SetEWeaponSparkle(e, fakeparticle);
			}
			ghost3::Ghost_Waitframe(this, ghost3::GHD_EXPLODE, true);
		}
	}
}

@Author("Dimi")
npc script G3_Example3
{
	using namespace ghost3::flags;
	void run()
	{
		int data[ghost3::DATA_SIZE]; //Always first
		ghost3::init(this, data); //Always second
		
		eweapon fakeparticle = ghost3::CreateDummyEWeapon(EW_SCRIPT1, 0, this->WeaponDamage, 87, 0, 0);
		ghost3::SetEWeaponLifespan(fakeparticle, ghost3::EWL_TIMER, 30);
		ghost3::SetEWeaponDeathEffect(fakeparticle, ghost3::EWD_AIM_AT_LINK, 0);
		ghost3::SetEWeaponSparkleFrequency(fakeparticle, 4);
		fakeparticle->Behind = true;
		int shotcounter;
		while(true)
		{
			this->ConstantWalk8({this->Rate, this->Homing, 0});
			++shotcounter;
			if (shotcounter % 180 == 60)
			{
				eweapon e = ghost3::FireAimedEWeapon(EW_SCRIPT1, this->X, this->Y, 0, 300, this->WeaponDamage, 98, -1, 0);
				ghost3::SetEWeaponSparkle(e, fakeparticle);
			}
			ghost3::Ghost_Waitframe(this, ghost3::GHD_SHRINK, true);
		}
	}
}

@Author("Dimi")
npc script G3_Example4
{
	using namespace ghost3::flags;
	void run()
	{
		int data[ghost3::DATA_SIZE]; //Always first
		ghost3::init(this, data); //Always second
		
		int shotcounter;
		while(true)
		{
			this->ConstantWalk8({this->Rate, this->Homing, 0});
			++shotcounter;
			if (shotcounter % 60 == 30)
			{
				eweapon e = ghost3::FireAimedEWeapon(EW_SCRIPT1, this->X, this->Y, DegtoRad(180)+Rand(-0.4, 0.4), 200, this->WeaponDamage, 13, -1, 0);
				ghost3::SetEWeaponMovement(e, ghost3::EWM_VEER, ghost3::AngleDir8(this->X, this->Y, Hero->X, Hero->Y), 0.07);
			}
			ghost3::Ghost_Waitframe(this, ghost3::GHD_NONE, true);
		}
	}
}

@Author("Dimi")
npc script G3_Example5
{
	using namespace ghost3::flags;
	void run()
	{
		int data[ghost3::DATA_SIZE]; //Always first
		ghost3::init(this, data); //Always second
		
		int shotcounter;
		while(true)
		{
			this->HaltingWalk({this->Rate, this->Homing, 0, this->Haltrate, 60});
			if (this-> Halt == 20)
			{
				eweapon e = ghost3::FireAimedEWeapon(EW_SCRIPT1, this->X, this->Y, 0, this->Attributes[6], this->WeaponDamage, this->WeaponSprite, -1, 0);
				int flags = ghost3::EWMF_DIE;
				if (this->Attributes[9] == 1 || this->Attributes[9] == 3) flags |= ghost3::EWMF_SPEEDBOUNCE;
				if (this->Attributes[9] == 2 || this->Attributes[9] == 3) flags |= ghost3::EWMF_SLOWBOUNCE;
				if (this->Attributes[8] == 1) flags |= ghost3::EWMF_SCALEUP;
				if (this->Attributes[8] == 2) flags |= ghost3::EWMF_SCALEDOWN;
				ghost3::SetEWeaponMovement(e, ghost3::EWM_WALLBOUNCE, this->Attributes[7], flags);
				ghost3::SetEWeaponDeathEffect(e, ghost3::EWD_SBOMB_EXPLODE, this->WeaponDamage*2);
			}
			ghost3::Ghost_Waitframe(this, ghost3::GHD_NONE, true);
		}
	}
}
	
// Temp Functions
namespace ghost3
{

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

	void UpdateKnockback(npc this, int frames, int speed)
	{
		this->NoSlide = true;
		if (GotHit(this))
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

	//FireEWeapon(int weaponID, int x, int y, float angle, int step, int damage, int sprite, int sound, int flags);
}