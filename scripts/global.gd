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
var raça_selecionado = ""


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



func _ready():
	# Opcional: inicializa vazio
	inimigos.clear()
	jogador.clear()
	
	
