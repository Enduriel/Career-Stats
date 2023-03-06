::mods_hookNewObjectOnce("statistics/statistics_manager", function (o)
{
	local addFallen = o.addFallen;
	// _fallen
	o.addFallen = function( ... )
	{
		vargv.insert(0, this);
		local ret = addFallen.acall(vargv);
		::CareerStats.LastFallen = this.m.Fallen[0]; // because legends handles this function differently I instead rely on the fact that this.m.Fallen[0] is the latest dead character
		return ret;
	}

	local onSerialize = o.onSerialize;
	o.onSerialize = function( _out )
	{
		local fallenWithCareerStats = []
		for (local i = 0; i < this.m.Fallen.len(); ++i)
		{
			if ("CareerStats_Stats" in this.m.Fallen[i])
			{
				fallenWithCareerStats.push(i);
				this.m.Fallen[i].CareerStats_Stats.onSerialize(::CareerStats.Mod.Serialization.getSerializationEmulator("StatsFor" + i, this.m.Flags));
			}
		}
		::CareerStats.Mod.Serialization.flagSerialize("FallenWithStats", fallenWithCareerStats, this.m.Flags);
		onSerialize(_out);
	}

	local onDeserialize = o.onDeserialize;
	o.onDeserialize = function( _in )
	{
		onDeserialize(_in);
		if (::CareerStats.Mod.Serialization.isSavedVersionAtLeast("0.2.0", _in.getMetaData()))
		{
			local fallenWithCareerStats;
			if (::CareerStats.Mod.Serialization.isSavedVersionAtLeast("1.0.0-rc.1", _in.getMetaData()))
				fallenWithCareerStats = ::CareerStats.Mod.Serialization.flagDeserialize("FallenWithStats", [], null, this.m.Flags);
			else
				fallenWithCareerStats = ::CareerStats.Mod.Serialization.flagDeserialize("CareerStats_FallenWithStats", [], null, this.m.Flags);

			foreach (i in fallenWithCareerStats)
			{
				this.m.Fallen[i].CareerStats_Stats <- ::new("scripts/mods/career_stats/career_stats");
				if (::CareerStats.Mod.Serialization.isSavedVersionAtLeast("1.0.0-rc.1", _in.getMetaData()))
					this.m.Fallen[i].CareerStats_Stats.onDeserialize(::CareerStats.Mod.Serialization.getDeserializationEmulator("StatsFor" + i, this.m.Flags));
				else
					this.m.Fallen[i].CareerStats_Stats.onDeserialize(::CareerStats.Mod.Serialization.getDeserializationEmulator("CareerStats_Fallen" + i, this.m.Flags));
			}
		}
	}

	o.CareerStats_getTooltipForFallen <- function( _idx )
	{
		local tooltip = [
			{
				id = 1,
				type = "title",
				text = this.m.Fallen[_idx].Name,
			}
		];
		if ("CareerStats_Stats" in this.m.Fallen[_idx])
		{
			this.m.Fallen[_idx].CareerStats_Stats.extendTooltip(tooltip, 2);
		}
		else
		{
			tooltip.push({
				id = 2,
				type = "text",
				text = "Since this character died while career stats was not loaded, their stats are lost forever."
			})
		}
		return tooltip;
	}
});
