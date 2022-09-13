extends Node

var _price_history = []

const MIN_PRICE: float = 2.00
const MAX_PRICE: float = 6.00

func _ready():
    _price_history.push_back((MIN_PRICE + MAX_PRICE) / 2) # start at the middle

func curr_price() -> float:
    return _price_history[-1]

func tick():
    _price_history.push_back(rand_range(MIN_PRICE, MAX_PRICE))