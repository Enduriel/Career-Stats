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
	// _out
	o.onSerialize = function( ... )
	{
		vargv.insert(0, this);
		local fallenWithCareerStats = []
		for (local i = 0; i < this.m.Fallen.len(); ++i)
		{
			if ("CareerStats_Stats" in this.m.Fallen[i])
			{
				fallenWithCareerStats.push(i);
				::CareerStats.Mod.Serialization.flagSerializeBBObject("CareerStats_Fallen" + i, this.m.Fallen[i].CareerStats_Stats, this.m.Flags);
			}
		}
		::CareerStats.Mod.Serialization.flagSerialize("CareerStats_FallenWithStats", fallenWithCareerStats, this.m.Flags);
		return onSerialize.acall(vargv);
	}

	local onDeserialize = o.onDeserialize;
	// _in
	o.onDeserialize = function( ... )
	{
		vargv.insert(0, this);
		local ret = onDeserialize.acall(vargv);
		if (::CareerStats.Mod.Serialization.isSavedVersionAtLeast("0.2.0", vargv[1].getMetaData()))
		{
			local fallenWithCareerStats = ::CareerStats.Mod.Serialization.flagDeserialize("CareerStats_FallenWithStats", null, this.m.Flags);

			foreach (i in fallenWithCareerStats)
			{
				this.m.Fallen[i].CareerStats_Stats <- ::new("scripts/mods/career_stats/career_stats");
				::CareerStats.Mod.Serialization.flagDeserializeBBObject("CareerStats_Fallen" + i, this.m.Fallen[i].CareerStats_Stats, this.m.Flags);
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
