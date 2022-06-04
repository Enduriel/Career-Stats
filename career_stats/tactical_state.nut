::mods_hookExactClass("states/tactical_state", function (o)
{
	local gatherBrothers = o.gatherBrothers;
	o.gatherBrothers = function( _isVictory )
	{
		gatherBrothers(_isVictory);
		::CareerStats.evaluateRanks();
	}
});
