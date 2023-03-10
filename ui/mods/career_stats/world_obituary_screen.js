var CareerStats = {
	ID : "mod_career_stats"
};

CareerStats.WorldObituaryScreen_createDiv = WorldObituaryScreen.prototype.createDIV;
WorldObituaryScreen.prototype.createDIV = function (_parentDiv)
{
	CareerStats.WorldObituaryScreen_createDiv.call(this, _parentDiv);
	var empty = this.mListScrollContainer.empty;
	this.mListScrollContainer.empty = function()
	{
		this.children('.l-row').each(function()
		{
			$(this).unbindTooltip();
		});
		empty.call(this);
	}
}

CareerStats.WorldObituaryScreen_addListEntry = WorldObituaryScreen.prototype.addListEntry;
WorldObituaryScreen.prototype.addListEntry = function (_data)
{
	CareerStats.WorldObituaryScreen_addListEntry.call(this, _data);
	var result = this.mListScrollContainer.children('.l-row:last');
	result.bindTooltip({ contentType: 'msu-generic', modId: CareerStats.ID, elementId: "Fallen", CareerStats_Idx: _data.CareerStats_Idx });
}
