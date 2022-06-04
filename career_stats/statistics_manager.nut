::mods_hookNewObjectOnce("statistics/statistics_manager", function (o)
{
	local addFallen = o.addFallen;
	o.addFallen = function( _fallen )
	{
		::CareerStats.LastFallen = _fallen;
		addFallen(_fallen);
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
				::CareerStats.Mod.Serialization.flagSerializeBBObject("CareerStats_Fallen" + i, this.m.Fallen[i].CareerStats_Stats, this.m.Flags);
			}
		}
		::CareerStats.Mod.Serialization.flagSerialize("CareerStats_FallenWithStats", fallenWithCareerStats, this.m.Flags);
		onSerialize(_out);
	}

	local onDeserialize = o.onDeserialize;
	o.onDeserialize = function( _in )
	{
		onDeserialize(_in);
		if (::CareerStats.Mod.Serialization.isSavedVersionAtLeast("0.2.0", _in.getMetaData()))
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
