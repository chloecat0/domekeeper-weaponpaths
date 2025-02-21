extends Node

const MYMODNAME_LOG = "chloecat-weaponpaths"
const MYMODNAME_MOD_DIR = "chloecat-weaponpaths/"

var dir = ""
var ext_dir = ""
var trans_dir = ""

func _init():
	ModLoaderLog.info("Init", MYMODNAME_LOG)
	dir = ModLoaderMod.get_unpacked_dir() + MYMODNAME_MOD_DIR
	ext_dir = dir + "extensions/"
	trans_dir = dir + "translations/"
	
	# Add translations
	#ModLoaderMod.add_translation(trans_dir + "weaponpaths.en.translation")
	
	# Add extensions
#	ModLoaderMod.install_script_extension(ext_dir + "main.gd")

func _ready():
	ModLoaderLog.info("Ready", MYMODNAME_LOG)
	add_to_group("mod_init")

func modInit():
	var pathToModYaml : String = "res://mods-unpacked/chloecat-weaponpaths/yaml/upgrades.yaml"
	ModLoaderLog.info("Trying to parse YAML: %s" % pathToModYaml, MYMODNAME_LOG)
	Data.parseUpgradesYaml(pathToModYaml)
	
	ModLoaderLog.info("Finished Init", MYMODNAME_LOG)
	# This signal can be used to test the mod
	#StageManager.connect("level_ready", self, "testMod")
