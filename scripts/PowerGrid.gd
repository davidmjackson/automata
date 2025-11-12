extends Node

signal power_changed(total_generation: float, total_load: float)

var producers: Array = [] # [{node, watts}]
var consumers: Array = [] # [{node, watts, throttle}]

func register_producer(node: Node, watts: float) -> void:
    producers.append({"node": node, "watts": watts})

func register_consumer(node: Node, watts: float) -> void:
    consumers.append({"node": node, "watts": watts, "throttle": 1.0})

func process_tick(dt: float) -> void:
    var gen := 0.0
    for p in producers:
        gen += float(p.watts)
    var load := 0.0
    for c in consumers:
        load += float(c.watts)
    var throttle := 1.0
    if load > 0.0 and gen < load:
        throttle = clamp(gen / load, 0.0, 1.0)
    for c in consumers:
        c.throttle = throttle
        if c.node and c.node.has_method("set_power_throttle"):
            c.node.set_power_throttle(throttle)
    emit_signal("power_changed", gen, load)

