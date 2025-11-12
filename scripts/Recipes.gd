extends Node
class_name RecipesDB

var _recipes := {}
var _loaded := false

func ensure_loaded() -> void:
    if _loaded:
        return
    var f := FileAccess.open("res://data/recipes.json", FileAccess.READ)
    if f:
        var txt := f.get_as_text()
        _recipes = JSON.parse_string(txt) if txt else {}
    _loaded = true

func get_recipe(id: String) -> Dictionary:
    ensure_loaded()
    return _recipes.get(id, {})

