::mods_hookExactClass("entity/tactical/player", function (o)
{
	o.m.CareerStats_Stats <- null;

	local create = o.create;
	o.create = function()
	{
		create();
		this.m.CareerStats_Stats = ::new("scripts/mods/career_stats/career_stats");
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
	o.onBeforeCombatResult = function()
	{
		onBeforeCombatResult();
		this.CareerStats_updateCombatStats();
	}

	local getRosterTooltip = o.getRosterTooltip;
	o.getRosterTooltip = function()
	{
		local ret = getRosterTooltip();
		this.m.CareerStats_Stats.extendTooltip(ret, 6);
		return ret;
	}

	local onDeath = o.onDeath;
	o.onDeath = function( _killer, _skill, _tile, _fatalityType )
	{
		onDeath(_killer, _skill, _tile, _fatalityType);
		if (!this.isGuest())
		{
			this.m.CareerStats_Stats.clearRanks();
			::Tactical.getCasualtyRoster().getAll()[::Tactical.getCasualtyRoster().getAll().len() - 1].m.CareerStats_Stats = this.m.CareerStats_Stats;
		}
		if (!this.m.IsGuest && !this.Tactical.State.isScenarioMode() && _fatalityType != this.Const.FatalityType.Unconscious && (_skill != null && _killer != null || _fatalityType == this.Const.FatalityType.Devoured || _fatalityType == this.Const.FatalityType.Kraken))
		{
			this.CareerStats_updateCombatStats();
		}
	}

	local onSerialize = o.onSerialize;
	o.onSerialize = function(_out)
	{
		::CareerStats.Mod.Serialization.flagSerializeBBObject("CareerStats", this.m.CareerStats_Stats, this.getFlags());
		onSerialize(_out);
	}

	local onDeserialize = o.onDeserialize;
	o.onDeserialize = function(_in)
	{
		onDeserialize(_in);
		if (::CareerStats.Mod.Serialization.isSavedVersionAtLeast("0.1.0", _in.getMetaData()))
		{
			::CareerStats.Mod.Serialization.flagDeserializeBBObject("CareerStats", this.m.CareerStats_Stats, this.getFlags());
		}
	}
});
