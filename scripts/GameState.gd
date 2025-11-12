extends Node

const VERSION := "0.1.0"

var entities: Dictionary = {}
var belts: Dictionary = {}
var machines: Dictionary = {}
var robots: Dictionary = {}
var inventories: Dictionary = {}
var research_state: Dictionary = {}
var power_state: Dictionary = {}
var world_seed: int = 123456

func _ready() -> void:
	# Placeholder init; expand as systems come online.
	pass

func register_entity(id: String, data) -> void:
	entities[id] = data

func get_entity(id: String):
	return entities.get(id, null)

func each_in_chunk(chunk_id: String, callback: Callable) -> void:
	# MVP stub: iterate all entities; chunking to be added with Map.
	for id in entities.keys():
		callback.call(id, entities[id])

func rng(seed_offset: int = 0) -> RandomNumberGenerator:
	var r := RandomNumberGenerator.new()
	r.seed = int(world_seed) + int(seed_offset)
	return r
