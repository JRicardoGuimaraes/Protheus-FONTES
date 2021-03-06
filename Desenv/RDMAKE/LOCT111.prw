#Include "Protheus.ch"                                                                                                                     
#Include "Rwmake.ch"
#Include 'TOPCONN.CH'                                       
#Include "ap5mail.ch"   
#include "TBICONN.CH"

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �          Autor   �M&S Consultoria     � Data �  30/06/07   ���
�������������������������������������������������������������������������͹��
���Descricao � Apontador AS                                               ���
�������������������������������������������������������������������������͹��
���Uso       �                                                            ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

User Function LOCT111()
Private cCadastro := "DTQ" 
Private aRotina   := {{"Pesquisar"        ,"AxPesqui" 			,0,1}}		// Pesquisar


	dbSelectArea('DTQ')
	dbGoTop()
	mBrowse( 6, 1,22,75,"DTQ")

return nil

static function xxxx
Local   aCpos       := {}
Private aBrowse		:= {}
Private aRotina		:= {}
Private cCadastro	:= "Aprova��o de AST"
Private aFilterExp	 := {}								//Variavel para Filtro
//Private cExpFiltro	:= 'DTQ->DTQ_DATGER>=mv_par01 .and. DTQ->DTQ_DATGER<=mv_par02 .and. DTQ->DTQ_TPAS==cServ .and. DTQ->DTQ_FILORI==cFilAnt'		//Variavel para Filtro
//Private cExpFiltro	:= 'DTQ->DTQ_DATINI>=mv_par01 .and. DTQ->DTQ_DATFIM<=mv_par02 .and. DTQ->DTQ_TPAS==cServ .and. DTQ->DTQ_FILORI==cFilAnt .and. Empty(DTQ_TPCTRC)'		//Variavel para Filtro
//Private cExpFiltro	:= 'DTQ->DTQ_DATINI>=mv_par01 .and. DTQ->DTQ_DATINI<=mv_par02 .and. DTQ->DTQ_TPAS==cServ .and. DTQ->DTQ_FILORI==cFilAnt .and. Empty(DTQ_TPCTRC)'		//Variavel para Filtro
Private cExpFiltro	:= 'DTQ->DTQ_DATINI>=mv_par01 .and. DTQ->DTQ_DATINI<=mv_par02 .and. DTQ->DTQ_TPAS==cServ .and. Empty(DTQ_TPCTRC) .and. DTQ->DTQ_FILORI $ mv_par03' //DTQ->DTQ_FILORI==cFilAnt .and. 		//Variavel para Filtro
Private aIndex		:= {}								//Variavel para Filtro
//Private cFiltro 	:= 'DTQ->DTQ_DATGER>=mv_par01 .and. DTQ->DTQ_DATGER<=mv_par02 .and. DTQ->DTQ_TPAS==cServ .and. DTQ->DTQ_FILORI==cFilAnt'		//Variavel para Filtro
//Private cFiltro 	:= 'DTQ->DTQ_DATINI>=mv_par01 .and. DTQ->DTQ_DATFIM<=mv_par02 .and. DTQ->DTQ_TPAS==cServ .and. DTQ->DTQ_FILORI==cFilAnt .and. Empty(DTQ_TPCTRC)'		//Variavel para Filtro
//Private cFiltro 	:= 'DTQ->DTQ_DATINI>=mv_par01 .and. DTQ->DTQ_DATINI<=mv_par02 .and. DTQ->DTQ_TPAS==cServ .and. DTQ->DTQ_FILORI==cFilAnt .and. Empty(DTQ_TPCTRC)'		//Variavel para Filtro
Private cFiltro 	:= 'DTQ->DTQ_DATINI>=mv_par01 .and. DTQ->DTQ_DATINI<=mv_par02 .and. DTQ->DTQ_TPAS==cServ .and. Empty(DTQ_TPCTRC) .and. DTQ->DTQ_FILORI $ mv_par03' //Variavel para Filtro
Private bFiltraBrw  := {|| Nil}							//Variavel para Filtro
Private bEndFilBrw  := {||EndFilBrw("DTQ",@aIndex)}		//Variavel para Filtro
Private nOrdPesq	:= DTQ->(IndexOrd())       			//Variavel para Filtro
Private cPerg       := "LOC111"
Private cServ	    := ""
Private aCores

	ValidPerg()

	IF ! Pergunte(cPerg,.T.)
		RETURN NIL
	ENDIF
	
	//Trata Filial
	
	mv_par03 :=  StrTran(StrTran(StrTran(FormatIn(AllTrim(mv_par03),,2),"'",""),"(",""),")","")

/*
cServ := Iif(mv_par03==1,"T",;			//Transporte
		 Iif(mv_par03==2,"G",;			//Guindaste
		 Iif(mv_par03==3,"U",;			//Grua
		 Iif(mv_par03==4,"R",;			//Remo��o Mec�nica
		 Iif(mv_par03==5,"P","")))))	//Plataforma
*/

//cServ := if(mv_par03 $ "TGURPFM", mv_par03, "")	// Mudei para poder incluir a op��o Frete - Cristiam Rossi em 01/09/2011 
	cServ := "T" //sempre vai ser Transporte GEFCO

	If MV_PAR03 = "F"
		cFiltro 	:= 'DTQ->DTQ_TPAS==cServ .and. DTQ->DTQ_FILORI==cFilAnt'		//Variavel para Filtro 
		cExpFiltro	:= 'DTQ->DTQ_TPAS==cServ .and. DTQ->DTQ_FILORI==cFilAnt'
	Endif

	AAdd(aRotina,{"Pesquisar"        ,"AxPesqui" 			,0,1} )		// Pesquisar
	Aadd(aRotina,{"Imprime AST"       ,"U_ImpAS()"			,0,2} )		// Impress�o da  AS
  //Aadd(aRotina,{"Fecha   AST"       ,"U_FecAS()"			,0,3} )		// Fecha         AS
  //Aadd(aRotina,{"Encerra AST"       ,"U_EncAS()"			,0,4} )		// Encerra       AS
	Aadd(aRotina,{"Reabre  AST"       ,"U_AbrAS()"			,0,5} )		// Reabertura da AS
	Aadd(aRotina,{"Rejeita AST"       ,"U_RejAS()"			,0,6} )		// Rejeita AS do Dia
	Aadd(aRotina,{"Aceitar AST"       ,"U_AceAS()"			,0,7} )		// Aceita  AS selecionada - Cristiam Rossi em 10/05/2011
  //Aadd(aRotina,{"AS do Dia "       ,"U_FilAS()"			,0,6} )		// Filtra AS do Dia
  //Aadd(aRotina,{"Todas   AS"       ,"Eval(bEndFilBrw)"	,0,7} )		// Limpa Filtro das AS 
  //Aadd(aRotina,{"Envia email"      ,"U_GerMail()"		,0,7} )		// Envia email
	if cServ == "F"
		Aadd(aRotina,{"Programa��o"      ,"U_PrgFrt111()"		,0,7} )		// Di�logo que preenche alguns campos - Cristiam Rossi em 02/09/2011
	endif
	Aadd(aRotina,{"Lote"             ,"U_FLote111()"		,0,7} )		// Tratamente AS por Lote
	Aadd(aRotina,{"Legenda"          ,"U_L111LG"			,0,8} )		// Legenda
	Aadd(aRotina,{"Planilha PDF"     ,"U_LOCR001"			,0,9} )		// Alison 02/01/14
	//Aadd(aRotina,{"Trocar Equip."    ,"U_L111TREQ"			,0,10} )	// Alison 17/02/14 - Troca Equipamento

	aCores := { {' Empty(DTQ->DTQ_DATFEC) .and.  Empty(DTQ->DTQ_DATENC) .and. DTQ->DTQ_STATUS == "1"', 'BR_VERDE'    },; //  pendente
				{'!Empty(DTQ->DTQ_DATFEC) .and.  Empty(DTQ->DTQ_DATENC) .and. DTQ->DTQ_STATUS == "1"', 'BR_AMARELO'  },; //  fechada
	            {'!Empty(DTQ->DTQ_DATENC) .and. !Empty(DTQ->DTQ_DATENC) .and. DTQ->DTQ_STATUS == "1"', 'BR_AZUL'     },; //  encerrado
	            {'!DTQ->DTQ_STATUS $ "1/6" '														 , 'BR_VERMELHO' },; //  rejeitado
	            {'DTQ->DTQ_STATUS == "6"'															 , 'BR_LARANJA'  } } //  aceita

//	bFiltraBrw 	:= {|cCompleta| FilBrowse("DTQ", @aIndex,@cFiltro,.F.) }
//	Eval(bFiltraBrw,cExpFiltro)

	
	aadd(aCpos, {"Filial Ori.","DTQ_FILORI"} )
	aadd(aCpos, {"Viagem"     ,"DTQ_VIAGEM"} )
	aadd(aCpos, {"Num. AST"    ,"DTQ_AS"    } )	// Campos a serem exibidos no mBrowse
	aadd(aCpos, {"Projeto"    ,"DTQ_SOT"   } )
	aadd(aCpos, {"Dt. Coleta","DTQ_DATGER"} )
	aadd(aCpos, {"Tp. Veiculo","DTQ_EQUIP" } )
	aadd(aCpos, {"Descr. Veic","DTQ_EQUIPD"} )	//	DUT
	aadd(aCpos, {"Pag. Frete" ,"DTQ_NOMCLI"} )
	aadd(aCpos, {"Cli. Coleta","DTQ_CLICOL"} )	//	pela Viagem		// ZA7
	aadd(aCpos, {"Descr. Rota","DTQ_ROTAD" } )	//  pela AS na ZA6 


	dbSelectArea('DTQ')
	dbGoTop()
//	mBrowse( 6, 1,22,75,"DTQ",aCpos,,,,1,aCores)
	mBrowse( 6, 1,22,75,"DTQ")

Return

**********************
User Function L111LG()
// Legenda
**********************
aLegenda := { {'BR_VERDE'     ,'Em Aberto'},;
			  {'BR_AMARELO'   ,'Fechado'  },;
			  {'BR_AZUL'      ,'Encerrado'},;
			  {'BR_VERMELHO'  ,'Rejeitada'},;
			  {'BR_LARANJA'   ,'AST Aceita'} }

BrwLegenda(cCadastro,"Legenda" ,aLegenda)

Return .T.

*********************
User Function ImpAS()
// Impress�o das AS 
*********************
ZA0->(DbSetOrder(1))
ZA0->(DbSeek(xFilial("DTQ") + DTQ->DTQ_SOT))
If DTQ->DTQ_TPAS # "F"
	Do Case
	Case ZA0->ZA0_TIPOSE $ "G|R|I"	//AS de Guindastes / Remo��o / Transporte Interno (ASG)
		U_LOCI022( DTQ->DTQ_AS )
	Case ZA0->ZA0_TIPOSE == "U"		//AS de Gruas (AS Grua)
		U_LOCI045( DTQ->DTQ_AS )
	Case ZA0->ZA0_TIPOSE $ "T|O"	//AS de Transporte (AST)
		U_LOCI024( DTQ->DTQ_AS )
	Case ZA0->ZA0_TIPOSE $ "P"		//AS de Plataforma (ASP)
		U_LOCI086( DTQ->DTQ_AS )
	Case ZA0->ZA0_TIPOSE == "M"		//AS de Gruas (AS Grua)
		U_LOCI045( DTQ->DTQ_AS )
	OtherWise
		MsgStop("ATEN��O: N�o existe AST definida para esse tipo de servi�o. (" + ZA0->ZA0_TIPOSE + ")")
	EndCase
Else
	U_LOCAASF( DTQ->DTQ_AS )
Endif

Return

*********************
User Function FilAS()
// Filtra AS do dia
*********************

cFiltro := 'DTQ->DTQ_DATGER==dDataBase'
bFiltraBrw 	:= {|cCompleta| FilBrowse("DTQ", @aIndex,@cFiltro,.F.) }

Eval(bFiltraBrw,cExpFiltro)

Return

*********************
User Function FecAS()
// Fecha AS
*********************

If DTQ->DTQ_STATUS == "6"
	MsgAlert("AST Aceita, opera��o cancelada.","Aten��o!")
ElseIf !Empty(DTQ->DTQ_DATFEC)
	MsgAlert("AST j� se encontra fechada.","Aten��o!")
ElseIf !Empty(DTQ->DTQ_DATENC)
	MsgAlert("AST j� se encontra encerrada.","Aten��o!")
ElseIf MsgYesNo("Confirma o fechamento da AST na data de hoje (" + DtoC(dDataBase) + ") ?","Aten��o")
	RecLock("DTQ",.F.)
	DTQ->DTQ_DATFEC := dDataBase
	DTQ->DTQ_HORFEC := Time()
	DTQ->(MsUnLock())
EndIf

Return

*********************
User Function EncAS()
// Encerra AS
*********************

If DTQ->DTQ_STATUS == "6"
	MsgAlert("AST Aceita, opera��o cancelada.","Aten��o!")
ElseIf !Empty(DTQ->DTQ_DATENC)
	MsgAlert("AST j� se encontra encerrada.","Aten��o!")
ElseIf Empty(DTQ->DTQ_DATFEC)
	MsgAlert("AST precisa ser fechada antes de ser encerrada.","Aten��o!")
ElseIf MsgYesNo("Confirma o encerramento da AST na data de hoje (" + DtoC(dDataBase) + ") ?","Aten��o")
	RecLock("DTQ",.F.)
	DTQ->DTQ_DATENC := dDataBase
	DTQ->DTQ_HORENC := Time()
	DTQ->(MsUnLock())
EndIf

Return

*********************
User Function AbrAS()
// Reabre AS
*********************

//Se a AS encontra-se encerrada
Do Case
Case  DTQ->DTQ_STATUS == "6"
	MsgAlert("AST Aceita, opera��o cancelada.","Aten��o!")
Case  DTQ->DTQ_STATUS == "9"
	MsgAlert("AST Rejeitada, opera��o cancelada.","Aten��o!")
Case !Empty(DTQ->DTQ_DATENC)			//Se a AS encontra-se encerrada
	If MsgYesNo("Confirma o estorno do encerramento da AST ?","Aten��o")
		RecLock("DTQ",.F.)
		DTQ->DTQ_DATENC := CtoD("//")
		DTQ->DTQ_HORENC := Space(Len(DTQ->DTQ_HORENC))
		DTQ->(MsUnLock())
	EndIf
Case !Empty(DTQ->DTQ_DATFEC)
	If MsgYesNo("Confirma o estorno do fechamento da AST ?","Aten��o")
		RecLock("DTQ",.F.)
		DTQ->DTQ_DATFEC := CtoD("//")
		DTQ->DTQ_HORFEC := Space(Len(DTQ->DTQ_HORENC))
		DTQ->(MsUnLock())
	EndIf
OtherWise
	MsgAlert("AST encontra-se aberta.","Aten��o!")
EndCase

Return

*********************
User Function RejAS(xMSG)  // Rejeita AS
***********************
Local lOk 		:= .F. 
Local cCC	 	:= Space(100)
Local cCCo	 	:= Space(100)
Local cMsg	 	:= ""
Local cPara	 	:= Space(100)
Local cTitulo	:= Space(100)
Local oAnexo                                                           
Local oCC
Local oCCo
Local oMsg
Local oPara
Local oTitulo
Local eFrom 	:= AllTrim(UsrRetName(RetCodUsr())) + " <" + AllTrim(UsrRetMail(RetCodUsr())) + ">" 
Local aButtons	:= {}
Local cBody		:= ""
Private _oDlgMail

ZA0->(DbSetOrder(1))                                                   
//ZA0->(DbSeek(DTQ->DTQ_FILORI + DTQ->DTQ_SOT))
ZA0->( dbSeek( xFilial("ZA0") + DTQ->DTQ_SOT ) )

cMsg := ZA0->ZA0_OBSDOC + CHR(13)+CHR(10)
_cFil:= xFilial() //Right(AllTrim(DTQ->DTQ_AS),2)

Do Case
Case ZA0->ZA0_TIPOSE == "G"; _cTipoAS := "AS"; cPara := GetMv("MV_REJEG")  ; cCC := "" //GetMv("MV_EMAILG")
Case ZA0->ZA0_TIPOSE == "R"; _cTipoAS := "AS"; cPara := GetMv("MV_REJER")  ; cCC := "" //GetMv("MV_EMAILR")
Case ZA0->ZA0_TIPOSE == "U"; _cTipoAS := "AS"; cPara := GetMv("MV_REJEU")  ; cCC := "" //GetMv("MV_EMAILU")
Case ZA0->ZA0_TIPOSE == "P"; _cTipoAS := "AS"; cPara := GetMv("MV_REJEP")  ; cCC := "" //GetMv("MV_EMAILP")
Case ZA0->ZA0_TIPOSE == "T"; _cTipoAS := "AST"; cPara := GetMv("MV_REJET")  ; cCC := "" //GetMv("MV_EMAILT")
Case ZA0->ZA0_TIPOSE == "I"; _cTipoAS := "AS"; cPara := GetMv("MV_REJEI")  ; cCC := "" //GetMv("MV_EMAILI")
Case ZA0->ZA0_TIPOSE == "O"; _cTipoAS := "AS"; cPara := GetMv("MV_REJER")  ; cCC := "" //GetMv("MV_EMAILR")
Case ZA0->ZA0_TIPOSE == "F"; _cTipoAS := "AS"; cPara := GetMv("LC_ACEMAIL"); cCC := ""   

/*Case ZA0->ZA0_TIPOSE == "G"; _cTipoAS := "ASG"; cPara := SuperGetMv("MV_REJEG",nil,nil,_cFil)  ; cCC := SuperGetMv("MV_EMAILG",nil,nil,_cFil)
Case ZA0->ZA0_TIPOSE == "R"; _cTipoAS := "ASG"; cPara := SuperGetMv("MV_REJER",nil,nil,_cFil)  ; cCC := SuperGetMv("MV_EMAILR",nil,nil,_cFil)
Case ZA0->ZA0_TIPOSE == "U"; _cTipoAS := "ASG"; cPara := SuperGetMv("MV_REJEU",nil,nil,_cFil)  ; cCC := SuperGetMv("MV_EMAILU",nil,nil,_cFil)
Case ZA0->ZA0_TIPOSE == "P"; _cTipoAS := "ASG"; cPara := SuperGetMv("MV_REJEP",nil,nil,_cFil)  ; cCC := SuperGetMv("MV_EMAILP",nil,nil,_cFil)
Case ZA0->ZA0_TIPOSE == "T"; _cTipoAS := "AST"; cPara := SuperGetMv("MV_REJET",nil,nil,_cFil)  ; cCC := SuperGetMv("MV_EMAILT",nil,nil,_cFil)
Case ZA0->ZA0_TIPOSE == "I"; _cTipoAS := "AST"; cPara := SuperGetMv("MV_REJEI",nil,nil,_cFil)  ; cCC := SuperGetMv("MV_EMAILI",nil,nil,_cFil)
Case ZA0->ZA0_TIPOSE == "O"; _cTipoAS := "AST"; cPara := SuperGetMv("MV_REJER",nil,nil,_cFil)  ; cCC := SuperGetMv("MV_EMAILR",nil,nil,_cFil)
Case ZA0->ZA0_TIPOSE == "F"; _cTipoAS := "ASF"; cPara := SuperGetMv("LC_ACEMAIL"); cCC := ""
*/
OtherWise                  ; _cTipoAS := "AS "; cPara := ""									   ; cCC := ""
EndCase

cTitulo		:= "Referente a Rejei��o da " + _cTipoAS + " n�mero " + DTQ->DTQ_AS + ", Projeto " + AllTrim(DTQ->DTQ_SOT) + ", Revis�o " + ZA0->ZA0_REVISA + Space(100)

//If DTQ->DTQ_STATUS == '6' //Maickon Queiroz - 14-10-2011 - Incluido valida��o para n�o permitir que a AS seja Rejeitada depois do Aceite.
If (!Empty(DTQ->DTQ_NUMCTR) .and. !Empty(DTQ->DTQ_SERCTR)) .OR. (!Empty(DTQ->DTQ_SERCTR))  //Maickon Queiroz - 14-10-2011 - Incluido valida��o para n�o permitir que a AS seja Rejeitada depois do Aceite.
	MsgAlert("AST se encontra com CT-e/NFS-e gerada e n�o poder� ser Rejeitada.") 
	Return
EndIf

If DTQ->DTQ_STATUS == '9' //Maickon Queiroz - 14-10-2011 - Incluido valida��o para n�o permitir que a AS seja Rejeitada depois do Aceite.
	MsgAlert("AST j� se encontra Rejeitada.") 
	Return
EndIf
// data in�cio/fim , local da obra, cidade, estado, nome do cliente
cBody := "Data Ini/Fim: "+DTOC(DTQ->DTQ_DATINI)+" - "+DTOC(DTQ->DTQ_DATINI)+",  Obra: "+AllTrim(DTQ->DTQ_DESTIN)+",  Cliente: "+AllTrim(DTQ->DTQ_NOMCLI)+"" 

if Empty(xMSG)
	Define MsDialog _oDlgMail Title "Motivo da Rejei��o" From C(230),C(359) To C(400),C(882) Pixel	//de 610 para 400

	@ C(014),C(011) Say "Motivo:"   			Size C(030),C(008) COLOR CLR_BLACK PIXEL OF _oDlgMail
	@ C(015),C(042) GET oMsg Var cMsg MEMO 		Size C(210),C(065) 				   PIXEL OF _oDlgMail

	Activate MsDialog _oDlgMail Centered On Init EnchoiceBar(_oDlgMail, {||lOk:=.T., _oDlgMail:End()},{||_oDlgMail:End()},,aButtons)
else
	cMsg := xMSG	// Vem mensagem como par�metro da rotina de Rejei��o por Lote - Cristiam Rossi em 05/09/2011
	lOk  := .T.
endif

If lOk
   	U_MandaEmail( eFrom, cPara , cCC, cTitulo, cTitulo + Chr(13) + Chr(10) + cBody + Chr(13) + Chr(10) + "Motivo da Rejei��o:" + Chr(13) + Chr(10) + cMsg, nil, cCCo) 
	RecLock("ZA0",.F.)
		ZA0->ZA0_OBSDOC := "==> " + cTitulo + Chr(13) + Chr(10) + cMsg
	ZA0->(MsUnLock())

	RecLock("DTQ",.F.)
		DTQ->DTQ_STATUS := "9"
		DTQ->DTQ_ACEITE := CtoD("")
	DTQ->(MsUnLock())
EndIf       

Return()



/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �AceAS     �Autor  �M&S Consultoria     � Data �  30/06/07   ���
�������������������������������������������������������������������������͹��
���Desc.     � Esta rotina serve para aprovar uma OS                      ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Apontador de AS                                            ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function AceAS(cLOTE)
*******************
Local oFont     := TFont():New("Arial",11,,.T.,.T.,5,.T.,5,.T.,.F.)
Local lOk 		:= .F. 
Local lTdOk     := .F.                       /// Indica se a avaliacao esta Ok CJCAMPOS PROATIVA
Local cCC	 	:= Space(100)
Local cCCo	 	:= Space(100)
Local cMsg	 	:= ""
Local cBody		:= ""
Local cPara	 	:= Space(100)
Local cTitulo	:= Space(100)
Local oAnexo                                                           
Local oCC
Local oCCo
Local oMsg
Local oPara
Local oTitulo
Local eFrom
Local _cQuery
Local lConflito := .F.  
Local lCZLG
Local cFilial  := ""
Local cProjeto := ""
Local cObra    := "" 
Local lDtEncav := .F.       
Local lRevis   := .F.	
Local dDtAntIni	:= DTQ->DTQ_DATINI
Local dDtAntFim	:= DTQ->DTQ_DATFIM
Local dDtValIni	
Local dDtValFim                
Local cTpAnt	:= ""
Private _oDlg
Private lAcess := .f.       


if EMPTY(ALIAS())
	DBSELECTAREA("DTQ")
endif

eFrom 	:= AllTrim(UsrRetName(__cUserID)) + " <" + AllTrim(UsrRetMail(__cUserID)) + ">" 


If DTQ->DTQ_STATUS != "1" .or. !Empty(DTQ->DTQ_DATENC) .or. !Empty(DTQ->DTQ_DATENC)
	MsgStop("Somente uma AST Aberta pode ser Aceita!","Aten��o!")
	Return .F.
endif                
     
ZA0->(DbSetOrder(1))                                                   
ZA0->(DbSeek(DTQ->DTQ_FILORI + DTQ->DTQ_SOT))

cProjet := DTQ->DTQ_SOT
cOBRA   := DTQ->DTQ_OBRA

/*If DTQ->DTQ_TPAS == "T"//Valida��o para o tipo = Transporte
	DbSelectArea("ZLE")
	DbSetOrder(6)
	If DbSeek(xFilial("ZLE")+DTQ->DTQ_SOT+DTQ->DTQ_OBRA+DTQ->DTQ_VIAGEM)
		lRevis := .T.
	EndIf
	
	If ZA0->ZA0_TIPOSE == "G"//se o projeto for de equipamento
		cTpAnt := "G"
		DbSelectArea("ZA5")
	    DbSetOrder(3)
	    If DbSeek(xFilial("ZA5")+DTQ->DTQ_AS+DTQ->DTQ_VIAGEM)		
		
			DbSelectArea("ZLE")
		    DbSetOrder(5)
		    DbSeek(xFilial("ZLE")+ZA5->ZA5_GUINDA)
		    
		    While !ZLE->(Eof()) .And. AllTrim(ZLE->ZLE_FROTA) == AllTrim(ZA5->ZA5_GUINDA)
		    	If AllTrim(ZLE->ZLE_STATUS) == "1"
			    	ZLE->(DbSkip())
			    	Loop
			    EndIf    
			    
			    If lRevis//AS 2� vez
		    		If AllTrim(ZLE->ZLE_STATUS) == "9" .Or. AllTrim(ZLE->ZLE_STATUS) == "M"
			    		ZLE->(DbSkip())
			    		Loop
			    	EndIf  			    	
			    	
			    	If AllTrim(DTQ->DTQ_AS+DTQ->DTQ_SOT+DTQ->DTQ_OBRA+ZA5->ZA5_GUINDA) == AllTrim(ZLE->ZLE_AS+ZLE->ZLE_PROJET+ZLE->ZLE_OBRA+ZLE->ZLE_FROTA)
			    		ZLE->(DbSkip())
			    		Loop
			    	EndIf
			    	
			    	If DTOS(ZLE->ZLE_DTPROG) >= DTOS(DTQ->DTQ_DATINI) .And. DTOS(ZLE->ZLE_DTPROG) <= DTOS(DTQ->DTQ_DATFIM)
			    		lDtEncav := .T.
			    		Exit
			    	EndIf	
			    Else				    
		    		If DTOS(ZLE->ZLE_DTPROG) >= DTOS(DTQ->DTQ_DATINI) .And. DTOS(ZLE->ZLE_DTPROG) <= DTOS(DTQ->DTQ_DATFIM)
			    		lDtEncav := .T.
			    		Exit
			    	EndIf
		        EndIf
		    	ZLE->(DbSkip())
		    EndDo
		EndIf                                                                       
	Else
		If Empty(DTQ->DTQ_JUNTO)

			DbSelectArea("ZAE")
		    DbSetOrder(1)//Projet+Obra+SeqTra+SeqCar
		    DbSeek(xFilial("ZAE")+DTQ->DTQ_SOT+DTQ->DTQ_OBRA+DTQ->DTQ_OBRA+DTQ->DTQ_SEQCAR)
		    
		    While !ZAE->(Eof()) .And. AllTrim(ZAE->ZAE_FILIAL+ZAE->ZAE_PROJET+ZAE->ZAE_OBRA+ZAE->ZAE_SEQTRA+ZAE->ZAE_SEQCAR) == AllTrim(xFilial("ZAE")+DTQ->DTQ_SOT+DTQ->DTQ_OBRA+DTQ->DTQ_OBRA+DTQ->DTQ_SEQCAR)
			
				DbSelectArea("ZLE")
			    DbSetOrder(5)
			    DbSeek(xFilial("ZLE")+ZAE->ZAE_TRANSP)
			    
			    While !ZLE->(Eof()) .And. AllTrim(ZLE->ZLE_FROTA) == AllTrim(ZAE->ZAE_TRANSP)
			    	If AllTrim(ZLE->ZLE_STATUS) == "1"
				    	ZLE->(DbSkip())
				    	Loop
				    EndIf    
				    
				    If lRevis//AS 2� vez
			    		If AllTrim(ZLE->ZLE_STATUS) == "9" .Or. AllTrim(ZLE->ZLE_STATUS) == "M"
				    		ZLE->(DbSkip())
				    		Loop
				    	EndIf  			    	
				    	
				    	If AllTrim(DTQ->DTQ_AS+DTQ->DTQ_SOT+DTQ->DTQ_OBRA+ZAE->ZAE_TRANSP) == AllTrim(ZLE->ZLE_AS+ZLE->ZLE_PROJET+ZLE->ZLE_OBRA+ZLE->ZLE_FROTA)
				    		ZLE->(DbSkip())
				    		Loop
				    	EndIf
				    	
				    	If DTOS(ZLE->ZLE_DTPROG) >= DTOS(DTQ->DTQ_DATINI) .And. DTOS(ZLE->ZLE_DTPROG) <= DTOS(DTQ->DTQ_DATFIM)
				    		lDtEncav := .T.
				    		Exit
				    	EndIf	
				    Else				    
			    		If DTOS(ZLE->ZLE_DTPROG) >= DTOS(DTQ->DTQ_DATINI) .And. DTOS(ZLE->ZLE_DTPROG) <= DTOS(DTQ->DTQ_DATFIM)
				    		lDtEncav := .T.
				    		Exit
				    	EndIf
			        EndIf
			    	ZLE->(DbSkip())
			    EndDo         
			    
			    ZAE->(DbSkip())
			 EndDo
		EndIf
		If !ValidAS(DTQ->DTQ_SOT,DTQ->DTQ_OBRA,DTQ->DTQ_JUNTO)
			Return .F.
		EndIf
	EndIf   
	
	If lDtEncav
		MsgAlert("N�o foi possivel aceitar a AS, pois uma ou mais frotas est�o com datas envaladas na 'Prog. diaria Transp'.","Aten��o")
		Return .F.
	EndIf          
	
	//Return .F.//Provisorio para validar fun��o acima          

EndIf*/

cMsg := ZA0->ZA0_OBSDOC + CHR(13)+CHR(10)
_cFil:= xFilial() //Right(AllTrim(DTQ->DTQ_AS),2)

Do Case
Case ZA0->ZA0_TIPOSE == "G"; _cTipoAS := "AS"; cPara := GetMv("LC_ACEG")  ; cCC := "" //cPara := GetMv("MV_REJEG")  ; cCC := GetMv("MV_EMAILG")
Case ZA0->ZA0_TIPOSE == "R"; _cTipoAS := "ASG"; cPara := GetMv("MV_REJER")  ; cCC := "" //cPara := GetMv("MV_REJER")  ; cCC := GetMv("MV_EMAILR")
Case ZA0->ZA0_TIPOSE == "U"; _cTipoAS := "ASG"; cPara := GetMv("LC_ACEU")  ; cCC := "" //cPara := GetMv("MV_REJEU")  ; cCC := GetMv("MV_EMAILU")
Case ZA0->ZA0_TIPOSE == "P"; _cTipoAS := "ASG"; cPara := GetMv("MV_REJEP")  ; cCC := "" //cPara := GetMv("MV_REJEP")  ; cCC := GetMv("MV_EMAILP")
Case ZA0->ZA0_TIPOSE == "T"; _cTipoAS := "AST"; cPara := GetMv("MV_REJET")  ; cCC := "" //cPara := GetMv("MV_REJET")  ; cCC := GetMv("MV_EMAILT")
Case ZA0->ZA0_TIPOSE == "I"; _cTipoAS := "AST"; cPara := GetMv("MV_REJEI")  ; cCC := "" //cPara := GetMv("MV_REJEI")  ; cCC := GetMv("MV_EMAILI")
Case ZA0->ZA0_TIPOSE == "O"; _cTipoAS := "AST"; cPara := GetMv("MV_REJER")  ; cCC := "" //cPara := GetMv("MV_REJER")  ; cCC := GetMv("MV_EMAILR")
Case ZA0->ZA0_TIPOSE == "F"; _cTipoAS := "ASF"; cPara := GetMv("LC_ACEMAIL"); cCC := "" //cPara := GetMv("LC_ACEMAIL"); cCC := "" 
OtherWise                  ; _cTipoAS := "AS "; cPara := ""								       ; cCC := ""
EndCase

if 	DTQ->DTQ_TPAS == "F"
	_cTipoAS := "ASF"
	cCC := ""
	If ZA0->ZA0_TIPOSE == "G"
	cPara := GetMv("LC_ACEG")
	cCC := ""   
	ElseIf ZA0->ZA0_TIPOSE == "U"
	cPara := GetMv("LC_ACEU")
	cCC := "" 
	Else
	cPara := GetMv("LC_ACEMAIL")
	cCC := "" 
	EndIf
endif

/*		-- Coloquei este trecho mais abaixo, para suprimir em caso de aceite por Lote - Cristiam Rossi em 05/09/2011
Define MsDialog _oDlg Title "Aceite de " + _cTipoAS From C(230),C(359) To C(400),C(882) Pixel	//de 610 para 400

@ C(017),C(010) Say "Confirma o aceite da "+_cTipoAS+" n�: "+DTQ->DTQ_AS FONT oFont COLOR CLR_BLACK PIXEL OF _oDlg

@ C(025),C(010) Say "Projeto N�: "+AllTrim(DTQ->DTQ_SOT) + " Rev.: " + ZA0->ZA0_REVISA + " ?" FONT oFont COLOR CLR_BLACK PIXEL OF _oDlg
*/

/*if DTQ->DTQ_TPAS != "F"
	// Verifica��o de conflito de datas DTQ x ZAG - Cristiam Rossi em 14/07/2011
	cAlias     := Alias()
	aDiasManut := {}		// para armazenar os dias que a frota est� em manunte��o
	aOpcCmb    := MontaCombo('ZLG_STATUS')	// Carrega os itens do ComboBox da SX3
	
	If Select("TRAB") > 0
		DbSelectArea("TRAB")
		DbCloseArea("TRAB")
	Endif
	// Verifica se frota estah liberada
	// Status possiveis nesta rotina 2,3,4,5,6,7,8,R 
	cQuery := "select ZLG_NRAS,ZLG_NOMCLI,ZLG_STATUS,ZLG_DTINI,ZLG_DTFIM from " + RetSqlName('ZLG')
	cQuery += " where D_E_L_E_T_ = '' "
	cQuery += " and ZLG_FROTA = '" + DTQ->DTQ_GUINDA + "'"
	cQuery += " and ZLG_CODBEM = ''"
	cQuery += " and ZLG_NRAS <> '" + DTQ->DTQ_AS + "'"
	cQuery += " and ZLG_STATUS IN ('2','3','4','5','6','7','8','R')"
	cQuery += " and (ZLG_DTINI between '" + DtoS(DTQ->DTQ_DATINI) + "' and '" + DtoS(DTQ->DTQ_DATFIM) + "'"
	cQuery += " or   ZLG_DTFIM between '" + DtoS(DTQ->DTQ_DATINI) + "' and '" + DtoS(DTQ->DTQ_DATFIM) + "'"
	cQuery += " or  (ZLG_DTINI <= '" + DtoS(DTQ->DTQ_DATINI) + "' and ZLG_DTFIM >='" + DtoS(DTQ->DTQ_DATFIM) + "')"
	cQuery += " or  (ZLG_DTINI >= '" + DtoS(DTQ->DTQ_DATINI) + "' and ZLG_DTFIM <='" + DtoS(DTQ->DTQ_DATFIM) + "'))"
	cQuery += " order by ZLG_DTINI;"
	
	DBUseArea(.T.,"TOPCONN", TCGenQry(,,cQuery),"TRAB", .F., .T.)
	TCSetField("TRAB","ZLG_DTINI",   "D",8,0)
	TCSetField("TRAB","ZLG_DTFIM",   "D",8,0)
	
	lConflito := .F.
	xMsg      := "CONFLITO AS X PROG. DI�RIA, ACEITE CANCELADO!"
	
	Do while ! EOF()
		lConflito := .T.
		cMsg := 'O per�odo de ' + DtoC(DTQ->DTQ_DATINI) + ' at� ' + DtoC(DTQ->DTQ_DATFIM) + ' conflita com a AS: ' + ZLG_NRAS + chr(10)
		cMsg += 'de ' + DtoC(ZLG_DTINI) + ' at� ' + DtoC(ZLG_DTFIM) + ' Status: ' + aOpcCmb[aScan(aOpcCmb, {|x| x[3]==ZLG_STATUS}), 4] + '  cliente: ' + ZLG_NOMCLI
		MsgStop(cMsg, 'Conflito de Datas na Frota '+DTQ->DTQ_GUINDA)
		DbSelectArea("TRAB")
		DbSkip()
	endDo
	TRAB->( DbCloseArea() )
	
	If ! lConflito	// Verificar se existe per�odo de manuten��o - Cristiam Rossi em 14/07/2011
		If Select("TRAB") > 0; DbSelectArea("TRAB"); DbCloseArea("TRAB");Endif
		cQuery := "select ZLG_NRAS,ZLG_NOMCLI,ZLG_STATUS,ZLG_DTINI,ZLG_DTFIM from " + RetSqlName('ZLG')
		cQuery += " where D_E_L_E_T_ = '' "
		cQuery += " and ZLG_FROTA = '" + DTQ->DTQ_GUINDA + "'"
		cQuery += " and ZLG_CODBEM = ''"
		cQuery += " and ZLG_STATUS IN ('9','C')"	// Status de Manuten��o 9-Preventivo C-Corretivo
		cQuery += " and (ZLG_DTINI between '" + DtoS(DTQ->DTQ_DATINI) + "' and '" + DtoS(DTQ->DTQ_DATFIM) + "'"
		cQuery += " or   ZLG_DTFIM between '" + DtoS(DTQ->DTQ_DATINI) + "' and '" + DtoS(DTQ->DTQ_DATFIM) + "'"
		cQuery += " or  (ZLG_DTINI <= '" + DtoS(DTQ->DTQ_DATINI) + "' and ZLG_DTFIM >='" + DtoS(DTQ->DTQ_DATFIM) + "')"
		cQuery += " or  (ZLG_DTINI >= '" + DtoS(DTQ->DTQ_DATINI) + "' and ZLG_DTFIM <='" + DtoS(DTQ->DTQ_DATFIM) + "'))"
		cQuery += " order by ZLG_DTINI;"	
		DBUseArea(.T.,"TOPCONN", TCGenQry(,,cQuery),"TRAB", .F., .T.)
		TCSetField("TRAB","ZLG_DTINI",   "D",8,0)
		TCSetField("TRAB","ZLG_DTFIM",   "D",8,0)
		
		Do while ! EOF()
			cMsg := 'O per�odo de ' + DtoC(DTQ->DTQ_DATINI) + ' at� ' + DtoC(DTQ->DTQ_DATFIM) 
			cMsg += ' conflita com Manuten��o, Status: ' + aOpcCmb[aScan(aOpcCmb, {|x| x[3]==ZLG_STATUS}), 4] + chr(10)
			cMsg += 'Manuten��o de ' + DtoC(ZLG_DTINI) + ' at� ' + DtoC(ZLG_DTFIM)
			MsgStop(cMsg, 'Conflito MANUTEN��O na Frota '+DTQ->DTQ_GUINDA)
	
			For dDT := ZLG_DTINI to ZLG_DTFIM
				If aScan(aDiasManut, dDT) == 0
					aAdd(aDiasManut, dDT)
				Endif
			Next
			
			If DTQ->DTQ_DATINI >= ZLG_DTINI .and. DTQ->DTQ_DATFIM <= ZLG_DTFIM	
				// se o per�odo de manuten��o compreender toda a AS, bloqueia Aceite.
				lConflito := .T.
			Endif
			DbSelectArea("TRAB")
			dbSkip()
		EndDo
		TRAB->(DbCloseArea())
	Endif
	
	dbSelectArea(cAlias)
	// Fim da Verifica��o de conflito de datas DTQ x ZAG - Cristiam Rossi em 14/07/2011
endif */

if DTQ->DTQ_TPAS == "F" .and. (Empty(DTQ->DTQ_DTINI) .or. Empty(DTQ->DTQ_DTFIM))
	lConflito := .T.
	xMsg      := "A AS deve ser programada!"
endif

if Empty(cLOTE)
	Define MsDialog _oDlg Title "Aceite de " + _cTipoAS From C(230),C(359) To C(400),C(882) Pixel	//de 610 para 400
	
	@ C(017),C(010) Say "Confirma o aceite da "+_cTipoAS+" n�: "+DTQ->DTQ_AS FONT oFont COLOR CLR_BLACK PIXEL OF _oDlg
	
	@ C(025),C(010) Say "Projeto N�: "+AllTrim(DTQ->DTQ_SOT) + " Rev.: " + ZA0->ZA0_REVISA + " ?" FONT oFont COLOR CLR_BLACK PIXEL OF _oDlg
	
	If lConflito
		// Mensagem de Conflito com a Prog. Di�ria - Cristiam Rossi em 14/07/11
		@ C(040),C(010) Say xMsg FONT oFont COLOR CLR_RED PIXEL OF _oDlg		// Mensagem de Conflito com a Prog. Di�ria - Cristiam Rossi em 14/07/11
	Endif
	
	Activate MsDialog _oDlg Centered On Init EnchoiceBar(_oDlg, {|| lOk := .T. , _oDlg:End()} , {||_oDlg:End() } )
else
	lOk := .T.
endif

If lConflito	// Se existir conflito da AS com alguma Programa��o Di�ria, n�o permite o Aceite - Cristiam Rossi em 14/07/2011
	MsgInfo('Esta AS ('+DTQ->DTQ_AS+') n�o poder� ser aceita pois existem conflitos','Opera��o Cancelada. Frota: '+DTQ->DTQ_GUINDA)
	
	Return .F.
endif 

If lOk
	If DTQ->DTQ_TPAS == "F" 
	
	dDtIni   := ""
	dDtFim   := ""
	cHrIni := ""
    cHrFim := ""
    cTpAma  := ""
	cPacLis := ""
	
	dDtIni   := DTQ->DTQ_DTINI
	dDtFim   := DTQ->DTQ_DTFIM
	cHrIni := SubStr(DTQ->DTQ_HRINI,1,2) + SubStr(DTQ->DTQ_HRINI,3,4)
    cHrFim := SubStr(DTQ->DTQ_HRFIM,1,2) + SubStr(DTQ->DTQ_HRFIM,3,4)
    cTpAma  := DTQ->DTQ_TIPAMA
	cPacLis := DTQ->DTQ_PACLIS
	
	cTitulo := "Referente a Aceite da " + _cTipoAS + " n�mero " + DTQ->DTQ_AS + ", projeto " + AllTrim(DTQ->DTQ_SOT) + ", revis�o " + ZA0->ZA0_REVISA + Space(100)

   	eFrom 	:= AllTrim(UsrRetName(__cUserID)) + " <" + AllTrim(UsrRetMail(__cUserID)) + ">" 
		
	cMsg	:= cTitulo + "<BR><BR>"
	cMsg    += "Data Ini/Fim: "+DTOC(DTQ->DTQ_DATINI)+" - "+DTOC(DTQ->DTQ_DATINI)+", Obra: "+AllTrim(DTQ->DTQ_DESTIN)+", Cliente: "+AllTrim(DTQ->DTQ_NOMCLI)+"<BR><BR>" 
	cMsg	+= "Dados informados pelo usu�rio: " + UsrRetName(__cUserID) + "<BR><BR>"

	cMsg	+= "<table><tr><th>Data Carregamento:</th><td>"+DtoC(dDtIni)+"</td></tr>"
	cMsg	+= "<tr><th>Hora Carregamento:       </th><td>"+substr(cHrIni,1,2)+":"+substr(cHrIni,3,2)     +"</td></tr>"
	cMsg	+= "<tr><th>Data Descarregamento:    </th><td>"+DtoC(dDtFim)+"</td></tr>"
	cMsg	+= "<tr><th>Hora Descarregamento:    </th><td>"+substr(cHrFim,1,2)+":"+substr(cHrFim,3,2)     +"</td></tr>"
	cMsg	+= "<tr><th>Tipo Amarra��o:          </th><td>"+cTpAma      +"</td></tr>"
	cMsg	+= "<tr><th>N� da carreta:           </th><td>"+cPacLis     +"</td></tr></table>"
	// ALTERACAO CJDECAMPOS 22/09/2011
	cAnexo := "ASfrete.pdf"  
	
	If ZA0->ZA0_TIPOSE == "G"	
	//U_Loci022(DTQ->DTQ_AS, cAnexo)
	ElseIf ZA0->ZA0_TIPOSE == "U"
	U_Loci045(DTQ->DTQ_AS, cAnexo)
	EndIf
		
	if __CopyFile(AllTrim(GetTempPath())+cAnexo, GetSrvProfString("Startpath","")+cAnexo)
	   	cAnexo := GetSrvProfString("Startpath","")+cAnexo
	
		cAnexo := ""
	endif
		// FIM 22/09/2011
//		U_MandaEmail( eFrom, cPara , "", cTitulo, cMsg, nil, "")
		U_MandaEmail( eFrom, cPara , "", cTitulo, cMsg, cAnexo , "")
		
		fCalcEmb(DTQ->DTQ_SOT,DTQ->DTQ_VIAGEM) 
		
		RecLock("DTQ",.F.)
			DTQ->DTQ_STATUS := "6" 			// aprovado !
			DTQ->DTQ_ACEITE := dDatabase 	// data aprova��o
		DTQ->(MsUnLock())   
	EndIf

	If DTQ->DTQ_TPAS == "T"	// se for Transporte
	    //Comentado por Pedrassi para n�o chamar a sele��o de Motorista no Aceite da AS pois na GEFCO o motorista sera informando na Ordem de Coleta.
        /*
		If Empty(DTQ->DTQ_JUNTO) 
			If !xMotorista(DTQ->DTQ_DATINI,DTQ->DTQ_DATFIM,DTQ->DTQ_AS,DTQ->DTQ_NOMCLI,DTQ->DTQ_SOT,DTQ->DTQ_OBRA,DTQ->DTQ_VIAGEM,lRevis,DTQ->DTQ_SEQCAR)
				Return .F.
			EndIf
		EndIf
		*/
	/*	If SELECT("ZA5") == 0
			ChkFile("ZA5")
		Endif
	
		ST9->(DbSetOrder(1))
	 //	ZA6->(DbSetOrder(1))
		ZAE->(DbSetOrder(1))
		ZLE->(DbSetOrder(1)) // ZLE_FILIAL+ ANOMES + ZLE_FROTA+ ZLE_DTPROG

	//	ZA6->(DbSeek(SM0->M0_CODFIL+cProjet+cObra))
	    DbSelectarea("ZA6")
	    DbSetOrder(1)
	    //DbSeek(SM0->M0_CODFIL+cProjet+cObra)
	    DbSeek(xFilial("ZA6")+cProjet+cObra)
	
		While ZA6->(!Eof()) .And. ZA6->ZA6_FILIAL+ZA6->ZA6_PROJET+ZA6->ZA6_OBRA == xFilial("ZA6")+DTQ->DTQ_SOT+DTQ->DTQ_OBRA

			ZAE->(DBSEEK( XFILIAL("ZAE")+ZA6->ZA6_PROJET+ZA6->ZA6_OBRA+ZA6->ZA6_SEQTRA, .F. ))
			DO WHILE !ZAE->(EOF()) .AND. ( ZAE->ZAE_FILIAL+ZAE->ZAE_PROJET+ZAE->ZAE_OBRA+ZAE->ZAE_SEQTRA == XFILIAL("ZAE")+ZA6->ZA6_PROJET+ZA6->ZA6_OBRA+ZA6->ZA6_SEQTRA )

				cFrota := iif(!EMPTY(ZAE->ZAE_TRALOC), ZAE->ZAE_TRALOC, ZAE->ZAE_TRANSP)

				If Empty(cFrota) .or. !ST9->(DBSEEK(XFILIAL("ST9")+cFrota))
					ZAE->(dbSkip())
					Loop
				EndIf

				FOR dDia := ZA6->ZA6_DTINI to ZA6->ZA6_DTFIM
					ZLE->(MsSeek(XFILIAL("ZLE")+SUBS(DTOS( dDia ),1,6) + cFrota + DTOS( dDia )))
					ZLE->(RECLOCK("ZLE", !ZLE->(Found())))

					ZLE->ZLE_FILIAL	:= XFILIAL("ZLE")
					ZLE->ZLE_ANOMES := LEFT( DTOS( dDia ) , 6 )
					ZLE->ZLE_DTPROG := dDia
					ZLE->ZLE_DIASEM := diasemana(dDia)
					ZLE->ZLE_FROTA  := cFrota
					ZLE->ZLE_CODBEM := ""
					ZLE->ZLE_DESCRI := ST9->T9_NOME
					ZLE->ZLE_AS     := DTQ->DTQ_AS
					ZLE->ZLE_PROJET := DTQ->DTQ_SOT  // NUMERO DO PROJETO
					ZLE->ZLE_OBRA   := DTQ->DTQ_OBRA
					ZLE->ZLE_VIAGEM := DTQ->DTQ_VIAGEM 
					ZLE->ZLE_TIPO   := DTQ->DTQ_TPAS
					ZLE->ZLE_STATUS := "0"
					ZLE->(MsUnlock())
				Next
		
				ZAE->(DBSKIP())
			ENDDO 
		
			ZA6->(dbSkip())
		end*/
		lAcess := .T.
	endif	// Fim cria��o de Programa��o de Transportes
	
	If DTQ->DTQ_TPAS $ "G;U"	// se for Guindaste ou Grua
                               
		lAvalia := .f.   // Dispara Avaliacao das Programacoes
		If DTQ->DTQ_TPAS == "G"  // Se guindaste
			DbSelectArea("ZA5")                   
			DbSetOrder(3)
			//DbSeek(xFilial("ZA5")+DTQ->DTQ_GUINDA)  - COMENTADO: RENATO RUY - 07/05/2012 - ERRO NO POSICIONAMENTO
			DbSeek(xFilial("ZA5")+DTQ->DTQ_AS+DTQ->DTQ_VIAGEM)  // AJUSTADO POSICIONAMENTO NA ZA5 - RENATO RUY - 07/05/2012 
			
			lAvalia := ! Empty(ZA5->ZA5_VIAGEM) // Ativa avaliacao se viagem nao vazia
		ElseIf DTQ->DTQ_TPAS == "U" // Se Grua
			DbSelectArea("ZAG")
			DbSetOrder(3)
			DbSeek(xFilial("ZAG")+ DTQ->DTQ_AS +DTQ->DTQ_VIAGEM)
			lAvalia := ! Empty(ZAG->ZAG_VIAGEM) // Ativa avaliacao se viagem nao vazia
		Endif                                                                          
		
		If lAvalia // Usa o processo atual - gerando a programacao
		
			ZLG->(DBSETORDER(1))
			ST9->(DBSETORDER(1))
			ZLT->(dbSetOrder(1))
			
			cFrota 	:= DTQ->DTQ_GUINDA
			dtIni	:= DTQ->DTQ_DATINI
			dtFim	:= DTQ->DTQ_DATFIM
			cNrAs	:= DTQ->DTQ_AS
			
			IF ST9->(DBSEEK(XFILIAL("ST9")+cFrota))
				x_CodFa := ST9->T9_CODFA  // inclusao CJDECAMPOS  13/09/2011
				
				dbSelectArea("ZA0")
    			ZA0->(dbSetOrder(1))
			    ZA0->(dbSeek(xFilial("ZA0") + DTQ->DTQ_SOT))
				cCodCli := ZA0->ZA0_CLI   //posicione("AAM",1,xFilial("AAM")+DTQ->DTQ_CONTRA,"AAM_CODCLI")
				cLojCli := ZA0->ZA0_LOJA  //AAM->AAM_LOJA

//				ZLG->(dbSeek(XFILIAL("ZLG")+ cFrota, .T.))
//				lZLT := ! ZLG->(Found())

				cAlias     := Alias()
			
				If Select("TRAB") > 0
					TRAB->(DbCloseArea())
				Endif
			    //Verifica se Existe registro para a mesma frota e cliente.
				cQuery := "select top 1 R_E_C_N_O_ zlgrecno from " + RetSqlName('ZLG')
				cQuery += " where D_E_L_E_T_ = '' "
				cQuery += " and ZLG_FROTA  = '" + DTQ->DTQ_GUINDA + "'"
				cQuery += " and ZLG_NRAS   = '" + DTQ->DTQ_AS + "'"
				cQuery += " and ZLG_CODCLI = '" + cCodCli + "'"
				cQuery += " and ZLG_LOJA   = '" + cLojCli + "'"
				cQuery += " and ZLG_STATUS NOT IN ('9','C')"
				cQuery += " order by R_E_C_N_O_ DESC"
				DBUseArea(.T.,"TOPCONN", TCGenQry(,,cQuery),"TRAB", .F., .T.)

				lZLT := EOF() // Nao tem registros cadastrados
				if ! lZLT
					ZLG->( dbGoto( TRAB->zlgrecno ) )
				endif

				If Select("TRAB") > 0
					TRAB->(DbCloseArea())
				Endif

				dbSelectArea(cAlias)

				// N�o localizou ZLG, ou seja � o 1� Aceite. O Lui pediu para n�o mexer nas Revis�es. - Cristiam Rossi em 14/07/2011
				//BEGINDOC
				//��������������������������������������������������������������������������������������Ŀ
				//�Maickon Queiroz - 12/04/2012	                                               		     �
				//�    Criado parametro LC_LBASG para que seja possivel liberar a verificacao para ASG.  �
				//�    antes do projeto.                                                                 �
				//�                                                                                      �
				//�    Fun��o auxiliar CriaParDef responsavel por criar o Parametro na Tabela SX6 caso   �
				//�    n�o exista.                                                                       �								
				//����������������������������������������������������������������������������������������
				//ENDDOC
				//cFil	:= "" //COMENTADO 18/05/2012 - RENATO RUY - N�O DUPLICAR O PAR�METRO
				//cVar	:= "LC_LBASG"
                //cTipo	:= "L"
                //cCont	:= ".T."
                //cDesc	:= "Indica se dever� Bloquear a verifica��o de datas encavaladas na ASG, campo l�gico"
                //U_CriaParDef(cFil,cVar,cTipo,cCont,cDesc)
				//BEGINDOC
				//��������������������������������������������������������������������������������������Ŀ
				//�Maickon Queiroz - 07/10/2011	                                               		     �
				//�    Criado processo para verificar se existe encavalamento com Programa��o anterior.  �
				//�    01 - Remaneja ou deleta as programa��es disponiveis incluindo a revis�o da As.    �
				//�                                                                         			 �
				//�    Valida��o - Caso o lAcess seja .F. a AS n�o ser� aceita.               			 �
				//����������������������������������������������������������������������������������������
				//ENDDOC
				//lAcess:= GETMV("LC_LBASG") .and. U_LocA(cFrota,cNrAs ,DTOS(dtIni),DTOS(dtFim))//Verifica se existe frota programada
				lAcess:= .T.//U_LocA(cFrota,cNrAs ,DTOS(dtIni),DTOS(dtFim))//Verifica se existe frota programada
			
				If lAcess 
					If Select("LOFRO") > 0
						LOFRO->(DbCloseArea())
					Endif 
					
					cQry2:= " Select * "
					cQry2+= " From "+RetSqlName("ZLG")
					cQry2+= " WHERE D_E_L_E_T_ = '' "             
					//cQry2+= " 	AND ZLG_STATUS NOT IN ('A','E','S') "
					cQry2+= " 	AND ZLG_FROTA = '"+cFrota+"' " 
					cQry2+= " 	AND ZLG_CODBEM = '' " 
					cQry2 += " and (ZLG_DTINI between '" + DtoS(dtIni) + "' and '" + DtoS(dtFim) + "'"
					cQry2 += " or   ZLG_DTFIM between '" + DtoS(dtIni) + "' and '" + DtoS(dtFim) + "'"
					cQry2 += " or  (ZLG_DTINI <= '" + DtoS(dtIni) + "' and ZLG_DTFIM >='" + DtoS(dtFim) + "')"
					cQry2 += " or  (ZLG_DTINI >= '" + DtoS(dtIni) + "' and ZLG_DTFIM <='" + DtoS(dtFim) + "'))"

					TcQuery cQry2 New Alias "LOFRO"
	
					DbSelectArea("LOFRO")                                           
                    /*
					If LOFRO->(EOF())
						CriaZLG(.t., dtIni, dtFim)
					EndIf
			         /*/
   					aCZLG	:= {}
   					aDaEnca1:= {}
  					aDaEnca2:= {}
					n:=1  
					lAdd := .t.
					//aaDD(aCZLG,{dtIni,dtFim})
			  		While LOFRO->(!EOF())  //Carrega as datas das programa��es que est�o encavaladas
			  			IF LOFRO->ZLG_NRAS <> cNrAs  .or. Empty(LOFRO->ZLG_NRAS) .or. LOFRO->ZLG_STATUS <> 'R'
				  			Aadd(aDaEnca1,{LOFRO->ZLG_DTINI,LOFRO->ZLG_DTFIM,LOFRO->ZLG_NRAS,LOFRO->ZLG_STATUS,LOFRO->ZLG_CODBEM,LOFRO->R_E_C_N_O_})
				  		Else
				  			Aadd(aDaEnca2,{LOFRO->R_E_C_N_O_})
				  		EndIf
			  			
			  		    LOFRO->(DbSkip())
			  		EndDo
			  		//23-11-2011 Maickon Queiroz - Criado para ordenar o Array dos encavalamentos.
			  		//Begin
			  		aSort(aDaEnca1,,,{|x,y| x[1] <y[1]})
			  		//End
					//Deleta a ZLG pois � a mesma AS
				   	ZLG->(DbSetOrder(5))
				   	ZLG->(DbSeek(xFilial("ZLG")+cNrAs+cFrota))
				   	While cNrAs == ZLG->ZLG_NRAS 
				   		If alltrim(ZLG->ZLG_CODBEM) == ''
				   			If ZLG->ZLG_STATUS == 'R'
								Reclock("ZLG",.f.)
									ZLG->(DbDelete())
								ZLG->(MsUnLock()) 
							EndIf
						EndIf
						ZLG->(DbSkip())
				   	Enddo//Next
				   	//Cria��o da ZLG           
				   	If Len(aDaEnca1) == 0
			   			Aadd(aCZLG,{dtIni,dtFim})  //Adiciona no Array a data Inicial e Final que dever� ser incluida
				   	EndIf
				   	For nY:= 1 To Len(aDaEnca1)
						If aDaEnca1[nY][1] >= Dtos(dtIni)    //Verifica se a DtInicial da Programacao e maior que a data da ASG.
							If aDaEnca1[nY][2] <= Dtos(dtFim) //Verifica se a DtFinal da Programacao e menor que a da ASG, se for devera deletar
								If aDaEnca1[nY][4] $  'R|1'
									ZLG->(DbGoto(aDaEnca1[nY][6]))
									RecLock("ZLG",.F.)
										ZLG->(DbDelete())// Deleta a Programa��o pois a atual ir� substituir a original
									ZLG->(MsUnLock())
									Aadd(aCZLG,{dtIni,dtFim})  //Adiciona no Array a data Inicial e Final que dever� ser incluida
								Else
									If nY == 1
										If !Locq111(cFrota,cNrAs ,DTOS(dtIni),DTOS((STOD(aDaEnca1[nY][1])-1)))//!Locq111(cFrota,cNrAs ,(aDaEnca1[nY][1]),(aDaEnca1[nY][2]))
									   		Aadd(aCZLG,{dtIni,(STOD(aDaEnca1[nY][1])-1)})  //Adiciona no Array a data Inicial e Final -1 da programa��o encavalada
									 	EndIf
									Else 
										If !Locq111(cFrota,cNrAs ,dtos(STOD(aDaEnca1[nY-1][2])+1),DTOS(STOD(aDaEnca1[nY][1])-1) )
											Aadd(aCZLG,{(STOD(aDaEnca1[nY-1][2])+1),(STOD(aDaEnca1[nY][1])-1) })
										EndIf
									EndIF
									IF aDaEnca1[nY][2] < Dtos(dtFim)                 
									   If !Locq111(cFrota,cNrAs ,dtos(stod((aDaEnca1[nY][2]))+1),dtos(dtFim))//!Locq111(cFrota,cNrAs ,(aDaEnca1[nY][1]),(aDaEnca1[nY][2]))
									   		Aadd(aCZLG,{STOD(aDaEnca1[nY][2])+1,dtFim})
									   Endif
									EndIf
								EndIf
							Else   								//Ajusta a Programacao da Data Final do projeto + 1
								If aDaEnca1[nY][4] <> 'C'
									ZLG->(DbGoto(aDaEnca1[nY][6]))
									Reclock("ZLG",.f.)
										ZLG->ZLG_DTFIM := (dtFim)
									ZLG->(MsUnLock())
									If nY == 1
										Aadd(aCZLG,{dtIni,dtFim})  //Adiciona no Array a data Inicial e Final que dever� ser incluida									
									Else 
										Aadd(aCZLG,{(STOD(aDaEnca1[nY-1][2])+1),(STOD(aDaEnca1[nY][1])-1)}) //05/12/11 //Adiciona no Array a data Inicial e Final que dever� ser incluida
									EndIf
								Else
									iF nY == 1
										If aDaEnca1[nY][1] == Dtos(dtIni) 
											If !Locq111(cFrota,cNrAs ,DTOS((STOD(aDaEnca1[nY][2])+1)),dtos(dtFim))
												//Aadd(aCZLG,{(STOD(aDaEnca1[nY][2])+1),(STOD(aDaEnca1[nY+1][1])-1)})  //Adiciona no Array a data Inicial e Final -1 da programa��o encavalada
											//Else
												Aadd(aCZLG,{(STOD(aDaEnca1[nY][2])+1),(dtFim)})  //Adiciona no Array a data Inicial e Final -1 da programa��o encavalada
											EndIf
										Else
											Aadd(aCZLG,{dtIni,(STOD(aDaEnca1[nY][1])-1)})  //Adiciona no Array a data Inicial e Final -1 da programa��o encavalada
										EndIf
									Else
										Aadd(aCZLG,{(STOD(aDaEnca1[nY-1][2])+1),(STOD(aDaEnca1[nY][1])-1)})  //Adiciona no Array a data Inicial e Final -1 da programa��o encavalada
									EndIf
									IF aDaEnca1[nY][2] < Dtos(dtFim)
									   If !Locq111(cFrota,cNrAs ,dtos(stod((aDaEnca1[nY][2]))+1),dtos(dtFim))
									   		Aadd(aCZLG,{STOD(aDaEnca1[nY][2])+1,dtFim})
									   Endif
									EndIf
								EndIf
							EndIf
						EndIf
				   	Next

                    If Select("LOFRO") > 0
						LOFRO->(DbCloseArea())
					Endif         
					
					lCZLG := .f.
					
					cQry2:= " Select * "
					cQry2+= " From "+RetSqlName("ZLG")
					cQry2+= " WHERE D_E_L_E_T_ = '' "             
					cQry2+= " 	AND ZLG_STATUS = 'R' "//('A','E','S') "
					cQry2+= " 	AND ZLG_NRAS = '"+cNrAs+"' " 

					TcQuery cQry2 New Alias "LOFRO"

					DbSelectArea("LOFRO")
					LOFRO->(DbGoTop())  

	                While LOFRO->(!EOF()) 
	                	If  LOFRO->ZLG_NRAS == cNrAs .and. LOFRO->ZLG_FROTA <> cFrota
					   		ZLG->(DbGoto(LOFRO->R_E_C_N_O_))
							Reclock("ZLG",.f.)
								ZLG->(DbDelete())
							ZLG->(MsUnLock()) 
							lCZLG := .T.     
						EndIf
						LOFRO->(DbSkip())
					Enddo   
					    
					If Select("LOFRO") > 0
						LOFRO->(DbCloseArea())
					Endif  
					//Criado processo Urgente para que seja deletada todo registro que seja menor ou maior que a data inicial e final.
					cQry2:= " Select 'V1' RESULT,* "
					cQry2+= " From "+RetSqlName("ZLG")
					cQry2+= " WHERE D_E_L_E_T_ = '' "
					cQry2+= " 	AND ZLG_STATUS Not In ('A','E','S','C','2','4','5','6') "
					cQry2+= " 	AND ZLG_NRAS = '"+cNrAs+"' "
					cQry2+= " 	AND ZLG_DTINI < '"+DTOS(dtIni)+"' "
					
					cQry2+= " 	Union All
					
					cQry2+= " Select 'V2' RESULT,*	
					cQry2+= " From "+RetSqlName("ZLG")
					cQry2+= " WHERE D_E_L_E_T_ = '' "
					cQry2+= " 	AND ZLG_STATUS Not In ('A','E','S','C','2','4','5','6') "
					cQry2+= " 	AND ZLG_NRAS = '"+cNrAs+"' "
					cQry2+= " 	AND ZLG_DTFIM > '"+DTOS(dtFim)+"'"
					
					TcQuery cQry2 New Alias "LOFRO"

					DbSelectArea("LOFRO")
					LOFRO->(DbGoTop())
	                
					While LOFRO->(!EOF()) 
	                	If  LOFRO->ZLG_NRAS == cNrAs .and. LOFRO->ZLG_FROTA == cFrota
	                		If LOFRO->RESULT == 'V1'
	                			If STOD(LOFRO->ZLG_DTFIM) < dtIni
	               					ZLG->(DbGoto(LOFRO->R_E_C_N_O_))
									Reclock("ZLG",.f.)
										ZLG->(DbDelete())           
									ZLG->(MsUnLock())
								Else
									ZLG->(DbGoto(LOFRO->R_E_C_N_O_))
									Reclock("ZLG",.f.)
										ZLG->ZLG_DTINI := dtIni
									ZLG->(MsUnLock())								
	                			EndIf
    	            		ElseIf LOFRO->RESULT == 'V2'
    	            			If STOD(LOFRO->ZLG_DTINI) > dtFim
									ZLG->(DbGoto(LOFRO->R_E_C_N_O_))
									Reclock("ZLG",.f.)
										ZLG->(DbDelete())           
									ZLG->(MsUnLock())
								Else
									ZLG->(DbGoto(LOFRO->R_E_C_N_O_))
									Reclock("ZLG",.f.)
										ZLG->ZLG_DTFIM := dtFim
									ZLG->(MsUnLock())	
        	        			EndIf
							lCZLG := .T.     
							EndIf
						EndIf
						LOFRO->(DbSkip())
					Enddo   
					
					For nY:= 1 To Len(aCZLG)
						If !Locq111(cFrota,cNrAs ,dtos(aCZLG[nY][1]),dtos(aCZLG[nY][2]))
							CriaZLG(.t., aCZLG[nY][1], aCZLG[nY][2])				// CMria a Programa��o Di�ria  atual
						EndIf
					Next
					/*
			   		If lZLT .and. Len(aDiasManut) > 0 
						dPerIni := CtoD('')
						dPerFim := CtoD('')
						for dIni := DTQ->DTQ_DATINI to DTQ->DTQ_DATFIM
							if aScan(aDiasManut, dIni) > 0
								if ! Empty(dPerIni)
									CriaZLG(lZLT, dPerIni, dPerFim)	// Cria a Programa��o Di�ria
									dPerIni := CtoD('')
									dPerFim := CtoD('')
								endif
							elseif Empty(dPerIni)
								dPerIni := dIni
								dPerFim := dIni
							else
								dPerFim := dIni
							endif
						next
					
						if ! Empty(dPerIni)
							CriaZLG(lZLT, dPerIni, dPerFim)	// Cria a Programa��o Di�ria
						endif				
					Else
						CriaZLG(lZLT, DTQ->DTQ_DATINI, DTQ->DTQ_DATFIM)  //Altera�ao da Programa�ao
			        endif
				    */
					If lZLT .or. ZLT->(dbSeek(xFilial("ZLT")+DTQ->DTQ_AS+cFrota))
						ZLT->(Reclock("ZLT", lZLT ))
						ZLT->ZLT_FILIAL := xFilial("ZLT")
						ZLT->ZLT_AS     := DTQ->DTQ_AS
						ZLT->ZLT_FROTA  := cFrota
						ZLT->ZLT_CODCLI := cCodCli 
						ZLT->ZLT_LOJA   := cLojCli
						ZLT->ZLT_DATINI := DTQ->DTQ_DATINI
						ZLT->ZLT_DATFIM := DTQ->DTQ_DATFIM
						ZLT->(MsUnlock())
					Endif
				EndIf	        			
				// Programa��o autom�tica dos Acess�rios Padr�o - Cristiam Rossi em 22/06/2011 - RECOLOCADO EM 11/08/2011 CJDECAMPOS
	            // 04-10-2011 - Maickon Queiroz - Chamada da Fun��o LGerPrg para realizar a programa��o autom�tica Acessorios Padr�o e Rotativos.
	            If Empty(DTQ->DTQ_ACEITE) .or. lCZLG
					LGerPrg(lCZLG)
				EndIf
			Else
				If Empty(cFrota)//se n�o tem frota deixa passar, solicitado pelo Lui; Alison - 22/10/2013
					lAcess := .T.
				Else
					// Avalia e Grava altera��es
					u_fRecProg(DTQ->DTQ_AS , DTQ->DTQ_GUINDA , DTQ->DTQ_TPAS , DTQ->DTQ_DATINI , DTQ->DTQ_DATFIM, DTQ->DTQ_VIAGEM)
				EndIf
			Endif
		Endif
	Endif	// Fim cria��o de Programa��o de Guindastes e Gruas

	//------------------------------------------------------------------------------------------------------------------------------------------
	//Criando registros para Medi��o - Julio Cesar Campos 
	//------------------------------------------------------------------------------------------------------------------------------------------
    //quantidades de itens para o registro de Medi��o
    If ZA5->ZA5_TIPOCA == 'F' // Maickon 16-06-2011 - Incluido para gerar somente uma Medi��o caso a loca��o seja Fechada.
    	_nItens := 1
    ElseIf !Empty(DTQ->DTQ_DATFIM) .And. !Empty(DTQ->DTQ_DATINI) .And. DTQ->DTQ_DATINI <= DTQ->DTQ_DATFIM 
       	_nItens := IIf(DTQ->DTQ_DATFIM - DTQ->DTQ_DATINI==0, 1,(DTQ->DTQ_DATFIM - DTQ->DTQ_DATINI)+1)
    Else
//    	Alert("Erro nos campos de Data Inicial e Data Final")
    	Return
    EndIf
	//------------------------------------------------------------------------------------------------------------------------------------------
    //Busca codigo para Medi��o
    //_cCod    := GETSX8NUM("ZLF")
    //ZLF->(ConfirmSX8())
    //------------------------------------------------------------------------------------------------------------------------------------------
    //Posiciona na ZLG
    dbSelectArea("ZLG")
	ZLG->(dbSetOrder(4))
    ZLG->(dbSeek(xFilial("ZLG") + DTQ->DTQ_SOT + DTQ->DTQ_OBRA + DTQ->DTQ_AS + DTQ->DTQ_VIAGEM))
    //------------------------------------------------------------------------------------------------------------------------------------------
    _dMobRea := CtoD("//")
    _dDesRea := CtoD("//")
    // Projeto
	dbSelectArea("ZA0")
    ZA0->(dbSetOrder(1))
    ZA0->(dbSeek(xFilial("ZA0") + DTQ->DTQ_SOT))
    _cNumPed := ZA0->ZA0_NUMPED
    _cFilPed := ZA0->ZA0_FILPED
    _cCodCli := ZA0->ZA0_CLI    
    _cLojCli := ZA0->ZA0_LOJA  
    // Se tipo de Servi�o
    If ZA0->ZA0_TIPOSE $ "G;I" //Guindaste / Transporte Interno
	    dbSelectArea("ZA5")
	    ZA5->(dbSetOrder(2))
	    ZA5->(dbSeek( xFilial("ZA5") + DTQ->DTQ_SOT + DTQ->DTQ_OBRA + DTQ->DTQ_AS + DTQ->DTQ_VIAGEM))
	    If ZA5->ZA5_TPMEDI == "Q"
			_dMedPre := ZA5_DTINI + 15
	    ElseIf ZA5->ZA5_TPMEDI == "M"
			_dMedPre := ZA5_DTINI + 30
	    ElseIf ZA5->ZA5_TPMEDI == "S"
			_dMedPre := ZA5_DTINI + 7
	    ElseIf ZA5->ZA5_TPMEDI == "E"
			_dMedPre := ZA5_DTINI
	    EndIf
    	_cFrota := ZA5->ZA5_GUINDA
    	_cDesEq := Posicione("ST9", 1, xFilial("ST9") + _cFrota, "T9_NOME")
    	_cHrIni := SubStr(ZA5->ZA5_HRINI,1,2) + SubStr(ZA5->ZA5_HRINI,3,4)
    	_cHrFim := SubStr(ZA5->ZA5_HRFIM,1,2) + SubStr(ZA5->ZA5_HRFIM,3,4)
    	_nHrTot := ZA5->ZA5_MINDIA
    	_cBase  := ZA5->ZA5_TIPOCA
    	_nVrHor := ZA5->ZA5_VRHOR
    	_nVTotH := IIF(ZA5->ZA5_TIPOCA == 'F',ZA5->ZA5_VRHOR ,ZA5->ZA5_VRHOR * ZA5->ZA5_MINDIA)
    	_nVrMob := ZA5->ZA5_VRMOB
    	_nVrDes := ZA5->ZA5_VRDES
    	_cTpSeg := ZA5->ZA5_TPSEGU
    	_nPerSg := ZA5->ZA5_PERSEG
    	_nVBasS := ZA5->ZA5_VRCARG
    	_nVrSeg := ZA5->ZA5_VRSEGU
    	_cTpISS := ZA5->ZA5_TPISS
    	_nPrISS := ZA5->ZA5_PERISS
    	_nVrISS := ZA5->ZA5_VRISS
    	_nTnsPs := ZA5->ZA5_VRPESO
		_nAncor := 0
		_nTeles := 0
		_Montag := 0
		_Desmon := 0
		_cCdAnt := ZA5->ZA5__CODLC 
    	_nTotKM := ZA5->ZA5_PREKM 
    	If _cTpSeg $ "I;C"
    		If _cBase == "K"
    			_nVrToM := (_nTotKM * _nVrHor ) + _nVrMob + _nVrDes + _nAncor + _nTeles + _Montag + _Desmon + _nTnsPs 
    		Else
    			_nVrToM := ( 0 * _nVrHor ) + _nVrMob + _nVrDes + _nAncor + _nTeles + _Montag + _Desmon + _nTnsPs        
    		EndIf
    	Else
    		If _cBase == "K"
    			_nVrToM := (_nTotKM * _nVrHor ) + _nVrMob + _nVrDes + _nAncor + _nTeles + _Montag + _Desmon + _nTnsPs + _nVrSeg 
    		Else
    			_nVrToM := ( 0 * _nVrHor ) + _nVrMob + _nVrDes + _nAncor + _nTeles + _Montag + _Desmon + _nTnsPs + _nVrSeg 
    	    EndIf
    	EndIf
    	_cOriVn := ZA5->ZA5_FILIAL 
    	_cFiMaq := ZA5->ZA5_FLMAQ 
    	_cFiMOr := ZA5->ZA5_FLMO  
    	_nPOVen := Posicione("ZLK", 1, xFilial("ZLK") + ZA5->ZA5_RATEIO, "ZLK_PCOML")
    	_nPrMaq := Posicione("ZLK", 1, xFilial("ZLK") + ZA5->ZA5_RATEIO, "ZLK_PBEM")
    	_nPrMao := Posicione("ZLK", 1, xFilial("ZLK") + ZA5->ZA5_RATEIO, "ZLK_PMO")
    	_nPorMa := ZA5->ZA5_PERMAO
    	_nVrOrV := _nVrToM * _nPOVen / 100
    	_nVrMaq := _nVrToM * _nPrMaq / 100
    	_nVrMao := _nVrToM * _nPrMao / 100
	    
	    If ZLG->ZLG_STATUS == "2"
		    If ZA5->ZA5_TPMEDM == "O" 
		    	_dMobRea := ZLG->ZLG_DTINI  
		    ElseIf ZA5->ZA5_TPMEDM $ "I;E;Q;S;M"
		    	_dMobRea := ZLG->ZLG_DTFIM  
		    EndIf
		ElseIf ZLG->ZLG_STATUS == "4"
		    If ZA5->ZA5_TPMEDM == "O" 
				_dDesRea := ZLG->ZLG_DTINI
		    ElseIf ZA5->ZA5_TPMEDM $ "I;E;Q;S;M"
		    	_dDesRea := ZLG->ZLG_DTFIM  
		    EndIf
	    EndIf
    ElseIf ZA0->ZA0_TIPOSE $ "U;P;M"
	    dbSelectArea("ZAG")
	    ZAG->(dbSetOrder(2))
    	ZAG->(dbSeek(xFilial("ZAG") + DTQ->DTQ_SOT + DTQ->DTQ_OBRA + DTQ->DTQ_AS + DTQ->DTQ_VIAGEM))
	    If ZAG->ZAG_TPMEDI == "Q"
			_dMedPre := ZAG->ZAG_DTINI + 15
	    ElseIf ZAG->ZAG_TPMEDI == "M"
			_dMedPre := ZAG->ZAG_DTINI + 30
	    ElseIf ZAG->ZAG_TPMEDI == "S"
			_dMedPre := ZAG->ZAG_DTINI + 7
	    ElseIf ZAG->ZAG_TPMEDI == "E" 
	    	_dMedPre := ZAG->ZAG_DTINI
	    Else
	    	_dMedPre := ZAG->ZAG_DTINI
	    EndIf
     	_cFrota := ZAG->ZAG_GRUA
    	_cDesEq := Posicione("ST9", 1, xFilial("ST9") + _cFrota, "T9_NOME")
    	_cHrIni := SubStr(ZAG->ZAG_HRINI,1,2)  + SubStr(ZAG->ZAG_HRINI,3,4) 
    	_cHrFim := SubStr(ZAG->ZAG_HRFIM,1,2)  + SubStr(ZAG->ZAG_HRFIM,3,4) 
    	_nHrTot := ZAG->ZAG_PREDIA//ZAG->ZAG_MINDIA
    	_cBase  := ZAG->ZAG_TIPOCA
    	_nVrHor := ZAG->ZAG_VRHOR
    	_nVTotH := ZAG->ZAG_VRHOR * _nHrTot//ZAG->ZAG_MINDIA
    	_nVrMob := ZAG->ZAG_VRMOB
    	_nVrDes := ZAG->ZAG_VRDES
    	_cTpSeg := ZAG->ZAG_TPSEGU
    	_nPerSg := ZAG->ZAG_PERSEG
    	_nVBasS := ZAG->ZAG_VRCARG 
    	_nVrSeg := ZAG->ZAG_VRSEGU
    	_cTpISS := ZAG->ZAG_TPISS 
    	_nPrISS := ZAG->ZAG_PERISS
    	_nVrISS := ZAG->ZAG_VRISS 
    	_nTnsPs := ZAG->ZAG_VRPESO
    	_nAncor := ZAG->ZAG_ANCORA
    	_nTeles := ZAG->ZAG_TELESC
    	_Montag := ZAG->ZAG_MONTAG
    	_Desmon := ZAG->ZAG_DESMON
    	_cCdAnt := ZAG->ZAG_CODLCR
    	_nTotKM := 0
    	If _cTpSeg $ "I;C"
    		If _cBase == "K"
    			_nVrToM := (_nTotKM * _nVrHor ) + _nVrMob + _nVrDes + _nAncor + _nTeles + _Montag + _Desmon + _nTnsPs 
    		Else
    			_nVrToM := ( 0 * _nVrHor ) + _nVrMob + _nVrDes + _nAncor + _nTeles + _Montag + _Desmon + _nTnsPs        
    		EndIf
    	Else
    		If _cBase == "K"
    			_nVrToM := (_nTotKM * _nVrHor ) + _nVrMob + _nVrDes + _nAncor + _nTeles + _Montag + _Desmon + _nTnsPs + _nVrSeg 
    		Else
    			_nVrToM := ( 0 * _nVrHor ) + _nVrMob + _nVrDes + _nAncor + _nTeles + _Montag + _Desmon + _nTnsPs + _nVrSeg 
    		EndIf
    	EndIf
    	_cOriVn := ZAG->ZAG_FILIAL 
    	_cFiMaq := ZAG->ZAG_FLMAQ 
    	_cFiMOr := ZAG->ZAG_FLMO  
    	_nPOVen := Posicione("ZLK", 1, xFilial("ZLK") + ZAG->ZAG_RATEIO, "ZLK_PCOML")
    	_nPrMaq := Posicione("ZLK", 1, xFilial("ZLK") + ZAG->ZAG_RATEIO, "ZLK_PBEM")
    	_nPrMao := Posicione("ZLK", 1, xFilial("ZLK") + ZAG->ZAG_RATEIO, "ZLK_PMO")
    	_nPorMa := ZAG->ZAG_PERMAO
    	_nVrOrV := _nVrToM * _nPOVen / 100
    	_nVrMaq := _nVrToM * _nPrMaq / 100
    	_nVrMao := _nVrToM * _nPrMao / 100
	    
	    If ZLG->ZLG_STATUS == "2"
		    If ZA5->ZA5_TPMEDM == "O" 
		    	_dMobRea := ZLG->ZLG_DTINI  
		    ElseIf ZA5->ZA5_TPMEDM $ "I;E;Q;S;M"
		    	_dMobRea := ZLG->ZLG_DTFIM  
		    EndIf
		ElseIf ZLG->ZLG_STATUS == "4"
		    If ZA5->ZA5_TPMEDM == "O" 
				_dDesRea := ZLG->ZLG_DTINI
		    ElseIf ZA5->ZA5_TPMEDM $ "I;E;Q;S;M"
		    	_dDesRea := ZLG->ZLG_DTFIM  
		    EndIf
	    EndIf
    ElseIF ZA0->ZA0_TIPOSE $ "T;I" .AND. ZA6->ZA6_INTMUN == "S" // "T;R;O"
        dbSelectArea("ZA6")
        ZA6->(dbSetOrder(2))
        ZA6->(dbSeek(xFilial("DTQ") + DTQ->DTQ_AS + DTQ_VIAGEM))
		_dMedPre:= ZA6->ZA6_DTINI 
	    _cFrota := ZA6->ZA6_TRANSP 
    	_cDesEq := Posicione("ST9", 1, xFilial("ST9") + _cFrota, "T9_NOME")
    	_cHrIni := SubStr(ZA6->ZA6_HRINI,1,2)  + SubStr(ZA6->ZA6_HRINI,3,4) 
    	_cHrFim := SubStr(ZA6->ZA6_HRFIM,1,2)  + SubStr(ZA6->ZA6_HRFIM,3,4) 
    	_nHrTot := __Hrs2Min(_cHrFim) - __Hrs2Min(_cHrIni)
    	_cBase  := ZA6->ZA6_TIPOCA
    	_nVrHor := ZA6->ZA6_VRDIA / 8
    	_nVTotH := _nVrHor * _nHrTot
    	_nVrMob := 0 
    	_nVrDes := 0
    	dbSelectArea("ZA7")
    	ZA7->(dbSetOrder(4))
    	ZA7->(dbSeek(xFilial("ZA7") + DTQ->DTQ_SOT + DTQ->DTQ_OBRA + DTQ->DTQ_VIAGEM))
    	_cTpSeg := ZA7->ZA7_FORMAS
    	_nPerSg := ZA7->ZA7_VALADV
		_nVBasS := 0
		dbSelectArea("ZA9")
		ZA9->(dbSetOrder(2))
		ZA9->(dbSeek(xFilial("ZA9") + DTQ->DTQ_SOT + DTQ->DTQ_OBRA + ZA7->ZA7_SEQTRA))
		_nVrSeg := Round( ( ZA9->ZA9_VRFRET * _nPerSg / 100 ) ,2)
    	_cTpISS := ZA7->ZA7_INCICM
    	_nPrISS := ZA7->ZA7_VALICM
    	_nVrISS := Round( ( ZA9->ZA9_VRFRET * _nPrISS / 100 ) / (( 100 - _nPrISS ) / 100) ,2)
    	_nTnsPs := ZA7->ZA7_VRCARG
		_nAncor := 0
 		_nTeles := 0
		_Montag := 0
		_Desmon := 0
    	_cCdAnt := ZA6->ZA6_CODLCR
    	dbSelectArea("ZLX")
    	ZLX->(dbSetOrder(1))
    	ZLX->(dbSeek(xFilial("ZLX") + DTQ->DTQ_SOT ))
    	_nTotKM := ZLX->ZLX_KM
    	If _cTpSeg $ "I;C"
    		If _cBase == "K"
    			_nVrToM := (_nTotKM * _nVrHor ) + _nVrMob + _nVrDes + _nAncor + _nTeles + _Montag + _Desmon + _nTnsPs 
    		Else
    			_nVrToM := ( 0 * _nVrHor ) + _nVrMob + _nVrDes + _nAncor + _nTeles + _Montag + _Desmon + _nTnsPs        
    		EndIf
    	Else
    		If _cBase == "K"
    			_nVrToM := (_nTotKM * _nVrHor ) + _nVrMob + _nVrDes + _nAncor + _nTeles + _Montag + _Desmon + _nTnsPs + _nVrSeg 
    		Else
    			_nVrToM := ( 0 * _nVrHor ) + _nVrMob + _nVrDes + _nAncor + _nTeles + _Montag + _Desmon + _nTnsPs + _nVrSeg 
    		EndIf
    	EndIf
    	_cOriVn := ""
    	_cFiMaq := ""
    	_cFiMOr := ""
    	_nPOVen := 0
    	_nPrMaq := 0
    	_nVrOrV := 0
    	_nVrMaq := 0
    	_nVrMao := 0
    	_nPrMao := 0 

	    If ZLG->ZLG_STATUS == "2"
		    If ZA5->ZA5_TPMEDM == "O" 
		    	_dMobRea := ZLG->ZLG_DTINI  
		    ElseIf ZA5->ZA5_TPMEDM $ "I;E;Q;S;M"
		    	_dMobRea := ZLG->ZLG_DTFIM  
		    EndIf
		ElseIf ZLG->ZLG_STATUS == "4"
		    If ZA5->ZA5_TPMEDM == "O" 
				_dDesRea := ZLG->ZLG_DTINI
		    ElseIf ZA5->ZA5_TPMEDM $ "I;E;Q;S;M"
		    	_dDesRea := ZLG->ZLG_DTFIM  
		    EndIf
	    EndIf
    	//------Quando o tipo de seguro for igual a "T, R, O" s� criara um linha para o registro
    	_nItens := 1 
    EndIf 
    /*
	IF (ZA0->ZA0_TIPOSE $ "T;I") 
	  	If (ZA6->ZA6_INTMUN == "S") // "T;R;O"
	    	CrItens() //Maickon Queiroz - Chamada da Rotina CriaItens para a Medicao
   		ENDIF
  	Else
		
  		CrItens() //Maickon Queiroz - Chamada da Rotina CriaItens para a Medicao
    EndIf                                                                        
		*/
EndIf 

If lAcess

	cTitulo := "Referente a Aceite da " + _cTipoAS + " n�mero " + DTQ->DTQ_AS + ", projeto " + AllTrim(DTQ->DTQ_SOT) + ", revis�o " + ZA0->ZA0_REVISA + Space(100)
	cMsg    := "Data Ini/Fim: "+DTOC(DTQ->DTQ_DATINI)+" - "+DTOC(DTQ->DTQ_DATINI)+",  Obra: "+AllTrim(DTQ->DTQ_DESTIN)+",  Cliente: "+AllTrim(DTQ->DTQ_NOMCLI)+""
   	U_MandaEmail( eFrom, cPara , cCC, cTitulo, cTitulo + Chr(13) + Chr(10) + cMsg, nil, cCCo)
   	
   
   fCalcEmb(DTQ->DTQ_SOT,DTQ->DTQ_VIAGEM) 
   
   	
	RecLock("DTQ",.F.)
		DTQ->DTQ_STATUS := "6" 			// aprovado !
		DTQ->DTQ_ACEITE := dDatabase 	// data aprova��o
//		IF !Empty(cTpAnt)
//			DTQ->DTQ_TPAS := cTpAnt
//		EndIf
	DTQ->(MsUnLock())
EndIf



Return .T.
/*
Static Function fCalcEmb(cSOT,cViagem)
	LOCAL aAreaDTQ := GETAREA()
	Local mSQL := ""
	Local vFrete := 0
	Local vValor := 0	
	Local vCli,vLJ,vAS := ""
    Local nRecno 
      
	If Select("TDTQ") > 0 
		dbSelectArea("TDTQ")
		TDTQ->(dbCloseArea())
	EndIf

	mSQL := "SELECT DTQ.R_E_C_N_O_,DTQ_VIAGEM,DTQ_XFRETE,ZA7_CODCLI,ZA7_LOJCLI,ZA7_AS "
	mSQL += " FROM "+RetSQLName("DTQ")+" DTQ INNER JOIN "+RetSQLName("ZA7")+" ZA7 "
	mSQL += " ON DTQ_VIAGEM=ZA7_VIAGEM AND DTQ_AS=ZA7_AS AND DTQ_FILORI=ZA7_FILIAL "
	mSQL += " WHERE DTQ_SOT ='"+cSOT+"' AND DTQ_VIAGEM='"+cViagem+"' "
	mSQL += " AND DTQ_FILIAL='"+xFilial("DTQ")+"' AND ZA7_FILIAL='"+xFilial("ZA7")+"' "
	mSQL += " AND ZA7.D_E_L_E_T_ =' ' AND DTQ.D_E_L_E_T_=' ' "
	mSQL += " AND ZA7_DEVEMB='P' AND DTQ_NUMCTC='' " 
	
				
	dbUseArea( .T., "TOPCONN", TCGENQRY(,,mSQL), "TDTQ", .F., .T. )
		
	dbSelectArea("TDTQ")
	TDTQ->(dbGoTop())
	IF TDTQ->(!EoF())
    	nRecno := TDTQ->R_E_C_N_O_
    	vCli   := TDTQ->ZA7_CODCLI
		vLJ    := TDTQ->ZA7_LOJCLI
		vFrete := TDTQ->DTQ_XFRETE
		
		If Select("TMP") > 0 
			dbSelectArea("TMP")
			TMP->(dbCloseArea())
		EndIf

		mSQL := "SELECT DTQ_XFRETE " 
		mSQL += " FROM DTQ010 DTQ,ZA7010 ZA7 "
		mSQL += " WHERE DTQ_SOT ='"+cSOT+"' AND DTQ_VIAGEM=ZA7_VIAGEM AND DTQ_AS=ZA7_AS "
		mSQL += " AND ZA7_CODCLI='"+vCli+"' AND ZA7_LOJCLI='"+vLJ+"'"
		mSQL += " AND DTQ_FILIAL='"+xFilial("DTQ")+"' AND ZA7_FILIAL='"+xFilial("ZA7")+"' AND DTQ_FILORI=ZA7_FILIAL 
		mSQL += " AND ZA7.D_E_L_E_T_ =' ' AND DTQ.D_E_L_E_T_=' ' AND ZA7_DEVEMB='I' AND DTQ_NUMCTC=''"
 
		dbUseArea( .T., "TOPCONN", TCGENQRY(,,mSQL), "TMP", .F., .T. )
		
		dbSelectArea("TMP")
		TMP->(dbGoTop())
		IF TMP->(!EoF())
			vValor := TMP->DTQ_XFRETE
		Endif	
		TMP->(dbCloseArea())
		
	    DTQ->(dbGoto(nRecno)) 
		RecLock("DTQ",.F.)
		DTQ->DTQ_XFRETE := vFrete - vValor
		DTQ->(MsUnLock())
			
	Endif		
	TDTQ->(dbCloseArea())
    
	      
	RESTAREA(aAreaDTQ)      
Return
 */
Static Function fCalcEmb(cSOT,cViagem)
	Local aAreaDTQ1 := DTQ->(GetArea())
	Local mSQL := ""
	Local vFrete := 0
	Local vValor := 0	
	Local vCli,vLJ,vAS := ""
    Local nRecno 
      

		If Select("TMP") > 0 
			dbSelectArea("TMP")
			TMP->(dbCloseArea())
		EndIf


		mSQL := "SELECT DTQ_XFRETE,ZA7_CODCLI,ZA7_LOJCLI " 
		mSQL += " FROM "+RetSQLName("DTQ")+" DTQ,"+RetSQLName("ZA7")+" ZA7 "
		mSQL += " WHERE DTQ_SOT ='"+cSOT+"' AND DTQ_VIAGEM='"+cViagem+"' "
		mSQL += " AND DTQ_VIAGEM=ZA7_VIAGEM AND DTQ_AS=ZA7_AS "
		mSQL += " AND DTQ_FILIAL='"+xFilial("DTQ")+"' AND ZA7_FILIAL='"+xFilial("ZA7")+"' AND DTQ_FILORI=ZA7_FILIAL 
		mSQL += " AND ZA7.D_E_L_E_T_ =' ' AND DTQ.D_E_L_E_T_=' ' AND ZA7_DEVEMB='I' AND DTQ_NUMCTC=''"
 
		dbUseArea( .T., "TOPCONN", TCGENQRY(,,mSQL), "TMP", .F., .T. )
		
		dbSelectArea("TMP")
		TMP->(dbGoTop())
		IF TMP->(!EoF())
			vValor := TMP->DTQ_XFRETE
	    	vCli   := TMP->ZA7_CODCLI
			vLJ    := TMP->ZA7_LOJCLI
		
			If Select("TDTQ") > 0 
				dbSelectArea("TDTQ")
				TDTQ->(dbCloseArea())
			EndIf

			mSQL := "SELECT DTQ.R_E_C_N_O_,DTQ_VIAGEM,DTQ_XFRETE,ZA7_CODCLI,ZA7_LOJCLI,ZA7_AS "
			mSQL += " FROM "+RetSQLName("DTQ")+" DTQ INNER JOIN "+RetSQLName("ZA7")+" ZA7 "
			mSQL += " ON DTQ_VIAGEM=ZA7_VIAGEM AND DTQ_AS=ZA7_AS AND DTQ_FILORI=ZA7_FILIAL "
			mSQL += " WHERE DTQ_SOT ='"+cSOT+"' "
			mSQL += " AND ZA7_CODCLI='"+vCli+"' AND ZA7_LOJCLI='"+vLJ+"'"
			mSQL += " AND DTQ_FILIAL='"+xFilial("DTQ")+"' AND ZA7_FILIAL='"+xFilial("ZA7")+"' "
			mSQL += " AND ZA7.D_E_L_E_T_ =' ' AND DTQ.D_E_L_E_T_=' ' "
			mSQL += " AND ZA7_DEVEMB='P' AND DTQ_NUMCTC='' " 
			
				
			dbUseArea( .T., "TOPCONN", TCGENQRY(,,mSQL), "TDTQ", .F., .T. )
				
			dbSelectArea("TDTQ")
			TDTQ->(dbGoTop())
			IF TDTQ->(!EoF())
		    	nRecno := TDTQ->R_E_C_N_O_
				vFrete := TDTQ->DTQ_XFRETE
			Endif
			TDTQ->(dbCloseArea())
			
			DTQ->(dbGoto(nRecno)) 
			RecLock("DTQ",.F.)
			DTQ->DTQ_XFRETE := vFrete - vValor
			DTQ->(MsUnLock())

		Endif
		TMP->(dbCloseArea())


	      

	DTQ->(RestArea(aAreaDTQ1))      
Return


/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �CriaZLG   �Autor  �M&S Consultoria     � Data �  30/06/07   ���
�������������������������������������������������������������������������͹��
���Desc.     � Para evitar de ter que repetir o mesmo c�digo v�rias vezes ���
���          � criei esta rotina.                                         ���
���          �                                                            ���
���          � SERVE PARA CRIAR A PROGRAMA��O DI�RIA A PARTIR DA AS (DTQ) ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
����������������������������������������������������������������������������� 
Alterado em 04/08/2011 by CJCAMPOS PROATIVA dacoor Lui
/*/
Static Function CriaZLG(lZLT, dIni, dFim,xStatus) 

Local nPosBarra := AT("/",DTQ->DTQ_SOT)
Default xStatus := "R"
dbSelectArea("ZA0")
ZA0->(dbSetOrder(1))
ZA0->(dbSeek(xFilial("ZA0") + DTQ->DTQ_SOT))

ZLG->(RECLOCK("ZLG", lZLT))
	ZLG->ZLG_FILIAL	:= XFILIAL("ZLG")
	ZLG->ZLG_FROTA  := DTQ->DTQ_GUINDA
	ZLG->ZLG_CODCLI	:= ZA0->ZA0_CLI // posicione("AAM",1,xFilial("AAM")+DTQ->DTQ_CONTRA,"AAM_CODCLI") // ALIAS "AAM" -> ARQUIVO DE CONTRATOS DE PRESTACAO DE SERVI�O
	ZLG->ZLG_LOJA	:= ZA0->ZA0_LOJA //POSICIONE("AAM",1,xFilial("AAM")+DTQ->DTQ_CONTRA,"AAM->AAM_LOJA")
	ZLG->ZLG_NOMCLI	:= posicione("SA1",1,xFilial("SA1")+ZA0->ZA0_CLI+ZA0->ZA0_LOJA,"A1_NOME") 
	ZLG->ZLG_LOCAL	:= Alltrim(Posicione("SA1",1,xFilial("SA1")+ZA0->ZA0_CLI+ZA0->ZA0_LOJA,"A1_NREDUZ"))+" / "+Alltrim(DTQ->DTQ_DESTIN) //03/11/2011 - Maickon Queiroz - Solicita��o do Lui
	ZLG->ZLG_DTINI	:= dIni            // DTQ->DTQ_DATINI
	ZLG->ZLG_DTFIM	:= dFim            // DTQ->DTQ_DATFIM
	ZLG->ZLG_NRAS   := DTQ->DTQ_AS    // NUMERO DA AS
	ZLG->ZLG_PROJET := DTQ->DTQ_SOT   // NUMERO DO PROJETO
	If nPosBarra > 0                   // INDICA QUE EXISTE REVISAO.
		If DTQ->DTQ_TPAS == "G"       // INCLUIDO CJC
			ZLG->ZLG_REVISA := StrZero(posicione("ZA5",3,DTQ->DTQ_FILORI+DTQ->DTQ_AS+DTQ->DTQ_VIAGEM,"ZA5_REVNAS"),2)
		ElseIf DTQ->DTQ_TPAS == "U"   // INCLUIDO CJC
			ZLG->ZLG_REVISA := StrZero(posicione("ZAG",3,DTQ->DTQ_FILORI+DTQ->DTQ_AS+DTQ->DTQ_VIAGEM,"ZAG_REVNAS"),2) // INCLUIDO CJC
		Endif // INCLUDO CJC
	Endif
	ZLG->ZLG_OBRA   := DTQ->DTQ_OBRA     // OBRA
	ZLG->ZLG_VIAGEM := DTQ->DTQ_VIAGEM   // viagem
	//ZLG->ZLG_STATUS := "R"
	ZLG->ZLG_STATUS := xStatus
ZLG->(MsUnlock())

// fun��o que trata os acessorios tipo R - ETG11 CJDECAMPOS
//nPosZlg := ZLG->(Recno())
//U_fDoZlg(cFrota,nPosZlg)
// Fim ETG11

Return Nil


**********************
User Function GerMail()
// Envia Email
***********************
Local lOk 		:= .F. 
Local cCC	 	:= Space(100)
Local cCCo	 	:= Space(100)
Local cMsg	 	:= "" + CHR(13)+CHR(10)
Local cPara	 	:= Space(100)
Local cTitulo	:= Space(100)
Local oAnexo                                                           
Local oCC
Local oCCo
Local oMsg
Local oPara
Local oTitulo
Local eFrom 	:= AllTrim(UsrRetName(RetCodUsr())) + " <" + AllTrim(UsrRetMail(RetCodUsr())) + ">" 
Local aButtons	:= {}
Private _oDlgMail
	
ZA0->(DbSetOrder(1))                                                   
ZA0->(DbSeek(DTQ->DTQ_FILORI + DTQ->DTQ_SOT))

Do Case
Case ZA0->ZA0_TIPOSE == "G"; _cTipoAS := "AS"; _cDesc := "GUINDASTE"
Case ZA0->ZA0_TIPOSE == "R"; _cTipoAS := "ASG"; _cDesc := "P�RTICO"
Case ZA0->ZA0_TIPOSE == "U"; _cTipoAS := "ASG"; _cDesc := "GRUA"
Case ZA0->ZA0_TIPOSE == "P"; _cTipoAS := "ASG"; _cDesc := "PLATAFORMA"
Case ZA0->ZA0_TIPOSE == "T"; _cTipoAS := "AST"; _cDesc := "TRANSPORTE"
Case ZA0->ZA0_TIPOSE == "I"; _cTipoAS := "AST"; _cDesc := "TRANSPORTE INT."
Case ZA0->ZA0_TIPOSE == "O"; _cTipoAS := "AST"; _cDesc := "TRANSPORTE Emp."
OtherWise                  ; _cTipoAS := "AS "; _cDesc := ZA0->ZA0_TIPOSE
EndCase

cTitulo		:= "Referente a " + _cTipoAS + " n�mero " + DTQ->DTQ_AS + ", projeto " + AllTrim(DTQ->DTQ_SOT) + ", revis�o " + ZA0->ZA0_REVISA + Space(100)

Define MsDialog _oDlgMail Title "Envia E-mail" From C(230),C(359) To C(610),C(882) Pixel
	
@ C(034),C(011) Say "Para:"					Size C(060),C(016) COLOR CLR_BLACK PIXEL OF _oDlgMail
@ C(031),C(042) MsGet oPara Var cPara 		Size C(159),C(009) COLOR CLR_BLACK PIXEL OF _oDlgMail
@ C(045),C(011) Say "Cc:" 					Size C(030),C(008) COLOR CLR_BLACK PIXEL OF _oDlgMail
@ C(045),C(042) MsGet oCC 	Var cCC 		Size C(159),C(009) COLOR CLR_BLACK PIXEL OF _oDlgMail	


@ C(058),C(011) Say "Cco:" 					Size C(030),C(008) COLOR CLR_BLACK PIXEL OF _oDlgMail
@ C(058),C(042) MsGet oCCo 	Var cCCo 		Size C(159),C(009) COLOR CLR_BLACK PIXEL OF _oDlgMail		
@ C(072),C(011) Say "Assunto:" 				Size C(030),C(008) COLOR CLR_BLACK PIXEL OF _oDlgMail
@ C(072),C(042) MsGet oTitulo Var cTitulo	Size C(210),C(009) COLOR CLR_BLACK PIXEL OF _oDlgMail
@ C(085),C(011) Say "Mensagem:" 			Size C(030),C(008) COLOR CLR_BLACK PIXEL OF _oDlgMail
@ C(086),C(042) GET oMsg Var cMsg MEMO 		Size C(210),C(065) 				   PIXEL OF _oDlgMail
	
Activate MsDialog _oDlgMail Centered On Init EnchoiceBar(_oDlgMail, {||lOk:=.T., _oDlgMail:End()},{||_oDlgMail:End()},,aButtons)
	
If lOk
   	U_MandaEmail( eFrom, cPara , cCC, cTitulo, cMsg, nil, cCCo) 
EndIf       
	
Return()

***********************
Static Function C(nTam)
// Tamanho / Posi��o
***********************

Local nHRes	:=	oMainWnd:nClientWidth	// Resolucao horizontal do monitor     

If nHRes == 640	// Resolucao 640x480 (soh o Ocean e o Classic aceitam 640)  
	nTam *= 0.8                                                                
ElseIf (nHRes == 798).Or.(nHRes == 800)	// Resolucao 800x600                
	nTam *= 1                                                                  
Else	// Resolucao 1024x768 e acima                                           
	nTam *= 1.28                                                               
EndIf                                                                         
                                                                                
//���������������������������Ŀ                                               
//�Tratamento para tema "Flat"�                                               
//�����������������������������                                               
If "MP8" $ oApp:cVersion                                                      
	If (Alltrim(GetTheme()) == "FLAT") .Or. SetMdiChild()                      
		nTam *= 0.90                                                            
	EndIf                                                                      
EndIf                                                                         

Return Int(nTam)       

***************************************************************************************
User Function MandaEmail(_cRemet, _cDest, _cCC, _cAssunto, cBody, _cAnexo, _cCco, _lMsg)	//u_MandaEmail("Workflow <totvs@itup.com.br>", "marcos_feijo@terra.com.br","fabio.martins@itup.com.br","Assunto","Corpo","","")
// Envia Email - Rotina Padr�o
***************************************************************************************
Local cEnvia    	:= AllTrim(GetMV("MV_RELFROM"))	//marcos_feijo@terra.com.br
Local _cSerMail		:= AllTrim(GetMV("MV_RELSERV"))						
Local _cDe     		:= AllTrim(GetMV("MV_RELACNT"))			//totvs					//marcos_feijo@terra.com.br
Local _cSenha		:= AllTrim(GetMV("MV_RELPSW")) 			//123mudar@
Local lSmtpAuth  	:= GetMv("MV_RELAUTH",,.F.)			//.t.
Local _lEnviado		:= .F.
Local _lConectou	:= .F.
Local _cMailError	:= ""
Local _cFile 		:= ""    
Local _cBody		:= cBody

_cRemet := cEnvia

If IsInCallStack("APCRetorno")	
	ConOut("Retornou WF")
EndIf  
	 


     /* Local oMailServer := TMailManager():New()
      Local oMessage := TMailMessage():New()
      Local nErro := 0
      
      oMailServer:Init( "", "webmail.transremocao.com.br", _cDe, _cSenha, 0, 25)
      
      If( (nErro := oMailServer:SmtpConnect()) != 0 )
      conout( "N�o conectou.", oMailServer:GetErrorString( nErro ) )
      Return
      EndIf
      
      oMessage:Clear()
      
      oMessage:cFrom           := _cRemet     //Altere
      oMessage:cTo             := _cDest //Altere
      oMessage:cCc             := ""
      oMessage:cBcc            := ""
      oMessage:cSubject        := _cAssunto
      oMessage:cBody           := _cBody
      oMessage:MsgBodyType( "text/html" )
      
      // Para solicitar confima��o de envio
      //oMessage:SetConfirmRead( .T. )
      
      // Adiciona um anexo, nesse caso a imagem esta no root
      //oMessage:AttachFile( _cAnexo )
      
      
      // Essa tag, � a referecia para o arquivo ser mostrado no corpo, o nome declarado nela deve ser o usado no HTML
      oMessage:AddAttHTag( "Content-ID: " )
      
      If( (nErro := oMessage:Send( oMailServer )) != 0 )
      conout( "N�o enviou o e-mail.", oMailServer:GetErrorString( nErro ) )
      Return
      EndIf
      
      If( (nErro := oMailServer:SmtpDisconnect()) != 0 )
      conout( "N�o desconectou.", oMailServer:GetErrorString( nErro ) )
      Return
      EndIf*/
      

If Pcount() < 8		//N�o mostra a mensagem de email enviado com sucesso
	_lMsg	:= .T.
EndIf  
                                                             	
Connect SMTP Server _cSerMail Account _cDe Password _cSenha Result _lConectou			// Conecta ao servidor de email

If !(_lConectou)																		// Se nao conectou ao servidor de email, avisa ao usuario
	Get Mail Error _cMailError
	If _lMsg
		msgBox("N�o foi poss�vel conectar ao Servidor de email." + Chr(13) + Chr(10) +;
			   "Procure o Administrador da rede."				 + Chr(13) + Chr(10)+;
			   "Erro retornado: "								 + _cMailError)
	EndIf
Else   
	If lSmtpAuth
		lAutOk := MailAuth(_cDe,_cSenha)
    Else                      
        lAutOK := .t.
    EndIf

	IF !lAutOk 
		If _lMsg
			MsgStop("N�o foi possivel autenticar no servidor.")
		EndIf
	Else   
		If Empty(_cRemet)
			_cRemet := Capital(StrTran(AllTrim(UsrRetName(RetCodUsr())),"."," ")) + " <" + AllTrim(cEnvia) + ">"
		EndIf
//  		Send Mail From cEnvia  To _cDest CC _cCC BCC _cCco SUBJECT _cAssunto BODY cBody RESULT _lEnviado
//		Send Mail From _cRemet To _cDest Cc _cCc BCC _cCco SUBJECT _cAssunto BODY cBody Result _lEnviado

		If !Empty(_cAnexo)
			Send Mail From _cRemet To _cDest Cc _cCc BCC _cCco SUBJECT _cAssunto BODY cBody ATTACHMENT _cAnexo Result _lEnviado
		Else
			Send Mail From _cRemet To _cDest Cc _cCc BCC _cCco SUBJECT _cAssunto BODY cBody Result _lEnviado
		Endif
		
		If !(_lEnviado)
			Get Mail Error _cMailError
			If _lMsg
				MsgBox("N�o foi poss�vel enviar o email."	+ Chr(13) + Chr(10) +;
					   "Procure o Administrador da rede."	+ Chr(13) + Chr(10) +;
					   "Erro retornado: "					+ _cMailError)
			EndIf
		Else
			If _lMsg
				MsgInfo("E-Mail enviado com sucesso!","Informa��o")
			EndIf
		EndIf
    EndIf		

	Disconnect Smtp Server
EndIf 

Return

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Fun??o    �VALIDPERG � Autor � AP5 IDE            � Data �  07/05/02   ���
�������������������������������������������������������������������������͹��
���Descri??o � Verifica a existencia das perguntas criando-as caso seja   ���
���          � necessario (caso nao existam).                             ���
�������������������������������������������������������������������������͹��
���Uso       � Programa principal                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

Static Function ValidPerg

Local _sAlias := Alias()
Local aRegs := {}
Local i,j

dbSelectArea("SX1")
dbSetOrder(1)
cPerg := PADR(cPerg,10)

//          Grupo/Ordem/Pergunta                                                            /Variavel /Tipo/Tamanho/Decimal/Presel/GSC/Valid                              	/Var01     /Def01         /Def01         /Def01         /Cnt01/Var02/Def02        /Def02        /Def02        /Cnt02/Var03/Def03   /Def03   /Def03   /Cnt03/Var04/Def04         /Def04         /Def04         /Cnt04/Var05/Def05        /Def05        /Def05        /Cnt05/F3    /PYME/SXG/HELP/PICTURE/IDFIL
AAdd(aRegs,{cPerg,"01" ,"Per�odo Coleta de ?"        ,"Per�odo de ?"        ,"Per�odo de ?"        ,"mv_ch1" ,"D" ,08     ,0      ,0     ,"G",""                                	,"mv_par01",""            ,""            ,""            ,""   ,""   ,""           ,""           ,""           ,""   ,""   ,""      ,""      ,""      ,""   ,""   ,""            ,""            ,""            ,""   ,""   ,""           ,""           ,""           ,""   ,""    ,"S" ,"" ,"" ,""}) 
AAdd(aRegs,{cPerg,"02" ,"Per�odo Coleta at� ?"       ,"Per�odo at� ?"       ,"Per�odo at� ?"       ,"mv_ch2" ,"D" ,08     ,0      ,0     ,"G",""                                	,"mv_par02",""            ,""            ,""            ,""   ,""   ,""           ,""           ,""           ,""   ,""   ,""      ,""      ,""      ,""   ,""   ,""            ,""            ,""            ,""   ,""   ,""           ,""           ,""           ,""   ,""    ,"S" ,"" ,"" ,""}) 
AAdd(aRegs,{cPerg,"03" ,"Filial"                     ,"Filial"              ,"Filial       "       ,"mv_ch3" ,"C" ,99     ,0      ,0     ,"G",""                                	,"mv_par03",""            ,""            ,""            ,""   ,""   ,""           ,""           ,""           ,""   ,""   ,""      ,""      ,""      ,""   ,""   ,""            ,""            ,""            ,""   ,""   ,""           ,""           ,""           ,""   ,""    ,"S" ,"" ,"" ,""}) 
// AAdd(aRegs,{cPerg,"03" ,"Tipo de Servi�o"     ,"Tipo de Servi�o"     ,"Tipo de Servi�o"     ,"mv_ch3" ,"N" ,01     ,0      ,0     ,"C",""                               	,"mv_par03","Transportes" ,"Transportes" ,"Transportes" ,""   ,""   ,"Guindastes" ,"Guindastes" ,"Guindastes" ,""   ,""   ,"Gruas" ,"Gruas" ,"Gruas" ,""   ,""   ,"Remocao Mec" ,"Remocao Mec" ,"Remocao Mec" ,""   ,""   ,"Plataforma" ,"Plataforma" ,"Plataforma" ,""   ,""    ,"S" ,"" ,"" ,""})  
// Fui obrigado a alterar o par�metro pois n�o tem como coloca a 6� op��o - Cristiam Rossi em 01/09/2011
//AAdd(aRegs,{cPerg,"03" ,"Tipo de Servi�o"     ,"Tipo de Servi�o"     ,"Tipo de Servi�o"     ,"mv_ch3" ,"C" ,01     ,0      ,0     ,"G","EXISTCPO('SX5','78'+mv_par03,1)" 	,""        ,""            ,""            ,""            ,""   ,""   ,""           ,""           ,""           ,""   ,""   ,""      ,""      ,""      ,""   ,""   ,""            ,""            ,""            ,""   ,""   ,""           ,""           ,""           ,""   ,"78"  ,"S" ,"" ,"" ,""})  


For i:=1 to Len(aRegs)
    If !dbSeek(cPerg+aRegs[i,2])
        RecLock("SX1",.T.)
        For j:=1 to FCount()
            If j <= Len(aRegs[i])
                FieldPut(j,aRegs[i,j])
            Endif
        Next
        MsUnlock()
    Endif
Next

dbSelectArea(_sAlias)

Return

********************************************************************************

Static Function fCalcSegG(nBase,nPerc)     // Julio Cesar Campos

// Valida��es - Calcula o Seguro das Gruas, Plataformas e Maritima

********************************************************************************

Return(Round( (nBase*nPerc/100) ,2))                           


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �CrItens   �Autor  �M&S Consultoria     � Data �  30/06/07   ���
�������������������������������������������������������������������������͹��
���Desc.     � Funcao auxiliadora para gerar os itens da medicao.         ���
���          � Tabelas envolvidas:ZLM e ZLF                               ���
���          �                                                            ���
���          � Desenvolvido para atender os turnos de medicao, Periodos de���
���          � Medicao.                                                   ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       �                                                            ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

Static Function CrItens

Local _nValSer := 0 
Local _cPerIni  := 0
Local _cPerFim  := 0

//Peridos de Medi��o
Do Case
	Case ZA0->ZA0_PMEDIC == '1'
		_cPerIni := 01
		_cPerFim := 30
	Case ZA0->ZA0_PMEDIC == '2'
		_cPerIni := 21
		_cPerFim := 20
	Case ZA0->ZA0_PMEDIC == '3'
		_cPerIni := 26
		_cPerFim := 25
	Case ZA0->ZA0_PMEDIC == '4'
		_cPerIni := 01
		_cPerFim := 15
EndCase

//Calculos de Guindaste - Transporte Interno
If ZA0->ZA0_TIPOSE $ "G;I" //Guindaste - Transporte Interno
	_nVrToM := U_CalcGui(ZA5->ZA5_TIPOCA,ZA5->ZA5_VRHOR,ZA5->ZA5_PREDIA,ZA5->ZA5_MINDIA,ZA5->ZA5_MINMES,ZA5->ZA5_QTDIA,ZA5->ZA5_QTMES) 
	_nVrToM := _nVrToM+_nVrMob+_nVrDes+_nVrSeg+_nTnsPs 
	cTipoca := ZA5->ZA5_TIPOCA
	 
//Calculos de Grua - Maritimo
ElseIf ZA0->ZA0_TIPOSE $ "U;M" //Grua - Maritimo
	If ZAG->ZAG_TIPOSE $ "U/G/R/T/O" //Grua
		nValbase 	:= ZAG->ZAG_VRHOR + ZAG->ZAG_OPERAD
	    _PREDIA 	:= ZAG->ZAG_PREDIA
	    _nVrToM:= ZAG->ZAG_PREDIA   * nValbase + ( ZAG->ZAG_ANCORA + ;
	                                             ZAG->ZAG_TELESC + ;
	                                             ZAG->ZAG_VRSEGU + ;
	                                             ZAG->ZAG_DESMON + ;
	                                             ZAG->ZAG_MONTAG + ;
	                                             ZAG->ZAG_VRMOB  + ;
	                                             ZAG->ZAG_VRDES  )//ZAG->ZAG_VRISS  + ;
		_nVrToM:= _nVrToM+_nVrMob+_nVrDes+_nVrSeg+_nTnsPs                                             
	
	Else 
	      nCalc:= ZAG->ZAG_PREDIA *  ZAG->ZAG_OPERAD + ( ZAG->ZAG_ANCORA + ;
	                                                     ZAG->ZAG_TELESC + ;
	                                                     ZAG->ZAG_VRSEGU + ;
	                                                     ZAG->ZAG_DESMON + ;
	                                                     ZAG->ZAG_MONTAG + ;
	                                                     ZAG->ZAG_VRMOB  + ;
	                                                     ZAG->ZAG_VRDES  )//ZAG->ZAG_VRISS  + ;    
	Endif
	cTipoCa:=  ZAG->ZAG_TPBASE 
//Calculos de Plataforma
ElseIF ZA0->ZA0_TIPOSE $ "P" //Plataforma
	IF ZAG->ZAG_TIPOSE $ "U/G/R/T/O/P"
		nValbase:= ZAG->ZAG_VRHOR + ZAG->ZAG_OPERAD
	    _PREDIA := ZAG->ZAG_PREDIA  
		_nVrToM	:= ZAG->ZAG_PREDIA   * nValbase + ( ZAG->ZAG_VRISS  + ;
												 ZAG->ZAG_VRSEGU + ;
												 ZAG->ZAG_VRMOB  + ;
												 ZAG->ZAG_VRDES  )
	Else 
		_nVrToM:= ZAG->ZAG_PREDIA *  ZAG->ZAG_OPERAD + ( ZAG->ZAG_VRISS  + ;
													   ZAG->ZAG_VRSEGU + ;
													   ZAG->ZAG_VRMOB  + ;
													   ZAG->ZAG_VRDES  )
	Endif
	_cHrIni := '0000'
	_cHrFim := '0000'
	_nHrTot := 0 
	_nHrTot2:= 1                                                                                                            	
	_cBase := 'D'
	cTipoCa:=  ZAG->ZAG_TPBASE	    
EndIf

//Criado para Deleta as Medi��es antigas
//Tabela ZLM
TcSqlExec(" Update "+RetSqlName("ZLM")+" SET D_E_L_E_T_ = '*'  From "+RetSqlName("ZLM")+" as ZLM Inner Join "+;
          " (Select DISTINCT ZLF_FILIAL, ZLF_COD  From "+RetSqlName("ZLF")+" WHERE ZLF_AS = '"+DTQ->DTQ_AS+"' And D_E_L_E_T_ = ' ') as ZLF "+;
		  "	 on ZLM_FILIAL = ZLF_FILIAL AND ZLM_COD = ZLF_COD And ZLM.D_E_L_E_T_ = ' ' ")

//Tabela ZLF	
TcSqlExec( " Update "+RetSqlName("ZLF")+" SET D_E_L_E_T_ = '*' WHERE ZLF_AS = '"+DTQ->DTQ_AS+"' And D_E_L_E_T_ = ' '" )

_nValSer := (_nVrToM-(_nVrMob+_nVrDes))// Maickon - Incluido para n�o levar para a Medi��o o Mob/Desmob.
	
//Cria os Cabe�alhos 
//Faz cabe�alho para a tabela de Medi��o dtos
_DtIni := Dtos(DTQ->DTQ_DATINI)
_DtFim := Dtos(DTQ->DTQ_DATFIM)
/*
If ZA0->ZA0_PMEDIC == '4' //Tem Segunda Medi��o
	
	//����������������������������������������������������Ŀ
	//�Executa Query para Criar� os Periodos da Medi��o    �
	//�Funcao do Banco: Fn_Per_Med_2                       �
	//�Parametros: Data Inicial,                           �
	//�            Data Final;                             �
	//�            Periodo Medicao Inicial                 �
	//�            Periodo Medicao Final                   �
	//�                                                    �
	//�Retorno: Data Inicial e Data Final da Medicao       �
	//�Ex: Parametros(01-01-2011, 30-03-2011, 01, 15)      �
	//�    Retorno 01-01-2011, 16-01-2011                  �
	//�            16-01-2011, 28-02-2011                  �
	//�			   01-02-2011, 15-03-2011				   �
	//�			   16-03-2011, 30-03-2011                  �
	//�													   �
	//������������������������������������������������������
	
    BeginSQL Alias "MRD"
    %NoParser%
	Select * 
		From (
			Select * From Fn_Per_Med_2(%EXP:_DtIni%,%EXP:_DtFim%,%EXP:_cPerIni%,%EXP:_cPerFim%)
			Union All
			Select Convert(VarChar(8), DateAdd(Day,1,MED_DTFIM),112) As MED_DTINI2,
				Case
					When Convert(VarChar(8),DateAdd(Day,-1,DateAdd(Month,1,Substring(MED_DTFIM,1,6)+'01')),112) > %EXP:_DtFim% //
					Then %EXP:_DtFim%
				Else Convert(VarChar(8),DateAdd(Day,-1,DateAdd(Month,1,Substring(MED_DTFIM,1,6)+'01')),112)
				End As MED_DTFIM2 
				From Fn_Per_Med_2(%EXP:_DtIni%,%EXP:_DtFim%,%EXP:_cPerIni%,%EXP:_cPerFim%)
	) Tmp
	Order By MED_DTINI
	EndSQL   

Else //Nao tem Segunda Medi�a�      
	
	//����������������������������������������������������Ŀ
	//�Executa Query para Criar� os Periodos da Medi��o    �
	//�Funcao do Banco: Fn_Per_Med                         �
	//�Parametros: Data Inicial,                           �
	//�            Data Final;                             �
	//�            Periodo Medicao Inicial                 �
	//�            Periodo Medicao Final                   �
	//�                                                    �
	//�Retorno: Data Inicial e Data Final da Medicao       �
	//�Ex: Parametros(01-01-2011, 30-03-2011, 21, 20)      �
	//�    Retorno 01-01-2011, 20-01-2011                  �
	//�            21-01-2011, 20-02-2011                  �
	//�			   21-02-2011, 20-03-2011				   �
	//�			   21-03-2011, 30-03-2011                  �
	//�													   �
	//������������������������������������������������������

    BeginSQL Alias "MRD"
    %NoParser%
	Select * From Fn_Per_Med (%EXP:_DtIni%,%EXP:_DtFim%,%EXP:_cPerIni%,%EXP:_cPerFim%)
	EndSQL 
	
EndIf
*/
//Chamada da Fun��o que para retorno dos Periodos de Medi��o
aArray:= U_Fn_Per_Med(_DtIni,_DtFim,_cPerIni,_cPerFim)

//nLinMRD := MRD->(ScopeCount()) //Numero de Linhas do Select
//MRD->(Dbgotop())

//Com Retorno da Query Cria os Periodos da Medicao    
//While MRD->(!EOF())
For nW:= 1 to Len(aArray)

	If ZA0->ZA0_TIPOSE $ "G;I" //Guindaste - Transporte Interno
		If ZA5->ZA5_TIPOCA == 'F'
			_nItens := 1
		Else
				_nItens := NumberItens(  StoD(aArray[nW][1]) , StoD(aArray[nW][2]))//DTQ->DTQ_DATFIM
		Endif
	ElseIf ZA0->ZA0_TIPOSE $ "U;M" //Grua - Maritimo
		_nItens := 1
	ElseIF ZA0->ZA0_TIPOSE $ "P" //Plataforma
		_nItens := 1
	EndIf

    //_nItens := (StoD(MRD->MED_DTFIM)-StoD(MRD->MED_DTINI))+1        
	_cCod 	:= GETSX8NUM("ZLF")
		    
	RecLock("ZLF", .T.)
		ZLF->ZLF_FILIAL := xFilial("ZLF")
	 	ZLF->ZLF_AS     := DTQ->DTQ_AS
    	ZLF->ZLF_PROJET := DTQ->DTQ_SOT   
    	ZLF->ZLF_OBRA   := DTQ->DTQ_OBRA  
    	ZLF->ZLF_VIAGEM := DTQ->DTQ_VIAGEM
    	ZLF->ZLF_COD    := _cCod
    	ZLF->ZLF_DTINIC := Stod(aArray[nW][1])//StoD(MRD->MED_DTINI)//DTQ->DTQ_DATINI
    	ZLF->ZLF_DTFIM  := Stod(aArray[nW][2])//StoD(MRD->MED_DTFIM)//DTQ->DTQ_DATFIM
    	ZLF->ZLF_MOBDTP := Iif( ZA0->ZA0_TIPOSE $ "G;I", ZA5->ZA5_DTINI, Iif( ZA0->ZA0_TIPOSE $ "U;P;M", ZAG->ZAG_DTINI , ZA6->ZA6_DTINI )) 
    	ZLF->ZLF_MOBDTR := _dMobRea
    	ZLF->ZLF_DESDTP := Iif( ZA0->ZA0_TIPOSE $ "G;I", ZA5->ZA5_DTFIM, Iif( ZA0->ZA0_TIPOSE $ "U;P;M", ZAG->ZAG_DTFIM , ZA6->ZA6_DTFIM )) 
    	ZLF->ZLF_DESDTR := _dDesRea
    	ZLF->ZLF_DTMEDP := _dMedPre
    	ZLF->ZLF_CLIENT := _cCodCli
    	ZLF->ZLF_LOJA   := _cLojCli
    	ZLF->ZLF_CONDPA := DTQ->DTQ_CONDPG
    	ZLF->ZLF_VALSER := (_nVTotH*_nItens)//(_nValSer / nLinMRD )//Valor dos Servi�os
//    	ZLF->ZLF_VLAISS := (_nVrISS / nLinMRD )//Valor de ISS
//    	ZLF->ZLF_VALTOT := ((_nValSer / nLinMRD )+ (_nVrISS /nLinMRD ))//fCalcSegG( ZLF->ZLF_VALSER, ZLF->ZLF_VLAISS)

	    ZLF->ZLF_VLAISS :=  (U_fCalcIssG(_nVTotH ,_nPrISS,_cTpISS)*_nItens) //((_nVrISS / nLinMRD )/_nItens) //U_fCalcIssG( (_nVrToM / _nItens) ,_nPrISS,_cTpISS) //_nVrISS 
		ZLF->ZLF_VALTOT := ((_nVTotH+ U_fCalcIssG(_nVTotH ,_nPrISS,_cTpISS))*_nItens)//(((_nValSer / nLinMRD )+ (_nVrISS /nLinMRD ))/_nItens) //(((_nVrToM + _nVrISS ) /  _nItens)/ nLinMRD )//IIf(ZA5->ZA5_TIPOCA == 'F',_nItens,_nVrToM / _nItens ) //Maickon 16-06-11 - Trazer valores ratiado para todos os itens
				
    	ZLF->ZLF_SITUAC := GETMV("MV_SITUAR")
    	ZLF->ZLF_VLDESC := Iif( ZA0->ZA0_TIPOSE $ "G", ZA5->ZA5_VALDES, Iif( ZA0->ZA0_TIPOSE $ "U;P;M",ZAG->ZAG_VALDES ,""))  
     	//ZLF->ZLF_OBS    := DTQ->DTQ_OBS   
    	ZLF->ZLF_ENCEAS := DTQ->DTQ_ENCERR
    	ZLF->ZLF_NUMPV  := _cNumPed
    	ZLF->ZLF_FILPV  := _cFilPed 
	    ZLF->(MsUnLock()) 
	   
	ZLF->(ConfirmSX8())
        
    dDtPar := Stod(aArray[nW][1])//StoD(MRD->MED_DTINI)
    //Cria os Itens   
    //Projeto Fechado gera somente uma linha na medicao com o valor total
    If cTipoca == 'F' .or. (ZA0->ZA0_TIPOSE $ 'U|P')
		_nItens := 1 //Para gerar somente um item na medicao
	Endif    

    For nX := 1 To _nItens 
                       
		DtValid:= DataValida(dDtPar,.T.)//Posterga data
		dDtPar:= DtValid
    	
    	// grava�ao de 2 ou mais turnos
    	ZBB->(dbselectArea("ZBB"))
    	ZBB->(dbSetOrder(1))
    	
    	If ZBB->(MsSeek( cChave := xFilial("ZBB") + DTQ->DTQ_SOT + DTQ->DTQ_OBRA + _cFrota)) .and. cTipoca <> 'F' .and. !ZA0->ZA0_TIPOSE $ 'U|P' // N�o se aplica para Grua
        
    		While ZBB->(!Eof()) .And. ZBB->(ZBB_FILIAL+ZBB_PROJET+ZBB_OBRA+ZBB_FROTA) = cChave 
	    		
	    		If ZA0->ZA0_TIPOSE == 'G'
		       		_nVrToM := U_CalcGui(ZA5->ZA5_TIPOCA,ZBB->ZBB_VALTUR,ZA5->ZA5_PREDIA,ZBB->ZBB_MINDIT,ZA5->ZA5_MINMES,ZA5->ZA5_QTDIA,ZA5->ZA5_QTMES) 
			    	_nVrToM := _nVrToM+_nVrMob+_nVrDes+_nVrSeg+_nTnsPs
					_PREDIA := 	ZA5->ZA5_PREDIA
				Endif  
				If ZBB->ZBB_HRINIT > ZBB->ZBB_HOFIMT
					cHrIni := ZBB->ZBB_HRINIT
					cHrFim := Alltrim(Str(Val(Left(ZBB->ZBB_HRINIT,2))+(24 - Val(Left(ZBB->ZBB_HRINIT,2))))+'00') //Val((LEFT('0830',2))+'.'+(Right('0830',2)))
					DtMedic:= DtValid 
			
					For n:= 1 to 2
						If n == 2
							cHrIni := '0000' 
							cHrFim := ZBB->ZBB_HOFIMT
							DtMedic:= DtValid + 1
						Endif
    	
					  	RecLock("ZLM", .T.)
						ZLM->ZLM_FILIAL := xFilial("ZLM")
						ZLM->ZLM_COD    := _cCod
						ZLM->ZLM_ITEM   := PadL(cValtoChar(nX),3,"0")
						ZLM->ZLM_DTMEDI := DtMedic //StoD(MRD->MED_DTINI)+nX -1 //DTQ->DTQ_DATINI + nX - 1 
						ZLM->ZLM_FROTA  := _cFrota
						ZLM->ZLM_DESCEQ := _cDesEq
						ZLM->ZLM_HORAI  := cHrIni
						ZLM->ZLM_HORAF  := cHrFim
						ZLM->ZLM_HORTOT := Val(ZBB->ZBB_MINDIT)
						ZLM->ZLM_QTDHR  := Val(ZBB->ZBB_MINDIT)
						ZLM->ZLM_BASE   := _cBase
						ZLM->ZLM_VALHOR := ZBB->ZBB_VALTUR  
						ZLM->ZLM_VLTOHR := (ZBB->ZBB_VALTUR*_PREDIA)/_nItens
						ZLM->ZLM_VLRMOB := IIf(nX==1,0/*_nVrMob*/,0)
						ZLM->ZLM_VLRDES := IIf(nX==1,0/*_nVrDes*/,0)
						ZLM->ZLM_TIPO   := _cTpSeg
						ZLM->ZLM_PERSEG := 0//_nPerSg
						ZLM->ZLM_VLBSEG := 0//_nVBasS
						ZLM->ZLM_VALSEG := 0//_nVrSeg
						ZLM->ZLM_TPISS  := _cTpISS 
						ZLM->ZLM_PERISS := _nPrISS
						//ZLM->ZLM_VALISS := ((_nVrISS / nLinMRD )/_nItens) //U_fCalcIssG( (_nVrToM / _nItens) ,_nPrISS,_cTpISS) //_nVrISS 
						//ZLM->ZLM_VALISS := (_nVTotH*_nPrISS/100) //U_fCalcIssG( (_nVrToM / _nItens) ,_nPrISS,_cTpISS) //_nVrISS 
						ZLM->ZLM_VALISS := (U_fCalcIssG( (_nVrToM / _nItens) ,_nPrISS,_cTpISS)/_nItens) //_nVrISS 
						ZLM->ZLM_VLRTOT := ((ZBB->ZBB_VALTUR*_PREDIA)/_nItens)+(U_fCalcIssG( (_nVrToM / _nItens) ,_nPrISS,_cTpISS)/_nItens)//(((_nVrToM + _nVrISS ) /  _nItens)/ nLinMRD )//IIf(ZA5->ZA5_TIPOCA == 'F',_nItens,_nVrToM / _nItens ) //Maickon 16-06-11 - Trazer valores ratiado para todos os itens
						//_nTOTMED := _nVrToM
						ZLM->ZLM_TRSPES := 0//_nTnsPs
						ZLM->ZLM_ANCORA := 0//_nAncor
						ZLM->ZLM_TELESC := _nTeles
						ZLM->ZLM_MONTAG := _Montag
						ZLM->ZLM_DESMON := _Desmon
						ZLM->ZLM_CODLCR := _cCdAnt
						ZLM->ZLM_QTDKM  := _nTotKM
						ZLM->ZLM_VENDA  := _cOriVn
						ZLM->ZLM_MAQUIN := _cFiMaq
						ZLM->ZLM_MAO    := _cFiMOr
						ZLM->ZLM_PERVND := _nPOVen
						ZLM->ZLM_PERMAQ := _nPrMaq
						ZLM->ZLM_VLVND  := _nVrOrV
						ZLM->ZLM_VLMAQ  := _nVrMaq
						ZLM->ZLM_VLMAO  := ( ( (_nVTotH+ U_fCalcIssG(_nVTotH ,_nPrISS,_cTpISS)) *_nPorMa / 100) *_nPorMa / 100)
						ZLM->ZLM_PERMAO := _nPorMa//_nPrMao
						ZLM->ZLM_LIBER  := "2"
						ZLM->(MsUnLock())
					Next										
				Else
			    	RecLock("ZLM", .T.)
						ZLM->ZLM_FILIAL := xFilial("ZLM")
						ZLM->ZLM_COD    := _cCod
						ZLM->ZLM_ITEM   := PadL(cValtoChar(nX),3,"0")
						ZLM->ZLM_DTMEDI := DtValid//StoD(MRD->MED_DTINI)+nX -1 //DTQ->DTQ_DATINI + nX - 1 
						ZLM->ZLM_FROTA  := _cFrota
						ZLM->ZLM_DESCEQ := _cDesEq
						ZLM->ZLM_HORAI  := ZBB->ZBB_HRINIT 
						ZLM->ZLM_HORAF  := ZBB->ZBB_HOFIMT 
						ZLM->ZLM_HORTOT := Val(ZBB->ZBB_MINDIT)
						ZLM->ZLM_QTDHR  := Val(ZBB->ZBB_MINDIT)
						ZLM->ZLM_BASE   := _cBase
						ZLM->ZLM_VALHOR := ZBB->ZBB_VALTUR  
						ZLM->ZLM_VLTOHR := (ZBB->ZBB_VALTUR*_PREDIA)/_nItens
						ZLM->ZLM_VLRMOB := IIf(nX==1,0/*_nVrMob*/,0)
						ZLM->ZLM_VLRDES := IIf(nX==1,0/*_nVrDes*/,0)
						ZLM->ZLM_TIPO   := _cTpSeg
						ZLM->ZLM_PERSEG := 0//_nPerSg
						ZLM->ZLM_VLBSEG := 0//_nVBasS
						ZLM->ZLM_VALSEG := 0//_nVrSeg
						ZLM->ZLM_TPISS  := _cTpISS 
						ZLM->ZLM_PERISS := _nPrISS
						//ZLM->ZLM_VALISS := ((_nVrISS / nLinMRD )/_nItens) //U_fCalcIssG( (_nVrToM / _nItens) ,_nPrISS,_cTpISS) //_nVrISS 
						//ZLM->ZLM_VALISS := (_nVTotH*_nPrISS/100) //U_fCalcIssG( (_nVrToM / _nItens) ,_nPrISS,_cTpISS) //_nVrISS 
						ZLM->ZLM_VALISS := (U_fCalcIssG( (_nVrToM / _nItens) ,_nPrISS,_cTpISS)/_nItens) //_nVrISS 
						ZLM->ZLM_VLRTOT := ((ZBB->ZBB_VALTUR*_PREDIA)/_nItens)+(U_fCalcIssG( (_nVrToM / _nItens) ,_nPrISS,_cTpISS)/_nItens)//(((_nVrToM + _nVrISS ) /  _nItens)/ nLinMRD )//IIf(ZA5->ZA5_TIPOCA == 'F',_nItens,_nVrToM / _nItens ) //Maickon 16-06-11 - Trazer valores ratiado para todos os itens
						//_nTOTMED := _nVrToM
						ZLM->ZLM_TRSPES := 0//_nTnsPs
						ZLM->ZLM_ANCORA := 0//_nAncor
						ZLM->ZLM_TELESC := _nTeles
						ZLM->ZLM_MONTAG := _Montag
						ZLM->ZLM_DESMON := _Desmon
						ZLM->ZLM_CODLCR := _cCdAnt
						ZLM->ZLM_QTDKM  := _nTotKM
						ZLM->ZLM_VENDA  := _cOriVn
						ZLM->ZLM_MAQUIN := _cFiMaq
						ZLM->ZLM_MAO    := _cFiMOr
						ZLM->ZLM_PERVND := _nPOVen
						ZLM->ZLM_PERMAQ := _nPrMaq
						ZLM->ZLM_VLVND  := _nVrOrV
						ZLM->ZLM_VLMAQ  := _nVrMaq
//						ZLM->ZLM_VLMAO  := _nVrMao
//						ZLM->ZLM_PERMAO := _nPrMao
						ZLM->ZLM_VLMAO  := _nVrMao//( ( (_nVTotH+ U_fCalcIssG(_nVTotH ,_nPrISS,_cTpISS)) *_nPorMa / 100)*_nPorMa / 100)
						ZLM->ZLM_PERMAO := _nPrMao
						ZLM->ZLM_LIBER  := "2"
						ZLM->ZLM_PERMO  := _nPorMa
						ZLM->ZLM_VLTOTM :=( _nVTotH *_nPorMa / 100)
					ZLM->(MsUnLock())
				EndIf
		    	ZBB->(DbSkip())
    		EndDo
        Else 
        	RecLock("ZLM", .T.)
				ZLM->ZLM_FILIAL := xFilial("ZLM")
				ZLM->ZLM_COD    := _cCod
				ZLM->ZLM_ITEM   := PadL(cValtoChar(nX),3,"0")
				ZLM->ZLM_DTMEDI := DtValid//StoD(MRD->MED_DTINI)+nX -1 //DTQ->DTQ_DATINI + nX - 1 
				ZLM->ZLM_FROTA  := _cFrota
				ZLM->ZLM_DESCEQ := _cDesEq
				ZLM->ZLM_HORAI  := _cHrIni 
				ZLM->ZLM_HORAF  := _cHrFim 
				ZLM->ZLM_HORTOT := _nHrTot    
				ZLM->ZLM_QTDHR  := IIf (ZA0->ZA0_TIPOSE == "P",_nHrTot2,_nHrTot)
				ZLM->ZLM_BASE   := _cBase
				ZLM->ZLM_VALHOR := _nVrHor  
				ZLM->ZLM_VLTOHR := _nVTotH
				ZLM->ZLM_VLRMOB := 0//IIf(nX==1,_nVrMob,0)//nao trazer mob e desmob para medicao
				ZLM->ZLM_VLRDES := 0//IIf(nX==1,_nVrDes,0)
				ZLM->ZLM_TIPO   := _cTpSeg
				ZLM->ZLM_PERSEG := 0//_nPerSg
				ZLM->ZLM_VLBSEG := 0//_nVBasS
				ZLM->ZLM_VALSEG := 0//_nVrSeg
				ZLM->ZLM_TPISS  := _cTpISS 
				ZLM->ZLM_PERISS := _nPrISS
				//ZLM->ZLM_VALISS := ((_nVrISS / nLinMRD )/_nItens) //U_fCalcIssG( (_nVrToM / _nItens) ,_nPrISS,_cTpISS) //_nVrISS 
				//ZLM->ZLM_VALISS := (_nVTotH*_nPrISS/100) //U_fCalcIssG( (_nVrToM / _nItens) ,_nPrISS,_cTpISS) //_nVrISS 
				ZLM->ZLM_VALISS :=  U_fCalcIssG(_nVTotH ,_nPrISS,_cTpISS) //((_nVrISS / nLinMRD )/_nItens) //U_fCalcIssG( (_nVrToM / _nItens) ,_nPrISS,_cTpISS) //_nVrISS 
				ZLM->ZLM_VLRTOT := (_nVTotH+ U_fCalcIssG(_nVTotH ,_nPrISS,_cTpISS))//(((_nValSer / nLinMRD )+ (_nVrISS /nLinMRD ))/_nItens) //(((_nVrToM + _nVrISS ) /  _nItens)/ nLinMRD )//IIf(ZA5->ZA5_TIPOCA == 'F',_nItens,_nVrToM / _nItens ) //Maickon 16-06-11 - Trazer valores ratiado para todos os itens
				//_nTOTMED := _nVrToM
				ZLM->ZLM_TRSPES := 0//_nTnsPs
				ZLM->ZLM_ANCORA := 0//_nAncor
				ZLM->ZLM_TELESC := _nTeles
				ZLM->ZLM_MONTAG := _Montag
				ZLM->ZLM_DESMON := _Desmon
				ZLM->ZLM_CODLCR := _cCdAnt
				ZLM->ZLM_QTDKM  := _nTotKM
				ZLM->ZLM_VENDA  := _cOriVn
				ZLM->ZLM_MAQUIN := _cFiMaq
				ZLM->ZLM_MAO    := _cFiMOr
				ZLM->ZLM_PERVND := _nPOVen
				ZLM->ZLM_PERMAQ := _nPrMaq
				ZLM->ZLM_VLVND  := _nVrOrV
				ZLM->ZLM_VLMAQ  := _nVrMaq
//				ZLM->ZLM_VLMAO  := _nVrMao
//				ZLM->ZLM_PERMAO := _nPrMao
				ZLM->ZLM_VLMAO  := _nVrMao//( (_nVTotH+ U_fCalcIssG(_nVTotH ,_nPrISS,_cTpISS)) *_nPorMa / 100)
				ZLM->ZLM_PERMAO := _nPrMao
				ZLM->ZLM_LIBER  := "2"                                                                
				ZLM->ZLM_PERMO  := _nPorMa
				ZLM->ZLM_VLTOTM :=( _nVTotH *_nPorMa / 100)
			ZLM->(MsUnLock())
        EndIf

    	dDtPar ++

	Next	  

	//MRD->(DbSkip())

Next//Enddo 
//MRD->(DbCloseArea())
Return
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �          �Autor  �M&S Consultoria     � Data �  30/06/07   ���
�������������������������������������������������������������������������͹��
���Desc.     �Funcao auxiliadora da CrItens que retorna quantos dias      ���
���          �existem entre as datas retirando os finais de semana e      ���
���          �feriados existentes na SX5. Utiliza DataValida.             ���
���          �                                                            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       �                                                            ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function NumberItens (_DtIni ,_DtFim )

Local dDtPar := _DtIni
Local nRet := 0
Local _nItens 	:= DateDiffDay(_DtIni,_DtFim)+1
 
For nX := 1 To _nItens
                       
	DtValid:= DataValida(dDtPar,.T.)//Posterga data
			
	If (DtValid > _DtFim) // Fim do Loop
   		nX:= _nItens +1
		Loop
	EndIf
			
	If DtValid <> dDtPar
		dDtPar:= DtValid
		nX++
	Endif   
						
   	dDtPar ++
    nRet += 1			
Next	  
		 
Return nRet


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �          �Autor  �M&S Consultoria     � Data �  30/06/07   ���
�������������������������������������������������������������������������͹��
���Desc.     �                                                            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/


User Function fRecProg(x_As,x_Cod,x_Tipo,x_Ini,x_Fim, x_Viagem)
/// Reavalia as programacoes de acordo com as alteracoes feitas no Cadastro de AS.
// By CJCAMPOS
// x_As  	- numero da AS
// x_Cod  	- codigo do produto
// x_Tipo 	- tipo de produto
// x_Ini 	- inicio da programacao negociada
// x_Fim 	- fim da programacao negociada
Local aArea    := GetArea()
Local nTempo   := x_Fim - x_Ini + 1 // Periodo da AS ( dias corridos )
Local lAlterou := .f.           // Houve alguma altera��o

/// Avalia a Existencia de Programa��es 
If U_fAvaProg(x_As,x_Cod,x_Tipo,x_Ini,x_Fim, x_Viagem)
	RestArea(aArea)
	Return .T.
Endif

lAlterou := .f.

If Select("ANTES") # 0 ; DbSelectArea("ANTES") ; DbCloseArea("ANTES") ; Endif

// Selecionando para Programacoes da AS para o mesmo produto da AS com status 1, R , 3
cQuery := " select ZLG_NRAS, ZLG_CODBEM, ZLG_PROJET, ZLG_OBRA, ZLG_VIAGEM, ZLG_NOMCLI,ZLG_STATUS,ZLG_DTINI,ZLG_DTFIM, R_E_C_N_O_  zlgrecno from " + RetSqlName('ZLG')
cQuery += " where D_E_L_E_T_ = '' "
cQuery += " and ZLG_FROTA = '" + x_Cod + "'"
cQuery += " and ZLG_CODBEM = ''"
cQuery += " and ZLG_NRAS = '" + x_As + "'"
cQuery += " and ZLG_STATUS IN ('1','3','R')"
//cQuery += " and (ZLG_DTINI between '" + DtoS(x_Ini) + "' and '" + DtoS(x_Fim) + "'"
//cQuery += " or   ZLG_DTFIM between '" + DtoS(x_Ini) + "' and '" + DtoS(x_Fim) + "'"
//cQuery += " or  (ZLG_DTINI <= '" + DtoS(x_Ini) + "' and ZLG_DTFIM >='" + DtoS(x_Fim) + "')"
//cQuery += " or  (ZLG_DTINI >= '" + DtoS(x_Ini) + "' and ZLG_DTFIM <='" + DtoS(x_Fim) + "'))"
cQuery += " order by ZLG_DTINI;"

DBUseArea(.T.,"TOPCONN", TCGenQry(,,cQuery),"ANTES", .F., .T.)
TCSetField("ANTES","ZLG_DTINI",   "D",8,0)
TCSetField("ANTES","ZLG_DTFIM",   "D",8,0)

// Tratamento Datas Inicial
DbSelectArea("ANTES")
Do while ! eof()
	If ANTES->ZLG_STATUS $ "1/3/R" // Se a programacao anterior estava como disponivel ou trabalhando ou reservado
		// e a programacao anterior esta abaixo da alteracao
		ZLG->( DbGoTo( ANTES->zlgrecno ) )
		RecLock("ZLG",.f.)
		// Data inicial da programacao anterior eh menor do que a data de inicio negociada atual
		ZLG->ZLG_DTINI  := x_Ini
		// Se a data final da programaco negociada eh menor que a da programacao anterior 
		ZLG->ZLG_DTFIM  := x_Fim // Nao fazer nada - dacour Lui
		// Se Status Anterior eh DISPONIVEL , mudo para RESERVADO
		ZLG->ZLG_STATUS := Iif(ANTES->ZLG_STATUS == "1","3"  , ZLG->ZLG_STATUS ) 
		MsUnLock()
	Endif
	DbSelectArea("ANTES")
	DbSkip()	
Enddo			

ANTES->(DbCloseArea())

If Select("ATUAL") # 0 ; DbSelectArea("ATUAL") ; DbCloseArea("ATUAL") ; Endif
// Selecionando para Programacoes de outras ASs para o mesmo produto da AS com Status tipo 9 , C - Manutencao
cQuery := " select ZLG_NRAS, ZLG_CODBEM, ZLG_PROJET, ZLG_OBRA, ZLG_VIAGEM, ZLG_NOMCLI,ZLG_STATUS,ZLG_DTINI,ZLG_DTFIM, R_E_C_N_O_  zlgrecno from " + RetSqlName('ZLG')
cQuery += " where D_E_L_E_T_ = '' "
cQuery += " and ZLG_FROTA = '" + x_Cod + "'"
cQuery += " and ZLG_CODBEM = ''"
cQuery += " and ZLG_NRAS <> '" + x_As + "'"
cQuery += " and ZLG_STATUS IN ('9','C')"
//cQuery += " and (ZLG_DTINI between '" + DtoS(x_Ini) + "' and '" + DtoS(x_Fim) + "'"
//cQuery += " or   ZLG_DTFIM between '" + DtoS(x_Ini) + "' and '" + DtoS(x_Fim) + "'"
//cQuery += " or  (ZLG_DTINI <= '" + DtoS(x_Ini) + "' and ZLG_DTFIM >='" + DtoS(x_Fim) + "')"
//cQuery += " or  (ZLG_DTINI >= '" + DtoS(x_Ini) + "' and ZLG_DTFIM <='" + DtoS(x_Fim) + "'))"
//cQuery += " order by ZLG_DTINI;"

DBUseArea(.T.,"TOPCONN", TCGenQry(,,cQuery),"ATUAL", .F., .T.)
TCSetField("ATUAL","ZLG_DTINI",   "D",8,0)
TCSetField("ATUAL","ZLG_DTFIM",   "D",8,0)

			
// Se data inicio negociada esta entre uma programacao de MANUTENCAO
DbSelectArea("ATUAL")
Do while ! Eof()
	If ATUAL->ZLG_STATUS $ "9/C"
		// Se Data inicial negociado esta entre as datas da MANUTENCAO e a data final negociada for superior a data fim da manutencao
		If ( ATUAL->ZLG_DTINI <= x_Ini .and. x_Ini <= ATUAL->ZLG_DTFIM ) .and. x_Fim > ATUAL->ZLG_DTFIM
			ZLG->( DbGoTo( ATUAL->zlgrecno ) )
			RecLock("ZLG",.f.)
			// Data inicial da programacao negociada passa a ser o dia posterior ao fim da manutencao
			ZLG->ZLG_DTINI  := Atual->ZLG_DTFIM + 1
			// Data final eh igual a nova data final mais o periodo total negociado
//			ZLG->ZLG_DTFIM  := Atual->ZLG_DTFIM + 1 + nTempo 
			// Se Status Anterior eh DISPONIVEL , mudo para RESERVADO
//			ZLG->ZLG_STATUS := Iif(ANTES->ZLG_STATUS == "1","3"  , ZLG->ZLG_STATUS ) 
			MsUnLock()
		Endif
		// Se Data final negociada esta entre as datas da MANUTENCAO e a data inicial for inferior a data inicial da manutencao
		If ( ATUAL->ZLG_DTINI >= x_Fim .and. x_Fim <= ATUAL->ZLG_DTFIM ) .and. x_Ini < ATUAL->ZLG_DTINI
			ZLG->( DbGoTo( ATUAL->zlgrecno ) )
			RecLock("ZLG",.f.)
			// Data inicial da programacao negociada passa a ser o dia posterior ao fim da manutencao
//			ZLG->ZLG_DTINI  := Atual->ZLG_DTFIM + 1
			// Data final eh igual a data inicial da manutencao - 1 (dia anterior)
			ZLG->ZLG_DTFIM  := Atual->ZLG_DTINI - 1
			// Se Status Anterior eh DISPONIVEL , mudo para RESERVADO
//			ZLG->ZLG_STATUS := Iif(ANTES->ZLG_STATUS == "1","3"  , ZLG->ZLG_STATUS ) 
			MsUnLock()
		Endif
		// Se o periodo de manutencao estiver entre o Inicio e Fim do Negociado
		If  ( x_Ini < Atual->ZLG_DTINI .and. Atual->ZLG_DTFIM < x_Fim)
			// Crio um registro anterior a manutencao 
			CriaZlg(.t.,x_Ini,Atual->ZLG_DTINI-1,"R")
			// Crio um registro posterior a manutencao
//			CriaZLg(.t.,Atual->ZLG_DTFIM+1,x_Fim + (Atual->ZLG_DTFIM - Atual->ZLG_DTINI + 1 ),"R")
			CriaZLg(.t.,Atual->ZLG_DTFIM+1,x_Fim,"R") // Termino no fim do contrato .
		Endif
	Endif
	DbSelectArea("ATUAL")
	DbSkip()
EndDo

DbCloseArea("ATUAL")

RestArea(aArea)

Return .F.


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �          �Autor  �M&S Consultoria     � Data �  30/06/07   ���
�������������������������������������������������������������������������͹��
���Desc.     �                                                            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

		
User Function fAvaProg(y_As,y_Cod,y_Tipo,y_Ini,y_Fim, x_Viagem)
/// Avalia as programacoes de acordo com as alteracoes feitas no Cadastro de AS.
// By CJCAMPOS
// y_As  	- numero da AS
// y_Cod  	- codigo do produto
// y_Tipo 	- tipo de produto
// y_Ini 	- inicio da programacao negociada
// y_Fim 	- fim da programacao negociada
Local aArea  := GetArea()

If Select("ATUAL") # 0 ; DbSelectArea("ATUAL") ; DbCloseArea("ATUAL") ; Endif
// Selecionando para Programacoes das outras ASs para o mesmo produto da AS com Status tipo 2/3/4/5/6/7/8/R 
cQuery := " select ZLG_NRAS,ZLG_NOMCLI,ZLG_STATUS,ZLG_DTINI,ZLG_DTFIM from " + RetSqlName('ZLG')
cQuery += " where D_E_L_E_T_ = '' "
cQuery += " and ZLG_FROTA = '" + y_Cod + "'"
cQuery += " and ZLG_CODBEM = ''"
cQuery += " and ZLG_NRAS <> '" + y_As + "'"
cQuery += " and ZLG_STATUS IN ('2','3','4','5','6','7','8','R')"
cQuery += " and (ZLG_DTINI between '" + DtoS(y_Ini) + "' and '" + DtoS(y_Fim) + "'"
cQuery += " or   ZLG_DTFIM between '" + DtoS(y_Ini) + "' and '" + DtoS(y_Fim) + "'"
cQuery += " or  (ZLG_DTINI <= '" + DtoS(y_Ini) + "' and ZLG_DTFIM >='" + DtoS(y_Fim) + "')"
cQuery += " or  (ZLG_DTINI >= '" + DtoS(y_Ini) + "' and ZLG_DTFIM <='" + DtoS(y_Fim) + "'))"
cQuery += " order by ZLG_DTINI;"

DBUseArea(.T.,"TOPCONN", TCGenQry(,,cQuery),"ATUAL", .F., .T.)
TCSetField("ATUAL","ZLG_DTINI",   "D",8,0)
TCSetField("ATUAL","ZLG_DTFIM",   "D",8,0)

lConflito := .F.
// Se Existir 
while ! EOF()
	lConflito := .T.
	cMsg := "J� existe programa��o para esta Frota ( " + y_Cod + " ) que n�o pertence a essa AS. para as datas entre "+DtoC(ATUAL->ZLG_DTINI)+" e "+DtoC(ATUAL->ZLG_DTFIM)
	MsgStop(cMsg, 'Conflito de Datas na Frota da '+y_AS)
	dbSkip()
EndDo

If lConflito 
	RestArea(aArea)
	Return .t.
Endif
     
If Select("ATUAL") # 0 ; DbSelectArea("ATUAL") ; DbCloseArea("ATUAL") ; Endif
// Selecionando para Programacoes da mesma AS para o mesmo produto da AS com Status tipo 2/4/5/6/7/8/R
cQuery := " select ZLG_NRAS,ZLG_NOMCLI,ZLG_STATUS,ZLG_DTINI,ZLG_DTFIM from " + RetSqlName('ZLG')
cQuery += " where D_E_L_E_T_ = '' "
cQuery += " and ZLG_FROTA = '" + y_Cod + "'"
cQuery += " and ZLG_CODBEM = ''"
cQuery += " and ZLG_NRAS = '" + y_As + "'"
cQuery += " and ZLG_STATUS IN ('2','4','5','6','7','8','R')"
cQuery += " and ZLG_VIAGEM <> '" + x_Viagem + "'"
cQuery += " and (ZLG_DTINI between '" + DtoS(y_Ini) + "' and '" + DtoS(y_Fim) + "'"
cQuery += " or   ZLG_DTFIM between '" + DtoS(y_Ini) + "' and '" + DtoS(y_Fim) + "'"
cQuery += " or  (ZLG_DTINI <= '" + DtoS(y_Ini) + "' and ZLG_DTFIM >='" + DtoS(y_Fim) + "')"
cQuery += " or  (ZLG_DTINI >= '" + DtoS(y_Ini) + "' and ZLG_DTFIM <='" + DtoS(y_Fim) + "'))"
cQuery += " order by ZLG_DTINI;"

DBUseArea(.T.,"TOPCONN", TCGenQry(,,cQuery),"ATUAL", .F., .T.)
TCSetField("ATUAL","ZLG_DTINI",   "D",8,0)
TCSetField("ATUAL","ZLG_DTFIM",   "D",8,0)

lConflito := .F.
// Se Existir 
while ! EOF()
	lConflito := .T.
	cMsg := "J� existe programa��o(�es) para esta Frota ( " + y_Cod + " ) que pertence(m) a essa AS, entre os dias : "+dtoC(ATUAL->ZLG_DTINI)+" e "+DtoC(ATUAL->ZLG_DTFIM)
	MsgStop(cMsg, 'Conflito de Datas na AS '+y_AS)
	dbSkip()
EndDo

ATUAL->(DbCloseArea())
RestArea(aArea)

Return lConflito
                


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �          �Autor  �M&S Consultoria     � Data �  30/06/07   ���
�������������������������������������������������������������������������͹��
���Desc.     �                                                            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function fDoZLG(cCodEqui)
////////////////////////////////////////
// Funcao gera programa��o de acordo com a estrutura do Equipamento x Acessorios ( rotativos ) - arquivo ZM2
// ETG11 - CJDDECAMPOS
// Definicao de Variaveis
Local aArea    := GetArea()  
Local cCodZlg, cCliente, cLoja, cNomCli
Local dDtIni 
Local dDtFim
Local cAs
Local cSot
Local cRev
Local cTpas
Local cObra
Local cViagem
Local cStatus
Local cCodEst
Local cTipAce
Local nSaldo , nQtEmp , nQtReq

// Arquivo de Programacoes
//DbSelectArea("ZLG")
//DbGoto(nPosEqui) // Ultimo registro adicionado "NORMAL"

cCodZlg  := ZLG->ZLG_FROTA
cCliente := ZLG->ZLG_CODCLI	
cLoja    := ZLG->ZLG_LOJA
cNomCli  := ZLG->ZLG_NOMCLI
dDtIni   := ZLG->ZLG_DTINI
dDtFim   := ZLG->ZLG_DTFIM
cAs      := ZLG->ZLG_NRAS
cSot     := ZLG->ZLG_PROJET		//		ZLG->ZLG_SOT  - CORRE��O CRISTIAM ROSSI EM 05/09/2011
cRev     := ZLG->ZLG_REVISA
//	cTpAs    := ZLG->ZLG_TPAS		// 		N�O EST� SENDO USADO E D� ERRO, POIS CAMPO N�O EXISTE - CRISTIAM ROSSI EM 05/09/2011
cObra    := ZLG->ZLG_OBRA 
cViagem  := ZLG->ZLG_VIAGEM 
cStatus  := ZLG->ZLG_STATUS
// Arquivo de Equipamentos x Frota

DbSelectArea("ZM2")
DbSetOrder(1)
DbSeek(xFilial("ZM2")+cCodEqui) // Pesquisa o Equipamento

While ZM2->(!Eof()) .and. cCodEqui == ZM2->ZM2_EQUIP // Lendo Estrutura 
	// Codigo de pesquisa no Estoque ( campo t9_codest )
	// cCodEst := Posicione("ST9",1,xFilial("ST9")+ZM2->ZM2_CODACE,"T9_CODEST") AJUSTE CJDECAMPOS 08/09/2011
	cCodEst := Posicione("ST9",1,xFilial("ST9")+ZM2->ZM2_CODACE,"T9_CODESTO")
	// tipo de acessorio - teoricamente a estrutura seria somente de "ROTATIVOS", mas se mudarem a estrutura antes de alimentar a programacao 
   //	cTipAce := Posicione("ST9",1,xFilial("ST9")+ZM2->ZM2_CODACE,"T9_ACESSOR")
	//		aSaldo  := CalcEst(cCodEst,"01",dDataBase)
	nSaldo  := POSICIONE("SB2",1,xFilial("SB2")+cCodEst,"B2_QATU")
	nQtEmp  := ZM2->ZM2_QUANT
	nQtReq  := Iif(nSaldo > 0,Iif(nSaldo < nQtEmp , nSaldo ,nQtEmp),0)//Iif(nSaldo > 0,Iif(nSaldo - nQtEmp >= 0 , nQtEmp , Iif(nQtEmp - nSaldo > 0 , nQtEmp - nSaldo, 0 )),0)
	
	If Empty(nQtReq) .OR. nQtReq == 0//.or. cTipAce # "R"
		//DbSelectArea("ZM2")
		ZM2->(DbSkip())
		Loop
	Endif
	
//	DbSelectArea("ZLG")
//	DbSetOrder(5)
//	DbSeek(xFilial("ZLG")+cCodZlg+Zm2->ZM2_CODACE)
	
//	If Eof()
	ZLG->(RECLOCK("ZLG", .T.))
		ZLG->ZLG_FILIAL	:= xFilial("ZLG")
		ZLG->ZLG_FROTA	:= cCodZlg
		ZLG->ZLG_CODCLI	:= cCliente 
		ZLG->ZLG_LOJA	:= cLoja  
		ZLG->ZLG_LOCAL	:= AllTrim(POSICIONE("SA1",1,xFilial("SA1")+cCodCli+cLojCli,"A1_NREDUZ"))+" / "+Alltrim(DTQ->DTQ_DESTIN)
		ZLG->ZLG_DESCAC := Posicione("ST9",1,xFilial("ST9")+ZM2->ZM2_CODACE,"T9_NOME")
		ZLG->ZLG_CODFAN := Posicione("ST9",1,xFilial("ST9")+ZM2->ZM2_CODACE,"T9_CODFA")
		ZLG->ZLG_NOMCLI	:= cNomCli
		ZLG->ZLG_DTINI	:= dDtIni
		ZLG->ZLG_DTFIM	:= dDtFim
		ZLG->ZLG_NRAS	:= cAs 
		ZLG->ZLG_PROJET	:= cSot
		ZLG->ZLG_REVISA	:= cRev 
		ZLG->ZLG_OBRA	:= cObra
		ZLG->ZLG_VIAGEM	:= cViagem 
		ZLG->ZLG_STATUS	:= 'R'
		ZLG->ZLG_CODBEM := ZM2->ZM2_CODACE
		ZLG->ZLG_QTACES := nQtReq
		ZLG->ZLG_COMPR  := ROUND(Val(SubStr('0'+Posicione("STB",1,xFilial("STB")+TRAB->T9_CODBEM+"000002","TB_DETALHE"),1,5)),2)
		ZLG->ZLG_LARGUR := ROUND(Val(SubStr('0'+Posicione("STB",1,xFilial("STB")+TRAB->T9_CODBEM+"000003","TB_DETALHE"),1,5)),2)
		ZLG->ZLG_ALTURA := ROUND(Val(SubStr('0'+Posicione("STB",1,xFilial("STB")+TRAB->T9_CODBEM+"000001","TB_DETALHE"),1,5)),2)
		ZLG->ZLG_PESO   := ROUND(Val(SubStr('0'+Posicione("STB",1,xFilial("STB")+TRAB->T9_CODBEM+"000004","TB_DETALHE"),1,5)),2)
	ZLG->(MsUnlock())
//	Endif
//	DbSelectArea("ZM2")
		
	ZM2->(DbSkip())
EndDo          

RestArea(aArea)

Return Nil



/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �PrgFrt111 �Autor  �M&S Consultoria     � Data �  30/06/07   ���
�������������������������������������������������������������������������͹��
���Desc.     �                                                            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       �                                                            ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function PrgFrt111()
Private oDlg
Private lOk     := .F.
Private dDtIni  := DTQ->DTQ_DTINI
Private dDtFim  := DTQ->DTQ_DTFIM
Private cHrIni  := DTQ->DTQ_HRINI
Private cHrFim  := DTQ->DTQ_HRFIM
Private cTpAma  := DTQ->DTQ_TIPAMA
Private cPacLis := DTQ->DTQ_PACLIS

	if  !Empty(DTQ->DTQ_DATFEC) .or. !Empty(DTQ->DTQ_DATENC) .or. !DTQ->DTQ_STATUS $ "16"
		MsgInfo("Opera��o cancelada. S� pode programar AS aberta","Programa��o de Frete")
		Return nil
	endif

	Define MsDialog oDlg Title "Programa��o de Frete" From C(230),C(359) To C(420),C(700) Pixel

	@ C(015),C(010) Say "Data Carregamento:" PIXEL OF oDlg
	@ C(022),C(010) GET dDtIni PIXEL OF oDlg
	@ C(015),C(070) Say "Hora Carregamento:" PIXEL OF oDlg
	@ C(022),C(070) GET cHrIni Picture "@R 99:99" Valid FValidHr(cHrIni) PIXEL OF oDlg

	@ C(040),C(010) Say "Data Descarregamento:" PIXEL OF oDlg
	@ C(047),C(010) MsGET dDtFim PIXEL OF oDlg
	@ C(040),C(070) Say "Hora Descarregamento:" PIXEL OF oDlg
	@ C(047),C(070) MsGET cHrFim Picture "@R 99:99" Valid FValidHr(cHrFim) PIXEL OF oDlg

	@ C(065),C(010) Say "Tipo Amarra��o:" PIXEL OF oDlg
	@ C(072),C(010) MsGET cTpAma Picture "XXXXXX" F3 "80" Valid ExistCpo("SX5","80"+cTpAma,1) PIXEL OF oDlg
	@ C(065),C(070) Say "N� da carreta:" PIXEL OF oDlg
	@ C(072),C(070) MsGET cPacLis Picture "@R 999" Valid ( cPacLis:=StrZero(Val(cPacLis),3), .T.,FvlCrt() ) PIXEL OF oDlg
	Activate MsDialog oDlg Centered On Init EnchoiceBar(oDlg, {|| lOk:= .t.,FValidCpos()}, {|| oDlg:End()} )

	if lOk 
		
		RecLock("DTQ",.F.)
			DTQ->DTQ_DTINI	:= dDtIni
			DTQ->DTQ_DTFIM	:= dDtFim
			DTQ->DTQ_HRINI	:= cHrIni
			DTQ->DTQ_HRFIM	:= cHrFim
			DTQ->DTQ_TIPAMA	:= cTpAma
			DTQ->DTQ_PACLIS	:= cPacLis
			DTQ->DTQ_DTPROG	:= dDatabase
			DTQ->DTQ_STATUS := '1'//Maickon Queiroz - 17/10/2011 - Voltar o Status da AS para aprova��o.	
		DTQ->(MsUnlock())

		cPara	:= SuperGetMV("LC_MAILFR",.F.,"loliveira@itup.com.br") 
		
		eFrom 	:= AllTrim(UsrRetName(__cUserID)) + " <" + AllTrim(UsrRetMail(__cUserID)) + ">" 
		
		cTitulo := "Referente a Programa��o da ASF n�mero " + DTQ->DTQ_AS + ", projeto " + AllTrim(DTQ->DTQ_SOT)

		cMsg	:= cTitulo + "<BR><BR>"
		cMsg	+= "Dados informados pelo usu�rio: " + UsrRetName(__cUserID) + "<BR><BR>"
		cMsg    += "Data Ini/Fim: "+DTOC(DTQ->DTQ_DATINI)+" - "+DTOC(DTQ->DTQ_DATINI)+", Obra: "+AllTrim(DTQ->DTQ_DESTIN)+", Cliente: "+AllTrim(DTQ->DTQ_NOMCLI)+"<BR><BR>" 
		cMsg	+= "<table><tr><th>Data Carregamento:</th><td>"+DtoC(dDtIni)+"</td></tr>"
		cMsg	+= "<tr><th>Hora Carregamento:       </th><td>"+substr(cHrIni,1,2)+":"+substr(cHrIni,3,2)     +"</td></tr>"
		cMsg	+= "<tr><th>Data Descarregamento:    </th><td>"+DtoC(dDtFim)+"</td></tr>"
		cMsg	+= "<tr><th>Hora Descarregamento:    </th><td>"+substr(cHrFim,1,2)+":"+substr(cHrFim,3,2)     +"</td></tr>"
		cMsg	+= "<tr><th>Tipo Amarra��o:          </th><td>"+cTpAma      +"</td></tr>"
		cMsg	+= "<tr><th>N� da carreta:           </th><td>"+cPacLis     +"</td></tr></table>"
		// ALTERACAO CJDECAMPOS 22/09/2011
		cAnexo := "ASfrete.pdf"  
		
		//U_Loci022(DTQ->DTQ_AS, cAnexo)
		
	    if __CopyFile(AllTrim(GetTempPath())+cAnexo, GetSrvProfString("Startpath","")+cAnexo)
	    	cAnexo := GetSrvProfString("Startpath","")+cAnexo
	    else
			cAnexo := ""
	    endif
		// FIM 22/09/2011
//		U_MandaEmail( eFrom, cPara , "", cTitulo, cMsg, nil, "")
		U_MandaEmail( eFrom, cPara , "", cTitulo, cMsg, cAnexo , "")

	endif 
	
Return Nil

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �FValidCpos�Autor  �M&S Consultoria     � Data �  30/06/07   ���
�������������������������������������������������������������������������͹��
���Desc.     � Fun��o para valida��o dos campos                           ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       �                                                            ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function FValidCpos()
Local lRet := .T.

	if dDtIni > dDtFim .or. (dDtIni == dDtFim .and. cHrIni > cHrFim)
		lRet := .F.
		MsgStop("A Data de Carregamento n�o pode ser maior que a Data de Descarregamento","Dados incorretos")
	else
		oDlg:End()
		lOk := .T.
	endif
Return lRet


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �FValidHr  �Autor  �M&S Consultoria     � Data �  30/06/07   ���
�������������������������������������������������������������������������͹��
���Desc.     � Fun��o para valida��o de horas HH:MM                       ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       �                                                            ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function FValidHr(cParam)
Local lRet := .T.

	if Left(cParam,2) > '23' .or. Right(Alltrim(cParam),2) > '59'
		MsgStop("O hor�rio deve ser entre 00:00 at� 23:59","Dado Inv�lido")
		lRet := .F.
	endif
Return lRet


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �FLOTE111  �Autor  �M&S Consultoria     � Data �  30/06/07   ���
�������������������������������������������������������������������������͹��
���Desc.     � Fun��o para tratar AS em lote                              ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       �                                                            ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function FLote111()
Local cACAO     := ""
Local oOk       := LoadBitmap( GetResources(), "LBOK" )
Local oNo   	:= LoadBitmap( GetResources(), "LBNO" )
Local aAreaDTQ  := DTQ->(GetArea())
Local cMsg      := ""
Local nI
Local lOk		:= .F.
Local lNprog    := .F.
Private aLinha  := {}
Private lTodos  := .F.
Private oLbx
Private oDlg

	DTQ->(dbGotop())
	While !DTQ->(EOF())
		//if Empty(DTQ->DTQ_DATFEC)	.and.	Empty(DTQ->DTQ_DATENC)	.and.	DTQ->DTQ_STATUS == "1"	.and.	!Empty(DTQ->DTQ_SOT)
		If DTQ->DTQ_DATINI	>=	mv_par01	.and.	DTQ->DTQ_DATINI	<=	mv_par02	.and.	DTQ->DTQ_TPAS	==	cServ	.and.	Empty(DTQ_TPCTRC)	.and.	DTQ->DTQ_STATUS == "1" .and. DTQ->DTQ_FILORI $ mv_par03 
			aadd(aLinha, { .F.            ,;
			               AllTrim(DTQ->DTQ_AS)    	,;
			               DTQ->DTQ_VIAGEM			,;
			               AllTrim(DTQ->DTQ_SOT)   	,;
			               AllTrim(DTQ->DTQ_ORIGEM)	,;
			               AllTrim(DTQ->DTQ_DESTIN)	,;
			               DTQ->(RECNO()) })
		EndIf
		DTQ->(dbSkip())
	End
	
	If Len(aLinha) == 0
		Alert("N�o h� AST's para serem aprovadas.")
		DTQ->(RestArea(aAreaDTQ))
		Return .T.
	EndIf

	DEFINE MSDIALOG oDlg FROM  000,000 TO 430,780 TITLE "Selecione as AST (Lote)" PIXEL

	@ 012,5 LISTBOX oLbx FIELDS HEADER " ", "N� AST","Viagem","Projeto","Origem" ,"Destino" SIZE 380,170 OF ODLG PIXEL ON DBLCLICK (MarcarREGI(.F.))
	oLbx:SetArray(aLinha)
	oLbx:bLine := {|| { if( aLinha[oLbx:nAt,1],oOk,oNo),; 	// CheckBOx
							aLinha[oLbx:nAt,2],; 			// N� AS
							aLinha[oLbx:nAt,3],;			// Viagem
							aLinha[oLbx:nAt,4],;			// Projeto
							aLinha[oLbx:nAt,5],;            // Destino
							aLinha[oLbx:nAt,6]}}            // Origem

	@ 195,5 CHECKBOX lTodos PROMPT "Marca/Desmarca Todos" SIZE 70, 10 OF ODLG PIXEL ON CLICK MarcarREGI(.T.)
	@ 195, 280 BUTTON "Aceitar"  SIZE 30,15 PIXEL OF oDlg ACTION (cACAO:="A", oDlg:End())
	@ 195, 320 BUTTON "Recusar"  SIZE 30,15 PIXEL OF oDlg ACTION (cACAO:="R", oDlg:End())
	@ 195, 360 BUTTON "Cancelar" SIZE 30,15 PIXEL OF oDlg ACTION (oDlg:End())

	ACTIVATE MSDIALOG ODLG CENTERED 

	if !Empty(cACAO)
		if cACAO == "R"
			lOk := .F.
			Define MsDialog _oDlgMail Title "Motivo da Rejei��o do Lote" From C(230),C(359) To C(400),C(882) Pixel	//de 610 para 400
			@ C(014),C(011) Say "Motivo:"   			Size C(030),C(008) PIXEL OF _oDlgMail
			@ C(015),C(042) GET oMsg Var cMsg MEMO 		Size C(210),C(065) PIXEL OF _oDlgMail
			Activate MsDialog _oDlgMail Centered On Init EnchoiceBar(_oDlgMail, {||lOk:=.T., _oDlgMail:End()}, {||_oDlgMail:End()} )
			if ! lOk
				DTQ->(RestArea(aAreaDTQ))
				Return .F.
			endif

			cMsg  := "MOTIVO: " + cMsg + CRLF + CRLF
		endif

		for nI:=1 to Len(aLinha)
			if aLinha[nI,1]		// Selecionado
				DTQ->(dbGoto( aLinha[nI,7] ))	// Recno
				if cACAO == "R"
					U_RejAS(cMsg)
				else
				
                    if ! lNprog .and. cServ=="F" .and. Empty(DTQ->DTQ_TIPAMA)
                    	lNprog := .T.
                    endif
                    
					if cServ!="F" .or. !Empty(DTQ->DTQ_TIPAMA)
						U_AceAS("LOTE")
					endif
					
				endif
			endif
		next
		
		if lNprog
			MsgInfo("Existem ASF sem programa��o, verifique","ASF n�o aceita")
		endif
	endif

	DTQ->(RestArea(aAreaDTQ))
Return .T.


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �MarcarREGI�Autor  �M&S Consultoria     � Data �  30/06/07   ���
�������������������������������������������������������������������������͹��
���Desc.     � Fun��o auxiliar do Listbox, serve para marcar e desmarcar  ���
���          � os itens                                                   ���
�������������������������������������������������������������������������͹��
���Uso       �                                                            ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function MarcarREGI(lTodos)
Local lMarcados := aLinha[oLbx:nAt,1]
Local lDesmarq  := .F.

	If lTodos
		lMarcados := ! lMarcados
		For nI := 1 to Len(aLinha)
//			DTQ->(dbGoto(aLinha[nI,7]))
//			if cServ=="F" .and. Empty(DTQ->DTQ_TIPAMA)
//				lDesmarq := .T.
//			else
				aLinha[nI,1] := lMarcados
//			endif
		Next

		if lDesmarq
			MsgAlert("AS n�o selecionadas faltam programa��o","Opera��o cancelada, Preencher Programa��o")
		endif
	Else
//		DTQ->(dbGoto(aLinha[oLbx:nAt,7]))
//		if cServ=="F" .and. Empty(DTQ->DTQ_TIPAMA)
//			MsgAlert("Voc� precisa preencher a programa��o da AS: "+DTQ->DTQ_AS,"Opera��o cancelada, Preencher Programa��o")
//		else
			aLinha[oLbx:nAt,1] := ! lMarcados
//		endif
	Endif

	oLbx:Refresh()
	oDlg:Refresh()
Return Nil


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � LGerPrg  �Autor  �M&S Consultoria     � Data �  30/06/07   ���
�������������������������������������������������������������������������͹��
���Desc.     � 05-10-2011 - Maickon Queiroz                               ���
���          �    Criado a Rotina Static Function para criar as           ���
���          �    programa��es de Acess�rios conforme especifica��es da   ���
���          �    ETG11.                                                  ���
���          �                                                            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       �                                                            ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/  
Static Function LGerPrg(lCZLG)

//If !Empty(DTQ->DTQ_ACEITE) .AND. !lCZLG //06-10-2011 - Maickon Queiroz -> Se o campo DTQ_ACEITE estiver preenchido a rotina n�o dever� ser executada
//	Return
//EndIf

If Select("TRAB") > 0
	TRAB->(dbCloseArea())
Endif


//Verifica se existe Acessorios padr�es conforme especificado no campo T9_ACESSOR				
cQuery := " Select T9_CODBEM, T9_NOME, T9_CODESTO"
cQuery += " From " + RetSqlName("ST9")
cQuery += " Where D_E_L_E_T_ <> '*' "
cQuery += " 	AND T9_FILIAL   = '" + xFilial("ST9") + "'"
cQuery += " 	AND T9_CODFA = '" + X_CodFa + "'"
cQuery += " 	AND T9_SITBEM <> 'I'"
cQuery += " 	AND T9_ACESSOR = 'P'"
cQuery += " Order By T9_CODBEM"

TcQuery cQuery New Alias "TRAB"

DbSelectArea("TRAB")
TRAB->(DbGoTop())

DbSelectArea("ZLG")
DbSetOrder(1)

While TRAB->(!Eof())

	nSaldo  := POSICIONE("SB2",1,xFilial("SB2")+TRAB->T9_CODESTO,"B2_QATU")
	
	If nSaldo <= 0
		TRAB->(DbSkip())
		Loop 	
	EndIf


	If Select("LTRB") > 0
		LTRB->(dbCloseArea())
	Endif
	
	//Verifica se existe Programa��o Dispon�vel para o Acess�rio 
	cQry:= " SELECT R_E_C_N_O_ RECNOZLG"
	cQry+= " FROM " + RetSqlName("ZLG")
	cQry+= " WHERE D_E_L_E_T_ = '' "
	cQry+= " 	And ZLG_STATUS = '1' "
	cQry+= " 	And ZLG_CODBEM = '"+TRAB->T9_CODBEM+"' "
	cQry+= " 	And (ZLG_DTINI Between '"+DTOS(DTQ->DTQ_DATINI)+"' and '"+DTOS(DTQ->DTQ_DATFIM)+" '"
	cQry+= " 	or   ZLG_DTFIM Between '"+DTOS(DTQ->DTQ_DATINI)+"' and '"+DTOS(DTQ->DTQ_DATFIM)+" '"
	cQry+= "    or   (ZLG_DTINI <= '" +DTOS(DTQ->DTQ_DATINI)+ "' and ZLG_DTFIM >='" +DTOS(DTQ->DTQ_DATFIM)+ "')"
	cQry+= "    or   (ZLG_DTINI >= '" +DTOS(DTQ->DTQ_DATINI)+ "' and ZLG_DTFIM <='" +DTOS(DTQ->DTQ_DATFIM)+ "') )"
	TcQuery cQry New Alias "LTRB"

	while ! LTRB->(EOF())
		ZLG->(dbGoto(LTRB->RECNOZLG))
		
		if DTQ->DTQ_DATINI <= ZLG->ZLG_DTINI .and. DTQ->DTQ_DATFIM >= ZLG->ZLG_DTFIM	// Prog Dispon�vel abrangida pela AS
			Reclock("ZLG",.F.)
				ZLG->(DbDelete())
			ZLG->(MsUnLock())
			
			LTRB->(dbSkip())
			Loop
		endif

		
		if ZLG->ZLG_DTINI <= DTQ->DTQ_DATINI .and. ZLG->ZLG_DTFIM >= DTQ->DTQ_DATFIM	// AS abrangida pela Prog Dispon�vel
			aRegOri := {}	// Carregar registros para duplica��o
			for nJ := 1 to ZLG->(FCount())
				aAdd(aRegOri, ZLG->(FieldGet(nJ)) )
			next

			Reclock("ZLG",.F.)	// Ajuste do registro de disponibilidade inicial
				ZLG->ZLG_DTFIM := DTQ->DTQ_DATINI - 1
			ZLG->(MsUnLock())
            /*
			Reclock("ZLG",.T.)	// gerando a linha duplicada para ajuste
				for nJ := 1 to ZLG->(FCount())
					ZLG->( FieldPut(nJ, aRegOri[nJ]) )
				next
				ZLG->ZLG_DTINI := DTQ->DTQ_DATFIM + 1	// ajuste da data final do registro de disponibilidade
			ZLG->(MsUnLock())  
			*/
		endif

		
		if DTQ->DTQ_DATINI <= ZLG->ZLG_DTINI .and. DTQ->DTQ_DATFIM >= ZLG->ZLG_DTINI .and. DTQ->DTQ_DATFIM <= ZLG->ZLG_DTFIM	// Prog Dispon�vel abrangida pela AS parcial, no in�cio
			Reclock("ZLG",.F.)
				ZLG->(DbDelete())//ZLG->ZLG_DTINI := DTQ->DTQ_DATFIM + 1	// ajuste da data final do registro de disponibilidade
			ZLG->(MsUnLock())
		endif

		
		if DTQ->DTQ_DATINI >= ZLG->ZLG_DTINI .and. DTQ->DTQ_DATINI <= ZLG->ZLG_DTFIM .and. DTQ->DTQ_DATFIM >= ZLG->ZLG_DTFIM	// Prog Dispon�vel abrangida pela AS parcial, no fim
			Reclock("ZLG",.F.)
			ZLG->ZLG_DTFIM := DTQ->DTQ_DATINI - 1	// ajuste da data final do registro de disponibilidade
			ZLG->(MsUnLock())
		endif

		LTRB->(dbSkip())
	end


	If Select("LTRB") > 0
		LTRB->(dbCloseArea())
	Endif
	
	//Verifica se existe Programa��o para o Acess�rio
	cQry:= " SELECT ZLG_FROTA , ZLG_STATUS, ZLG_DTINI, ZLG_DTFIM, R_E_C_N_O_ RECNOZLG"
	cQry+= " FROM " + RetSqlName("ZLG")
	cQry+= " WHERE D_E_L_E_T_ = '' "
	cQry+= " 	And ZLG_STATUS NOT IN ('A','S','E','1') "
	cQry+= " 	And ZLG_CODBEM = '"+TRAB->T9_CODBEM+"' "
	cQry+= " 	And ZLG_NRAS <> '' "
	cQry+= " 	And (ZLG_DTINI Between '"+DTOS(DTQ->DTQ_DATINI)+"' and '"+DTOS(DTQ->DTQ_DATFIM)+" '"
	cQry+= " 	or   ZLG_DTFIM Between '"+DTOS(DTQ->DTQ_DATINI)+"' and '"+DTOS(DTQ->DTQ_DATFIM)+" '"
	cQry+= "    or   (ZLG_DTINI <= '" +DTOS(DTQ->DTQ_DATINI)+ "' and ZLG_DTFIM >='" +DTOS(DTQ->DTQ_DATFIM)+ "')"
	cQry+= "    or   (ZLG_DTINI >= '" +DTOS(DTQ->DTQ_DATINI)+ "' and ZLG_DTFIM <='" +DTOS(DTQ->DTQ_DATFIM)+ "') )"
	TcQuery cQry New Alias "LTRB"

	DbSelectArea("LTRB")

//	If (LTRB->(EOF())) .or. LTRB->ZLG_STATUS == '1' //Se n�o existir Programa��o cria a programa�ao na tabela ZLG.
	If LTRB->(EOF())
//		If LTRB->ZLG_STATUS == '1' //Tratamento da data Encavalada com Status Disponivel.

// Colocado em coment�rio a pedido do Lui. Cristiam Rossi em 31/10/2011
/*			ZLG->(DbGoTop(RECNOZLG))
			Reclock("ZLG",.f.)
				ZLG->(DbDelete())
			ZLG->(MsUnLock())


			If LTRB->ZLG_DTINI >= DTOS(DTQ->DTQ_DATINI)
				If LTRB->ZLG_DTFIM <= DTOS(DTQ->DTQ_DATFIM) //Verifica se Exclui o Registro
					ZLG->(DbGoTo(RECNOZLG))
					Reclock("ZLG",.f.)
					ZLG->(DbDelete())
					ZLG->(MsUnLock())
				Else
					ZLG->(DbGoTo(LTRB->RECNOZLG))
					Reclock("ZLG",.f.)
					ZLG->ZLG_DTINI:= (DTQ->DTQ_DATFIM+1)
					ZLG->(MsUnLock())
				EndIf
			Else
				ZLG->(DbGoTo(LTRB->RECNOZLG))
				Reclock("ZLG",.f.)
				ZLG->ZLG_DTFIM:= (DTQ->DTQ_DATINI-1)
				ZLG->(MsUnLock())
			EndIf
		EndIf
*/
		ZLG->(RecLock('ZLG',.T.))
			ZLG->ZLG_FILIAL := xFilial('ZLG')
			ZLG->ZLG_FROTA  := cFrota
			ZLG->ZLG_CODCLI := cCodCli                                                              // Inclusao CJDECAMPOS 13/09/2011
			ZLG->ZLG_LOJA   := cLojCli                                                              // Inclusao CJDECAMPOS 13/09/2011
			ZLG->ZLG_NOMCLI := POSICIONE("SA1",1,xFilial("SA1")+cCodCli+cLojCli,"A1_NOME")         // Inclusao CJDECAMPOS 13/09/2011
			ZLG->ZLG_LOCAL	:= AllTrim(POSICIONE("SA1",1,xFilial("SA1")+cCodCli+cLojCli,"A1_NREDUZ"))+" / "+Alltrim(DTQ->DTQ_DESTIN) //
			ZLG->ZLG_NRAS   := DTQ->DTQ_AS
			ZLG->ZLG_CODBEM := TRAB->T9_CODBEM
			ZLG->ZLG_DESCAC := TRAB->T9_NOME
			ZLG->ZLG_DTINI  := DTQ->DTQ_DATINI
			ZLG->ZLG_DTFIM  := DTQ->DTQ_DATFIM
			ZLG->ZLG_PROJET := DTQ->DTQ_SOT			// NUMERO DO PROJETO
			ZLG->ZLG_OBRA   := DTQ->DTQ_OBRA
			ZLG->ZLG_VIAGEM := DTQ->DTQ_VIAGEM
			ZLG->ZLG_QTACES := 1								// ALTERARO CJDECAMPOS 13/09/2011
//			ZLG->ZLG_STATUS := '3'								// alterado CJDECAMPOS 13/09/2011
			ZLG->ZLG_STATUS := 'R'
			ZLG->ZLG_COMPR  := ROUND(Val(SubStr('0'+Posicione("STB",1,xFilial("STB")+TRAB->T9_CODBEM+"000002","TB_DETALHE"),1,5)),2)
			ZLG->ZLG_LARGUR := ROUND(Val(SubStr('0'+Posicione("STB",1,xFilial("STB")+TRAB->T9_CODBEM+"000003","TB_DETALHE"),1,5)),2)
			ZLG->ZLG_ALTURA := ROUND(Val(SubStr('0'+Posicione("STB",1,xFilial("STB")+TRAB->T9_CODBEM+"000001","TB_DETALHE"),1,5)),2)
			ZLG->ZLG_PESO   := ROUND(Val(SubStr('0'+Posicione("STB",1,xFilial("STB")+TRAB->T9_CODBEM+"000004","TB_DETALHE"),1,5)),2)
			ZLG->ZLG_CODFAN := ST9->T9_CODFA
		ZLG->(MsUnlock()) 
  	Else
  		ZLG->(dbGoto(LTRB->RECNOZLG))
//		MsgInfo("O Acess�rio "+TRAB->T9_CODBEM+" n�o foi programado pois j� existe programa��o entre "+cValtoChar(DTQ->DTQ_DATINI)+ " at� "+cValtoChar(DTQ->DTQ_DATFIM)," Acess�rio n�o Programado")
		xMsg := "O Acess�rio "+TRAB->T9_CODBEM+" n�o foi programado pois j� existe programa��o entre "+cValtoChar(DTQ->DTQ_DATINI)+ " at� "+cValtoChar(DTQ->DTQ_DATFIM)
		xMsg += ". AS: " + ZLG->ZLG_NRAS + " de: " + DtoC(ZLG->ZLG_DTINI) + " at�: " + DtoC(ZLG->ZLG_DTFIM)
		Aviso("Acess�rio n�o Programado", xMsg, {"Ok"},2)
	Endif

	TRAB->(DbSkip()) 

EndDo
//Chamada da Fun��o FDOZLG para cria��o dos acess�rios Rotativos
U_fDoZlg(cFrota)     

If Select("TRAB") > 0
	TRAB->(dbCloseArea())
Endif

Return             


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �LoaA      �Autor  �M&S Consultoria     � Data �  30/06/07   ���
�������������������������������������������������������������������������͹��
���Desc.     � Fun��o que ir� verificar se a existe Programa��o Di�ria    ���
���          � que encavala com a Frota referente a Data Inicial e Final. ���
���          �                                                            ���
���Paramentro� cFrota (Caracter)                                          ���
���          � dtIni  (Caracter) AAAAMMDD                                 ���
���          � dtFim  (Caracter) AAAAMMDD                                 ���
���          �                                                            ���
���          �                                                            ���
���Retorno   � Logico : .T. N�o existe Encavalamento de programa��o       ���
���          �          .F. Existe Encavalamento de Programa��o           ���
�������������������������������������������������������������������������͹��
���Uso       �                                                            ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function LocA(cFrota,cNrAs, dtIni,dtFim,cCodBem,xEXCLUSAO)
Local lRet        := .T.  
Local cProj	      := "Por favor verificar, a AS e/ou projeto abaixo: " + CRLF
Local cQry1, cQry2
Local aArea       := GetArea()		// Cristiam Rossi em 21/10/2014
Default cNrAs	  := Space(21)
Default cCodBem   := ''
Default xEXCLUSAO := "'A','E','S','9','C','9'"

	If Select("NFRO") > 0                     
		NFRO->(DbCloseArea())
	EndIf

	cQry1:= " Select DTQ_ACEITE, DTQ_AS "
	cQry1+= " From "+RetSqlName("DTQ")
	cQry1+= " WHERE D_E_L_E_T_ = '' "
	cQry1+= " 	AND DTQ_GUINDA = '"+cFrota+"'"
	cQry1+= " 	AND DTQ_AS = '"+cNrAs+"'"

	TcQuery cQry1 New Alias "NFRO"

	DbSelectArea("NFRO")

	If Select("LOAS") > 0
		LOAS->(DbCloseArea())
	EndIf

	cQry2:= " Select * "
	cQry2+= " From "+RetSqlName("ZLG")
	cQry2+= " WHERE D_E_L_E_T_ = '' "
//Data			: 30-03-2012
//Analista		: Maickon Queiroz 
//Ajuste		: Incluido condi��o cQry2+= " and ZLG_FILIAL = '"+xFilial("ZLG")+"' " para filtrar por filial
//Solicita��o	: Caue Buontempi Poltronieri (Referente ao Chamado aberto pelo CEC)
	cQry2+= " and ZLG_FILIAL = '"+xFilial("ZLG")+"' "
                       
	If Empty(NFRO->DTQ_AS)//Se nao tem AS
		cQry2+= " 	AND ZLG_STATUS NOT IN ('A','E','S') "
	Else
		If Empty(NFRO->DTQ_ACEITE)
			cQry2+= " 	AND ZLG_STATUS NOT IN ('A','E','S','C','9') "
		Else
			cQry2+= " 	AND ZLG_STATUS NOT IN ("+xEXCLUSAO+")"
			cQry2+= "   AND ZLG_NRAS <> '"+NFRO->DTQ_AS+"' "
		EndIf  
	EndIf

//cQry2+= "   AND ZLG_NRAS <> '"+NFRO->DTQ_AS+"' "

	If Empty(cCodBem)	
		cQry2+= " 	AND ZLG_FROTA = '"+cFrota+"' " 
		cQry2+= " 	AND ZLG_CODBEM = '' "
		If !Empty(cNrAs)//Se nao tem AS
			cQry2+= " 	AND ZLG_NRAS != '" + cNrAs + "' " 
		EndIf	
	Else
		cQry2+= " 	AND ZLG_CODBEM = '"+cCodBem+"' " 	
	EndIf

	cQry2 += " and (ZLG_DTINI between '" + dtIni + "' and '" + dtFim + "'"
	cQry2 += " or   ZLG_DTFIM between '" + dtIni + "' and '" + dtFim + "'"
	cQry2 += " or  (ZLG_DTINI <= '" + dtIni + "' and ZLG_DTFIM >='" + dtFim + "')"
	cQry2 += " or  (ZLG_DTINI >= '" + dtIni + "' and ZLG_DTFIM <='" + dtFim + "'))"

	TcQuery cQry2 New Alias "LOAS"

	DbSelectArea("LOAS")                      
	
	While LOAS->(!EOF())
		If LOAS->ZLG_STATUS <> '1'  
			//MsgAlert("Ocorreram conflito nas datas programadas para Frota: "+cFrota+" Datas:"+cValTochar(stod(dtIni))+" at� "+cValTochar(stod(dtFim))+". Por favor verificar, a AS:'" + LOAS->ZLG_NRAS + "', Projeto '" + LOAS->ZLG_PROJET + "'")
			cProj+= "AS:" + Alltrim(LOAS->ZLG_NRAS) + " - Projeto: " + Alltrim(LOAS->ZLG_PROJET) + CRLF
			lRet:= .F.
			//Return lRet
		EndIf
		LOAS->(DbSkip())
	Enddo 
  
	If !lRet
		MsgAlert("Ocorreram conflito nas datas programadas para Frota: "+cFrota+" Datas:"+cValTochar(stod(dtIni))+" at� "+cValTochar(stod(dtFim)) + ". " + CRLF + cProj) 
	Endif

	If Select("NFRO") > 0                     
		NFRO->(DbCloseArea())
	EndIf

	If Select("LOAS") > 0                     
		LOAS->(DbCloseArea())
	EndIf

	RestArea( aArea )			// Cristiam Rossi em 21/10/2014

Return lRet  


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �          �Autor  �M&S Consultoria     � Data �  30/06/07   ���
�������������������������������������������������������������������������͹��
���Desc.     �                                                            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function FvlCrt

Local cQuery:= ''
Local lRet	:= .t. 
Local cViaOri := ''    

//Verifica a PACKLIST poder� ser utilizada
If Select ("TMP") > 0
	TMP->(DbCloseArea())
EndIf

cQuery+= " Select * "
cQuery+= " From "+RetSqlName("ZLW")+" ZLW "
cQuery+= " 	Inner Join ZLG010 ZLG ON ZLG.D_E_L_E_T_ = '' "
cQuery+= " 		AND ZLG_VIAGEM = ZLW_VIAORI "
cQuery+= " Where ZLW.D_E_L_E_T_ = '' "
cQuery+= " 	AND ZLW_VIAGEM = '"+DTQ->DTQ_VIAGEM+"' "

TcQuery cQuery New Alias "TMP"
DbSelectArea("TMP")	
cViaOri:= TMP->ZLW_VIAORI
If TMP->(EOF())
	lRet:= .f.
Else
	While TMP->(!EOF()) 
		If cPacLis = TMP->ZLG_CARRET
			lRet := .T.
			Exit
		EndIf          
		lRet:= .f.
		TMP->(DbSkip())
	EndDo 
EndIf
If !lRet
	MsgInfo("PackList n�o mencionado na Programa��o, Verifique","Aten��o")
	lRet := .F.
EndIf       

//Verifica se a PACKLIST foi utilizada em outra 

If Select ("TMP") > 0
	TMP->(DbCloseArea())
EndIf

cQuery:= " SELECT Count(*) cNReg "
cQuery+= " FROM "+RetSqlName("ZLW")+" ZLW  "
cQuery+= " 	Inner Join DTQ010 DTQ on DTQ.D_E_L_E_T_ = '' AND DTQ_VIAGEM = ZLW_VIAGEM "
cQuery+= " WHERE ZLW.D_E_L_E_T_ = '' "
cQuery+= " 	AND ZLW_VIAORI = '"+cViaOri+"' "
cQuery+= " 	AND DTQ_PACLIS = '"+cPacLis+"' "

TcQuery cQuery New Alias "TMP"         

DbSelectArea("TMP")
While TMP->(!EOF())
	If TMP->cNReg > 0 
		//MsgInfo("PackList j� programada para outra carreta, Verifique","Aten��o")
		//lRet:= .F.
	EndIf
	TMP->(DbSkip())
Enddo

Return lRet


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �             tor  �M&S Consultoria     � Data �  30/06/07   ���
�������������������������������������������������������������������������͹��
���Desc.     �                                                            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function Locq111(cFrota,cNrAs, dtIni,dtFim,cCodBem)  

Local lRet := .f.

If Select("LOFRO2") > 0
	LOFRO2->(DbCloseArea())
Endif 
					
cQry2:= " Select Count(*) Conta "
cQry2+= " From "+RetSqlName("ZLG")
cQry2+= " WHERE D_E_L_E_T_ = '' "             
//cQry2+= " 	AND ZLG_STATUS NOT IN ('A','E','S') "
cQry2+= " 	AND ZLG_FROTA = '"+cFrota+"' " 
cQry2+= " 	AND ZLG_CODBEM = '' " 
cQry2 += " and (ZLG_DTINI between '" + (dtIni) + "' and '" + (dtFim) + "'"
cQry2 += " or   ZLG_DTFIM between '" + (dtIni) + "' and '" + (dtFim) + "'"
cQry2 += " or  (ZLG_DTINI <= '" + (dtIni) + "' and ZLG_DTFIM >='" + (dtFim) + "')"
cQry2 += " or  (ZLG_DTINI >= '" + (dtIni) + "' and ZLG_DTFIM <='" + (dtFim) + "'))"

TcQuery cQry2 New Alias "LOFRO2"

DbSelectArea("LOFRO2") 

If LOFRO2->Conta > 0
	lRet := .t.
EndIf
 
Return lRet

Static Function ValidAS(cProj,cObra,cJunto)
	Local aArea		:= GetArea()
	Local aAreaDTQ	:= DTQ->(GetArea())
	Local lRet		:= .T.
	
	DbSelectArea("DTQ")
	DbSetOrder(8)
	If DbSeek(xFilial("DTQ")+cProj+cObra)
		While !DTQ->(Eof()) .And. AllTrim(DTQ->DTQ_SOT) == AllTrim(cProj) .And. AllTrim(DTQ->DTQ_OBRA) == AllTrim(cObra) .And. AllTrim(DTQ->DTQ_SEQCAR) == AllTrim(cJunto)
			If !Empty(DTQ->DTQ_JUNTO)
				DTQ->(DbSkip())
				Loop			
			EndIf 	
	  			
			If Empty(DTQ->DTQ_DATFEC) .And.  Empty(DTQ->DTQ_DATENC) .And. DTQ->DTQ_STATUS == "1" //Em Aberto
				lRet := .F.
				Exit							
			EndIf
			
			If !Empty(DTQ->DTQ_DATENC) .and. !Empty(DTQ->DTQ_DATENC) .and. DTQ->DTQ_STATUS == "1" //encerrado
				lRet := .F.
				Exit							
			EndIf
			
			If !DTQ->DTQ_STATUS $ "1/6" //rejeitado
				lRet := .F.
				Exit							
			EndIf                                                                                            
			
			DTQ->(DbSkip())
		EndDo
		If !lRet          
			MsgAlert("N�o � possivel aceitar a AS, pois a AS pai '"+DTQ->DTQ_AS+"' n�o foi aceita.","Aten��o")
		EndIf	
	EndIf
	
	RestArea(aArea)
	RestArea(aAreaDTQ)
Return(lRet)

Static Function xMotorista(dDtIni,dDtFim,cAs,cNomCli,cSot,cObra,cViagem,lRevis,cSeqCar)
	Local cCod	:= Space(6)
	Local lRet	:= .F.
    
    DEFINE MSDIALOG oDlgUser TITLE "Motorista" FROM 000,000 TO 120,300 PIXEL OF oMainWnd
	
	@ 010,010 SAY "Informe o c�digo do motorista para gera��o da frota." OF oDlgUser PIXEL 		
	@ 030,010 MSGET cCod F3 "DA4" SIZE 80,010 OF oDlgUser PIXEL
	@ 030,100 BUTTON "Confirmar" SIZE 35,14 PIXEL OF oDlgUser Action (Processa({|| Iif(Empty(cCod),MsgAlert("Informe o motorista.","Aten��o!"),(GeraFrota(cCod,dDtIni,dDtFim,cAs,cNomCli,cSot,cObra,cViagem,lRevis,cSeqCar),lRet:=.T.)) }))
			
	ACTIVATE MSDIALOG oDlgUser CENTERED                        
	
Return(lRet)

Static Function GeraFrota(cCod,dDtIni,dDtFim,cAs,cNomCli,cSot,cObra,cViagem,lRevis,cSeqCar)
    Local aArea		:= GetArea()
	Local aAreaDA4	:= DA4->(GetArea())
	Local aAreaZLO	:= ZLO->(GetArea())
	Local aAreaST9	:= ST9->(GetArea())
	Local aAreaZAE	:= ZAE->(GetArea())
	Local aAreaZLE	:= ZLE->(GetArea())
	Local aAreaZA6	:= ZA6->(GetArea())
	Local lExit		:= .F.
	Local dDataIni	:= dDtIni
	Local aDelet	:= {}
	Local aInsert	:= {}      
	Local cFrota	:= ""    
	Local cNomMot	:= "" 
	Local lPula		:= .F.   
	
	
    DbSelectArea("DA4")
    DbSetOrder(1)
    If DbSeek(xFilial("DA4")+cCod) .And. !Empty(cCod)
    
    	cNomMot := DA4->DA4_NOME
    	
    	DbSelectArea("ZB2")
      DbSetOrder(1)
      DbSeek(xFilial("ZB2")+cViagem)
      While !ZB2->(Eof()) .And. ZB2->ZB2_VIAGEM == cViagem
      	RecLock("ZB2",.F.)
         ZB2->ZB2_NOMMOT := cNomMot                 
         MsUnlock()  
      	ZB2->(DbSkip())
      EndDo
      
      //cNomMot := ""
        If !Empty(DA4->DA4_MAT)
        	cNomMot := DA4->DA4_NOME
        	
	        If !lRevis
		        While !lExit
	        		If DTOS(dDataIni) > DTOS(dDtFim)	
	        			lExit := .T.    
	        			Loop
	        		EndIf
	        		
	        		DbSelectArea("ZLO")
	        		DbSetOrder(1)
	        		If DbSeek(xFilial("ZLO")+DA4->DA4_MAT+DTOS(dDataIni))
		        		While !ZLO->(Eof()) .And. AllTrim(ZLO->ZLO_MAT) == AllTrim(DA4->DA4_MAT) .And. DTOS(dDataIni) == DTOS(ZLO->ZLO_DATA)
							If AllTrim(ZLO->ZLO_TIPINC) == "M"
								ZLO->(DbSkip())
								Loop
							EndIf
							
							Aadd(aDelet, ZLO->(Recno()) )
							
							Aadd(aInsert,{DA4->DA4_MAT,dDataIni,cAs,cNomCli,cSot,cObra})					
							
							dDataIni++	           
							ZLO->(DbSkip())			
		        		EndDo	
	        		Else
		        		
		        		RecLock("ZLO",.T.)
						ZLO->ZLO_FILIAL := xFilial("ZLO")
						ZLO->ZLO_MAT 	:= DA4->DA4_MAT
						ZLO->ZLO_DATA 	:= dDataIni
						ZLO->ZLO_AGENDA := "2"
						ZLO->ZLO_STATUS := "OBRA"
						ZLO->ZLO_AS 	:= cAs
						ZLO->ZLO_DESC 	:= cNomCli
						ZLO->ZLO_PROJET := cSot
						ZLO->ZLO_OBRA 	:= cObra
						ZLO->ZLO_FILMAT := xFilial("ZLO")
						ZLO->ZLO_TIPINC := "A"
						MsUnlock()
					
					EndIf
	        			
	   			   		dDataIni++ 
	    		EndDo
	        				
	    	    	
		        If Len(aDelet) > 0
		        	For nX := 1 To Len(aDelet)
		        		DbSelectArea("ZLO")
				    	DbGoTo(aDelet[nX])
					    While !RecLock("ZLO",.F.)
					    EndDo
						DbDelete()
					    MsUnLock()			    
		        	Next nX
		        EndIf
		        
		        If Len(aInsert) > 0
		        	For nX := 1 To Len(aInsert)
		        		DbSelectArea("ZLO")
		        		//Aadd(aInsert,{DA4->DA4_MAT,dDtIni,cAs,cNomCli,cSot,cObra})
						RecLock("ZLO",.T.)
						ZLO->ZLO_FILIAL := xFilial("ZLO")
						ZLO->ZLO_MAT 	:= aInsert[nX,1]
						ZLO->ZLO_DATA 	:= aInsert[nX,2]
						ZLO->ZLO_AGENDA := "2"
						ZLO->ZLO_STATUS := "OBRA"
						ZLO->ZLO_AS 	:= aInsert[nX,3]
						ZLO->ZLO_DESC 	:= aInsert[nX,4]
						ZLO->ZLO_PROJET := aInsert[nX,5]
						ZLO->ZLO_OBRA 	:= aInsert[nX,6]
						ZLO->ZLO_FILMAT := xFilial("ZLO")
						ZLO->ZLO_TIPINC := "A"
						MsUnlock()            
		        	Next nX
		        EndIf 
		    Else
		    	ValidZLO(cAs,cNomCli,cSot,cObra,dDtIni,dDtFim)	
		    EndIf
	    EndIf
    EndIf
    
    ST9->(DbSetOrder(1))
 //	ZA6->(DbSetOrder(1))
	ZAE->(DbSetOrder(1))
	ZLE->(DbSetOrder(1)) // ZLE_FILIAL+ ANOMES + ZLE_FROTA+ ZLE_DTPROG
    
    //POSICIONAR NA ZAE APARTIR DA DTQ OBRA PROJETO E SEQCAR E GERR CORRETAMENTE A ZLE
    
    If ZA0->ZA0_TIPOSE == "G"//se o projeto for de equipamento.
		DbSelectArea("ZA5")
	    DbSetOrder(3)
	    If DbSeek(xFilial("ZA5")+DTQ->DTQ_AS+DTQ->DTQ_VIAGEM)		
	
			DbSelectArea("ZLE")
		    DbSetOrder(5)
		    DbSeek(xFilial("ZLE")+ZA5->ZA5_GUINDA)
		    
		    cFrota := ZA5->ZA5_GUINDA  
		    
		    ST9->(DBSEEK(XFILIAL("ST9")+cFrota))
			
			If lRevis // Se for aceita de AS pela 2� vez
				DeleteZLE(dDtIni,dDtFim,cCod,cNomMot,cFrota,ST9->T9_NOME)
			
			Else
	
				FOR dDia := dDtIni to dDtFim
					ZLE->(MsSeek(XFILIAL("ZLE")+SUBS(DTOS( dDia ),1,6) + cFrota + DTOS( dDia ))) 
					
					If ZLE->(Found()) 
						If ZLE->ZLE_STATUS $ "8|9|M" //Pular 8,9,M
							lPula := .T.						
						EndIf			 
					EndIf
					
					If !lPula
						ZLE->(RECLOCK("ZLE", !ZLE->(Found())))
			
						ZLE->ZLE_FILIAL	:= XFILIAL("ZLE")
						ZLE->ZLE_ANOMES := LEFT( DTOS( dDia ) , 6 )
						ZLE->ZLE_DTPROG := dDia
						ZLE->ZLE_DIASEM := diasemana(dDia)
						ZLE->ZLE_FROTA  := cFrota
						ZLE->ZLE_CODBEM := ""
						ZLE->ZLE_DESCRI := ST9->T9_NOME
						ZLE->ZLE_AS     := cAs//DTQ->DTQ_AS
						ZLE->ZLE_PROJET := cSot//DTQ->DTQ_SOT  // NUMERO DO PROJETO
						ZLE->ZLE_OBRA   := cObra//DTQ->DTQ_OBRA
						ZLE->ZLE_VIAGEM := cViagem//DTQ->DTQ_VIAGEM 
						ZLE->ZLE_TIPO   := "T"//DTQ->DTQ_TPAS
						ZLE->ZLE_STATUS := "R"    
						ZLE->ZLE_HORA	:= Time()
						ZLE->ZLE_CODMOT	:= cCod
						ZLE->ZLE_NOMMOT	:= cNomMot
						ZLE->(MsUnlock()) 
					EndIf
					lPula := .F.		 
				Next
			EndIf
        EndIf
    Else
	    DbSelectArea("ZAE")
	    DbSetOrder(1)//Projet+Obra+SeqTra+SeqCar
	    DbSeek(xFilial("ZAE")+cSot+cObra+cObra+cSeqCar)
	    
	    While !ZAE->(Eof()) .And. AllTrim(ZAE->ZAE_FILIAL+ZAE->ZAE_PROJET+ZAE->ZAE_OBRA+ZAE->ZAE_SEQTRA+ZAE->ZAE_SEQCAR) == AllTrim(xFilial("ZAE")+cSot+cObra+cObra+cSeqCar)
	    	
	    	cFrota := iif(!EMPTY(ZAE->ZAE_TRALOC), ZAE->ZAE_TRALOC, ZAE->ZAE_TRANSP)
	
			If Empty(cFrota) .or. !ST9->(DBSEEK(XFILIAL("ST9")+cFrota))
				ZAE->(dbSkip())
				Loop
			EndIf
	            
			If lRevis // Se for aceita de AS pela 2� vez
				DeleteZLE(dDtIni,dDtFim,cCod,cNomMot,cFrota,ST9->T9_NOME)
			
			Else
	
				FOR dDia := dDtIni to dDtFim
					ZLE->(MsSeek(XFILIAL("ZLE")+SUBS(DTOS( dDia ),1,6) + cFrota + DTOS( dDia ))) 
					
					If ZLE->(Found()) 
						If ZLE->ZLE_STATUS $ "8|9|M" //Pular 8,9,M
							lPula := .T.						
						EndIf			 
					EndIf
					
					If !lPula
						ZLE->(RECLOCK("ZLE", !ZLE->(Found())))
			
						ZLE->ZLE_FILIAL	:= XFILIAL("ZLE")
						ZLE->ZLE_ANOMES := LEFT( DTOS( dDia ) , 6 )
						ZLE->ZLE_DTPROG := dDia
						ZLE->ZLE_DIASEM := diasemana(dDia)
						ZLE->ZLE_FROTA  := cFrota
						ZLE->ZLE_CODBEM := ""
						ZLE->ZLE_DESCRI := ST9->T9_NOME
						ZLE->ZLE_AS     := cAs//DTQ->DTQ_AS
						ZLE->ZLE_PROJET := cSot//DTQ->DTQ_SOT  // NUMERO DO PROJETO
						ZLE->ZLE_OBRA   := cObra//DTQ->DTQ_OBRA
						ZLE->ZLE_VIAGEM := cViagem//DTQ->DTQ_VIAGEM 
						ZLE->ZLE_TIPO   := "T"//DTQ->DTQ_TPAS
						ZLE->ZLE_STATUS := "R"    
						ZLE->ZLE_HORA	:= Time()
						ZLE->ZLE_CODMOT	:= cCod
						ZLE->ZLE_NOMMOT	:= cNomMot
						ZLE->(MsUnlock()) 
					EndIf
					lPula := .F.		 
				Next
			EndIf
	
			ZAE->(DBSKIP())	
	    EndDo 
	EndIf
    
	 
//	ZA6->(DbSeek(SM0->M0_CODFIL+cProjet+cObra))
    /*DbSelectarea("ZA6")
    DbSetOrder(1)
    //DbSeek(SM0->M0_CODFIL+cProjet+cObra)
    DbSeek(xFilial("ZA6")+cSot+cObra)

	While ZA6->(!Eof()) .And. AllTrim(ZA6->ZA6_FILIAL+ZA6->ZA6_PROJET+ZA6->ZA6_OBRA) == AllTrim(xFilial("ZA6")+cSot+cObra)

		ZAE->(DBSEEK( XFILIAL("ZAE")+ZA6->ZA6_PROJET+ZA6->ZA6_OBRA+ZA6->ZA6_SEQTRA, .F. ))
		DO WHILE !ZAE->(EOF()) .AND. ( ZAE->ZAE_FILIAL+ZAE->ZAE_PROJET+ZAE->ZAE_OBRA+ZAE->ZAE_SEQTRA == XFILIAL("ZAE")+ZA6->ZA6_PROJET+ZA6->ZA6_OBRA+ZA6->ZA6_SEQTRA )

			cFrota := iif(!EMPTY(ZAE->ZAE_TRALOC), ZAE->ZAE_TRALOC, ZAE->ZAE_TRANSP)

			If Empty(cFrota) .or. !ST9->(DBSEEK(XFILIAL("ST9")+cFrota))
				ZAE->(dbSkip())
				Loop
			EndIf
            
			If lRevis // Se for aceita de AS pela 2� vez
				DeleteZLE(ZA6->ZA6_DTINI,ZA6->ZA6_DTFIM,cCod,cNomMot,cFrota,ST9->T9_NOME)
			
			Else

				FOR dDia := ZA6->ZA6_DTINI to ZA6->ZA6_DTFIM
					ZLE->(MsSeek(XFILIAL("ZLE")+SUBS(DTOS( dDia ),1,6) + cFrota + DTOS( dDia )))
					ZLE->(RECLOCK("ZLE", !ZLE->(Found())))
	
					ZLE->ZLE_FILIAL	:= XFILIAL("ZLE")
					ZLE->ZLE_ANOMES := LEFT( DTOS( dDia ) , 6 )
					ZLE->ZLE_DTPROG := dDia
					ZLE->ZLE_DIASEM := diasemana(dDia)
					ZLE->ZLE_FROTA  := cFrota
					ZLE->ZLE_CODBEM := ""
					ZLE->ZLE_DESCRI := ST9->T9_NOME
					ZLE->ZLE_AS     := cAs//DTQ->DTQ_AS
					ZLE->ZLE_PROJET := cSot//DTQ->DTQ_SOT  // NUMERO DO PROJETO
					ZLE->ZLE_OBRA   := cObra//DTQ->DTQ_OBRA
					ZLE->ZLE_VIAGEM := cViagem//DTQ->DTQ_VIAGEM 
					ZLE->ZLE_TIPO   := "T"//DTQ->DTQ_TPAS
					ZLE->ZLE_STATUS := "R"    
					ZLE->ZLE_HORA	:= Time()
					ZLE->ZLE_CODMOT	:= cCod
					ZLE->ZLE_NOMMOT	:= cNomMot
					ZLE->(MsUnlock())					 
				Next
			EndIf
	
			ZAE->(DBSKIP())
		ENDDO 
	
		ZA6->(dbSkip())
	EndDo*/
	
	oDlgUser:end()//Fecha Dialog
    
    RestArea(aArea)
	RestArea(aAreaDA4)
	RestArea(aAreaZLO)
	RestArea(aAreaST9)
	RestArea(aAreaZAE)
	RestArea(aAreaZLE)
	RestArea(aAreaZA6)
Return                                                        

Static Function DeleteZLE(dDtIni,dDtFim,cCod,cNomMot,cFrota,cT9Nome)
	Local aArea		:= GetArea()
	Local aAreaZLE	:= ZLE->(GetArea())
	Local aZleAnt	:= {}
	Local aDelet	:= {}
	Local aInsert	:= {}
	
	DbSelectArea("ZLE")
	DbSetOrder(6)
	DbSeek(xFilial("ZLE")+DTQ->DTQ_SOT+DTQ->DTQ_OBRA+DTQ->DTQ_VIAGEM)
	    
	While !ZLE->(Eof()) .And. AllTrim(ZLE->ZLE_PROJET+ZLE->ZLE_OBRA+ZLE->ZLE_VIAGEM) == AllTrim(DTQ->DTQ_SOT+DTQ->DTQ_OBRA+DTQ->DTQ_VIAGEM)
		If AllTrim(ZLE->ZLE_FROTA) != AllTrim(cFrota)
			ZLE->(DbSkip())	
			Loop
		EndIf
				
		If DTOS(ZLE->ZLE_DTPROG) < DTOS(DTQ->DTQ_DATINI) .Or. DTOS(ZLE->ZLE_DTPROG) > DTOS(DTQ->DTQ_DATFIM)
    		If AllTrim(ZLE->ZLE_STATUS) $ "R/3/1/4/5/2/7/6"
				Aadd(aDelet, ZLE->(Recno()))           
			EndIf
		Else
	   		//Aadd(aZleAnt,{DTOS(ZLE->ZLE_DTPROG),ZLE->ZLE_STATUS,ZLE->(Recno())})	 
		EndIf				
		
   		ZLE->(DbSkip())
	EndDo
	
	For dDia := dDtIni to dDtFim
		DbSelectArea("ZLE")
		DbSetOrder(1)
		If DbSeek(xFilial("ZLE")+SUBS(DTOS( dDia ),1,6)+cFrota+DTOS( dDia ))
			If ZLE->ZLE_STATUS $ "1" //Pular 8,9,M
				Aadd(aDelet,ZLE->(Recno()))
				Aadd(aInsert,{dDia})
			EndIf 
		Else
		 	Aadd(aInsert,{dDia})
		EndIf
		
		/*nPos := ASCAN(aZleAnt,{|x| x[1] == DTOS(dDia)})	
		If nPos > 0
			If aZleAnt[nPos,2] $ "1" 
				Aadd(aDelet,aZleAnt[nPos,3])
				Aadd(aInsert,{dDia})
			EndIf
		Else
			Aadd(aInsert,{dDia})	
		EndIf*/
	Next dDia
	
	For nX := 1 To Len(aDelet)
		DbSelectArea("ZLE")
    	DbGoTo(aDelet[nX])
	    While !RecLock("ZLE",.F.)
	    EndDo
		DbDelete()
	    MsUnLock()			    
	Next nX  
	
	For nX := 1 To Len(aInsert)
		ZLE->(RECLOCK("ZLE", .T.))
	
		ZLE->ZLE_FILIAL	:= XFILIAL("ZLE")
		ZLE->ZLE_ANOMES := LEFT( DTOS( aInsert[nX,1] ) , 6 )
		ZLE->ZLE_DTPROG := aInsert[nX,1]
		ZLE->ZLE_DIASEM := diasemana(aInsert[nX,1])
		ZLE->ZLE_FROTA  := cFrota
		ZLE->ZLE_CODBEM := ""
		ZLE->ZLE_DESCRI := cT9Nome
		ZLE->ZLE_AS     := DTQ->DTQ_AS
		ZLE->ZLE_PROJET := DTQ->DTQ_SOT  // NUMERO DO PROJETO
		ZLE->ZLE_OBRA   := DTQ->DTQ_OBRA
		ZLE->ZLE_VIAGEM := DTQ->DTQ_VIAGEM 
		ZLE->ZLE_TIPO   := "T"//DTQ->DTQ_TPAS
		ZLE->ZLE_STATUS := "R"    
		ZLE->ZLE_HORA	:= Time()
		ZLE->ZLE_CODMOT	:= cCod
		ZLE->ZLE_NOMMOT	:= cNomMot
		ZLE->(MsUnlock())					 	
	Next nX  
	
    RestArea(aArea)
	RestArea(aAreaZLE)
Return


//Grava todos os ZLE e ou ZLO num array ... depois roda o novo periodo e compara com o perido do array(anterior), e faz a valida��o
Static Function ValidZLO(cAs,cNomCli,cSot,cObra,dDtIni,dDtFim)
	Local aArea		:= GetArea()
	Local aAreaZLO	:= ZLO->(GetArea())
	Local aZlo		:= {}
	Local aDelet	:= {}
	Local aInsert	:= {}
	Local cMat		:= ""

	DbSelectArea("ZLO")
 	DbSetOrder(3)
    DbSeek(xFilial("ZLO")+cSot+cObra)
	cMat := DA4->DA4_MAT
	While !ZLO->(Eof()) .And. AllTrim(ZLO->ZLO_PROJET+ZLO->ZLO_OBRA) == AllTrim(cSot+cObra)
		If AllTrim(DA4->DA4_MAT) != AllTrim(cMat)
        	ZLO->(DbSkip())
        	Loop			
        EndIf                
        
        If AllTrim(ZLO->ZLO_TIPINC) == "M"
			ZLO->(DbSkip())
			Loop
		EndIf                 
		
		If DTOS(ZLO->ZLO_DATA) < DTOS(dDtIni) .Or. DTOS(ZLO->ZLO_DATA) > DTOS(dDtFim)
			Aadd(aDelet,ZLO->(Recno()))
		Else
		//	Aadd(aZlo,{DTOS(ZLO->ZLO_DATA),ZLO->(Recno())})
		EndIf
        
		ZLO->(DbSkip())
	EndDo 
	
	For dDia := dDtIni To dDtFim
		DbSelectArea("ZLO")
  		DbSetOrder(1)
        If DbSeek(xFilial("ZLO")+DA4->DA4_MAT+DTOS(dDia))
			If AllTrim(ZLO->ZLO_TIPINC) == "M"
				ZLO->(DbSkip())
				Loop
			EndIf
		    
			Aadd(aDelet,ZLO->(Recno()))
			Aadd(aInsert,{dDia})
		Else
			Aadd(aInsert,{dDia})
		EndIf
		
		
		/*nPos := ASCAN(aZlo,{|x| x[1] == DTOS(dDia)})	
		If nPos > 0
			Aadd(aDelet,aZlo[nPos,2])
			Aadd(aInsert,{dDia})
		Else
			Aadd(aInsert,{dDia})	
		EndIf*/
	Next dDia      
	
	If Len(aDelet) > 0
	   	For nX := 1 To Len(aDelet)
	      	DbSelectArea("ZLO")
	    	DbGoTo(aDelet[nX])
		    While !RecLock("ZLO",.F.)
		    EndDo
			DbDelete()
		    MsUnLock()			    
  		Next nX
    EndIf
        
 	If Len(aInsert) > 0
      	For nX := 1 To Len(aInsert)
     		DbSelectArea("ZLO")
        		//Aadd(aInsert,{DA4->DA4_MAT,dDtIni,cAs,cNomCli,cSot,cObra})
			RecLock("ZLO",.T.)
			ZLO->ZLO_FILIAL := xFilial("ZLO")
			ZLO->ZLO_MAT 	:= cMat
			ZLO->ZLO_DATA 	:= aInsert[nX,1]
			ZLO->ZLO_AGENDA := "2"
			ZLO->ZLO_STATUS := "OBRA"
			ZLO->ZLO_AS 	:= cAs
			ZLO->ZLO_DESC 	:= cNomCli
			ZLO->ZLO_PROJET := cSot
			ZLO->ZLO_OBRA 	:= cObra
			ZLO->ZLO_FILMAT := xFilial("ZLO")
			ZLO->ZLO_TIPINC := "A"
			MsUnlock()            
       	Next nX
	EndIf
        
	/*DbSelectArea("DA4")
    DbSetOrder(1)
    If DbSeek(xFilial("DA4")+cCod)
        If !Empty(DA4->DA4_MAT)
        	cNomMot := DA4->DA4_NOME
        	While !lExit
        		If DTOS(dDataIni) > DTOS(dDtFim)	
        			lExit := .T.    
        			Loop
        		EndIf
        		
        		DbSelectArea("ZLO")
        		DbSetOrder(1)
        		DbSeek(xFilial("ZLO")+DA4->DA4_MAT)
        		
        		While !ZLO->(Eof()) 
        			If AllTrim(ZLO->ZLO_PROJET+ZLO->ZLO_OBRA) == AllTrim(DTQ->DTQ_PROJET+DTQ->DTQ_OBRA)
        			
        			EndIf
        		
        			ZLO->(DbSkip())
        		EndDo
        		
	        		While !ZLO->(Eof()) .And. AllTrim(ZLO->ZLO_MAT) == AllTrim(DA4->DA4_MAT) .And. DTOS(dDataIni) == DTOS(ZLO->ZLO_DATA)
						If AllTrim(ZLO->ZLO_TIPINC) == "M"
							ZLO->(DbSkip())
							Loop
						EndIf
						
						Aadd(aDelet, ZLO->(Recno()) )
						
						Aadd(aInsert,{DA4->DA4_MAT,dDataIni,cAs,cNomCli,cSot,cObra})					
						
						dDataIni++	           
						ZLO->(DbSkip())			
	        		EndDo	
        		Else
	        		
	        		RecLock("ZLO",.T.)
					ZLO->ZLO_FILIAL := xFilial("ZLO")
					ZLO->ZLO_MAT 	:= cCod
					ZLO->ZLO_DATA 	:= dDataIni
					ZLO->ZLO_AGENDA := "2"
					ZLO->ZLO_STATUS := "OBRA"
					ZLO->ZLO_AS 	:= cAs
					ZLO->ZLO_DESC 	:= cNomCli
					ZLO->ZLO_PROJET := cSot
					ZLO->ZLO_OBRA 	:= cObra
					ZLO->ZLO_FILMAT := xFilial("ZLO")
					ZLO->ZLO_TIPINC := "A"
					MsUnlock()
				
				EndIf
        			
        		dDataIni++ 
        	EndDo
        				
        EndIf    	
        If Len(aDelet) > 0
        	For nX := 1 To Len(aDelet)
        		DbSelectArea("ZLO")
		    	DbGoTo(aDelet[nX])
			    While !RecLock("ZLO",.F.)
			    EndDo
				DbDelete()
			    MsUnLock()			    
        	Next nX
        EndIf
        
        If Len(aInsert) > 0
        	For nX := 1 To Len(aInsert)
        		DbSelectArea("ZLO")
        		//Aadd(aInsert,{DA4->DA4_MAT,dDtIni,cAs,cNomCli,cSot,cObra})
				RecLock("ZLO",.T.)
				ZLO->ZLO_FILIAL := xFilial("ZLO")
				ZLO->ZLO_MAT 	:= aInsert[nX,1]
				ZLO->ZLO_DATA 	:= aInsert[nX,2]
				ZLO->ZLO_AGENDA := "2"
				ZLO->ZLO_STATUS := "OBRA"
				ZLO->ZLO_AS 	:= aInsert[nX,3]
				ZLO->ZLO_DESC 	:= aInsert[nX,4]
				ZLO->ZLO_PROJET := aInsert[nX,5]
				ZLO->ZLO_OBRA 	:= aInsert[nX,6]
				ZLO->ZLO_FILMAT := xFilial("ZLO")
				ZLO->ZLO_TIPINC := "A"
				MsUnlock()            
        	Next nX
        EndIf
    EndIf*/
    
    RestArea(aArea)
	RestArea(aAreaZLO)
Return
                          
//Troca equipamento.
User Function L111TREQ()
	Local aArea     := GetArea()         
	Local aAreaZA0	:= ZA0->(GetArea())
	Local aAreaZA5	:= ZA5->(GetArea())         
	Local aItens	:= {}
	Local oDlgT		:= Nil                                       
	Local oLbx1     := Nil
	Local aCab		:= {}
	Local aAlterCpo := {"EQUIPNV"}
	Local aColsCP1  := {}
	Local aFieldFill:= {}                   
	Local nOpc		:= 0
	Local lOk := .F.
	Local nItem := 1  
	
	If !(Empty(DTQ->DTQ_DATFEC) .and.  Empty(DTQ->DTQ_DATENC) .and. DTQ->DTQ_STATUS == "1")
		MsgAlert("S� � permitido trocar equipamento de AS 'Em Aberto'.","Aten��o")
		Return
	EndIf
	
	Aadd(aCab, { "Item" , ;
			  "ITEM"             , ;
			  "@!"                 , ; 
			  02                   , ;
			  00                   , ;
			  ""                   , ;
	          "??????????????�"    , ;
    	      "C"                  , ;
	          "   "                , ;
    	      "R"                  , ;
        	  " "                  , ;
	          " " })
	
	Aadd(aCab, { "Equip. Atual" , ;
			  "EQUIPAT"             , ;
			  "@!"                 , ; 
			  16                   , ;
			  00                   , ;
			  ""                   , ;
	          "??????????????�"    , ;
    	      "C"                  , ;
	          "   "                , ;
    	      "R"                  , ;
        	  " "                  , ;
	          " " })
	          
	Aadd(aCab, { "Novo Equip." , ;
			  "EQUIPNV"             , ;
			  "@!"                 , ; 
			  16                   , ;
			  00                   , ;
			  "ExistCpo('ST9',M->EQUIPNV)"                   , ;
	          "??????????????�"    , ;
    	      "C"                  , ;
	          "ST9"                , ;
    	      "R"                  , ;
        	  " "                  , ;
	          " " })        
	          
	DbSelectArea("ZA0")
	DbSetOrder(1)
	DbSeek(xFilial("ZA0")+DTQ->DTQ_SOT)
	                 
	If ZA0->ZA0_TIPOSE == "G"
		DbSelectArea("ZA5")
		DbSetOrder(2)//Projet+obra+as+viagem
		DbSeek(xFilial("ZA5")+DTQ->(DTQ_SOT+DTQ_OBRA+DTQ_AS+DTQ_VIAGEM)) 
		
		While !ZA5->(Eof()) .And. ZA5->(ZA5_FILIAL+ZA5_PROJET+ZA5_OBRA+ZA5_AS+ZA5_VIAGEM) == xFilial("ZA5")+DTQ->(DTQ_SOT+DTQ_OBRA+DTQ_AS+DTQ_VIAGEM)
		                  
			aAdd(aItens,{StrZero(nItem,2),ZA5->ZA5_GUINDA,SPACE(16),ZA5->(Recno())})
		    
		    nItem++ 
			ZA5->(DbSkip())
		EndDo
	ElseIf ZA0->ZA0_TIPOSE == "T"  
		DbSelectArea("ZA7")
		DbSetOrder(2)
		DbSeek(xFilial("ZA7")+DTQ->(DTQ_SOT+DTQ_OBRA+DTQ_VIAGEM))		
	
		DbSelectArea("ZAE")
		DbSetOrder(1)
		DbSeek(xFilial("ZAE")+ZA7->(ZA7_PROJET+ZA7_OBRA+ZA7_SEQTRA+ZA7_SEQCAR))
		
		While !ZAE->(Eof()) .And. ZAE->(ZAE_FILIAL+ZAE_PROJET+ZAE_OBRA+ZAE_SEQTRA+ZAE_SEQCAR) == xFilial("ZAE")+ZA7->(ZA7_PROJET+ZA7_OBRA+ZA7_SEQTRA+ZA7_SEQCAR) 
		    aAdd(aItens,{StrZero(nItem,2),ZAE->ZAE_TRANSP,SPACE(16),ZAE->(Recno())})
		    nItem++ 
			ZAE->(DbSkip())
		EndDo
	EndIf
  	
  	//Alimenta o Acols
  	For nX := 1 To Len(aItens)
   		aFieldFill := {}           
   		For nY := 1 To Len(aItens[nX])
			Aadd(aFieldFill, aItens[nX,nY])
		Next nY

		Aadd(aFieldFill, .F.)
		
		Aadd(aColsCP1, aFieldFill)		   
   	Next nX	 
   		 
                                                    
  	DEFINE MSDIALOG oDlgT FROM 0,0 TO 285,510 PIXEL TITLE 'Equipamento'
	
	//oLbx1 := TWBrowse():New( 05 , 01, 242, 100,,aCab,, oDlgT, ,,,,{||},,,,,,,.F.,,.T.,,.F.,,, )  
	
	nW := (oDlgT:nClientWidth/2)
	nH := (oDlgT:nClientHeight/2)-25	
	
	oLbx1 := MsNewGetDados():New( 05 , 01, 120, nW, GD_UPDATE, "AllwaysTrue", "AllwaysTrue", "+", aAlterCpo,, 999, "AllwaysTrue", "", "AllwaysTrue", oDlgT, aCab, aColsCP1)
	//oLbx2 := MsNewGetDados():New( 05 , 01, 105, nW-05, GD_UPDATE, "AllwaysTrue", "AllwaysTrue", "+", aAlterCpo,, 999, "AllwaysTrue", "", "AllwaysTrue", oTFolder:aDialogs[2],  aCabEmp, aColsCP2)
	
	oTBrowseButton := TBrowseButton():New( 130,215,'Ok',oDlgT  , {|| Iif(ValidTrocaEq(oLbx1:aCols),(lOk := .T., oDlgT:End()),lOk := .F.)},37,12,,,.F.,.T.,.F.,,.F.,,,)  
	           
	/*oLbx1:SetArray(aItens)                               
	oLbx1:bLine := {|| {aItens[oLbx1:nAt,1],;
	                    aItens[oLbx1:nAt,2],;
	                    aItens[oLbx1:nAt,3]}}
	
	oLbx1:Refresh()                          */
	//oLbx1:blDblClick := {|| IIF(oLbx1:ColPos == 1,aItens[oLbx1:nAt,1] := !aItens[oLbx1:nAt,1],)}
	
	//Activate MsDialog oDlgT ON INIT (EnchoiceBar(oDlgT,{||lOk:=.T.,oDlgT:End()},{||oDlgT:End()}))

	ACTIVATE MSDIALOG oDlgT CENTERED

	If lOk 
		//GravaSB2(oLbx1:aCols)
		GravaTroca(oLbx1:aCols,ZA0->ZA0_TIPOSE)
	EndIf
  	
   	RestArea(aAreaZA5)
   	RestArea(aAreaZA0)   
	RestArea(aArea)
Return   
                           
//Valida se as siglas s�o iguais, conforme email do Lui
Static Function ValidTrocaEq(aTroca)
	Local cEquiAtu  := ""
	Local cEquiNov	:= ""
	Local lRet		:= .T.
	
	/*For nX := 1 To Len(aTroca)
		cEquiAtu := SubStr(aTroca[nX,2],1,3)+SubStr(aTroca[nX,2],6,3)
		cEquiNov := SubStr(aTroca[nX,3],1,3)+SubStr(aTroca[nX,3],6,3)
		
		DbSelectArea("ST9")
	 	DbSetOrder(1)
	    If !DbSeek(xFilial("ST9")+aTroca[nX,3]) 
	    	MsgAlert("Item: "+aTroca[nX,1]+" - O Recurso selecionado ("+AllTrim(aTroca[nX,3])+") � inv�lido.","Aten��o!")
			lRet := .F.
			Exit	                                                                                                     
	    EndIf
		
		If (cEquiAtu <> cEquiNov) .And. lRet
			MsgAlert("Item: "+aTroca[nX,1]+" - O Recurso selecionado ("+AllTrim(aTroca[nX,3])+"), n�o tem o mesmo tipo ou configura��o do que foi vendido ("+AllTrim(aTroca[nX,2])+").","Aten��o!")
			lRet := .F.
			Exit
		EndIf 
		
	Next nX*/ 
	
	For nX := 1 To Len(aTroca)
		       
		If Empty(aTroca[nX,3])
			MsgAlert("Novo equipamento n�o foi selecinado.","Aten��o!")
			lRet := .F.
			Exit
		EndIf
	Next nX
Return(lRet)
                                 
//Grava a troca para T ou G
Static Function GravaTroca(aTroca,cTipo)
	Local aArea		:= GetArea()
	Local aAreaZA5  := ZA5->(GetArea())  
	Local aAreaZLG  := ZLG->(GetArea())
	Local aAreaST9  := ST9->(GetArea())
	Local aAreaDTQ  := DTQ->(GetArea())
                               
    If cTipo == "G"
	    For nX := 1 To Len(aTroca)
	    	DbSelectArea("ST9")
	    	DbSetOrder(1)
	    	DbSeek(xFilial("ST9")+aTroca[nX,3])
	      
			DbSelectArea("ZA5")
			DbGoTo(aTroca[nX,4])
			Reclock("ZA5",.F.)
			ZA5->ZA5_GUINDA := aTroca[nX,3]
			ZA5->ZA5_DESGUI := ST9->T9_NOME
			MsUnlock()
			
			DbSelectArea("ZB2")
			DbSetOrder(1)//Viagem   
			If DbSeek(xFilial("ZB2")+DTQ->DTQ_VIAGEM)
				RecLock("ZB2",.F.)
				If nX == 1
					ZB2->ZB2_PLACA	 := ST9->T9_PLACA    
				Else
					ZB2->ZB2_VEICUL := ST9->T9_PLACA        
				EndIf				
			   MsUnlock()
			EndIf
			
			DbSelectArea("ZLG")
			DbSetOrder(4)//Projet+Obra+As+Viagem
			If DbSeek(xFilial("ZLG")+DTQ->(DTQ_SOT+DTQ_OBRA+DTQ_AS+DTQ_VIAGEM))
				Reclock("ZLG",.F.)
				ZLG->ZLG_FROTA := aTroca[nX,3]
				MsUnlock() 
			EndIf    
			
			DbSelectArea("DTQ")
			RecLock("DTQ", .F.)
			DTQ->DTQ_GUINDA := aTroca[nX,3]	
			MsUnlock()  
		Next nX
	Else
		DeletZLE()
		For nX := 1 To Len(aTroca)
	    	DbSelectArea("ST9")
	    	DbSetOrder(1)
	    	DbSeek(xFilial("ST9")+aTroca[nX,3])
	      
			DbSelectArea("ZAE")
			DbGoTo(aTroca[nX,4])
			Reclock("ZAE",.F.)
			ZAE->ZAE_TRANSP := aTroca[nX,3]
			ZAE->ZAE_DESTRA := ST9->T9_NOME
			MsUnlock()                      
			
			DbSelectArea("ZB2")
			DbSetOrder(1)//Viagem   
			If DbSeek(xFilial("ZB2")+DTQ->DTQ_VIAGEM) 
				RecLock("ZB2",.F.)
				If nX == 1
					ZB2->ZB2_PLACA	 := ST9->T9_PLACA    
				Else
					ZB2->ZB2_VEICUL := ST9->T9_PLACA       
				EndIf				
			   MsUnlock()
			EndIf       
			            
			If nX == 1
				DbSelectArea("DTQ")
				RecLock("DTQ", .F.)
				DTQ->DTQ_EQUIP := aTroca[nX,3]	
				MsUnlock() 
			EndIf 
		Next nX
	EndIf
	
	MsgInfo("Troca de equipamento efetuada com sucesso.","Sucesso!")       
	
	RestArea(aAreaDTQ)
	RestArea(aAreaST9)
	RestArea(aAreaZLG)
	RestArea(aAreaZA5)
	RestArea(aArea)
Return          

//Deleta ZLE antes de trocar o equipamento.
Static Function DeletZLE(cFrota)
    Local aArea		:= GetArea()
    Local aAreaZLE	:= ZLE->(GetArea())         
      
	DbSelectArea("ZLE")
    DbSetOrder(4)//As+Frota
    DbSeek(xFilial("ZLE")+DTQ->(DTQ_AS+DTQ_VIAGEM))
    
    While !ZLE->(Eof()) .And. ZLE->(ZLE_FILIAL+ZLE_AS+ZLE_VIAGEM) == xFilial("ZLE")+DTQ->(DTQ_AS+DTQ_VIAGEM)
    	While !RecLock("ZLE",.F.)
	    EndDo
    	DbDelete()
	    MsUnLock()
	    ZLE->(DbSkip())		
    EndDo
    
    RestArea(aAreaZLE)
	RestArea(aArea)
Return   

/*���������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �  FilST9  �Autor  � Claudio Miranda    � Data �  09/15/05   ���
�������������������������������������������������������������������������͹��
���Desc.     �Executa filtro do Controle de Acesso e Restricao na Consulta���
���          �SXB                                                         ���
�������������������������������������������������������������������������͹��
���Uso       �Generico                                                    ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
���������������������������������������������������������������������������*/ 
User Function FilST9() 

Local lRet			:= .F.
Static cCondicao 

If cCondicao == Nil 
	cCondicao	:= &( " { || " + ChkRH( FUNNAME() , ALIAS() , IF(ISINCALLSTACK("SETPRINT"), "2", "1") ) + " } " ) 
EndIf 

lRet := Eval( cCondicao )

Return(if(  Valtype(lRet) =="U" ,.T. , lRet ))
