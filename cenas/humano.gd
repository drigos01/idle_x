extends PanelContainer
#
#func _on_panel_containerhumanos_mouse_entered() -> void:
	## Obtém o nome da raça com base no nome do nó atual (supondo que o nome do nó seja o nome da raça)
	#var nome_raca := self.name.capitalize()
	#print("Raça detectada:", nome_raca)
#
	## Verifica se a raça existe no dicionário Global.racas
	#if Global.racas.has(nome_raca):
		#var dados = Global.racas[nome_raca]
#
		## Define o nome da raça
		#$layer/personagem/descricao_racas/nome_raca.text = nome_raca
#
		## Define a descrição
		#$layer/personagem/descricao_racas/nome_raca/descrição.text = dados.get("descricao", "Sem descrição.")
#
		## Monta os atributos formatados
		#var atributos_text := ""
		#for atributo in dados.get("atributos", {}):
			#atributos_text += "%s: %s\n" % [atributo.capitalize(), str(dados["atributos"][atributo])]
		#$layer/personagem/descricao_racas/nome_raca/atributos.text = atributos_text
#
		## Monta os bônus formatados
		#var bonus_text := ""
		#for bonus in dados.get("bonus", {}):
			#bonus_text += "%s: +%s\n" % [bonus.capitalize(), str(dados["bonus"][bonus])]
		#$layer/personagem/descricao_racas/nome_raca/atributos/bonus.text = bonus_text
#
	#else:
		#print("Raça não encontrada:", nome_raca)

#func _on_mouse_entered() -> void:
	#var nome_raca := self.name.capitalize()
	#print("Raça detectada:", nome_raca)
#
	## Verifica se a raça existe no dicionário Global.racas
	#if Global.racas.has(nome_raca):
		#var dados = Global.racas[nome_raca]
#
		## Define o nome da raça
		#$"../descricao_racas/nome_raca".text = nome_raca
#
		## Define a descrição
		#$"../descricao_racas/nome_raca/descrição".text = dados.get("descricao", "Sem descrição.")
#
		## Monta os atributos formatados
		#var atributos_text := ""
		#for atributo in dados.get("atributos", {}):
			#atributos_text += "%s: %s\n" % [atributo.capitalize(), str(dados["atributos"][atributo])]
		#$"../descricao_racas/nome_raca/atributos".text = atributos_text
#
		## Monta os bônus formatados
		#var bonus_text := ""
		#for bonus in dados.get("bonus", {}):
			#bonus_text += "%s: +%s\n" % [bonus.capitalize(), str(dados["bonus"][bonus])]
		#$"../descricao_racas/nome_raca/atributos/bonus".text = bonus_text
#
	#else:
		#print("Raça não encontrada:", nome_raca)

#
#func _on_mouse_exited() -> void:
	#$"../descricao_racas/nome_raca/descrição".text = ""
	#$"../descricao_racas/nome_raca/atributos/bonus".text = ""
	#$"../descricao_racas/nome_raca/atributos".text = ""
	#$"../descricao_racas/nome_raca".text = ""


func _on_mouse_entered() -> void:
	Global.descricao_raca = self.name.capitalize()
	$"../seleção_grande".visible = true


func _on_mouse_exited() -> void:
	$"../seleção_grande".visible = false
