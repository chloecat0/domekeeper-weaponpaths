extends Node

const MOD_PATH := "res://mods-unpacked/chloecat-weaponpaths/"
const MOD_ICON_PATH := MOD_PATH + "overwrites/content/icons/"
const GAME_ICON_PATH := "res://content/icons/"

var icons := [
	"teslachain.png",
	"teslachaindistance1.png","teslachaindistance2.png","teslachaindistance3.png",
	"teslachainlength1.png","teslachainlength2.png","teslachainsplit.png"
]

var loaded := []
var iconTextures := []

func _init():
	for icon in icons:
		var overwrite = load(MOD_ICON_PATH+icon)
		iconTextures.append(overwrite)
		overwrite.take_over_path(GAME_ICON_PATH+icon)
		
	ModLoaderLog.info("Completed overwrites", "chloecat-weaponpaths")
