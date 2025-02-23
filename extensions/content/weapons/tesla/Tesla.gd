extends "res://content/weapons/tesla/Tesla.gd"

func shootSingle(perfectTiming:bool, quickshot:bool):
	super(perfectTiming, quickshot)
	var chains = Data.of("tesla.chains")
	if(chains <= 0):
		return
	var chainDistance = Data.of("tesla.chaindistance")
	var splits = Data.of("tesla.splits")
	
	var reticleStart = reticle.global_position
	var reticleAutoAimVisible = reticle.autoAimArea.visible
	var reticleCollision = $reticle/AutoAimArea/CollisionShape2D
	var reticleStartRadius = reticleCollision.shape.radius
	var splitPosition = reticle.global_position
	
	reticle.autoAimArea.shape.radius *= chainDistance
	reticle.autoAimArea.visible = true
	for chain in range(chains):
		splitPosition = reticle.global_position
		for split in range(splits):
			reticle.global_position = splitPosition
			var monster = reticle.getAutoaimTarget()
			if(monster): #monster nearby
				reticle.global_position = monster.global_position
				super(false, false)
		
	reticleCollision.shape.radius = reticleStartRadius
	reticle.autoAimArea.visible = reticleAutoAimVisible
	reticle.global_position = reticleStart
