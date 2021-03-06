// import "std.zh"
// import "string.zh"
// import "ghost.zh"

// Floats around the top of the screen, kicking and firing lightning bolts at Link.
// When at half HP, he'll start dropping explosive fireballs and healing himself.
// Appears as the final boss in the demo.

const int JUL_ENEMY_ID=182;
const int JUL_FLOAT_COMBO=53;
const int JUL_MAGIC_COMBO=54;
const int JUL_KICK_COMBO_L=55; // The screen's left, Julius's right
const int JUL_KICK_COMBO_R=56;

const int JUL_BOLT_SPRITE_L=91;
const int JUL_BOLT_SPRITE_R=92;
const int JUL_BOLT_SPRITE_C=93;
const int JUL_HEAL_SPRITE=95;
const int JUL_FIREBALL_SPRITE=90;
const int JUL_DEATH_FLAME_SPRITE=94;
const int JUL_GLOW_CSET=3;

const int JUL_SFX_LIGHTNING=61;
const int JUL_SFX_HEAL=25;
const int JUL_SFX_FIREBALL=52;
const int JUL_SFX_EXPLODE=60;

const int JUL_BATTLE_MIDI=14;
const int JUL_VICTORY_MIDI=20;

const int JUL_IDX_FIREBALLS_ENABLED=0;
const int JUL_IDX_FIREBALL_TIMER=1;

ffc script Julius
{
    void run()
    {
        npc ghost;
        int maxHP;
        int attackTimer;
        int attackSelector;
        
        // Wait a moment before playing the battle music then enter from the top of the screen
        this->X=96;
        this->Y=-64;
        
        WaitNoAction(90);
        Game->PlayMIDI(JUL_BATTLE_MIDI);
        WaitNoAction(60);
        
        for(int i=0; i<80; i++)
        {
            this->Y++;
            WaitNoAction(3);
        }
        WaitNoAction(120);
        
        // Initialize
        ghost=Ghost_InitCreate(this, JUL_ENEMY_ID);
        Ghost_SetFlag(GHF_MOVE_OFFSCREEN);
        Ghost_SetFlag(GHF_IGNORE_ALL_TERRAIN);
        Ghost_SetHitOffsets(ghost, 0, 16, 16, 16);
        
        Ghost_Data=JUL_FLOAT_COMBO;
        maxHP=Ghost_HP;
        attackTimer=Rand(60, 150);
        
        // While at more than half HP, float around the top of the screen, firing
        // lightning bolts and kicking
        while(Ghost_HP>maxHP/2)
        {
            // Shoot lightning every so often
            attackTimer--;
            if(attackTimer<=0)
            {
                ShootLightning(this, ghost);
                attackTimer=Rand(60, 150);
            }
            
            // If Link is down low, and Julius is a bit to the side and moving toward him, kick,
            // then shoot lightning immediately afterward
            if(Link->Y>=Ghost_Y+40)
            {
                if(Ghost_Vx<0 && Abs(Ghost_X-(Link->X+16))<4) // Left
                {
                    Kick(this, ghost, DIR_LEFT);
                    ShootLightning(this, ghost);
                    attackTimer=Rand(60, 150);
                }
                else if(Ghost_Vx>0 && Abs((Ghost_X+64)-Link->X)<4) // Right
                {
                    Kick(this, ghost, DIR_RIGHT);
                    ShootLightning(this, ghost);
                    attackTimer=Rand(60, 150);
                }
            }
            
            FloatAround(this);
            JulWaitframe(this, ghost);
        }
        
        // Reached half HP; start dropping fireballs
        this->Misc[JUL_IDX_FIREBALLS_ENABLED]=1;
        this->Misc[JUL_IDX_FIREBALL_TIMER]=0;
        
        // New attack pattern: choose between lightning, super kicks, and healing
        while(true)
        {
            attackTimer--;
            if(attackTimer<=0)
            {
                attackTimer=Rand(60, 150);
                attackSelector=Rand(20);
                
                if(Ghost_HP>10)
                {
                    // Heal: 1/20 chance
                    // Super kick: 7/20 chance
                    // Lightning: 12/20 chance
                    if(attackSelector==0)
                        Heal(this, ghost, maxHP);
                    else if(attackSelector<=7)
                        SuperKick(this, ghost);
                    else
                        ShootLightning(this, ghost);
                }
                // Different odds if HP is at 10 or lower
                else
                {
                    // Heal: 8/20 chance
                    // Super kick: 4/20 chance
                    // Lightning: 8/20 chance
                    if(attackSelector<=7)
                        Heal(this, ghost, maxHP);
                    else if(attackSelector<=11)
                        SuperKick(this, ghost);
                    else
                        ShootLightning(this, ghost);
                }
            }
            
            FloatAround(this);
            JulWaitframe(this, ghost);
        }
    }
    
    
    // Fire lightning bolts downward or to the sides, depending on Link's position.
    void ShootLightning(ffc this, npc ghost)
    {
        Ghost_Data=JUL_MAGIC_COMBO;
        
        // If Link is lower down on the screen, shoot three bolts downward
        if(Link->Y>=Ghost_Y+40)
        {
            FireBigEWeapon(EW_SCRIPT1, Ghost_X, Ghost_Y+32, 5*PI/6, 250, 4, JUL_BOLT_SPRITE_L, JUL_SFX_LIGHTNING, EWF_UNBLOCKABLE, 2, 1);
            FireBigEWeapon(EW_SCRIPT1, Ghost_X+24, Ghost_Y+40, PI/2, 250, 4, JUL_BOLT_SPRITE_C, 0, EWF_UNBLOCKABLE, 1, 2);
            FireBigEWeapon(EW_SCRIPT1, Ghost_X+32, Ghost_Y+32, PI/6, 250, 4, JUL_BOLT_SPRITE_R, 0, EWF_UNBLOCKABLE, 2, 1);
        }
        // Otherwise, shoot two each to the left and right
        else
        {
            FireBigEWeapon(EW_SCRIPT1, Ghost_X, Ghost_Y+8, PI, 250, 4, JUL_BOLT_SPRITE_L, JUL_SFX_LIGHTNING, EWF_UNBLOCKABLE, 2, 1);
            FireBigEWeapon(EW_SCRIPT1, Ghost_X, Ghost_Y+32, PI, 250, 4, JUL_BOLT_SPRITE_L, 0, EWF_UNBLOCKABLE, 2, 1);
            FireBigEWeapon(EW_SCRIPT1, Ghost_X+32, Ghost_Y+8, 0, 250, 4, JUL_BOLT_SPRITE_R, 0, EWF_UNBLOCKABLE, 2, 1);
            FireBigEWeapon(EW_SCRIPT1, Ghost_X+32, Ghost_Y+32, 0, 250, 4, JUL_BOLT_SPRITE_R, 0, EWF_UNBLOCKABLE, 2, 1);
        }
        
        // Hold that pose for a moment
        for(int i=0; i<45; i++)
        {
            FloatAround(this);
            JulWaitframe(this, ghost);
        }
        
        Ghost_Data=JUL_FLOAT_COMBO;
    }
    
    
    // Kick diagonally at Link, then return to the top of the screen
    void Kick(ffc this, npc ghost, int dir)
    {
        ghost->Damage+=2;
        
        // Set combo and X velocity
        if(dir==DIR_LEFT)
        {
            Ghost_Data=JUL_KICK_COMBO_L;
            Ghost_Vx=-1.5;
        }
        else // Right
        {
            Ghost_Data=JUL_KICK_COMBO_R;
            Ghost_Vx=1.5;
        }
        
        // Move downward
        Ghost_Vy=3;
        while(Ghost_Y<108)
            JulWaitframe(this, ghost);
        
        // After reaching the bottom, float back up
        ghost->Damage-=2;
        Ghost_Data=JUL_FLOAT_COMBO;
        Ghost_Vx=0;
        Ghost_Vy=-1.5;
        while(Ghost_Y>48)
            JulWaitframe(this, ghost);
    }
    
    
    // Float off the top of the screen, then kick all the way down several times.
    void SuperKick(ffc this, npc ghost)
    {
        int numKicks=Rand(4, 7);
        
        // Float upward
        while(Ghost_Y>-64)
        {
            Ghost_Vy-=0.05;
            Ghost_Vx*=0.8;
            JulWaitframe(this, ghost);
        }
        
        Ghost_Vy=0;
        Ghost_Vx=0;
        
        for(int i=0; i<60; i++)
            JulWaitframe(this, ghost);
        
        ghost->Damage+=4;
        
        for(int i=0; i<numKicks; i++)
        {
            // Randomly pick left or right
            if(Rand(2)==0) // Left
            {
                Ghost_Data=JUL_KICK_COMBO_L;
                Ghost_X=Link->X+32;
                Ghost_Vx=-2;
            }
            else // Right
            {
                Ghost_Data=JUL_KICK_COMBO_R;
                Ghost_X=Link->X-80;
                Ghost_Vx=2;
            }
            
            
            Ghost_Y=-64;
            Ghost_Vy=3.5;
            
            while(Ghost_Y<176)
            {
                // Once fully onscreen, gradually decrease X velocity
                if(Ghost_Y>0)
                    Ghost_Vx-=0.065*Sign(Ghost_Vx);
                
                // If hit, fire some lightning
                if(Ghost_GotHit())
                {
                    FireBigEWeapon(EW_SCRIPT1, Ghost_X, Ghost_Y+32, 5*PI/6, 250, 4, JUL_BOLT_SPRITE_L, JUL_SFX_LIGHTNING, EWF_UNBLOCKABLE, 2, 1);
                    FireBigEWeapon(EW_SCRIPT1, Ghost_X+24, Ghost_Y+40, PI/2, 250, 4, JUL_BOLT_SPRITE_C, 0, EWF_UNBLOCKABLE, 1, 2);
                    FireBigEWeapon(EW_SCRIPT1, Ghost_X+32, Ghost_Y+32, PI/6, 250, 4, JUL_BOLT_SPRITE_R, 0, EWF_UNBLOCKABLE, 2, 1);
                }
                
                JulWaitframe(this, ghost);
            }
            
            for(int j=0; j<45; j++)
                JulWaitframe(this, ghost);
        }
        
        // Reset and return to the top
        ghost->Damage-=4;
        Ghost_Data=JUL_FLOAT_COMBO;
        Ghost_X=96;
        Ghost_Y=-64;
        Ghost_Vy=1.5;
        Ghost_Vx=0;
        while(Ghost_Y<16)
            JulWaitframe(this, ghost);
    }
    
    
    // Restore some HP. Won't go above his initial HP.
    void Heal(ffc this, npc ghost, int maxHP)
    {
        lweapon sparkle;
        int baseCSet=Ghost_CSet;
        
        Ghost_Data=JUL_MAGIC_COMBO;
        Game->PlaySound(JUL_SFX_HEAL);
        Ghost_HP=Min(Ghost_HP+10, maxHP);
        
        for(int i=0; i<90; i++)
        {
            if(i%4<2)
                Ghost_ForceCSet(JUL_GLOW_CSET);
            else
                Ghost_CSet=baseCSet;
            
            if(i%5==0)
            {
                sparkle=Screen->CreateLWeapon(LW_SPARKLE);
                sparkle->X=Ghost_X-8+Rand(64);
                sparkle->Y=Ghost_Y-8+Rand(64);
                sparkle->UseSprite(JUL_HEAL_SPRITE);
            }
            
            FloatAround(this);
            JulWaitframe(this, ghost);
        }
        
        Ghost_CSet=baseCSet;
        Ghost_Data=JUL_FLOAT_COMBO;
    }
 
 
    // Update regular movement - float back and forth at the top of the screen.
    void FloatAround(ffc this)
    {
        // If at the edge of the movable area, head the other way
        if(Ghost_X<32)
            Ghost_Vx=Min(Ghost_Vx+0.2, 2.5);
        else if(Ghost_X>160)
            Ghost_Vx=Max(Ghost_Vx-0.2, -2.5);
        // Not at an edge, but already moving; continue moving, speed up if not at max speed
        else if(Ghost_Vx>0)
            Ghost_Vx=Min(Ghost_Vx+0.2, 2.5);
        else if(Ghost_Vx<0)
            Ghost_Vx=Max(Ghost_Vx-0.2, -2.5);
        // Not at an edge and and Vx is 0; pick a direction at random
        else if(Rand(2)==0)
            Ghost_Vx=0.2;
        else
            Ghost_Vx=-0.2;
        
        // Same deal with Y
        if(Ghost_Y<16)
            Ghost_Vy=Min(Ghost_Vy+0.1, 1.5);
        else if(Ghost_Y>32)
            Ghost_Vy=Max(Ghost_Vy-0.1, -1.5);
        else if(Ghost_Vy>0)
            Ghost_Vy=Min(Ghost_Vy+0.1, 1.5);
        else if(Ghost_Vy<0)
            Ghost_Vy=Max(Ghost_Vy-0.1, -1.5);
        else if(Rand(2)==0)
            Ghost_Vy=0.1;
        else
            Ghost_Vy=-0.1;
    }
    
    
    void JulWaitframe(ffc this, npc ghost)
    {
        // Dead yet?
        if(!Ghost_Waitframe(this, ghost, false, false))
            Die(this, ghost);
        // Still alive; are fireballs enabled?
        else if(this->Misc[JUL_IDX_FIREBALLS_ENABLED]>0)
        {
            // The lower his HP, the faster they come, up to one per 3/4 second
            this->Misc[JUL_IDX_FIREBALL_TIMER]++;
            if(this->Misc[JUL_IDX_FIREBALL_TIMER]>=Max(Ghost_HP*3, 45))
            {
                this->Misc[JUL_IDX_FIREBALL_TIMER]=0;
                eweapon fireball=FireEWeapon(EW_SCRIPT1, Rand(48, 160), Rand(32, 128), 0, 0, 0, 90, JUL_SFX_FIREBALL, EWF_SHADOW);
                SetEWeaponMovement(fireball, EWM_FALL, 192, EWMF_DIE);
                SetEWeaponDeathEffect(fireball, EWD_EXPLODE, 4);
                fireball->CollDetection=false;
            }
        }
    }
    
    
    // Show Julius's death animation and leave a Triforce piece.
    void Die(ffc this, npc ghost)
    {
        lweapon fires[15];
        lweapon explosion;
        int particleX[100];
        int particleY[100];
        int particleAngle[100];
        int particleSpeed[100];
        
        Ghost_StopFlashing();
        Game->PlayMIDI(0);
        Ghost_Vx=0;
        Ghost_Vy=0;
        Ghost_HP=1; // Keep it alive - need to remember its CSet
        
        // Spawn fires randomly over Julius's body, 5 at a time
        for(int i=0; i<3; i++)
        {
            JulFlashWaitframe(this, ghost, 90);
            
            Game->PlaySound(SFX_FIRE);
            for(int j=0; j<5; j++)
            {
                fires[5*i+j]=CreateLWeaponAt(LW_SCRIPT1, Ghost_X+4+Rand(40), Ghost_Y-16+Rand(56));
                fires[5*i+j]->UseSprite(JUL_DEATH_FLAME_SPRITE);
                fires[5*i+j]->ASpeed+=Rand(3);
                fires[5*i+j]->Extend=3;
                fires[5*i+j]->TileHeight=2;
                fires[5*i+j]->CollDetection=false;
            }
        }
        
        JulFlashWaitframe(this, ghost, 180);
        
        // Start the music and drop the Triforce piece
        Game->PlayMIDI(JUL_VICTORY_MIDI);
        item i=Screen->CreateItem(I_TRIFORCE);
        i->X=120;
        i->Y=80;
        i->Z=96;
        
        // At the same time, explode
        // First, clear the fires and erase Julius
        for(int i=0; i<15; i++)
            fires[i]->DeadState=0;
        this->Data=0;
        ghost->X=1024;
        
        // Play the sound and make the screen flash
        Game->PlaySound(JUL_SFX_EXPLODE);
        for(int i=0; i<8; i++)
        {
            Screen->Rectangle(6, 0, 0, 255, 175, 13, -1, 0, 0, 0, true, 128);
            Waitframe();
        }
        
        // Create a bunch of particles
        for(int i=0; i<100; i++)
        {
            particleAngle[i]=Rand(360);
            particleSpeed[i]=Rand(5, 20)/10;
            particleX[i]=CenterX(this)+5*VectorX(particleSpeed[i], particleAngle[i]);
            particleY[i]=CenterY(this)+5*VectorY(particleSpeed[i], particleAngle[i]);
        }
        
        // Make the particles float away
        for(int i=0; i<600; i++)
        {
            for(int j=0; j<100; j++)
            {
                particleX[j]+=VectorX(particleSpeed[j], particleAngle[j]);
                particleY[j]+=VectorY(particleSpeed[j], particleAngle[j]);
                Screen->PutPixel(6, particleX[j], particleY[j], Rand(140, 143), 0, 0, 0, 128);
            }
            Waitframe();
        }
        
        Quit();
    }
    
    
    // Waitframe used by Die(). Makes Julius flash.
    void JulFlashWaitframe(ffc this, npc ghost, int numFrames)
    {
        int baseCSet=Ghost_CSet;
        while(numFrames-->0)
        {
            if(Ghost_CSet==JUL_GLOW_CSET)
                Ghost_CSet=baseCSet;
            else
                Ghost_CSet=JUL_GLOW_CSET;
            
            Ghost_Waitframe(this, ghost, false, false);
        }
        Ghost_CSet=baseCSet;
    }
}

