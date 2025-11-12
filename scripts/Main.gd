extends Control

@onready var _map = $Map if has_node("Map") else null
@onready var _power = $PowerGrid if has_node("PowerGrid") else null
@onready var _ui = $ShipUI if has_node("ShipUI") else null

func _ready() -> void:
    # Load data tables
    if Engine.has_singleton("GameState"):
        GameState.world_seed = 123456
    if Engine.is_editor_hint():
        # Avoid noisy prints in editor.
        pass
    # Connect TickLoop
    if Engine.has_singleton("TickLoop"):
        TickLoop.connect("tick", Callable(self, "_on_tick"))

func _on_tick(dt: float) -> void:
    # Order: power → machines → belts → robots → alerts (stubbed here).
    if _power and _power.has_method("process_tick"):
        _power.process_tick(dt)
    # Machines/belts/robots would be dispatched here when implemented.
