::CareerStats <- {
	ID = "mod_career_stats",
	Version = "0.3.0",
	Name = "Career Stats",
	ActiveUser = null,
	ActiveTarget = null,
	MinHitChance = 5,
	MaxHitChance = 95,
	evaluateRanks = null,
	DummyStats = ::new("scripts/mods/career_stats/career_stats")
	IsLoading = false,
	LastFallen = null,
};

::mods_registerMod(::CareerStats.ID, ::CareerStats.Version, ::CareerStats.Name);

::mods_queue(::CareerStats.ID, "mod_msu(>=1.1.0-0.snowmanbuild)", function() // should be updated to require 1.1.0
{
	::CareerStats.Mod <- ::MSU.Class.Mod(::CareerStats.ID, ::CareerStats.Version, ::CareerStats.Name);

	local currentStatGetter;

	local function compareByStat(_a, _b)
	{
		return _b.m.CareerStats_Stats[currentStatGetter]() <=> _a.m.CareerStats_Stats[currentStatGetter]();
	}

	::CareerStats.evaluateRanks = function()
	{
		if (::CareerStats.IsLoading) return;
		local bros = ::World.getPlayerRoster().getAll();
		local ranks = clone ::CareerStats.DummyStats.m.Ranks;
		foreach (statKey, statArray in ::CareerStats.DummyStats.m.Ranks)
		{
			local clonedBros = clone bros;
			ranks[statKey] = clonedBros;
			currentStatGetter = "get" + statKey;
			clonedBros.sort(compareByStat);

			local lastChange = 0;
			for (local i = 0; i < clonedBros.len(); ++i)
			{
				if (clonedBros[i].m.CareerStats_Stats[currentStatGetter]() != clonedBros[lastChange].m.CareerStats_Stats[currentStatGetter]())
				{
					lastChange = i;
				}
				clonedBros[i].m.CareerStats_Stats.m.Ranks[statKey] = lastChange + 1;
			}
		}
	}

	::include("career_stats/player");
	::include("career_stats/player_corpse_stub");
	::include("career_stats/skill");
	::include("career_stats/stats_collector");
	::include("career_stats/statistics_manager");
	::include("career_stats/tactical_screen_topbar_event_log");
	::include("career_stats/tactical_state");
	::include("career_stats/tooltip_events");
	::include("career_stats/world_obituary_screen");
	::include("career_stats/world_player_roster");
	::include("career_stats/world_state");

	::mods_registerJS("career_stats/world_obituary_screen.js");
});
