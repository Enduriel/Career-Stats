::mods_hookNewObjectOnce("ui/screens/world/world_obituary_screen", function (o)
{
	local convertFallenToUIData = o.convertFallenToUIData;
	o.convertFallenToUIData = function()
	{
		local ret = convertFallenToUIData();
		ret.Fallen = clone ret.Fallen;
		foreach (idx, fallen in ret.Fallen)
		{
			if ("CareerStats_Stats" in fallen)
			{
				ret.Fallen[idx] = clone fallen;
				ret.Fallen[idx].rawdelete("CareerStats_Stats");
			}
			ret.Fallen[idx].CareerStats_Idx <- idx;
		}
		return ret;
	}
});
