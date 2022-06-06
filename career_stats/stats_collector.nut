::mods_hookExactClass("skills/special/stats_collector", function (o)
{
	local onTargetHit = o.onTargetHit;
	// _skill, _targetEntity, _bodyPart, _damageInflictedHitpoints, _damageInflictedArmor
	o.onTargetHit = function( ... )
	{
		vargv.insert(0, this);
		local ret = onTargetHit.acall(vargv);
		local careerStats = this.getContainer().getActor().m.CareerStats_Stats.m.Stats;

		if (vargv[5] + vargv[4] > careerStats.MaxDamageAttackArmor + careerStats.MaxDamageAttackHitpoints)
		{
			careerStats.MaxDamageAttackArmor = vargv[5];
			careerStats.MaxDamageAttackHitpoints = vargv[4];
		}

		if (vargv[5] > careerStats.MaxDamageArmor)
		{
			careerStats.MaxDamageArmor = vargv[5];
		}
		if (vargv[4] > careerStats.MaxDamageHitpoints)
		{
			careerStats.MaxDamageHitpoints;
		}

		if (vargv[3] == ::Const.BodyPart.Head) ++careerStats.NumHeadHits;
		++careerStats.NumHits;
		return ret;
	}
});
