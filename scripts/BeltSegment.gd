extends Node2D

const THROUGHPUT_PER_TICK := 1.0
var rates := {} # {item_id: rate}

func request_power() -> float:
    return 0.0

func process_tick(dt: float) -> void:
    # Aggregated rates placeholder.
    pass

func get_io_ports() -> Dictionary:
    return {"inputs": ["*"], "outputs": ["*"]}

