#include "hl_weapons/weapon_hlmp5"
#include "point_checkpoint"
const bool disableSurvival = false;

void unoptimistic(CBaseEntity@ pActivator, CBaseEntity@ pCaller, USE_TYPE useType, float flValue){
	pActivator.TakeDamage(@pCaller.pev, @pCaller.pev, 999.0f, DMG_CRUSH);
}
HookReturnCode Chat(SayParameters@ pParams){
	CBasePlayer@ pPlayer = pParams.GetPlayer();
 	const CCommand@ args = pParams.GetArguments();	
	if(pPlayer.IsPlayer() && args[0]!="")g_SoundSystem.PlaySound(pPlayer.edict(), CHAN_VOICE, "hq/misc/talk.wav", 1, ATTN_NONE);
	return HOOK_CONTINUE;
}
HookReturnCode SadismSword(DamageInfo@ pDamageInfo){ // This looks very ineficient and awful, but I don't see in docs any other way to check active weapon on CBasePlayer
	CBaseEntity@ wep = cast<CBaseEntity>(cast<CBasePlayer>(pDamageInfo.pVictim).m_hActiveItem.GetEntity()); // Game has enums for WeaponIds, but I don't see in .pev anything that would make use of it
	if(string(wep.GetClassname())=="weapon_crowbar" && pDamageInfo.flDamage>0 && pDamageInfo.flDamage<100)pDamageInfo.flDamage=0;
	return HOOK_CONTINUE;
}
void MapInit(){
	g_Module.ScriptInfo.SetAuthor("Zorik");
	g_SoundSystem.PrecacheSound("hq/misc/talk.wav");
	g_Hooks.RegisterHook(Hooks::Player::ClientSay, @Chat);
	g_Hooks.RegisterHook(Hooks::Player::PlayerTakeDamage, @SadismSword);
	RegisterHLMP5();
}
void MapActivate(){
	if(disableSurvival)g_SurvivalMode.Disable();
}
