::mods_hookExactClass("entity/tactical/player", function (o)
{
	o.m.CareerStats_Stats <- null;

	local create = o.create;
	o.create = function( ... )
	{
		vargv.insert(0, this);
		local ret = create.acall(vargv);
		this.m.CareerStats_Stats = ::new("scripts/mods/career_stats/career_stats");
		return ret;
	}

	o.CareerStats_updateCombatStats <- function()
	{
		this.m.CareerStats_Stats.m.Stats.DamageReceivedHitpoints += this.m.CombatStats.DamageReceivedHitpoints;
		this.m.CareerStats_Stats.m.Stats.DamageReceivedArmor += this.m.CombatStats.DamageReceivedArmor;
		this.m.CareerStats_Stats.m.Stats.DamageDealtHitpoints += this.m.CombatStats.DamageDealtHitpoints;
		this.m.CareerStats_Stats.m.Stats.DamageDealtArmor += this.m.CombatStats.DamageDealtArmor;
		++this.m.CareerStats_Stats.m.Stats.Battles;
	}

	local onBeforeCombatResult = o.onBeforeCombatResult;
	o.onBeforeCombatResult = function( ... )
	{
		vargv.insert(0, this);
		local ret = onBeforeCombatResult.acall(vargv);
		this.CareerStats_updateCombatStats();
		return ret;
	}

	local getRosterTooltip = o.getRosterTooltip;
	o.getRosterTooltip = function( ... )
	{
		vargv.insert(0, this);
		local ret = getRosterTooltip.acall(vargv);
		this.m.CareerStats_Stats.extendTooltip(ret, 6);
		return ret;
	}

	local onDeath = o.onDeath;
	// _killer, _skill, _tile, _fatalityType
	o.onDeath = function( ... )
	{
		vargv.insert(0, this);
		local ret = onDeath.acall(vargv);
		if (!this.isGuest())
		{
			this.m.CareerStats_Stats.clearRanks();
			::Tactical.getCasualtyRoster().getAll()[::Tactical.getCasualtyRoster().getAll().len() - 1].m.CareerStats_Stats = this.m.CareerStats_Stats;
		}
		if (!this.m.IsGuest && !this.Tactical.State.isScenarioMode() && vargv[4] != this.Const.FatalityType.Unconscious && (vargv[2] != null && vargv[1] != null || vargv[4] == this.Const.FatalityType.Devoured || vargv[4] == this.Const.FatalityType.Kraken))
		{
			this.CareerStats_updateCombatStats();
		}
		return ret;
	}

	local onSerialize = o.onSerialize;
	// _out
	o.onSerialize = function( ... )
	{
		::CareerStats.Mod.Serialization.flagSerializeBBObject("CareerStats", this.m.CareerStats_Stats, this.getFlags());
		vargv.insert(0, this);
		return onSerialize.acall(vargv);
	}

	local onDeserialize = o.onDeserialize;
	// _in
	o.onDeserialize = function( ... )
	{
		vargv.insert(0, this);
		local ret = onDeserialize.acall(vargv);
		if (::CareerStats.Mod.Serialization.isSavedVersionAtLeast("0.1.0", vargv[1].getMetaData()))
		{
			::CareerStats.Mod.Serialization.flagDeserializeBBObject("CareerStats", this.m.CareerStats_Stats, this.getFlags());
		}
		return ret;
	}
});
