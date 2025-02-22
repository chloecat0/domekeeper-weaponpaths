extends Node2D

@onready
var arc_group = $ArcGroup

func createChain(startPosition:Vector2):
	var chains = Data.of("tesla.chains")
	var chainDistance = Data.of("tesla.chaindistance")
	var splits = Data.of("tesla.splits")
	
	var splitsLeft = splits
	
	$Area2D/Collision.shape.radius = chainDistance
	arc_group.extraPower = chains + chainDistance*0.1
	for monster in $Area2D.get_overlapping_areas():
		arc_group.createArc(startPosition, monster.position)
		
		var newShot = preload("res://content/weapons/tesla/TeslaThunder.tscn").instantiate()
		var radius = Data.of("tesla.radius")
		var damage = Data.of("tesla.damage")
		var strength = Data.of("tesla.persistance")
		
		newShot.global_position = monster.position
		Level.viewports.addElement(newShot)
		newShot.start(damage, radius, strength)
		
		if splitsLeft > 1:
			splitsLeft -= 1
		else:
			break
