extends Node2D

const MAP_SIZE := Vector2i(128, 128)

func _ready() -> void:
    # Placeholder: world gen to be implemented.
    # Ensure we have a seed for determinism.
    if Engine.has_singleton("GameState"):
        var rng = GameState.rng(0)
        rng.randomize() # still deterministic from seed

