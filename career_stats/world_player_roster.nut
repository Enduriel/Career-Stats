local getPlayerRoster = ::World.getPlayerRoster;
::World.getPlayerRoster = function()
{
	local playerRoster = getPlayerRoster();
	local remove = playerRoster.remove;
	// _player
	playerRoster.remove = function(...)
	{
		vargv.insert(0, this);
		if (::CareerStats.LastFallen != null)
		{
			::CareerStats.LastFallen.CareerStats_Stats <- vargv[1].m.CareerStats_Stats;
			::CareerStats.LastFallen = null;
		}
		local ret = remove(vargv[1]);
		::CareerStats.evaluateRanks();
		return ret;
	}

	local create = playerRoster.create;
	// _scriptName
	playerRoster.create = function(...)
	{
		vargv.insert(0, this);
		local ret = create.acall(vargv);
		::CareerStats.evaluateRanks();
		return ret;
	}

	local clear = playerRoster.clear;
	playerRoster.clear = function(...)
	{
		vargv.insert(0, this);
		local ret = clear.acall(vargv);
		::CareerStats.evaluateRanks();
		return ret;
	}

	local add = playerRoster.add;
	// _player
	playerRoster.add = function(...)
	{
		vargv.insert(0, this);
		local ret = add.acall(vargv);
		::CareerStats.evaluateRanks();
		return ret;
	}
	return playerRoster;
}
