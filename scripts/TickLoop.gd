extends Node

signal tick(dt_fixed: float)

const DT := 0.1
const MAX_STEPS := 5

var _accum := 0.0

func _process(delta: float) -> void:
	_accum += delta
	var steps := 0
	while _accum >= DT and steps < MAX_STEPS:
		emit_signal("tick", DT)
		_accum -= DT
		steps += 1
	if steps == MAX_STEPS:
		# Prevent spiral of death by capping catch-up.
		_accum = 0.0
