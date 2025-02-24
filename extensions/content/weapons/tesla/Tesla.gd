extends "res://content/weapons/tesla/Tesla.gd"

@onready
var chainArea = $ChainArea2D
@onready
var chainCollisionShape = $ChainArea2D/CollisionShape2D
@onready
var chainArcs = [$ChainArea2D/ShootChain1, $ChainArea2D/ShootChain2,
	$ChainArea2D/ShootChain3, $ChainArea2D/ShootChain4,
	$ChainArea2D/ShootChain5, $ChainArea2D/ShootChain6]

func shootSingle(perfectTiming:bool, quickshot:bool):
	super(perfectTiming, quickshot)
	var chains = Data.ofOr("tesla.chains", 0)
	print(chains)
	if(chains <= 0):
		return
	var chainDistance = Data.of("tesla.chaindistance")*10
	var splits = Data.of("tesla.splits")
	
	print("Chains: ",chains," Chain Distance: ",chainDistance," Splits: ",splits)
	#var lastPosition = reticle.position
	var nextPosition = reticle.position
	for chain in range(chains):
		#lastPosition = chainArea.position
		var monsters = getChainLightningTargets()
		print(monsters)
		for split in range(min(splits, monsters.size())):
			print("Chain",chain," Split",split)
			print("firing chain")
			shootChain(chainArea.position, monsters[split].global_position, chain*splits + split)
			nextPosition = monsters[split].global_position
		chainArea.position = nextPosition


func getChainLightningTargets() -> Array:
	chainCollisionShape.shape.radius = 50*Data.of("tesla.chaindistance")
	var monsters : Array = chainArea.get_overlapping_areas()
	if monsters.is_empty():
		return []
	var hittableMonsters := []
	for m in monsters:
		if m.canBeHit():
			hittableMonsters.append(m)
	hittableMonsters.sort_custom(Callable(self, "sortByDistanceChain"))
	hittableMonsters.reverse()
	if hittableMonsters.is_empty():
		return []
	return hittableMonsters

func shootChain(startPosition:Vector2, targetPosition:Vector2, arcIndex:int):
	var powervfx = Data.of("tesla.powervfx")
	var shotPosition = targetPosition
	var newImpactSound = preload("res://content/weapons/tesla/sounds/TeslaShotSound.tscn").instantiate()
	Level.viewports.addElement(newImpactSound)
	newImpactSound.play(powervfx, shotPosition, false)
	
	var newImpact = preload("res://content/weapons/tesla/TeslaImpact.tscn").instantiate()
	newImpact.position = shotPosition
	newImpact.setPower(powervfx)
	Level.map.addPixelEffect(newImpact)
	
	chainArcs[arcIndex].position = startPosition
	chainArcs[arcIndex].target = shotPosition
	var arcDuration = remap(float(powervfx), 0.0, 4.0, 0.7, 2.0)
	chainArcs[arcIndex].forkSpawnArea = Vector2(4,4) * arcDuration
	$Tween.interpolate_method(self, "controlChainArc", [arcIndex, 1], 0, arcDuration, Tween.TRANS_SINE, Tween.EASE_OUT)
	
	var newShot = preload("res://content/weapons/tesla/TeslaThunder.tscn").instantiate()
	newShot.perfect = false
	newShot.global_position = shotPosition
	
	var radius = Data.of("tesla.radius")
	var baseDamage = Data.of("tesla.damage")
	var damage = baseDamage
	var strength = Data.of("tesla.persistance")
	
	$Tween.start()
	shotCharge = 0
	reloadedSoundPlayed = false
	
	reticle.shoot()
	
	Level.viewports.addElement(newShot)
	newShot.start(damage, radius, strength)

func sortByDistanceChain(a, b):
	return a.global_position.distance_to(global_position) > b.global_position.distance_to(global_position)

func controlChainArc(index:int, v:float):
	chainArcs[index].visible = v >= 0.05
	#chainArc.position = (Vector2.RIGHT*float(Data.of("tesla.powervfx"))*2.0).rotated(randf()*TAU)
	var dir = sign(chainArea.global_position.x - chainArcs[index].target.x)
	chainArcs[index].baseCurvature = remap(v, 1.0, 0.0, 0.0, 0.8) * dir
	chainArcs[index].spawnInterval = remap(ease(v, 0.5), 1.0, 0.0, 0.01, 0.2)
	chainArcs[index].arcWildness = remap(v, 1.0, 0.0, 0.0, 20.0)
	chainArcs[index].modulate = lerp(Color(2,2,2,1), Color(1,1,1,1), ease(v, 1.2))
	chainArcs[index].impactRadius = remap(ease(v, 0.3), 1.0, 0.0, 4.0, 30.0)
