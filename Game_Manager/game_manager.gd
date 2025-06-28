extends Node

var npc_manager: NpcManager = NpcManager.new()
var player_stats: PlayerStats = preload("res://player/player_stats.tres")

var nostra_active: bool = false

var node_being_dragged: Node = null

func _ready():
	print("GameManager ready.")
