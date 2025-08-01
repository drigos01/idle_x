extends Node

var username = ""
var email = ""
var senha = ""
var mouse_sobre_chat = true
var players = {}
var show_mensagem_alerta = ""

var imagem_apresentacao_token = ""
var imagem_apresentacao_token_propocao = Rect2(Vector2(0, 0), Vector2(64, 64))
var alvo_selecionado = ""
var imagem_apresentacao_personagem = ""
var imagem_apresentacao_personagem_propocao = Rect2(Vector2(0, 0), Vector2(64, 64))

# Variável privada
var _raça_selecionado: String = ""

var slots_disponiveis = 3
var personagem_selecionado: Dictionary = {}
var selecionado_slots_selecao = ""
var selecionado_slots_estado = ""


var botao_selecao = false
var slot_selecionado_node = null


var dinheiro = 0
# Agora uma lista de personagens (não mais um dicionário único)
var personagens_criados: Array = [
	{
		"nome": "drig_dev",
		"imagem": preload("res://imagens/personagens/elfos.png"),
		"imagem_position": Rect2(Vector2(6.41696, 1.654), Vector2(261.0, 279.0)),
		"token": preload("res://imagens/layer/toke_1.png"),
		"token_position": Rect2(Vector2(520.375, 493.066), Vector2(239.625, 209.25)),
		"nivel": 1
	}
]

# Propriedade com getter e setter
var raça_selecionado:
	get:
		return _raça_selecionado
	set(value):
		_raça_selecionado = value
		atualizar_atributos_completos()

var inimigos: Dictionary = {}
var jogador: Dictionary = {}

var valor_total_distribuir_criacao_personagem = 5
var pontos_usados = 5
var show_erro = false
var valor_show_erro_passar = ""
var descricao_raca = ""

var racas = {
	"Humano": {
		"imagem": "res://imagens/personagens/images (1).jpg",
		"descricao": "Filhos da adaptação, os humanos prosperam em qualquer canto do mundo. Suas ambições moldam impérios e suas escolhas definem o curso da história.",
		"atributos": {"destreza": 2, "sabedoria": 1},
		"bonus": {"forca": 1, "destreza": 1, "constituicao": 1, "inteligencia": 1, "sabedoria": 1, "carisma": 1}
	},
	"Elfo": {
		"imagem": "res://imagens/personagens/images (2).jpg",
		"descricao": "Criaturas da graça e da antiguidade, os elfos são moldados pela magia e pela arte. Seus olhos veem além do tempo e seus movimentos dançam com a perfeição da floresta.",
		"atributos": {"destreza": 2, "sabedoria": 1},
		"bonus": {"destreza": 2, "sabedoria": 1}
	},
	"Anao": {
		"imagem": "res://imagens/personagens/images (2).jpg",
		"descricao": "Forjados sob a montanha, os anões são tão resistentes quanto o aço que moldam. Teimosos, leais e incansáveis, eles enfrentam qualquer adversidade com martelo em punho.",
		"atributos": {"constituicao": 2, "forca": 1},
		"bonus": {"constituicao": 2, "forca": 1}
	}
}

var atributos_completos = {
	"forca": 0,
	"destreza": 0,
	"constituicao": 0,
	"inteligencia": 0,
	"sabedoria": 0,
	"carisma": 0
}

func atualizar_atributos_completos():
	var nome_raca = raça_selecionado.strip_edges()
	var regex := RegEx.new()
	regex.compile("[0-9]")
	nome_raca = regex.sub(nome_raca, "", true)

	var dados = racas.get(nome_raca, {})

	# Zera tudo
	atributos_completos = {
		"forca": 0,
		"destreza": 0,
		"constituicao": 0,
		"inteligencia": 0,
		"sabedoria": 0,
		"carisma": 0
	}

	# Soma os valores de atributos + bônus
	for chave in atributos_completos.keys():
		var valor_attr = dados.get("atributos", {}).get(chave, 0)
		var valor_bonus = dados.get("bonus", {}).get(chave, 0)
		atributos_completos[chave] = valor_attr + valor_bonus

	print("Atributos atualizados:", atributos_completos)

# Função para adicionar um novo personagem na lista
func adicionar_personagem(dados: Dictionary) -> void:
	if personagens_criados.size() >= slots_disponiveis:
		print("Limite de personagens atingido.")
		return
	personagens_criados.append(dados)
	print("Personagem adicionado:", dados.nome)

# Função auxiliar: retorna total de personagens criados
func total_personagens() -> int:
	return personagens_criados.size()

func _ready():
	inimigos.clear()
	jogador.clear()
