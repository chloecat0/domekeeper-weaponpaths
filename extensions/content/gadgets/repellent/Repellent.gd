extends "res://content/gadgets/repellent/Repellent.gd"


const MODE_CONFUSION := 5 #cant be added to original enum
enum ExtendedMode {NOTHING, HEALTH_REDUCTION, SLOWDOWN, CONFUSION}

func _ready():
	super()
	Data.listen(self, "repellent.confuseproportion")

func propertyChanged(property:String, oldValue, newValue):
	super(property, oldValue, newValue)
	match property:
		"repellent.confuseproportion":
			if mode == Mode.NOTHING and newValue > 0:
				mode = MODE_CONFUSION
				add_to_group("dome_ability1")
				$FullScreenMist2Particles.queue_free()
				Style.init($FullScreenMist1Particles)
				particles = $FullScreenMist1Particles

func _process(delta):
	if GameWorld.paused:
		return
	
	if battleAbilityActive:
		var tell = $AbilityTween.tell()
		var time = $AbilityTween.get_runtime() - tell
		Data.apply("repellent.remainingabilityduration", lastBattleAbilityDuration - tell)
		match int(mode):
			MODE_CONFUSION:
				var confusepercent = Data.of("repellent.confuseproportion")
				for m in get_tree().get_nodes_in_group("monster"):
					if affectedMonsters.get(m, 0) < 1 and m.canBeHit():
						if(randf() < confusepercent):
							affectedMonsters[m] = 1
							m.leaving = true
						else:
							affectedMonsters[m] = 2
						
func executeBattle1() -> bool:
	var successful = super()
	if(!successful):
		return successful
	
	match int(mode):
		MODE_CONFUSION:
			$DebilitateSound.play()
	
	return successful
	
func deactivate():
	super()
	if not battleAbilityActive:
		return
	match int(mode):
		MODE_CONFUSION:
			for m in get_tree().get_nodes_in_group("monster"):
				if affectedMonsters.get(m, 0) == 1:
					m.leaving = false
					m.die()

func getBattleAbilityName() -> String:
	var returned = super()
	if(returned != ""):
		return returned
	
	match int(mode):
		MODE_CONFUSION:
			return tr("upgrades.repellentbattleconfusion.title")
	return ""
		
