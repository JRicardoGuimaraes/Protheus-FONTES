#Include "Protheus.CH"

/*
Programa	: GEFXMLROB
Funcao		: Usuario GEFXMLROB
Data		: 31/07/2015
Autor		: André Costa
Descricao	: Função de contorle
Chamada	: Schedule / Menu
Sintaxe	: GEFXMLROB
*/


User Function GEFXMLROB						// u_GEFXMLROB()
	Local aArea := GetArea()

	Private lSchedule := xSchedule()

	GEFXMLROB()

	RestArea( aArea )
Return


/*
Programa	: GEFXMLROB
Funcao		: Static GEFXMLROB
Data		: 31/07/2015
Autor		: André Costa
Descricao	: Função de contorle
Chamada	: GEFXMLROB
Sintaxe	: GEFXMLROB()
*/

Static Function GEFXMLROB
	Local aArea			:= GetArea()
	Local cFunName		:= FunName()
	Local xQtde			:= 0
	Local aCTE				:= {}
	Local aQuery			:= {}
	Local xIdEnt			:= ""
	Local cDe				:= ''
	Local cPara			:= ''
	Local cCc				:= ''
	Local cRpcEmp			:= '01'
	Local cRpcFil			:= '01'
	Local cEnvMod			:= '43'
	Local cAssunto		:= 'Log da exportação dos CTe´S para AVERBAÇÃO'
	Local cMsg				:= 'Segue em anexo o arquivo com as informações do processo de Exportação de XML para AVERBAÇÂO. '
	Local cAnexo			:= '\SYSTEM\CTEROBOT.LOG'
	Local cFilDT6
	Local dDataIni

	Local _cPatchCopia
	Local _cDirColab
	Local _cWhere
	Local _cSelect
	Local aTipArq			:= {	{"1","199_","Autorizado" } ,;
									{"2","200_","Cancelado"	}	;
								}

	Private TRAB			:=	GetNextAlias()
	Private cArquivo		:= 'CTEROBOT.LOG'

	If lSchedule
		RpcSetType( 3 )
		RpcSetEnv( cRpcEmp,cRpcFil,/*cEnvUser*/,/*cEnvPass*/,cEnvMod,cFunName,/*aTables*/,/*lShowFinal*/,/*lAbend*/,/*lOpenSX*/,/*lConnect*/ )
	EndIf

	AjustaSX6()

	// dDataIni		:= GetMv("MV_XDATROB")
	dDataIni		:= CtoD("12/01/2016")
	cDe				:= GetMv("MV_RELFROM")
	cPara			:= GetMv("MV_XUSRROB")
	_cPatchCopia	:= GetMV("MV_XXMLROB")
	_cDirColab		:= GetMV("MV_XARQCOL")

	If Select( "TRAB" ) # 0
		( TRAB )->( DbCloseArea() )
	EndIf

	For X := 1 To Len( aTipArq )

		nPos := aScan( aTipArq , { |Z| AllTrim( cValToChar( X ) ) == Z[1] } )

		If nPos == 0
			Loop
		EndIf

		Begin Sequence

			_cWhere	:= ""
			_cSelect	:= ""

			If !lSchedule
				_cWhere	+= " And DT6.DT6_FILDOC	= '" + cFilAnt + "'"
			EndIf

			If X == 1
				_cWhere := " And	DT6.DT6_XCTERO =	'' "
			Else
				_cWhere := " And	DT6.DT6_XCTERO =	'1' "
				_cSelect := " DT6.D_E_L_E_T_ "
			EndIf

			_cWhere	:= "%" + _cWhere	+ "%"
			_cSelect	:= "%" + _cSelect	+ "%"

			BeginSql Alias TRAB

				Select	%Exp:_cSelect% , DT6_FILDOC,DT6_DOC,DT6_SERIE,DT6_CHVCTE,DT6_DATEMI,DT6_XCTERO

		 		From	%Table:DT6010%	DT6

				Where (		DT6.DT6_DATEMI	=	%Exp:DtoS(dDataIni)%
							And	DT6.DT6_IDRCTE	=	'100'
							And	DT6.DT6_SERIE		=	'5'
						)

						%Exp:_cWhere%

				Order By DT6_FILDOC

			EndSql

			aQuery := GetLastQuery()

			( TRAB )->( DbGoTop() )

			If ( TRAB )->( Eof() )
				Break
			EndIf

			StaticCall( GEFCNHAST , LogThis, "Iniciando o processo de Exportação da AVERBAÇÂO dos CTE´S " + aTipArq[nPos][3] , cArquivo )

			cFilDT6 := ''

			aArqColab := Directory( _cDirColab + aTipArq[nPos][2] + "*.*" , "D" )

			While ( TRAB )->( !Eof() )

				If ( TRAB )->( DT6_FILDOC ) # cFilDT6
					cFilDT6 := ( TRAB )->( DT6_FILDOC )
					If lSchedule
						RpcClearEnv()
						RpcSetType( 3 )
						RpcSetEnv( cRpcEmp,cFilDT6,/*cEnvUser*/,/*cEnvPass*/,cEnvMod,cFunName,/*aTables*/,/*lShowFinal*/,/*lAbend*/,/*lOpenSX*/,/*lConnect*/ )
					EndIf
				EndIf

				lOkCTE := .F.

				For Y := 1 To Len( aArqColab )

					nHandle := FT_FUse( _cDirColab + aArqColab[X][1] )

					If nHandle = -1
						Loop
					EndIf

					FT_FGoTop()

					While ! FT_FEOF() .And. ! lOkCTE

						If ( TRAB )->( DT6_CHVCTE ) $ FT_FReadLn()
							lOkCTE := .T.
						EndIf

						FT_FSKIP()

					End While

					FT_FUse()

					If ! ( lOkCTE )
						Loop
					EndIf

					MemoWrit( _cPatchCopia , MemoRead( aArqColab[X][1] ) ) // EncodeUTF8(cString))

					lOkCTE := .T.

				Next Y

				If ! ( lOkCTE )

					Begin Sequence

						xIdEnt := GetIdEnt( cEmpAnt , ( TRAB )->( DT6_FILDOC ) )

						If Empty( xIdEnt )
							Break
						EndIf

						If !( SpedPExp( xIdEnt , ( TRAB )->( DT6_FILDOC ) , ( TRAB )->( DT6_SERIE	) , ( TRAB )->( DT6_DOC ) , _cPatchCopia , StoD( ( TRAB )->( DT6_DATEMI ) ) ) )
							Break
						EndIf

						lOkCTE := .T.

					End Sequence

				EndIf

				If lOkCTE

					DbSelectArea("DT6")
					DbSetOrder(1)

					If DbSeek( xFilial("DT6") + ( TRAB )->( DT6_FILDOC+DT6_DOC+DT6_SERIE ) )
						RecLock("DT6",.F.)
							DT6_XCTERO = cValToChar( X )
						DT6->( DbUnlock() )
					EndIf

				EndIf

				( TRAB )->( DbSkip() )

				xQtde++

			End While

		End Sequence

		StaticCall( GEFCNHAST , LogThis, "Foram Processados " + cValToChar( ( TRAB )->(RecCount()) ) + " registros e Exportados "+ cValToChar( xQtde ) +" XML'S - " + aTipArq[nPos][3] , cArquivo )

		StaticCall( GEFCNHAST , LogThis, "Finalizado o processo de Exportação da AVERBAÇÂO dos CTE´S " + aTipArq[nPos][3] , cArquivo )

		u_EnvEmail( cDe , cPara , cCc , cAssunto , cMsg , cAnexo )

		FErase( cAnexo )

	Next X

	If lSchedule
		RpcClearEnv()
	EndIf

	RestArea( aArea )

Return

/*
Programa	: GEFXMLROB
Funcao		: Static SpedPExp
Data		: 31/07/2015
Autor		: André Costa
Descricao	: Realiza a exportação do XML autorizado pelo SEFAZ
Chamada	: GEFXMLROB
Sintaxe	: SpedPExp(cIdEnt,cSerie,cNotaIni,cDirDest)
*/


Static Function SpedPExp(cIdEnt,xFilial,cSerie,cNotaIni,cDirDest,cDataDe,cDataAte,cCNPJDESTInicial,cCNPJDESTFinal)

	Local cChvNFe		:= ""
	Local cPrefixo	:= "CTe"
	Local cXml			:= ""
	Local cNFes		:= ""
	Local nHandle		:= 0
	Local X			:= 0
	Local lOk			:= .F.
	Local cURL			:= PadR(GetNewPar("MV_SPEDURL","http://"),250)
	Local oWS
	Local oRetorno
	Local oXML

	Default cDataDe				:= Lastday(dDataBase,1)
	Default cDataAte				:= Lastday(cDataDe)
	Default cCNPJDESTInicial		:= ''
	Default cCNPJDESTFinal		:= 'ZZZZZZZZZZZZZZ'

	oWS:= WSNFeSBRA():New()
	oWS:cUSERTOKEN			:= "TOTVS"
	oWS:cID_ENT				:= cIdEnt
	oWS:_URL					:= AllTrim(cURL)+"/NFeSBRA.apw"
	oWS:cIdInicial			:= cSerie+cNotaIni
	oWS:cIdFinal				:= cSerie+cNotaIni
	oWS:dDataDe				:= cDataDe
	oWS:dDataAte				:= cDataAte
	oWS:cCNPJDESTInicial		:= cCNPJDESTInicial
	oWS:cCNPJDESTFinal		:= cCNPJDESTFinal
	oWS:nDiasparaExclusao	:= 0
	lOk							:= oWS:RETORNAFX()
	oRetorno					:= oWS:oWsRetornaFxResult

	Begin Sequence

		If !( lOk )
			StaticCall( GEFCNHAST , LogThis, "Ocorreu problema. Filial "+xFilial+" Entidade "+ cIdEnt + " Serie "+cSerie+" Documento "+cNotaIni+" Dat Ini. "+DtoC(cDataDe)+" Dat. Fim"+DtoC(cDataAte)+" CNPJ Ini "+cCNPJDESTInicial+" CNPJ Fim "+cCNPJDESTFinal , cArquivo )
			Break
		EndIf

		For X := 1 To Len(oRetorno:OWSNOTAS:OWSNFES3)

			oXml		:= oRetorno:OWSNOTAS:OWSNFES3[X]
			oXmlExp	:= XmlParser(oRetorno:OWSNOTAS:OWSNFES3[X]:OWSNFE:CXML,"","","")
			cXML		:= ""
			cVerCte	:= Iif(Type("oXmlExp:_CTE:_INFCTE:_VERSAO:TEXT") <> "U", oXmlExp:_CTE:_INFCTE:_VERSAO:TEXT, '')

			If Empty(oXml:oWSNFe:cProtocolo)
				StaticCall( GEFCNHAST , LogThis, "Protoculo Vazio. Filial "+xFilial+" Entidade "+ cIdEnt + " Serie "+cSerie+" Documento "+cNotaIni+" Dat Ini. "+DtoC(cDataDe)+" Dat. Fim"+DtoC(cDataAte)+" CNPJ Ini "+cCNPJDESTInicial+" CNPJ Fim "+cCNPJDESTFinal , cArquivo )
				Loop
			EndIf

			cNotaIni	:= oXml:cID
			cNFes		:= cNFes+cNotaIni+CRLF
			cChvNFe	:= NfeIdSPED(oXml:oWSNFe:cXML,"Id")

			nHandle := FCreate(cDirDest+SubStr(cChvNFe,4,44)+"-"+cPrefixo+".xml")

			If nHandle == 0
				StaticCall( GEFCNHAST , LogThis, "Problema para Criar o Arquivo. Filial "+xFilial+" Entidade "+ cIdEnt + " Serie "+cSerie+" Documento "+cNotaIni+" Dat Ini. "+DtoC(cDataDe)+" Dat. Fim"+DtoC(cDataAte)+" CNPJ Ini "+cCNPJDESTInicial+" CNPJ Fim "+cCNPJDESTFinal , cArquivo )
				Loop
			EndIf

			cCab1	:= '<?xml version="1.0" encoding="UTF-8"?>'
			cCab1	+= '<cteProc xmlns="http://www.portalfiscal.inf.br/cte" xmlns:ds="http://www.w3.org/2000/09/xmldsig#" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://www.portalfiscal.inf.br/cte procCTe_v'+cVerCte+'.xsd" versao="'+cVerCte+'">'
			cRodap	:= '</cteProc>'

			FWrite(nHandle,AllTrim(cCab1))
			FWrite(nHandle,AllTrim(oXml:oWSNFe:cXML))
			FWrite(nHandle,AllTrim(oXml:oWSNFe:cXMLPROT))
			FWrite(nHandle,AllTrim(cRodap))
			FClose(nHandle)

		Next X

	End Sequence

Return( lOk )



/*
Programa	: GEFXMLROB
Funcao		: Static GetIdEnt
Data		: 31/07/2015
Autor		: André Costa
Descricao	: Faz a identificação da Entitade da Empresa
Chamada	: SpedPExp
Sintaxe	: GetIdEnt(xFilial)
*/

Static Function GetIdEnt(xEmpresa,xFilial)

	Local aArea  := GetArea()
	Local cIdEnt := ""
	Local cURL   := PadR(GetNewPar("MV_SPEDURL","http://"),250)
	Local oWs

	Default xEmpresa := cEmpAnt

	Begin Sequence

		DbSelectArea("SM0")
		DbSetOrder(1)

		If !( MsSeek(xEmpresa + xFilial ) )
			StaticCall( GEFCNHAST , LogThis, "Nao foi encontrada a Empresa "+xEmpresa+" e ou a Filial "+xFilial+". Favor informar a TI.", cArquivo )
			Break
		EndIf

		oWS := WsSPEDAdm():New()
		oWS:cUSERTOKEN := "TOTVS"

		oWS:oWSEMPRESA:cCNPJ       := IIF(SM0->M0_TPINSC==2 .Or. Empty(SM0->M0_TPINSC),SM0->M0_CGC,"")
		oWS:oWSEMPRESA:cCPF        := IIF(SM0->M0_TPINSC==3,SM0->M0_CGC,"")
		oWS:oWSEMPRESA:cIE         := SM0->M0_INSC
		oWS:oWSEMPRESA:cIM         := SM0->M0_INSCM
		oWS:oWSEMPRESA:cNOME       := SM0->M0_NOMECOM
		oWS:oWSEMPRESA:cFANTASIA   := SM0->M0_NOME
		oWS:oWSEMPRESA:cENDERECO   := FisGetEnd(SM0->M0_ENDENT)[1]
		oWS:oWSEMPRESA:cNUM        := FisGetEnd(SM0->M0_ENDENT)[3]
		oWS:oWSEMPRESA:cCOMPL      := FisGetEnd(SM0->M0_ENDENT)[4]
		oWS:oWSEMPRESA:cUF         := SM0->M0_ESTENT
		oWS:oWSEMPRESA:cCEP        := SM0->M0_CEPENT
		oWS:oWSEMPRESA:cCOD_MUN    := SM0->M0_CODMUN
		oWS:oWSEMPRESA:cCOD_PAIS   := "1058"
		oWS:oWSEMPRESA:cBAIRRO     := SM0->M0_BAIRENT
		oWS:oWSEMPRESA:cMUN        := SM0->M0_CIDENT
		oWS:oWSEMPRESA:cCEP_CP     := Nil
		oWS:oWSEMPRESA:cCP         := Nil
		oWS:oWSEMPRESA:cDDD        := Str(FisGetTel(SM0->M0_TEL)[2],3)
		oWS:oWSEMPRESA:cFONE       := AllTrim(Str(FisGetTel(SM0->M0_TEL)[3],15))
		oWS:oWSEMPRESA:cFAX        := AllTrim(Str(FisGetTel(SM0->M0_FAX)[3],15))
		oWS:oWSEMPRESA:cEMAIL      := UsrRetMail(RetCodUsr())
		oWS:oWSEMPRESA:cNIRE       := SM0->M0_NIRE
		oWS:oWSEMPRESA:dDTRE       := SM0->M0_DTRE
		oWS:oWSEMPRESA:cNIT        := IIF(SM0->M0_TPINSC==1,SM0->M0_CGC,"")
		oWS:oWSEMPRESA:cINDSITESP  := ""
		oWS:oWSEMPRESA:cID_MATRIZ  := ""
		oWS:oWSOUTRASINSCRICOES:oWSInscricao := SPEDADM_ARRAYOFSPED_GENERICSTRUCT():New()
		oWS:_URL := AllTrim(cURL)+"/SPEDADM.apw"

		If oWs:ADMEMPRESAS()
			cIdEnt  := oWs:cADMEMPRESASRESULT
		EndIf

	End Sequence

	RestArea(aArea)

Return(cIdEnt)


/*
Programa		: GEFXMLROB
Funcao			: Função Estatica - AjustaSX6
Data			: 31/07/2015
Autor			: André Costa
Descricao		: Função de Apoio
Uso				: Ajusta os Parametros da Rotina Exportação de XML para Averbação
Sintaxe		: AjustaSX6()
Retorno		: Conteudo do Parametro
*/


Static Function AjustaSX6
	Local aArea := GetArea()

	DbSelectArea("SX6")  // abre arquivo temporário
	SX6->( DbSetOrder(1) )

	If ( !MsSeek( Space( FWSizeFilial() ) + "MV_XDATROB" , .F. ) )
		Conout('Parametro MV_XDATROB Criado')
		RecLock( "SX6",.T. )
			SX6->X6_VAR     := "MV_XDATROB"
			SX6->X6_TIPO    := "D"
			SX6->X6_CONTEUD := CtoD( Date() )
			SX6->X6_CONTSPA := CtoD( Date() )
			SX6->X6_CONTENG := CtoD( Date() )

			SX6->X6_DESCRIC := "Data de Inicio do processo de Exportação da AVERBA"
			SX6->X6_DESC1   := "ÇAO"
			SX6->X6_DSCSPA  := "Data de Inicio do processo de Exportação da AVERBA"
			SX6->X6_DSCSPA1 := "ÇAO"
			SX6->X6_DSCENG  := "Data de Inicio do processo de Exportação da AVERBA"
			SX6->X6_DSCENG1 := "ÇAO"
		MsUnLock()
	EndIf

	If ( !MsSeek( Space( FWSizeFilial() ) + "MV_XXMLROB" , .F. ) )
		Conout('Parametro MV_XXMLROB Criado')
		RecLock( "SX6",.T. )
			SX6->X6_VAR     := "MV_XXMLROB"
			SX6->X6_TIPO    := "C"
			SX6->X6_CONTEUD := "\Interfaces\TMS\PROTHEUS\OUT\AVERBACAO\"
			SX6->X6_CONTSPA := "\Interfaces\TMS\PROTHEUS\OUT\AVERBACAO\"
			SX6->X6_CONTENG := "\Interfaces\TMS\PROTHEUS\OUT\AVERBACAO\"

			SX6->X6_DESCRIC := "Local de gravação dos arquivos XML para Exportação"
			SX6->X6_DESC1   := " da AVERBAÇAO"
			SX6->X6_DSCSPA  := "Local de gravação dos arquivos XML para Exportação"
			SX6->X6_DSCSPA1 := " da AVERBAÇAO"
			SX6->X6_DSCENG  := "Local de gravação dos arquivos XML para Exportação"
			SX6->X6_DSCENG1 := " da AVERBAÇAO"
		MsUnLock()
	EndIf

	If ( !MsSeek( Space( FWSizeFilial() ) + "MV_XUSRROB" , .F. ) )
		Conout('Parametro MV_XUSRROB Criado')
		RecLock( "SX6",.T. )
			SX6->X6_VAR     := "MV_XUSRROB"
			SX6->X6_TIPO    := "C"
			SX6->X6_CONTEUD := "pedro.alvarez@gefco.com.br"
			SX6->X6_CONTSPA := "pedro.alvarez@gefco.com.br"
			SX6->X6_CONTENG := "pedro.alvarez@gefco.com.br"

			SX6->X6_DESCRIC := "Email do usuario que recebera o log a AVERBACAO."
			SX6->X6_DESC1   := ""
			SX6->X6_DSCSPA  := "Email do usuario que recebera o log a AVERBACAO"
			SX6->X6_DSCSPA1 := ""
			SX6->X6_DSCENG  := "Email do usuario que recebera o log a AVERBACAO"
			SX6->X6_DSCENG1 := ""
		MsUnLock()
	EndIf

	If ( !MsSeek( Space( FWSizeFilial() ) + "MV_XARQCOL" , .F. ) )
		Conout('Parametro MV_XARQCOL Criado')
		RecLock( "SX6",.T. )
			SX6->X6_VAR     := "MV_XARQCOL"
			SX6->X6_TIPO    := "C"
			SX6->X6_CONTEUD := "\Protheus_Data\NeoGridClient\bin\LIDOS\"
			SX6->X6_CONTSPA := "\Protheus_Data\NeoGridClient\bin\LIDOS\"
			SX6->X6_CONTENG := "\Protheus_Data\NeoGridClient\bin\LIDOS\"

			SX6->X6_DESCRIC := "Diretorio onde estão os Arquivos do Colaboração."
			SX6->X6_DESC1   := ""
			SX6->X6_DSCSPA  := "Diretorio onde estão os Arquivos do Colaboração."
			SX6->X6_DSCSPA1 := ""
			SX6->X6_DSCENG  := "Diretorio onde estão os Arquivos do Colaboração."
			SX6->X6_DSCENG1 := ""
		MsUnLock()
	EndIf

	RestArea(aArea)

Return

/*
Programa	: GEFXMLROB
Funcao		: Função Estatica - xSchedule
Data		: 03/08/2015
Autor		: André Costa
Descricao	: Função de Apoio
Uso			: Verifica se a rotina esta esta rodando por Schedule ou via IDE
Sintaxe	: xSchedule()
Retorno	: Logico Verdadeiro / Falso
*/

Static Function xSchedule
	Local aArea		:= GetArea()
	Local lRetorno	:= .F.

	Begin Sequence

		If ( Type( "__cInternet" ) == "U" )

			If Select("SX6") == 0
				lRetorno := .T.
				Break
			EndIf

			If __cInternet == "AUTOMATICO"
				lRetorno := .T.
				Break
			EndIf

		EndIf

	End Sequence

	RestArea( aArea )

Return( lRetorno )
