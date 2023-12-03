extends Button

signal selected(name:String)

func _on_pressed():
	emit_signal("selected", text + ".tscn")
#	print("Scene selected: ", text + ".tscn")
