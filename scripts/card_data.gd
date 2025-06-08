class_name CardData

enum CardType { BRUDER, SONDERKARTE }

var name: String
var type: CardType
var value: int = 0            # Nur bei Bruder sinnvoll
var color: String = ""        # Nur bei Bruder sinnvoll
var sprite_path: String = ""  # Bildpfad für Darstellung

func _init(_name: String, _type: CardType, _value := 0, _color := "", _sprite_path := ""):
	name = _name
	type = _type
	value = _value
	color = _color
	sprite_path = _sprite_path
