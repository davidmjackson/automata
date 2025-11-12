extends Node

signal job_added(job)
signal job_completed(job)

var queue: Array = []

func add_job(job: Dictionary) -> void:
    queue.append(job)
    emit_signal("job_added", job)

func next_job() -> Dictionary:
    if queue.is_empty():
        return {}
    return queue.pop_front()

