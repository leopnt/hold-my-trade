extends Control

var _logs: TextEdit = null
var _debug_ui: Control = null

func _ready():
    pass

func link_scene(debug_ui: Control):
    _debug_ui = debug_ui
    _logs = debug_ui.get_node("HSplitContainer/Logs")


func logln(msg: String):
    _logs.text += msg
    _logs.text += "\n"
    _autoscroll_logs()


func _autoscroll_logs():
    var cl = _logs.get_line_count()
    _logs.cursor_set_line(cl)
