local getPlayerRoster = ::World.getPlayerRoster;
::World.getPlayerRoster = function()
{
	local playerRoster = getPlayerRoster();
	local remove = playerRoster.remove;
	playerRoster.remove = function(_player)
	{
		if (::CareerStats.LastFallen != null)
		{
			::CareerStats.LastFallen.CareerStats_Stats <- _player.m.CareerStats_Stats;
			::CareerStats.LastFallen = null;
		}
		local ret = remove(_player);
		::CareerStats.evaluateRanks();
		return ret;
	}

	local create = playerRoster.create;
	playerRoster.create = function(_scriptName)
	{
		local ret = create(_scriptName);
		::CareerStats.evaluateRanks();
		return ret;
	}

	local clear = playerRoster.clear;
	playerRoster.clear = function()
	{
		local ret = clear();
		::CareerStats.evaluateRanks();
		return ret;
	}

	local add = playerRoster.add;
	playerRoster.add = function(_player)
	{
		local ret = add(_player);
		::CareerStats.evaluateRanks();
		return ret;
	}
	return playerRoster;
}
