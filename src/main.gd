extends Node2D

onready var beer_price = get_node("CanvasLayer/BeerPrice")

func _ready():
    DebugUI.link_scene($CanvasLayer/DebugUI)
    beer_price.tick()

func _on_PriceTicker_timeout():
    beer_price.tick()
    beer_price.update()
    DebugUI.logln("%2.2f EUR" % beer_price.curr_price())
