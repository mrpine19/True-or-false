
tfm.exec.disableAfkDeath(true)
tfm.exec.disableAutoShaman(true)
tfm.exec.disableAutoNewGame(true)
tfm.exec.disableAutoScore(true)
tfm.exec.disableAutoTimeLeft(true)

-------------------------------------------------------------DEFINIÇÃO DAS VARIAVEIS------------------------------------------------------------
local mestre = "" -- quem vai ser o perguntador. como é randomico, começa nulo
players = {} -- armazena a quantidade de jogadores da sala
lang = {} -- armazena as mensagens do jogo
id = {}
perguntaFeita = false
necessarioResetar = false
fimDoTempo = false
atualSituacao = "começo"
boolean = resposta
timer = 0
num_de_jogadores_vivos = 0
qtd_de_jogadores = -1
rodada = 0
pontuacao = -1

lang.br = {

	botao_pergunta = "Clique aqui para fazer a pergunta",
	pergunta = "Digite a pergunta: ",
	more_players = "Deve ter, no mínimo, dois jogadores para o jogo começar!",
	question = "Digite a pergunta: ",
	verdadeiro = "Verdadeiro",
	falso = "Falso"
	
}

pisoTrue = {type = 12,width = 326,height = 30,foregound = 1,friction = 1.0,restitution = 0.0,angle = 0,color = '0x00FF7F',miceCollision = true,groundCollision = true,dynamic = false}
pisoFalse = {type = 12,width = 326,height = 30,foregound = 1,friction = 1.0,restitution = 0.0,angle = 0,color = '0xFF0000',miceCollision = true,groundCollision = true,dynamic = false}
pisoGelo = {type = 1,width = 152,height = 10,foregound = 1,friction = 1.0,restitution = 0.0,angle = 0,color = 0,miceCollision = true,groundCollision = true,dynamic = false}
text = lang.br

imagens = {img="174042eda4f.png", w=28, h=29}



id["question_button"] = 1
id["one_player_label"] = 2
id["turn_label1"] = 3
id["turn_label2"] = 4
id["ask_word_popup"] = 5
id["question_label"] = 6
id["resposta_true"] = 7
id["resposta_false"] = 8
id["piso_verdadeiro"] = 9
id["piso_falso"] = 10
id["piso_gelo"] = 11
id["question_reset"] = 12
id["jogo_vencido"] = 13
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

--------------------------------------------------------------função que dá as configurações iniciais do jogo------------------------------------------------------------
function eventNewGame()

	perguntaFeita = false

	num_de_jogadores_vivos = 0
	--DEFININDO A QUANTIDADE DE JOGADORES
	for name,player in next,tfm.get.room.playerList do
		num_de_jogadores_vivos=num_de_jogadores_vivos+1
	end 
	updatePlayersList()
	tfm.exec.newGame("@7917347")
	--tfm.exec.addImage(String nomeDaImagem, String target, Int posiçãoX, Int posiçãoY, String targetPlayer)
	tfm.exec.addImage("174042eda4f.png", "%Fake_da_annyxd#7479", -21, -30)
	--tfm.exec.addImage("149a49e4b38.jpg", "?2", 500, 0)
	--tfm.exec.addImage("15150c10e92.png", "?2", 0, 0)

	--tfm.exec.addImage("1651b3019c0.png", "+9", 0, 0)

		
	if numeroDeJogadores() > 1 then
		mestre = randomPlayer()
		tfm.exec.movePlayer(mestre, 400, 220, false, 0, 0, false) -- AJUSTAR A POSIÇÃO DO PERGUNTADOR
		tfm.exec.killPlayer(mestre)
		askQuestion()
		ui.addTextArea(id["one_player_label"], "<font size='20'><p align='center'><BL><font color='#DCDCDC'>" .."Aguarde enquanto "..mestre.." faz a pergunta".. "</font></font></p>", nil, 20, 340, 750, 30, 0xC0C0C0, 0xC0C0C0, 0f)
	else
		ui.addTextArea(id["one_player_label"], "<font size='20'><p align='center'><BL><font color='#DCDCDC'>" ..text.more_players.. "</font></font></p>", nil, 20, 340, 750, 30, 0xC0C0C0, 0xC0C0C0, 0f)	
	end

end
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------PONTUAÇÃO----------------------------------------------------------------
for name,player in pairs(tfm.get.room.playerList) do
  tfm.exec.setPlayerScore(name, 0, false)
end


------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------ATUALIZA A LISTA DE JOGADORES DA SALA------------------------------------------------------------
function updatePlayersList()
  players = {}
	  
  for p,_ in pairs(tfm.get.room.playerList) do
  	table.insert(players, p)
  end
end
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

---------------------------------------------------------------------BOTÃO PERGUNTA-----------------------------------------------------------------------------------------------------------------
function askQuestion()
	if not perguntaFeita then
		--ui.addTextArea(id["question_button"], "", mestre, 66, 322, 660, 81, 0xC0C0C0, 0x595959, 1f) 

		--BOTÃO PERGUNTA:
		ui.addTextArea(id["question_button"], "<p align='center'><a href='event:callbackAskWord'>"..text.botao_pergunta.."</a></p>", mestre, 300, 120, 210, 20, 0x595959, 0x595959, 1f) --BOTÃO PERGUNTA
    ui.addTextArea(id["turn_label1"], "<font size='13'><p align='center'><BL><font color='#8B008B'>".."É a vez de: "..mestre.."</font></font></p>", p, -250, 30, 750, 30, 0xC0C0C0, 0xC0C0C0, 0f)
    --ui.addTextArea(9, "", p, 20, 300, 750, 100, 0x128309, 0x128309, 1f)
      		
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

---------------------------------------------FUNCTIONS SOBRE A ENTRADA E SAIDA DE JOGADORES------------------------------------------------------------

function numeroDeJogadores() -- pega a quantidade de jogadores da sala
	return #players
end

function eventNewPlayer(nomeDoJogador)
  qtd_de_jogadores = qtd_de_jogadores + 1
end

for name,player in next,tfm.get.room.playerList do
	eventNewPlayer(name)
end
function eventPlayerLeft(name)
	qtd_de_jogadores = qtd_de_jogadores - 1
end
function eventPlayerDied(name)
	num_de_jogadores_vivos = num_de_jogadores_vivos - 1
end

--------------------------------------------FALTA DEFINIR QUANDO O JOGADOR SAIR DA SALA------------------------------------------------------------

--------------------------------------------------------FUNCTION PARA DEFINIR O MESTRE------------------------------------------------------------
function randomPlayer()
	return players[math.random(1,#players)]
end


-----------------------------------------------------QUANDO O JOGADOR DECIDE SE É TRUE OR FALSE------------------------------------------------------------
function eventTextAreaCallback(textAreaId, playerName, callback)
  	if callback=="callbackAskWord" then
  		perguntaFeita = true
  		--addPopup(Int id, Int type, String text, String targetPlayer, Int x, Int y, Int width, Boolean fixedPos (false))
    	ui.addPopup(id["ask_word_popup"], 2, text.question, mestre, 300, 120, 200) 
  	end

  	if callback == "callbackTrue" then
  		tfm.exec.setGameTime(5)
  		tfm.exec.removePhysicObject(id["piso_gelo"])
  	 	ui.addTextArea(id["question_label"], "<font size='20'><p align='center'><BL><font color='#DCDCDC'>" ..questionPlayer.. "</font></font></p>", nil, 20, 300, 750, 100, 0xC0C0C0, 0xC0C0C0, 0f)
  	 	ui.removeTextArea(id["question_button"])
  	 	ui.removeTextArea(id["resposta_true"])
  	 	ui.removeTextArea(id["resposta_false"])
  	 	resposta = true

  	end

  	if callback == "callbackFalse" then
  		tfm.exec.setGameTime(5)
  		tfm.exec.removePhysicObject(id["piso_gelo"])
  	 	ui.addTextArea(id["question_label"], "<font size='20'><p align='center'><BL><font color='#DCDCDC'>" ..questionPlayer.. "</font></font></p>", nil, 20, 300, 750, 100, 0xC0C0C0, 0xC0C0C0, 0f)
  	 	ui.removeTextArea(id["question_button"])
  	 	ui.removeTextArea(id["resposta_true"])
  	 	ui.removeTextArea(id["resposta_false"])
  	 	resposta = false
  	end
end

function eventPopupAnswer(popupId, playerName, answer)
  if popupId==id["ask_word_popup"] and mestre==playerName then
  	--criar cenário pós pergunta ser enviada
  	questionPlayer = answer
  	ui.addTextArea(id["resposta_true"], "<p align='center'><a href='event:callbackTrue'>"..text.verdadeiro.."</a></p>", mestre, 330, 150, 80, 20, 0x595959, 0x595959, 1f)
  	ui.addTextArea(id["resposta_false"], "<p align='center'><a href='event:callbackFalse'>"..text.falso.."</a></p>", mestre, 430, 150, 50, 20, 0x595959, 0x595959, 1f)
   	--ui.removeTextArea(id["question_button"])
    ui.removeTextArea(id["one_player_label"]) 

  end
end


function eventLoop(tempoAtual, tempoRestante)
	ui.setMapName("Verdadeiro ou falso! Ratos vivos "..num_de_jogadores_vivos.." de "..qtd_de_jogadores.."                                  Rodada atual: "..rodada)
	timer = timer + 0.5

	if timer==25 and not perguntaFeita and qtd_de_jogadores > 1 then
    fimDoTempo = true
    reset()
  end

	--ALTERANDO A SITUAÇÃO DA PARTIDA
	if tempoAtual < 2000 and atualSituacao == "começo" then
		atualSituacao = "pergunta"
		novaPergunta()
	end

	if tempoRestante < 1250 and atualSituacao == "pergunta" then
	--if atualSituacao == "pergunta" then
		for name,player in next,tfm.get.room.playerList do
			if tfm.get.room.playerList[name].x >= 330 and tfm.get.room.playerList[name].x <= 480 then
				tfm.exec.killPlayer(name)
			end
		end
		tfm.exec.setGameTime(6)

		if resposta == true then
			tfm.exec.removePhysicObject(id["piso_falso"])
			atualSituacao = "intervalo"
		end

		if resposta == false then
			tfm.exec.removePhysicObject(id["piso_verdadeiro"])
			atualSituacao = "intervalo"

		end
	end

	if atualSituacao == "pergunta" and tempoRestante >= 1 then
		-----------------------------------AQUI O TEMPO
		ui.addTextArea(33,"<p align='center'><font size='45'>"..math.floor((tempoRestante/1000)-1).."",nil,360,215,80,60,0x000001,0x494949,1.0,true)
	else
		ui.removeTextArea(33,nil)
	end

	--1 segundo = 1000 milisegundos 0,00
	if tempoRestante < 1 and atualSituacao == "intervalo" then
				novaPergunta()
	end

	if (num_de_jogadores_vivos == 0) then
				ui.addTextArea(id["question_reset"], "<font size='20'><p align='center'><BL><font color='#DCDCDC'>" .."Tudo ruim heheheheeh".. "</font></font></p>", nil, 20, 290, 750, 30, 0xC0C0C0, 0xC0C0C0, 0f)
				ui.removeTextArea(id["question_label"])
				tfm.exec.setGameTime(5)
				atualSituacao = "fim_do_jogo2"
	end

	if tempoRestante <= 1500 and num_de_jogadores_vivos == 0 and modo == "fim_do_jogo" then
		for name,player in next,tfm.get.room.playerList do
			if not tfm.get.room.playerList[name].isDead then
			ui.addTextArea(id["jogo_vencido"], "<font size='20'><p align='center'><BL><font color='#DCDCDC'>" .."O jogador "..mestre.." venceu!!".. "</font></font></p>", nil, 20, 340, 750, 30, 0xC0C0C0, 0xC0C0C0, 0f)
			end
		end
	end
	if tempoRestante < 50 then
		if atualSituacao == "fim_do_jogo" or atualSituacao == "fim_do_jogo2" then
			atualSituacao="começo"
			reset()
		end
	end
end
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

------------------------------------------------DEPOIS QUE A GALERA MORRE E PRECISA DE UMA NOVA PERGUNTA------------------------------------------------------------
function novaPergunta()
	perguntaFeita = false
	rodada = rodada + 1
	pontuacao = pontuacao + 1
	ui.removeTextArea(id["question_label"])
	for name,player in next,tfm.get.room.playerList do
		tfm.exec.movePlayer(name,400,60,false)
		if (name~=mestre) then
			if (rodada == 1) then
				tfm.exec.setPlayerScore(name, 0, false)
			else
  			tfm.exec.setPlayerScore(name, pontuacao, false)
  		end
  	end
	end
	atualSituacao = "pergunta"
	resposta = ""
	tfm.exec.setGameTime(15)
	tfm.exec.addPhysicObject(id["piso_gelo"], 400, 120, pisoGelo)
	tfm.exec.addPhysicObject(id["piso_verdadeiro"], 163, 275, pisoTrue)
	tfm.exec.addPhysicObject(id["piso_falso"], 638, 275, pisoFalse)
	askQuestion()
	atualSituacao = "pergunta"
	ui.addTextArea(id["one_player_label"], "<font size='20'><p align='center'><BL><font color='#DCDCDC'>" .."Aguarde enquanto "..mestre.." faz a pergunta".. "</font></font></p>", nil, 20, 340, 750, 30, 0xC0C0C0, 0xC0C0C0, 0f)
end

----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

------------------------------------------------------------PRECISA MELHORAR O RESET---------------------------------------------------------------------------------------------------------------

function reset()
	modo="começo"

	rodada = 0
	pontuacao = -1

	tfm.exec.newGame("@7917347")
	for name,player in pairs(tfm.get.room.playerList) do
  	tfm.exec.setPlayerScore(name, 0, false)
	end
end

reset()
