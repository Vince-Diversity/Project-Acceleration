class_name SetAct extends IdleFrameAct
## An act that calls any setter in [class DialogueCutscene].
##
## This allows setters to be run fluently during an [class AsyncAct].
## It is intended for setters or other methods that
## only need one frame to finish.

var setter: Callable
var setter_args: Array


## Initialises this class.
func init_act(given_setter: Callable, given_setter_args: Array):
	setter = given_setter
	setter_args = given_setter_args


## Calls the setter
func enter():
	setter.callv(setter_args)
