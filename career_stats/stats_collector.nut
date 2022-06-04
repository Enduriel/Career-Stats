::mods_hookExactClass("skills/special/stats_collector", function (o)
{
	local onTargetHit = o.onTargetHit;
	o.onTargetHit = function( _skill, _targetEntity, _bodyPart, _damageInflictedHitpoints, _damageInflictedArmor )
	{
		onTargetHit(_skill, _targetEntity, _bodyPart, _damageInflictedHitpoints, _damageInflictedArmor);
		local careerStats = this.getContainer().getActor().m.CareerStats_Stats.m.Stats;

		if (_damageInflictedArmor + _damageInflictedHitpoints > careerStats.MaxDamageAttackArmor + careerStats.MaxDamageAttackHitpoints)
		{
			careerStats.MaxDamageAttackArmor = _damageInflictedArmor;
			careerStats.MaxDamageAttackHitpoints = _damageInflictedHitpoints;
		}

		if (_damageInflictedArmor > careerStats.MaxDamageArmor)
		{
			careerStats.MaxDamageArmor = _damageInflictedArmor;
		}
		if (_damageInflictedHitpoints > careerStats.MaxDamageHitpoints)
		{
			careerStats.MaxDamageHitpoints;
		}

		if (_bodyPart == ::Const.BodyPart.Head) ++careerStats.NumHeadHits;
		++careerStats.NumHits;
	}
});
