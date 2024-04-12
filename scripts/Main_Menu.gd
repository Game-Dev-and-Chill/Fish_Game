
#MainMenu.gd
#@tool
#class_name MainMenu
extends CenterContainer
#docstring


#region Variables
#signals
#enums
#constants
#@export variables
#public variables
#private variables
#@onready variables
#endregion


#region Functions
#optional built-in virtual _init method
#optional built-in virtual _enter_tree() method
#optional built-in virtual _ready method - Called when the node enters the scene tree for the first time.
func _ready():
	pass
#region remaining built-in virtual methods
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
#endregion
#region public methods
#endregion
#region private methods
#endregion
#region subclasses
#endregion
#endregion

#region Auto_Include_Functions
#endregion


func _on_exit_button_pressed():
	get_tree().quit()


func _on_start_button_pressed():
	$"Main Menu".hide()
	$".".game_start()
