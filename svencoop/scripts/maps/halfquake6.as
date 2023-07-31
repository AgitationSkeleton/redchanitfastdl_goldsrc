#include "hl_weapons/weapon_hlmp5"
#include "point_checkpoint"
const bool disableSurvival = false; // It is adviced to leave this one with survival enabled, since if map runs out of free cameras due to repeated deaths,
				    // "2D view" won't work again.

array<int> cams = {0, 0, 0, 0, 0, 0}; // Keeps track of what cameras are in use for 2D section. Starting from camera numbered 0, it will allocate free cameras to each player.
void hqCamera(CBaseEntity@ pActivator, CBaseEntity@ pCaller, USE_TYPE useType, float flValue){	
	//int val = pCaller.GetCustomKeyvalues().GetKeyvalue("intval").GetInteger(); // Section number is stored inside caller(info_teleport_destination) ents	
	int val=-1; //Script refuses to see custom keyvalue "intval"(line above). There's no ASCII conversion for chars nor cast<int>, so I'm gonna write like an idiot.	
	if(pCaller.pev.targetname=="p3_2d_1_tele")val=0;
	if(pCaller.pev.targetname=="p3_2d_2_tele")val=1;
	if(pCaller.pev.targetname=="p3_2d_3_tele")val=2;
	if(pCaller.pev.targetname=="p3_2d_4_tele")val=3;
	if(pCaller.pev.targetname=="p3_2d_5_tele")val=4;
	if(pCaller.pev.targetname=="p3_2d_6_tele")val=5;
	if(cams[val]>42){
		g_EngineFuncs.ClientPrintf(cast<CBasePlayer>(pActivator), print_chat, "We ran out of cameras for you. Stop dying so much! >)");
	}
	else{
		g_EntityFuncs.FireTargets("p3_2d_"+string(val+1)+"_"+string(cams[val]), pActivator, pCaller, USE_TOGGLE);
		cams[val]+=1; // val - which out of 6 subparts camera aplies to
	}
}
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
