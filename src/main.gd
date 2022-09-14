extends Node2D

onready var beer_prices = get_node("CanvasLayer/GridContainer").get_children()

func _ready():
    DebugUI.link_scene($CanvasLayer/DebugUI)
    for beer_price in beer_prices:
        beer_price.tick()

func _on_PriceTicker_timeout():
    for beer_price in beer_prices:
        beer_price.tick()
        beer_price.update()
        DebugUI.logln("%2.2f EUR" % beer_price.curr_price())
