local tacticalRollMatch = regexp("(hits|misses) \\[color=.*\\[\\/color\\] \\(Chance: (\\d+), Rolled: (\\d+)\\)")

::mods_hookExactClass("ui/screens/tactical/modules/topbar/tactical_screen_topbar_event_log", function (o)
{
	local logEx = o.logEx;
	// _text
	o.logEx = function( ... )
	{
		vargv.insert(0, this);
		local capture = tacticalRollMatch.capture(vargv[1]);
		if (capture != null)
		{
			local chance = ::MSU.regexMatch(capture, vargv[1], 2).tointeger();
			local hits = ::MSU.regexMatch(capture, vargv[1], 1) == "hits";

			if (::MSU.isKindOf(::CareerStats.ActiveUser, "player"))
			{
				local careerStats = ::CareerStats.ActiveUser.m.CareerStats_Stats.m.Stats;
				if (hits) // hit
				{
					if (chance <= ::CareerStats.MinHitChance) ++careerStats.Num5PercentHits;
					++careerStats.NumAccuracyHits;
				}
				else
				{
					if (chance >= ::CareerStats.MaxHitChance) ++careerStats.Num95PercentMisses;
					++careerStats.NumAccuracyMisses;
				}
			}

			if (::MSU.isKindOf(::CareerStats.ActiveTarget, "player"))
			{
				local careerStats = ::CareerStats.ActiveTarget.m.CareerStats_Stats.m.Stats
				if (hits)
				{
					++careerStats.NumAccuracyHitsReceived;
				}
				else
				{
					++careerStats.NumAccuracyDodges;
				}
			}
		}
		return logEx.acall(vargv);
	}
});
