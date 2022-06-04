::mods_hookNewObjectOnce("ui/screens/tooltip/tooltip_events", function (o)
{
	local general_queryUIElementTooltipData = o.general_queryUIElementTooltipData;
	o.general_queryUIElementTooltipData = function( _entityId, _elementId, _elementOwner )
	{
		local ret = general_queryUIElementTooltipData(_entityId, _elementId, _elementOwner);
		if (ret == null && _elementId.find("career-stats.fallen") == 0)
		{
			ret = ::World.Statistics.CareerStats_getTooltipForFallen(split(_elementId, ".")[2].tointeger())
		}
		return ret;
	}
});
