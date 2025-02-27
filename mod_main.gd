extends Node

const MYMODNAME_LOG = "chloecat-weaponpaths"
const MYMODNAME_MOD_DIR = "chloecat-weaponpaths/"

const MOD_UPGRADES_YAML = MYMODNAME_MOD_DIR + "yaml/upgrades.yaml"

var dir = ""
var ext_dir = ""
var trans_dir = ""

func _init():
	ModLoaderLog.info("Init", MYMODNAME_LOG)
	dir = ModLoaderMod.get_unpacked_dir() + MYMODNAME_MOD_DIR
	ext_dir = dir + "extensions/"
	trans_dir = dir + "translations/"
	
	# Add translations
	ModLoaderMod.add_translation(trans_dir + "weaponpaths_text.en.translation")
	
	# Add extensions
	ModLoaderMod.install_script_extension(ext_dir + "content/weapons/tesla/Tesla.gd")
	ModLoaderMod.install_script_extension(ext_dir + "content/gadgets/repellent/Repellent.gd")

func _ready():
	ModLoaderLog.info("Ready", MYMODNAME_LOG)
	add_to_group("mod_init")

func modInit():
	var pathToModYaml : String = ModLoaderMod.get_unpacked_dir() + MOD_UPGRADES_YAML
	ModLoaderLog.info("Trying to parse YAML: %s" % pathToModYaml, MYMODNAME_LOG)
	Data.parseUpgradesYaml(pathToModYaml)
	#Data.apply("tesla.chains", 1, true)
	#Data.values["tesla.chains"] = 1
	#Data.apply("tesla.splits", 1)
	#Data.apply("tesla.chainDistance", 1)
	
	ModLoaderLog.info("Finished Init", MYMODNAME_LOG)
