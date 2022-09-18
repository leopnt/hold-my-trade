extends Node2D

onready var beer_prices = get_node(
    "CanvasLayer/VSplitContainer/GridContainer").get_children()
onready var prices_text_buf = ""

func _ready():
    DebugUI.link_scene($CanvasLayer/DebugUI)
    for beer_price in beer_prices:
        beer_price.tick()
func _on_PriceTicker_timeout():
    for beer_price in beer_prices:
        beer_price.tick()
        beer_price.update()

func _on_PriceDisplayTicker_timeout():
    var label = $CanvasLayer/VSplitContainer/Label
    label.text = prices_text_buf

    var width = label.get_font("normal_font").get_string_size(prices_text_buf).x
    if width > get_viewport_rect().size.x:
        prices_text_buf.erase(0, 1)
    else:
        for beer_price in beer_prices:
            prices_text_buf += beer_price.name + ": "
            prices_text_buf += "%2.2f EUR     " % beer_price.curr_price()

    while width > 2 * get_viewport_rect().size.x:
        prices_text_buf.erase(0, 1)
        width = label.get_font("normal_font").get_string_size(prices_text_buf).x
    

func _on_PriceDisplayFetcher_timeout():
    pass
