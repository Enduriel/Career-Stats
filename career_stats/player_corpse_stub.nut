::mods_hookNewObject("entity/tactical/player_corpse_stub", function (o)
{
	o.m.CareerStats_Stats <- null;

	local getRosterTooltip = o.getRosterTooltip;
	o.getRosterTooltip = function( ... )
	{
		vargv.insert(0, this);
		local ret = getRosterTooltip.acall(vargv);
		if (this.m.CareerStats_Stats != null) this.m.CareerStats_Stats.extendTooltip(ret, 4);
		return ret;
	}
});
