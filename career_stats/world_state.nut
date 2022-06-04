::mods_hookExactClass("states/world_state", function (o)
{
	local onBeforeDeserialize = o.onBeforeDeserialize;
	o.onBeforeDeserialize = function( _in )
	{
		::CareerStats.IsLoading = true;
		onBeforeDeserialize(_in);
	}

	local onDeserialize = o.onDeserialize;
	o.onDeserialize = function( _in )
	{
		onDeserialize(_in);
		::CareerStats.IsLoading = false;
		::CareerStats.evaluateRanks();
	}

	local startNewCampaign = o.startNewCampaign;
	o.startNewCampaign = function()
	{
		::CareerStats.IsLoading = true;
		startNewCampaign();
		::CareerStats.IsLoading = false;
		::CareerStats.evaluateRanks();
	}
});
