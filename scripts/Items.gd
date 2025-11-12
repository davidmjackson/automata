extends Node
class_name ItemsDB

var _items := {}
var _loaded := false

func ensure_loaded() -> void:
    if _loaded:
        return
    var f := FileAccess.open("res://data/items.json", FileAccess.READ)
    if f:
        var txt := f.get_as_text()
        _items = JSON.parse_string(txt) if txt else {}
    _loaded = true

func get_item(id: String) -> Dictionary:
    ensure_loaded()
    return _items.get(id, {})

