npc script G3_Example1
{
	using namespace ghost3;
	using namespace ghost3::flags;
	void run()
	{
		eweapon particle = CreateDummyEWeapon(EW_SCRIPT1, 0, 0, 32, 0, EWF_NO_COLLISION);
		SetEWeaponLifespan(particle, EWL_TIMER, 15);
		SetEWeaponDeathEffect(particle, EWD_VANISH, -1);
		particle->Misc[GWDM_FREQ] = 4;
		int shotcounter;
		int internal[8];
		GhostInit(this, internal);
		while(true)
		{
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
					e->Misc[GWM_PARTICLEUID] = particle->UID;
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
						e->Misc[GWM_INITMISC1] = 180;
						repeat(5) Ghost_Waitframe(this, GHD_EXPLODE, true);
					}
				}
			}
			Ghost_Waitframe(this, GHD_EXPLODE, true);
		}
	}
}

//FireEWeapon(int weaponID, int x, int y, float angle, int step, int damage, int sprite, int sound, int flags);