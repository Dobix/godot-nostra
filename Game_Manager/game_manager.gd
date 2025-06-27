extends Node

var npc_manager: NpcManager = NpcManager.new()
var nostra_active: bool = false

func _ready():
	print("GameManager ready.")
