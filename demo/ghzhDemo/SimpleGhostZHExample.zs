// import "std.zh"
// import "string.zh"
// import "ghost.zh"

// A simple enemy that moves straight toward Link, periodically shooting
// fireballs off to his sides. Not much of an enemy, just a script example.
// Appears on screen 1 in the demo.

const int SGZE_ENEMY_ID=177;
const int SGZE_WALK_COMBO=40;
const int SGZE_FIRE_COMBO=44;
const int SGZE_FIREBALL_SPRITE=38;

ffc script SimpleGhostZHExample
{
    void run()
    {
        npc ghost;
        int timer;
        
        // Initialize
        ghost=Ghost_InitCreate(this, SGZE_ENEMY_ID);
        Ghost_SetFlag(GHF_NORMAL);
        Ghost_SetFlag(GHF_4WAY);
        
        Ghost_SpawnAnimationPuff(this, ghost);
        timer=Rand(120, 180);
        
        while(true)
        {
            // Fire every 2-3 seconds
            timer--;
            if(timer<=0)
            {
                timer=Rand(90, 150); // 30 frames less since it'll pause for half a second afterward
                
                // Only one plays a sound, so it's not played twice
                FireAimedEWeapon(EW_SCRIPT1, Ghost_X, Ghost_Y, 0.35, 200, 2, SGZE_FIREBALL_SPRITE, SFX_FIREBALL, 0);
                FireAimedEWeapon(EW_SCRIPT1, Ghost_X, Ghost_Y, -0.35, 200, 2, SGZE_FIREBALL_SPRITE, 0, 0);
                
                // Change combo and stop moving for a moment when firing
                Ghost_Data=SGZE_FIRE_COMBO;
                Ghost_Waitframes(this, ghost, true, true, 30);
                Ghost_Data=SGZE_WALK_COMBO;
            }
            
            Ghost_MoveTowardLink(0.25, 2);
            Ghost_Waitframe(this, ghost, true, true);
        }
    }
}   

