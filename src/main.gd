extends Node2D

func _ready():
    DebugUI.link_scene($CanvasLayer/DebugUI)


func _on_PriceTicker_timeout():
    $BeerPrice.tick()
    DebugUI.logln("%2.2f EUR" % $BeerPrice.curr_price())
