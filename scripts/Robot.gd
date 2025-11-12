extends Node2D

enum State { IDLE, PLAN, MOVE, ACT, RETURN }
var state: int = State.IDLE
var battery: float = 1.0
var speed: float = 60.0

func _ready() -> void:
    pass

func process_tick(dt: float) -> void:
    # Stub state machine
    match state:
        State.IDLE:
            pass
        State.PLAN:
            pass
        State.MOVE:
            pass
        State.ACT:
            pass
        State.RETURN:
            pass

