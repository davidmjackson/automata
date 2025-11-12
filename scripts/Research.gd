extends Node

var techs := {}
var unlocked := {}

func load_from_json(path: String) -> void:
    var f := FileAccess.open(path, FileAccess.READ)
    if f:
        var txt := f.get_as_text()
        techs = JSON.parse_string(txt) if txt else {}

func is_unlocked(id: String) -> bool:
    return unlocked.get(id, false)

