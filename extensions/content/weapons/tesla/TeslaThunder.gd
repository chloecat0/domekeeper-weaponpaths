extends "res://content/weapons/tesla/TeslaThunder.gd"
	
func dealInitialDamage():
	super()
	
	var chains = Data.of("tesla.chains")
	if(chains > 0 && $Area2D.get_overlapping_areas()):
		var chain = preload("res://mods-unpacked/chloecat-weaponpaths/extensions/content/weapons/tesla/ChainLightning.tscn").instantiate()
		chain.createChain(global_position)
		print("hit something")
