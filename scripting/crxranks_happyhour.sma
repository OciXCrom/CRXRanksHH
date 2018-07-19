#include <amxmodx>
#include <crxranks>

#define PLUGIN_VERSION "1.0"

new bool:g_bHappyHour, g_pStart, g_pEnd, g_pMultiplier, g_iMultiplier

public plugin_init()
{
	register_plugin("CRXRanks: Happy Hour", PLUGIN_VERSION, "OciXCrom")
	register_cvar("CRXRanksHH", PLUGIN_VERSION, FCVAR_SERVER|FCVAR_SPONLY|FCVAR_UNLOGGED)
	register_logevent("OnRoundStart", 2, "0=World triggered", "1=Round_Start")
	g_pStart = register_cvar("crxranks_hh_start", "20")
	g_pEnd = register_cvar("crxranks_hh_end", "23")
	g_pMultiplier = register_cvar("crxranks_hh_multiplier", "2")
}

public plugin_cfg()
	OnRoundStart()

public OnRoundStart()
{
	g_iMultiplier = get_pcvar_num(g_pMultiplier)
	g_bHappyHour = is_happy_hour(get_pcvar_num(g_pStart), get_pcvar_num(g_pEnd))
}

public crxranks_user_receive_xp(id, iXP, CRXRanks_XPSources:iSource)
{
	if(g_bHappyHour && iSource == CRXRANKS_XPS_REWARD)
		return iXP * g_iMultiplier
		
	return CRXRANKS_CONTINUE
}

bool:is_happy_hour(const iStart, const iEnd)
{
    static iHour; time(iHour)
    return bool:(iStart < iEnd ? (iStart <= iHour < iEnd) : (iStart <= iHour || iHour < iEnd))
}