extends Control

var _price_history = []

const INITIAL_PRICE = 2.00

var _price_stack = []
const _stack_size: int = 4

const time_window: int = 240

const MIN_PRICE: float = 2.00
const MAX_PRICE: float = 20.00

onready var rng = RandomNumberGenerator.new()

func _ready():
    _price_stack.push_back(rand_range(MIN_PRICE + 1, MAX_PRICE))
    rng.randomize()

    for _i in range(time_window):
        self.tick()

func curr_price() -> float:
    return _price_stack[-1]

func _draw():
    var candle_list = _get_candle_list()

    var label = Label.new()
    var font = label.get_font("")
    draw_string(font, Vector2(0, 4), name, Color(1, 1, 1))
    label.free()

    for i in range(0, candle_list.size()):
        var candle = candle_list[i]
        _draw_candle(i, candle, _price_history.min(), _price_history.max())

func _get_candle_list():
    var candle_list = []
    for i in range(_price_history.size() - time_window, _price_history.size(), _stack_size):
        var candle = _price_history.slice(i, i + _stack_size - 1)
        candle_list.push_back(candle)
    
    var last_candle = _price_stack
    candle_list.push_back(last_candle)
    
    return candle_list

func _draw_candle(idx: int, candle: Array, min_hist: float, max_hist: float):
    var gap_ratio = 1.5
    var candle_width = rect_size.x / gap_ratio / ((time_window /float(_stack_size)) + 1)

    var little_candle_width = 2.0
    var x = idx * candle_width * gap_ratio

    var candle_dyn_height = rect_size.y / (max_hist - min_hist)

    var open_price = candle[0]
    var close_price = candle[-1]

    var height = close_price - open_price

    var color = Color.green
    if height < 0:
        color = Color.black

    var min_price = candle.min()
    var max_price = candle.max()

    var min_max_height = max_price - min_price

    var min_offset = (min_hist * candle_dyn_height)

    # little candle
    draw_rect(Rect2(
        x + 0.45 * candle_width,
        -min_offset + min_price * candle_dyn_height,
        little_candle_width,
        min_max_height * candle_dyn_height
        ), Color.green, true)

    # big candle
    draw_rect(Rect2(
        x,
        -min_offset + open_price * candle_dyn_height,
        candle_width,
        height * candle_dyn_height
        ), color, true)

    draw_rect(Rect2(
        x,
        -min_offset + open_price * candle_dyn_height,
        candle_width,
        height * candle_dyn_height
        ), Color.green, false, 2.0)

func get_price_force() -> float:
    # apply high force to keep price above 2 and apply
    # smaller force to keep below 20
    var x = curr_price()
    var y = (1 / (x - MIN_PRICE)) - (0.001 * pow(x - 4, 3))

    return y

func tick():
    var mean = 0.01 * get_price_force()
    var new_price = curr_price() + rng.randfn(mean, 1)
    while new_price < MIN_PRICE:
        new_price = curr_price() + rng.randfn(mean, 1)

    _price_stack.push_back(new_price)

    var is_price_stack_full = _price_stack.size() > _stack_size
    if is_price_stack_full:
        _dump_stack_to_history()
    
        var is_time_window_full = _price_history.size() > time_window
        if is_time_window_full:
            _clear_old()

func _dump_stack_to_history():
    for _i in range(_price_stack.size() - 1):
        var price = _price_stack.pop_front()
        _price_history.push_back(price)

func _clear_old():
    for _i in range(_price_history.size() - time_window):
        _price_history.pop_front()

func price_history() -> Array:
    return _price_history
