this.career_stats <- {
	m = {
		Stats = {
			DamageReceivedHitpoints = 0,
			DamageReceivedArmor = 0,
			DamageDealtHitpoints = 0,
			DamageDealtArmor = 0,
			MaxDamageHitpoints = 0,
			MaxDamageArmor = 0,
			MaxDamageAttackHitpoints = 0,
			MaxDamageAttackArmor = 0,
			NumHeadHits = 0,
			NumHits = 0,
			NumAccuracyHits = 0,
			NumAccuracyMisses = 0,
			NumAccuracyDodges = 0,
			NumAccuracyHitsReceived = 0,
			Num5PercentHits = 0,
			Num95PercentMisses = 0,
			Battles = 0
		},
		Ranks = {
			DamageDealt = 0,
			DamageDealtAvg = 0,
			DamageReceived = 0,
			DamageReceivedAvg = 0,
			MaxDamage = 0,
			AvgHitChance = 0,
			AvgHeadshotChance = 0,
			AvgDodgeChance = 0,
			Num5PercentHits = 0,
			Num95PercentMisses = 0
		}
		IDCounter = 0 // TODO
	},

	function getDamageDealt()
	{
		return this.m.Stats.DamageDealtHitpoints + this.m.Stats.DamageDealtArmor;
	}

	function getDamageDealtAvg()
	{
		if (this.m.Stats.Battles == 0)
		{
			return this.getDamageDealt();
		}
		return this.getDamageDealt() / this.m.Stats.Battles;
	}

	function getDamageDealtAvgHitpoints()
	{
		if (this.m.Stats.Battles == 0)
		{
			return this.m.Stats.DamageDealtHitpoints;
		}
		return this.m.Stats.DamageDealtHitpoints / this.m.Stats.Battles;
	}

	function getDamageDealtAvgArmor()
	{
		if (this.m.Stats.Battles == 0)
		{
			return this.m.Stats.DamageDealtArmor;
		}
		return this.m.Stats.DamageDealtArmor / this.m.Stats.Battles;
	}

	function getDamageReceived()
	{
		return this.m.Stats.DamageReceivedHitpoints + this.m.Stats.DamageReceivedArmor;
	}

	function getDamageReceivedAvg()
	{
		if (this.m.Stats.Battles == 0)
		{
			return this.getDamageReceived();
		}
		return this.getDamageReceived() / this.m.Stats.Battles;
	}

	function getDamageReceivedAvgHitpoints()
	{
		if (this.m.Stats.Battles == 0)
		{
			return this.m.Stats.DamageReceivedHitpoints;
		}
		return this.m.Stats.DamageReceivedHitpoints / this.m.Stats.Battles;
	}

	function getDamageReceivedAvgArmor()
	{
		if (this.m.Stats.Battles == 0)
		{
			return this.m.Stats.DamageReceivedArmor;
		}
		return this.m.Stats.DamageReceivedArmor / this.m.Stats.Battles;
	}

	function getMaxDamage()
	{
		return this.m.Stats.MaxDamageAttackArmor + this.m.Stats.MaxDamageAttackHitpoints;
	}

	function getAvgHitChance()
	{
		if (this.m.Stats.NumAccuracyHits + this.m.Stats.NumAccuracyMisses == 0)
		{
			return 0.0;
		}
		return this.m.Stats.NumAccuracyHits.tofloat() / (this.m.Stats.NumAccuracyHits + this.m.Stats.NumAccuracyMisses);
	}

	function getAvgHeadshotChance()
	{
		if (this.m.Stats.NumHits == 0)
		{
			return 0.0;
		}
		return this.m.Stats.NumHeadHits.tofloat() / this.m.Stats.NumHits;
	}

	function getAvgDodgeChance()
	{
		if (this.m.Stats.NumAccuracyDodges + this.m.Stats.NumAccuracyHitsReceived == 0)
		{
			return 0.0;
		}
		return this.m.Stats.NumAccuracyDodges.tofloat() / (this.m.Stats.NumAccuracyDodges + this.m.Stats.NumAccuracyHitsReceived);
	}

	function getNum5PercentHits()
	{
		return this.m.Stats.Num5PercentHits;
	}

	function getNum95PercentMisses()
	{
		return this.m.Stats.Num95PercentMisses;
	}

	function makeTooltipSegment( _icon, _rank, _text )
	{
		local rank = _rank == 0 ? "" : "#" + _rank + " ";

		return {
			id = this.m.IDCounter++,
			type = "hint",
			text = rank + _text,
			icon = _icon
		}
	}

	function extendTooltip( _tooltip, _idCounter )
	{
		this.m.IDCounter = _idCounter;
		_tooltip.extend([
			this.makeTooltipSegment("ui/icons/damage_dealt.png", this.m.Ranks.DamageDealt,
				format("DMG Dealt %s[img]gfx/mods/career_stats/health_mini.png[/img]%s[img]gfx/mods/career_stats/armor_body_mini.png[/img]",
					::MSU.String.colorGreen(this.m.Stats.DamageDealtHitpoints.tostring()),
					::MSU.String.colorGreen(this.m.Stats.DamageDealtArmor.tostring()))),

			this.makeTooltipSegment("mods/career_stats/damage_dealt_percent.png", this.m.Ranks.DamageDealtAvg,
				format("Avg DMG/Battle %s[img]gfx/mods/career_stats/health_mini.png[/img]%s[img]gfx/mods/career_stats/armor_body_mini.png[/img]",
					::MSU.String.colorGreen(this.getDamageDealtAvgHitpoints().tostring()),
					::MSU.String.colorGreen(this.getDamageDealtAvgArmor().tostring()))),

			this.makeTooltipSegment("ui/icons/damage_received.png", this.m.Ranks.DamageReceived,
				format("DMG Received %s[img]gfx/mods/career_stats/health_mini.png[/img]%s[img]gfx/mods/career_stats/armor_body_mini.png[/img]",
					::MSU.String.colorRed(this.m.Stats.DamageReceivedHitpoints.tostring()),
					::MSU.String.colorRed(this.m.Stats.DamageReceivedArmor.tostring()))),

			this.makeTooltipSegment("mods/career_stats/damage_received_percent.png", this.m.Ranks.DamageDealtAvg,
				format("Avg DMG/Battle Received %s[img]gfx/mods/career_stats/health_mini.png[/img]%s[img]gfx/mods/career_stats/armor_body_mini.png[/img]",
					::MSU.String.colorRed(this.getDamageReceivedAvgHitpoints().tostring()),
					::MSU.String.colorRed(this.getDamageReceivedAvgArmor().tostring()))),

			this.makeTooltipSegment("ui/icons/regular_damage.png", this.m.Ranks.MaxDamage,
				format("Heaviest Hit %s (%s[img]gfx/mods/career_stats/health_mini.png[/img]%s[img]gfx/mods/career_stats/armor_body_mini.png[/img])",
					::MSU.String.color("#002869", this.getMaxDamage().tostring()),
					::MSU.String.colorGreen(this.m.Stats.MaxDamageAttackHitpoints.tostring()),
					::MSU.String.colorGreen(this.m.Stats.MaxDamageAttackArmor.tostring()))),

			this.makeTooltipSegment("ui/icons/hitchance.png", this.m.Ranks.AvgHitChance,
				format("Hit Chance %s%%",
					::MSU.String.color("#002869", ::Math.round(this.getAvgHitChance() * 100).tostring()))),

			this.makeTooltipSegment("ui/icons/chance_to_hit_head.png", this.m.Ranks.AvgHeadshotChance,
				format("Headshot Chance %s%%",
					::MSU.String.color("#002869", ::Math.round(this.getAvgHeadshotChance() * 100).tostring()))),

			this.makeTooltipSegment("ui/icons/melee_defense.png", this.m.Ranks.AvgDodgeChance,
				format("Dodge Chance %s%%",
					::MSU.String.color("#002869", ::Math.round(this.getAvgDodgeChance() * 100).tostring()))),

			this.makeTooltipSegment("ui/icons/mood_07.png", this.m.Ranks.Num5PercentHits,
				format("Lucky 5%% Hits %s",
					::MSU.String.colorGreen(this.getNum5PercentHits().tostring()))),

			this.makeTooltipSegment("ui/icons/mood_01.png", this.m.Ranks.Num95PercentMisses,
				format("Unlucky 95%% Misses %s",
					::MSU.String.colorRed(this.getNum95PercentMisses().tostring())))
		]);
	}

	function clearRanks()
	{
		foreach (rank, value in this.m.Ranks)
		{
			this.m.Ranks[rank] = 0;
		}
	}

	function onSerialize( _out )
	{
		::MSU.Utils.serialize(this.m.Stats, _out);
		// vanilla stats?
	}

	function onDeserialize( _in )
	{
		::MSU.Utils.deserialize(_in, this.m.Stats);
	}

}
