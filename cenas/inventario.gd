extends Node2D

	
func _input(event: InputEvent) -> void:
	if event is InputEventKey and event.is_action_pressed("i") and not event.echo:
			var inventario = $"."
			var anim = inventario.get_node("AnimationPlayer")
					
			if inventario.visible:
				anim.play("desaparecer")
				await anim.animation_finished
				inventario.visible = false
			else:
				inventario.visible = true
				anim.play("aparecer")
				
			print("🟡 Inventário alternado")
