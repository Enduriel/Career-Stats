::mods_hookBaseClass("skills/skill", function (o)
{
	o = o[o.SuperName];

	local attackEntity = o.attackEntity;
	o.attackEntity = function( ... )
	{
		::CareerStats.ActiveUser = vargv[0];
		::CareerStats.ActiveTarget = vargv[1];
		vargv.insert(0, this)
		local ret = attackEntity.acall(vargv)
		::CareerStats.ActiveUser = null;
		::CareerStats.ActiveTarget = null;
		return ret;
	}
});
