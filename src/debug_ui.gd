extends Control

onready var _logs = get_node("HSplitContainer/Logs")


func _ready():
    pass


func logln(msg: String):
    _logs.text += msg
    _logs.text += "\n"
