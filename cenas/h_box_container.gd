extends HBoxContainer
func desmarcar_outros_slots(slot_selecionado):
	for slot in get_children():
		if slot != slot_selecionado and slot.has_method("desmarcar_slot"):
			slot.desmarcar_slot()
