#Include "aArray.ch"
#Include "jSon.ch"
#Include "Protheus.ch"
#Include "ApWebSrv.ch"

#Define nSAIORI 01
#Define nENTALV 02
#Define nSAIALV 03
#Define nLOGIST 04
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �RGEFM04   �Autor  � Vin�cius Moreira   � Data � 20/10/2014  ���
�������������������������������������������������������������������������͹��
���Desc.     � WS de integra��o com a Buonny.                             ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       �                                                            ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
WSSTRUCT request
	WSDATA sm	As integer  			//-- String de entrada dos metodos que processa XML.
	WSDATA latitude	As float  			//-- String de entrada dos metodos que processa XML.
	WSDATA longitude	As float  		//-- String de entrada dos metodos que processa XML.
	WSDATA evento	As String  			//-- String de entrada dos metodos que processa XML.
	WSDATA codigo_externo	As String  	//-- String de entrada dos metodos que processa XML.
	WSDATA alvo	As String  				//-- String de entrada dos metodos que processa XML.
	WSDATA data_hora	As String  		//-- String de entrada dos metodos que processa XML.
ENDWSSTRUCT 

WSSTRUCT result
	WSDATA sucesso	As integer  		//-- String de entrada dos metodos que processa XML.
	WSDATA erro	As String  				//-- String de entrada dos metodos que processa XML.
ENDWSSTRUCT 

WsService RGEFM04 Description "Integra��o Buonny"

WSDATA evento as request
WSDATA evento_result as result

WsMethod ReceberEvento Description "Receber eventos Buonny."

EndWsService
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �ReceberEventos�Autor� Vin�cius Moreira � Data �  10/20/14   ���
�������������������������������������������������������������������������͹��
���Desc.     � Recebe os eventos da Buonny.                               ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       �                                                            ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
WsMethod ReceberEvento WSReceive evento WSSend evento_result WsService RGEFM04

Local lTudoOk   := .F.
Local cMsgErr   := ""
Local dDatEve   := cToD("//")
Local cHorEve   := ""

Conout("//--  RGEFM04 - Inicio - Recebendo informa��es --//")
Conout("SM            - " + cValToChar(::evento:sm) )
Conout("Latitude      - " + cValToChar(::evento:latitude) )
Conout("Longitude     - " + cValToChar(::evento:longitude) )
Conout("Evento        - " + ::evento:evento )
Conout("Cod.Externo   - " + ::evento:codigo_externo )
Conout("Alvo          - " + ::evento:alvo )
Conout("Data Hora     - " + ::evento:data_hora )
Conout("//--  RGEFM04 - Fim    - Recebendo informa��es --//")

If Empty(::evento:sm)
	cMsgErr := "Sem informacoes para processamento."
Else
	dDatEve  := sToD(StrTran(SubStr(::evento:data_hora, 01, 10), "-", ""))
	cHorEve  := StrTran(SubStr(::evento:data_hora, 12, 08), ":", "")
	
	U_RGEFM04A (	cValToChar(::evento:sm),;
					::evento:latitude,;
					::evento:longitude,;
					::evento:evento,;
					::evento:codigo_externo,;
					::evento:alvo,;
					dDatEve,;
					cHorEve)
	lTudoOk := .T.
EndIf

If lTudoOk 
	::evento_result:sucesso := 1
	::evento_result:erro    := ""
Else
	::evento_result:sucesso := 0
	::evento_result:erro    := cMsgErr
EndIf

Return .T.
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � RGEFM04A �Autor  � Vin�cius Moreira   � Data � 21/09/2014  ���
�������������������������������������������������������������������������͹��
���Desc.     � Grava log referente integra��o.                            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       �                                                            ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function RGEFM04A (nSm, nLatit, nLongi, cEvento, cCodExt, cAlvo, dDatEve, cHorEve, cMsg)

Local cStatus   := "1"
Local lAutoOco  := GetMv("ES_GEFM04B",,.T.)
Default cMsg    := ""
Default cCodExt := ""
//�����������������������������������������������������������������������Ŀ
//�Checa se deve ser gerada ocorr�ncia ao receber informa��o da Buonny.   �
//�������������������������������������������������������������������������
If lAutoOco
	cStatus := fIncOco(nSm, cEvento, cCodExt, dDatEve, cHorEve)
EndIf

RecLock("PA6", .T.)
	PA6->PA6_FILIAL := xFilial("PA6")
	PA6->PA6_NUMSM  := nSm
	PA6->PA6_LATIT  := nLatit
	PA6->PA6_LONGI  := nLongi
	PA6->PA6_EVENTO := cEvento
	PA6->PA6_CODEXT := cCodExt
	PA6->PA6_ALVO   := cAlvo
	PA6->PA6_DATEVE := dDatEve
	PA6->PA6_HOREVE := cHorEve
	PA6->PA6_DATREC := Date()
	PA6->PA6_HORREC := Left(StrTran(Time(), ":", ""), 4)
	//�����������������������������������������������������������������������Ŀ
	//�Possiveis status.                                                      �
	//�1=Recebido                                                             �
	//�2=Oco.Gerada                                                           �
	//�3=Erro                                                                 �
	//�4=SM Invalida                                                          �
	//�������������������������������������������������������������������������
	If PA6->(FieldPos("PA6_STATUS")) > 0
		PA6->PA6_STATUS := cStatus
	EndIf
PA6->(MsUnLock())

If !Empty(cMsg)
	PA6->(MSMM(,80,,cMsg,1,,,"PA6","PA6_CODOBS"))
EndIf

Return 
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � fIncOco  �Autor  � Vin�cius Moreira   � Data � 09/11/2014  ���
�������������������������������������������������������������������������͹��
���Desc.     � Grava��o da ocorr�ncia.                                    ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       �                                                            ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function fIncOco (nSm, cEvento, cCodExt, dDatEve, cHorEve)

Local cRet          := "1"
Local cQuery        := ""
Local cAliasQry     := GetNextAlias()
Local aCabec        := {}
Local aItem         := {}
Local aItens        := {}
Local cNumOco       := ""
Local cFilBkp       := ""
Local cDirLog       := GetMv("ES_GEFM04A",,"\2LGI\Buonny\ReceberEvento\")
//����������������������������������������������������������������������������������Ŀ
//�Utilizo os mesmos par�metros do painel TDC para centralizar informa��o.           �
//������������������������������������������������������������������������������������
Local aOco          := {{	GetMv("ES_GEFM02H",,"GC01"),;
							GetMv("ES_GEFM02I",,"GC02"),;
							GetMv("ES_GEFM02L",,"GC05"),;
							GetMv("ES_GEFM02O",,"GC08")},;
						{	GetMv("ES_GEFM02P",,"GE01"),;
							GetMv("ES_GEFM02Q",,"GE02"),;
							GetMv("ES_GEFM02T",,"GE05"),;
							GetMv("ES_GEFM02X",,"GE08")}}
Local nTipOco		:= 1
Private INCLUI      := .T.
Private lMsErroAuto := .F.
//������������������������������������������������������������������������Ŀ
//�Possiveis eventos da Buonny.                                            �
//�entrada_alvo - Por alvo                                                 �
//�logistico    - Por viagem                                               �
//�saida_alvo   - Por alvo                                                 �
//�saida_origem - Por viagem                                               �
//��������������������������������������������������������������������������
If cEvento $ "logistico|saida_origem"
	cQuery := "  SELECT " + CRLF
	cQuery += "    DTQ.R_E_C_N_O_ DTQREC " + CRLF
	cQuery += "   ,DUD.R_E_C_N_O_ DUDREC " + CRLF
	cQuery += "   ,DT6.R_E_C_N_O_ DT6REC " + CRLF
	cQuery += "  FROM " + RetSqlName("DTQ") + " DTQ " + CRLF
	cQuery += " INNER JOIN " + RetSqlName("DUD") + " DUD ON " + CRLF
	cQuery += "       DUD.DUD_FILIAL = '" + xFilial("DUD") + "' " + CRLF
	cQuery += "   AND DUD.DUD_FILORI = DTQ.DTQ_FILORI " + CRLF
	cQuery += "   AND DUD.DUD_VIAGEM = DTQ.DTQ_VIAGEM " + CRLF
	cQuery += "   AND DUD.D_E_L_E_T_ = ' ' " + CRLF
	cQuery += " INNER JOIN " + RetSqlName("DT6") + " DT6 ON " + CRLF
	cQuery += "       DT6.DT6_FILIAL = '" + xFilial("DT6") + "' " + CRLF
	cQuery += "   AND DT6.DT6_FILDOC = DUD.DUD_FILDOC " + CRLF
	cQuery += "   AND DT6.DT6_DOC    = DUD.DUD_DOC " + CRLF
	cQuery += "   AND DT6.DT6_SERIE  = DUD.DUD_SERIE " + CRLF
	cQuery += "   AND DT6.D_E_L_E_T_ = ' ' " + CRLF
	cQuery += " WHERE DTQ.DTQ_FILIAL = '" + xFilial("DTQ") + "' " + CRLF
	cQuery += "   AND DTQ.DTQ_XSMBNY = '" + cValToChar(nSm) + "' " + CRLF
	cQuery += "   AND DTQ.D_E_L_E_T_ = ' ' " + CRLF
Else
	cQuery := "  SELECT " + CRLF
	cQuery += "    DTQ.R_E_C_N_O_ DTQREC " + CRLF
	cQuery += "   ,DUD.R_E_C_N_O_ DUDREC " + CRLF
	cQuery += "   ,DT6.R_E_C_N_O_ DT6REC " + CRLF
	cQuery += "  FROM " + RetSqlName("DTQ") + " DTQ " + CRLF
	cQuery += " INNER JOIN " + RetSqlName("DUD") + " DUD ON " + CRLF
	cQuery += "       DUD.DUD_FILIAL = '" + xFilial("DUD") + "' " + CRLF
	cQuery += "   AND DUD.DUD_FILORI = DTQ.DTQ_FILORI " + CRLF
	cQuery += "   AND DUD.DUD_VIAGEM = DTQ.DTQ_VIAGEM " + CRLF
	cQuery += "   AND DUD.D_E_L_E_T_ = ' ' " + CRLF
	cQuery += " INNER JOIN " + RetSqlName("DT6") + " DT6 ON " + CRLF
	cQuery += "       DT6.DT6_FILIAL = '" + xFilial("DT6") + "' " + CRLF
	cQuery += "   AND DT6.DT6_FILDOC = DUD.DUD_FILDOC " + CRLF
	cQuery += "   AND DT6.DT6_DOC    = DUD.DUD_DOC " + CRLF
	cQuery += "   AND DT6.DT6_SERIE  = DUD.DUD_SERIE " + CRLF
	cQuery += "   AND DT6.D_E_L_E_T_ = ' ' " + CRLF
	cQuery += " INNER JOIN " + RetSqlName("SA1") + " SA1 ON " + CRLF
	cQuery += "       SA1.A1_FILIAL  = '" + xFilial("SA1") + "' " + CRLF
	cQuery += "   AND SA1.A1_COD     = DT6.DT6_CLIDES " + CRLF
	cQuery += "   AND SA1.A1_LOJA    = DT6.DT6_LOJDES " + CRLF
	cQuery += "   AND SA1.A1_CGC     = '" + cCodExt + "' " + CRLF
	cQuery += "   AND SA1.D_E_L_E_T_ = ' ' " + CRLF
	cQuery += " WHERE DTQ.DTQ_FILIAL = '" + xFilial("DTQ") + "' " + CRLF
	cQuery += "   AND DTQ.DTQ_XSMBNY = '" + cValToChar(nSm) + "' " + CRLF
	cQuery += "   AND DTQ.D_E_L_E_T_ = ' ' " + CRLF
	cQuery += " UNION ALL " + CRLF
	cQuery += "  SELECT " + CRLF
	cQuery += "    DTQ.R_E_C_N_O_ DTQREC " + CRLF
	cQuery += "   ,DUD.R_E_C_N_O_ DUDREC " + CRLF
	cQuery += "   ,DT6.R_E_C_N_O_ DT6REC " + CRLF
	cQuery += "  FROM " + RetSqlName("DTQ") + " DTQ " + CRLF
	cQuery += " INNER JOIN " + RetSqlName("DUD") + " DUD ON " + CRLF
	cQuery += "       DUD.DUD_FILIAL = '" + xFilial("DUD") + "' " + CRLF
	cQuery += "   AND DUD.DUD_FILORI = DTQ.DTQ_FILORI " + CRLF
	cQuery += "   AND DUD.DUD_VIAGEM = DTQ.DTQ_VIAGEM " + CRLF
	cQuery += "   AND DUD.D_E_L_E_T_ = ' ' " + CRLF
	cQuery += " INNER JOIN " + RetSqlName("DT6") + " DT6 ON " + CRLF
	cQuery += "       DT6.DT6_FILIAL = '" + xFilial("DT6") + "' " + CRLF
	cQuery += "   AND DT6.DT6_FILDOC = DUD.DUD_FILDOC " + CRLF
	cQuery += "   AND DT6.DT6_DOC    = DUD.DUD_DOC " + CRLF
	cQuery += "   AND DT6.DT6_SERIE  = DUD.DUD_SERIE " + CRLF
	cQuery += "   AND DT6.D_E_L_E_T_ = ' ' " + CRLF
	cQuery += " INNER JOIN " + RetSqlName("DT5") + " DT5 ON " + CRLF
	cQuery += "       DT5.DT5_FILIAL = DUD.DUD_FILDOC " + CRLF
	cQuery += "   AND DT5.DT5_FILDOC = DUD.DUD_FILDOC " + CRLF
	cQuery += "   AND DT5.DT5_DOC    = DUD.DUD_DOC " + CRLF
	cQuery += "   AND DT5.DT5_SERIE  = DUD.DUD_SERIE " + CRLF
	cQuery += "   AND DT5.D_E_L_E_T_ = ' ' " + CRLF
	cQuery += " INNER JOIN " + RetSqlName("DUE") + " DUE ON " + CRLF
	cQuery += "       DUE.DUE_FILIAL = '" + xFilial("DUE") + "' " + CRLF
	cQuery += "   AND DUE.DUE_DDD    = DT5.DT5_DDD " + CRLF
	cQuery += "   AND DUE.DUE_TEL    = DT5.DT5_TEL " + CRLF
	cQuery += "   AND DUE.D_E_L_E_T_ = ' ' " + CRLF
	cQuery += " INNER JOIN " + RetSqlName("SA1") + " SA1 ON " + CRLF
	cQuery += "       SA1.A1_FILIAL  = '" + xFilial("SA1") + "' " + CRLF
	cQuery += "   AND SA1.A1_COD     = DUE.DUE_CODCLI " + CRLF
	cQuery += "   AND SA1.A1_LOJA    = DUE.DUE_LOJCLI " + CRLF
	cQuery += "   AND SA1.A1_CGC     = '" + cCodExt + "' " + CRLF
	cQuery += "   AND SA1.D_E_L_E_T_ = ' ' " + CRLF
	cQuery += " WHERE DTQ.DTQ_FILIAL = '" + xFilial("DTQ") + "' " + CRLF
	cQuery += "   AND DTQ.DTQ_XSMBNY = '" + cValToChar(nSm) + "' " + CRLF
	cQuery += "   AND DTQ.D_E_L_E_T_ = ' ' " + CRLF
	cQuery += "  GROUP BY " + CRLF
	cQuery += "    DTQ.R_E_C_N_O_ " + CRLF
	cQuery += "   ,DUD.R_E_C_N_O_ " + CRLF
	cQuery += "   ,DT6.R_E_C_N_O_ " + CRLF
EndIf

cQuery := ChangeQuery(cQuery)
DbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), cAliasQry, .F., .T.)
If (cAliasQry)->(Eof())
	cRet := "4"
Else
	fCriaDir (cDirLog)

	DTQ->(dbGoTo((cAliasQry)->DTQREC))
	//�������������������������������������������������������������������������������Ŀ
	//�Define posi��o onde est�o localizadas as ocorr�ncias de acordo com o servi�o.  �
	//���������������������������������������������������������������������������������
	If DTQ->DTQ_SERTMS == "1"
		nTipOco := 1
	Else
		nTipOco := 2
	EndIf
	While (cAliasQry)->(!Eof())
		DUD->(dbGoTo((cAliasQry)->DUDREC))
		DT6->(dbGoTo((cAliasQry)->DT6REC))
		
		//cNumOco := GetSx8Num ("DUA","DUA_NUMOCO",Nil)
		aCabec := {;
			{"DUA_FILORI", DUD->DUD_FILORI, NIL},;
			{"DUA_VIAGEM", DUD->DUD_VIAGEM, NIL};
		}
		
		//aAdd(aItem, {"DUA_NUMOCO", cNumOco 							,NIL})
		aAdd(aItem, {"DUA_SEQOCO", '0001'							,NIL})
		aAdd(aItem, {"DUA_DATOCO", dDatEve							,NIL})
		aAdd(aItem, {"DUA_HOROCO", cHorEve							,NIL})
		If cEvento == "saida_origem"
			aAdd(aItem, {"DUA_CODOCO", aOco[nTipOco, nSAIORI]	  	,NIL})
		ElseIf cEvento == "entrada_alvo"
			aAdd(aItem, {"DUA_CODOCO", aOco[nTipOco, nENTALV]	  	,NIL})
		ElseIf cEvento == "saida_alvo"
			aAdd(aItem, {"DUA_CODOCO", aOco[nTipOco, nSAIALV]	  	,NIL})
		ElseIf cEvento == "logistico"
			aAdd(aItem, {"DUA_CODOCO", aOco[nTipOco, nLOGIST]	  	,NIL})
		EndIf		
		aAdd(aItem, {"DUA_SERTMS", DUD->DUD_SERTMS					,NIL})
		aAdd(aItem, {"DUA_FILDOC", DT6->DT6_FILDOC					,NIL})
		aAdd(aItem, {"DUA_DOC"   , DT6->DT6_DOC						,NIL})
		aAdd(aItem, {"DUA_SERIE" , DT6->DT6_SERIE					,NIL})
		aAdd(aItem, {"DUA_QTDVOL", DT6->DT6_VOLORI					,NIL})
		aAdd(aItem, {"DUA_PESO"  , DT6->DT6_PESO 					,NIL})
		
		If DUD->DUD_SERTMS == "1"
			aAdd(aItem, {"DUA_QTDOCO", Iif(DT6->DT6_QTDVOL == 0, 1, DT6->DT6_QTDVOL)	,NIL})
			aAdd(aItem, {"DUA_PESOCO", Iif(DT6->DT6_PESO == 0  , 1, DT6->DT6_PESO)		,NIL})
		EndIf
		
		aAdd(aItens, aItem)			
		cFilAnt := DTQ->DTQ_FILDES 

		INCLUI   := .T.
		//-- Inclusao da Ocorrencia
		MsExecAuto({|x,y,z| Tmsa360(x,y,z)}, aCabec, aItens, {}, 3)
		If lMsErroAuto
			MostraErro(cDirLog, DTQ->DTQ_VIAGEM + "_" + DT6->(DT6_FILDOC+DT6_DOC+DT6_SERIE) + ".txt")
			Conout(DT6->(DT6_FILDOC+"-"+DT6_DOC+"/"+DT6_SERIE) + " - Problemas durante tentativa de grava��o de ocorr�ncia.")
			cRet := "3"
		Else
			//ConfirmSx8()
			Conout(DT6->(DT6_FILDOC+"-"+DT6_DOC+"/"+DT6_SERIE) + " - Documento baixado com sucesso.")
			cRet := "2"
		EndIf	
		lMsErroAuto := .F.
		
		cFilAnt := cFilBkp
		aCabec  := {}
		aItens  := {}
		aItem   := {}
		(cAliasQry)->(dbSkip())
	EndDo
EndIf

Return cRet
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � fCriaDir �Autor  � Vin�cius Moreira   � Data � 24/07/2012  ���
�������������������������������������������������������������������������͹��
���Desc.     � Cria diretorios utilizados pelo programa.                  ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       �                                                            ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function fCriaDir (cPatch)

Local lRet   := .T.
Local aDirs  := {}
Local nPasta := 1
Local cPasta := ""
Local cBarra   := If(IsSrvUnix(), "/", "\")
//�����������������������������������������������Ŀ
//�Criando diret�rio de configura��es de usu�rios.�
//�������������������������������������������������
aDirs := Separa(cPatch, cBarra)
For nPasta := 1 to Len(aDirs)
	If !Empty (aDirs[nPasta])
		cPasta += cBarra + aDirs[nPasta]
		If !ExistDir (cPasta) .And. MakeDir(cPasta) != 0
			lRet := .F.
			Exit
		EndIf
	EndIf
Next nPasta

Return lRet 