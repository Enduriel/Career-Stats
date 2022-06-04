::mods_hookBaseClass("skills/skill", function (o)
{
	o = o[o.SuperName];

	local attackEntity = o.attackEntity;
	o.attackEntity = function( _user, _targetEntity, _allowDiversion = true )
	{
		::CareerStats.ActiveUser = _user;
		::CareerStats.ActiveTarget = _targetEntity;
		attackEntity(_user, _targetEntity, _allowDiversion = true)
		::CareerStats.ActiveUser = null;
		::CareerStats.ActiveTarget = null;
	}
});
