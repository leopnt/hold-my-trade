extends Node2D

onready var debug_ui = get_node("CanvasLayer/DebugUI")

func _ready():
    print("wtf")
    debug_ui.logln("test")
    debug_ui.logln("ta grand mere")
