extends Node

enum Rooms {
	INTERSECTION,
	GYM,
	CAT_LAB
	}

const room_names = {
	Rooms.INTERSECTION: "intersection",
	Rooms.GYM: "gym",
	Rooms.CAT_LAB: "cat_lab"
}

var YELLOW = "Richy"
var GREEN = "Misa"
var RED = "Clara"
var BLUE = "Ari"
var TEACHER = "Phenia"
var CAT = "Erwin 1.0"
var REVEALER = "Revealing Eyepiece"

var action_names = {
	REVEALER: "Reveal"
}

var action_keys = {
	REVEALER: "z"
}

var action_suffix = {
	REVEALER: "revealed"
}
