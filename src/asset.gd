extends Control

var _price_history = []

const INITIAL_PRICE = 2.00

var _price_stack = []
const _stack_size: int = 4

const time_window: int = 240

export(float) var MIN_PRICE = 1.50
export(float) var MAX_PRICE = 5.00

onready var rng = RandomNumberGenerator.new()

enum UP_KEYS {KEY_UP = 16777232, KEY_R = 82, KEY_T = 84, KEY_Y = 89, KEY_U = 85, KEY_I = 73, KEY_O = 79}
enum DOWN_KEYS {KEY_DOWN = 16777234, KEY_F = 70, KEY_G = 71, KEY_H = 72, KEY_J = 74, KEY_K = 75, KEY_L = 76}
export(UP_KEYS) var up_key
export(DOWN_KEYS) var down_key

func _ready():
    _price_stack.push_back(rand_range(MIN_PRICE, MAX_PRICE))
    rng.randomize()

    for _i in range(4*time_window):
        self.tick()
    
func curr_price() -> float:
    return _price_stack[-1]

func _draw():
    var candle_list = _get_candle_list()

    for i in range(0, candle_list.size()):
        var candle = candle_list[i]
        _draw_candle(i, candle,
            (_price_history + _price_stack).min(), (_price_history + _price_stack).max())

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

    var little_candle_width = 1.0
    var x = idx * candle_width * gap_ratio + 1

    var open_price = candle[0]
    var close_price = candle[-1]

    var mapped_open_price = _map(open_price, min_hist, max_hist, rect_size.y - 1, 0)
    var mapped_close_price = _map(close_price, min_hist, max_hist, rect_size.y - 1, 0)
    var height = mapped_close_price - mapped_open_price

    var color = Color.green
    if close_price < open_price:
        color = Color.black

    var min_price = candle.min()
    var max_price = candle.max()
    
    var mapped_min_price = _map(min_price, min_hist, max_hist, rect_size.y - 1, 0)
    var mapped_max_price = _map(max_price, min_hist, max_hist, rect_size.y - 1, 0)

    var min_max_height = mapped_max_price - mapped_min_price

    # little candle
    draw_rect(Rect2(
        x + 0.45 * candle_width, mapped_min_price,
        little_candle_width, min_max_height
        ), Color.green, true)

    # big candle
    draw_rect(Rect2(x, mapped_open_price, candle_width, height), color, true)
    draw_rect(Rect2(x, mapped_open_price, candle_width, height), Color.green, false, 1.0)

func get_price_force() -> float:
    # apply high force to keep price above 2 and apply
    # smaller force to keep below 20
    var x = curr_price()
    var y = (1 / (4*x - MIN_PRICE)) - (0.008 * pow(x - 4, 3)) - 0.1

    return y

func tick():
    var mean = 0.0

    if Input.is_key_pressed(up_key):
        mean = rand_range(0.01, 0.2)
    elif Input.is_key_pressed(down_key):
        mean = -rand_range(0.01, 0.2)

    var new_price = curr_price() + rng.randfn(mean, 0.02)
    while new_price < MIN_PRICE:
        new_price = curr_price() + rng.randfn(0.02, 0.05)
    while new_price > MAX_PRICE:
        new_price = curr_price() + rng.randfn(-0.02, 0.05)

    _price_stack.push_back(new_price)

    var is_price_stack_full = _price_stack.size() > _stack_size
    if is_price_stack_full:
        _dump_stack_to_history()
    
        var is_time_window_full = _price_history.size() > time_window
        if is_time_window_full:
            _clear_old()
    
    var price_text = "%2.1f EUR" % curr_price()
    $Label.text = "{} {}".format([name, price_text], "{}")

func _dump_stack_to_history():
    for _i in range(_price_stack.size() - 1):
        var price = _price_stack.pop_front()
        _price_history.push_back(price)

func _clear_old():
    for _i in range(_price_history.size() - time_window):
        _price_history.pop_front()

func price_history() -> Array:
    return _price_history

func _map(value, istart, istop, ostart, ostop):
    return ostart + (ostop - ostart) * ((value - istart) / (istop - istart))
