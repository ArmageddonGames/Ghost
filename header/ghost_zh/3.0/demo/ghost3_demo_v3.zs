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
	using namespace ghost3; //Ghost is now in a namespace. You now have three options when it comes to making ghost scipts:
				//This is the first one. Putting this line means you don't have to do any annoying prefixing
				//To access ghost's internal stuff. The second option isn't shown off in this demo, but you can
				//put this line outside of any scripts to allow usage anywhere.
	void run()
	{
		int data[DATA_SIZE]; //Always first
		init(this, data); //Always second
		
		eweapon fakeparticle = CreateDummyEWeapon(EW_SCRIPT1, 0, 0, 32, 0, EWF_NO_COLLISION);
		SetEWeaponLifespan(fakeparticle, EWL_TIMER, 15);
		SetEWeaponDeathEffect(fakeparticle, EWD_VANISH, -1);
		SetEWeaponSparkleFrequency(fakeparticle, 4);
		fakeparticle->Behind = true;
		int shotcounter;
		this->NoSlide = true;
		while(true)
		{
			this->CanMove({this->Dir,1,SPW_WIZZROBE});
			this->CanMove({this->Dir,1,SPW_WIZZROBE});
			UpdateKnockback(this, 16, 4);
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
					SetEWeaponSparkle(e, fakeparticle);
					SetEWeaponAttribute(e, GWI_PARTICLEOFFSET, 2);
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
	//This script uses the third method of ghost scripts. It doesn't have the "using" line at the beginning;
	//Instead ghost's functions and constants and etc are accessed via ghost3::(thingname)
	//This is the most annoying method, but Zoria wanted to show it off for whatever reason?
	//Personally I think it's dumb. You should do either the method shown above or the method mentioned above
	void run()
	{
		int data[ghost3::DATA_SIZE]; //Always first
		ghost3::init(this, data); //Always second
		
		eweapon fakeparticle = ghost3::CreateDummyEWeapon(EW_SCRIPT1, 0, 0, 97, 0, ghost3::EWF_NO_COLLISION);
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
	using namespace ghost3;
	void run()
	{
		int data[DATA_SIZE]; //Always first
		init(this, data); //Always second
		
		eweapon fakeparticle = CreateDummyEWeapon(EW_SCRIPT1, 0, this->WeaponDamage, 87, 0, 0);
		SetEWeaponLifespan(fakeparticle, EWL_TIMER, 30);
		SetEWeaponDeathEffect(fakeparticle, EWD_AIM_AT_LINK, 0);
		SetEWeaponSparkleFrequency(fakeparticle, 4);
		fakeparticle->Behind = true;
		int shotcounter;
		while(true)
		{
			this->ConstantWalk8({this->Rate, this->Homing, 0});
			++shotcounter;
			if (shotcounter % 180 == 60)
			{
				eweapon e = FireAimedEWeapon(EW_SCRIPT1, this->X, this->Y, 0, 300, this->WeaponDamage, 98, -1, 0);
				SetEWeaponSparkle(e, fakeparticle);
			}
			Ghost_Waitframe(this, GHD_SHRINK, true);
		}
	}
}

@Author("Dimi")
npc script G3_Example4
{
	using namespace ghost3;
	void run()
	{
		int data[DATA_SIZE]; //Always first
		init(this, data); //Always second
		
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
	//Another script that uses the tedious method. *sigh*
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

npc script G3_Example6
{
	using namespace ghost3;
	void run()
	{
		int data[DATA_SIZE]; //Always first
		init(this, data); //Always second
		while(true)
		{
			if (DoWizzrobeStuff(this, this->Step, this->Step*2, this->Homing, this->Homing, this->Rate, this->Rate, this->Haltrate, 8, 0))
			{
				this->Dir = NormalizeDir(this->Dir);
				this->OriginalTile += 40;
				this->Tile += 40;
				int angle = DirAngle(this->Dir) - 45;
				eweapon e = FireEWeapon(EW_SCRIPT1, this->X+VectorX(14, angle), this->Y+VectorY(14, angle), DegtoRad(angle), 0, this->WeaponDamage, 100, 30, EWF_ROTATE_360);
				for (int i = 0; i < 90; i+=6)
				{
					e->X = this->X+VectorX(14, angle+i);
					e->Y = this->Y+VectorY(14, angle+i);
					e->Angle = DegtoRad(angle+i);
					MoveAtAngle(this, DirAngle(this->Dir), this->Step/33, 2);
					Ghost_Waitframe(this, GHD_NONE, true);
				}
				Remove(e);
				this->OriginalTile -= 40;
				this->Tile -= 40;
			}
			Ghost_Waitframe(this, GHD_NONE, true);
		}
	}
}
	
// Temp Functions
namespace ghost3
{
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