extends Node

const SAVE_PATH := "user://saves/slot1.json"

func save_state(state: Dictionary) -> bool:
    var dir := DirAccess.open("user://saves")
    if dir == null:
        DirAccess.make_dir_recursive_absolute("user://saves")
    var f := FileAccess.open(SAVE_PATH, FileAccess.WRITE)
    if f == null:
        return false
    f.store_string(JSON.stringify(state))
    return true

func load_state() -> Dictionary:
    if not FileAccess.file_exists(SAVE_PATH):
        return {}
    var f := FileAccess.open(SAVE_PATH, FileAccess.READ)
    if f == null:
        return {}
    var txt := f.get_as_text()
    var data := JSON.parse_string(txt)
    return data if typeof(data) == TYPE_DICTIONARY else {}

