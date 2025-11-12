extends Node2D

var power_throttle: float = 1.0

func set_power_throttle(t: float) -> void:
    power_throttle = t

func request_power() -> float:
    return 2.0 # placeholder watts

func process_tick(dt: float) -> void:
    # Stub: produce ore over time respecting power_throttle
    pass

func get_io_ports() -> Dictionary:
    return {"inputs": [], "outputs": ["ore"]}

