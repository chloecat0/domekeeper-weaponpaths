extends "res://content/weapons/tesla/Tesla.gd"

@onready
var chainArea = $ChainLightning/ChainArea2D
@onready
var chainCollisionShape = $ChainLightning/ChainArea2D/CollisionShape2D
@onready
var chainArcs = [$ChainLightning/ShootChain0, $ChainLightning/ShootChain1, $ChainLightning/ShootChain2,
	$ChainLightning/ShootChain3, $ChainLightning/ShootChain4, $ChainLightning/ShootChain5]

func shootSingle(perfectTiming:bool, quickshot:bool):
	super(perfectTiming, quickshot)
	var chains = Data.ofOr("tesla.chains", 0)
	print(chains)
	if(chains <= 0):
		return
	var splits = Data.of("tesla.splits")
	var chainDistance = Data.of("tesla.chaindistance")
	chainCollisionShape.shape.set_radius(10*chainDistance)
	
	print("Chains: ",chains," Chain Distance: ",chainDistance," Splits: ",splits)
	
	var damageMultiplier := 1.0
	if(perfectTiming):
		damageMultiplier *= Data.of("tesla.perfecttimingmultiplier")
	if(quickshot):
		damageMultiplier *= Data.of("tesla.quickshotstrength")
	
	var nextPosition = reticle.global_position
	chainArea.global_position = reticle.global_position
	var hitMonsters := []
	for chain in range(chains):
		#lastPosition = chainArea.position
		for split in range(splits):
			var monsters = getChainLightningTargets()
			for hit in hitMonsters:
				monsters.erase(hit)
			print(monsters)
			print(hitMonsters)
			if(split >= monsters.size()):
				break
			print("Chain",chain," Split",split)
			
			hitMonsters.append(monsters[split])
			shootChain(chainArea.global_position, monsters[split].global_position, chain*splits + split, damageMultiplier)
			nextPosition = monsters[split].global_position
		chainArea.global_position = nextPosition


func getChainLightningTargets() -> Array:
	var monsters : Array = chainArea.get_overlapping_areas()
	if monsters.is_empty():
		return []
	var hittableMonsters := []
	for m in monsters:
		if m.canBeHit():
			hittableMonsters.append(m)
	if hittableMonsters.is_empty():
		return []
	hittableMonsters.shuffle()
	return hittableMonsters

func shootChain(startPosition:Vector2, targetPosition:Vector2, arcIndex:int, damageMultiplier:float = 1.0):
	var powervfx = Data.of("tesla.powervfx")
	var shotPosition = targetPosition
	var newImpactSound = preload("res://content/weapons/tesla/sounds/TeslaShotSound.tscn").instantiate()
	Level.viewports.addElement(newImpactSound)
	newImpactSound.play(powervfx, shotPosition, false)
	
	var newImpact = preload("res://content/weapons/tesla/TeslaImpact.tscn").instantiate()
	newImpact.position = shotPosition
	newImpact.setPower(powervfx)
	Level.map.addPixelEffect(newImpact)
	
	chainArcs[arcIndex].global_position = startPosition
	chainArcs[arcIndex].target = shotPosition
	var arcDuration = remap(float(powervfx), 0.0, 4.0, 0.35, 1.0)
	chainArcs[arcIndex].forkSpawnArea = startPosition
	chainArcs[arcIndex].visible = true
	chainArcs[arcIndex].forceCreateArc()
	chainArcs[arcIndex].forceCreateArc()
	chainArcs[arcIndex].forceCreateArc()
	#$Tween.interpolate_method(self, "controlChainArc"+str(arcIndex), 1, 0, arcDuration, Tween.TRANS_SINE, Tween.EASE_OUT)
	
	var newShot = preload("res://content/weapons/tesla/TeslaThunder.tscn").instantiate()
	newShot.perfect = false
	newShot.global_position = shotPosition
	
	var radius = Data.of("tesla.radius")
	var baseDamage = Data.of("tesla.damage")
	var damage = baseDamage * damageMultiplier
	var strength = Data.of("tesla.persistance")
	
	#$Tween.start()
	#shotCharge = 0
	#reloadedSoundPlayed = false
	
	#reticle.shoot()
	
	Level.viewports.addElement(newShot)
	newShot.start(damage, radius, strength)

func sortByDistanceChain(a, b):
	return a.global_position.distance_to(global_position) > b.global_position.distance_to(global_position)

"""
func controlChainArc(index:int, v:float):
	chainArcs[index].visible = v >= 0.05
	#chainArc.position = (Vector2.RIGHT*float(Data.of("tesla.powervfx"))*2.0).rotated(randf()*TAU)
	var dir = sign(chainArcs[index].global_position.x - chainArcs[index].target.x)
	chainArcs[index].baseCurvature = remap(v, 1.0, 0.0, 0.0, 0.8) * dir
	chainArcs[index].spawnInterval = remap(ease(v, 0.5), 1.0, 0.0, 0.01, 0.2)
	chainArcs[index].arcWildness = remap(v, 1.0, 0.0, 0.0, 20.0)
	chainArcs[index].modulate = lerp(Color(2,2,2,1), Color(1,1,1,1), ease(v, 1.2))
	chainArcs[index].impactRadius = remap(ease(v, 0.3), 1.0, 0.0, 4.0, 30.0)

#probably a better way to do this, but tween only seems to work with one arg
func controlChainArc0(v:float):
	controlChainArc(0,v)
func controlChainArc1(v:float):
	controlChainArc(1,v)
func controlChainArc2(v:float):
	controlChainArc(2,v)
func controlChainArc3(v:float):
	controlChainArc(3,v)
func controlChainArc4(v:float):
	controlChainArc(4,v)
func controlChainArc5(v:float):
	controlChainArc(5,v)
"""
