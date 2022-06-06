::mods_hookBaseClass("skills/skill", function (o)
{
	o = o[o.SuperName];

	local attackEntity = o.attackEntity;
	// _user, _targetEntity, _allowDiversion
	o.attackEntity = function( ... )
	{
		vargv.insert(0, this)
		::CareerStats.ActiveUser = vargv[1];
		::CareerStats.ActiveTarget = vargv[2];
		local ret = attackEntity.acall(vargv)
		::CareerStats.ActiveUser = null;
		::CareerStats.ActiveTarget = null;
		return ret;
	}
});
