extends Node2D

var capacity_stacks := 100
var inventory := {}

func request_power() -> float:
    return 0.0

func process_tick(dt: float) -> void:
    pass

func get_io_ports() -> Dictionary:
    return {"inputs": ["*"], "outputs": []}

