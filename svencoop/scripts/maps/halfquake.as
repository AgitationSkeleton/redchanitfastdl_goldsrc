#include "hl_weapons/weapon_hlmp5"
#include "point_checkpoint"
const bool disableSurvival = false;

HookReturnCode Chat(SayParameters@ pParams){
	CBasePlayer@ pPlayer = pParams.GetPlayer();
 	const CCommand@ args = pParams.GetArguments();	
	if(pPlayer.IsPlayer() && args[0]!="")g_SoundSystem.PlaySound(pPlayer.edict(), CHAN_VOICE, "hq/misc/talk.wav", 1, ATTN_NONE);
	return HOOK_CONTINUE;
}
void MapInit(){
	g_Module.ScriptInfo.SetAuthor("Zorik");
	g_SoundSystem.PrecacheSound("hq/misc/talk.wav");
	g_Hooks.RegisterHook(Hooks::Player::ClientSay, @Chat);
	RegisterHLMP5();
}
void MapActivate(){
	if(disableSurvival)g_SurvivalMode.Disable();
}
