#Include 'Protheus.ch'
#Include 'FWMVCDef.ch'

/*
Programa    : GEFINSPA7
Funcao      : GEFINSPA7 - MVC
Data        : 17/03/2016
Autor       : André Costa
Descricao   : Função Principal - Controller
Uso         : Externo
Sintaxe     : GEFINSPA7
Chamanda    : Menu
*/


User Function GEFINSPA7			// u_GEFINSPA7()

	Local aCoors  := FWGetDialogSize( oMainWnd )
	Local oFWLayer
	Local oPanelUp
	Local oPanelDown
	Local oRelacDown

	Private oDlgPrinc
	Private aRelacDown	:= {}
	Private oBrowseUp
	Private oBrowseDown
	Private aRotina

	ModelDef()

	ViewDef()

	Define MsDialog oDlgPrinc Title 'Aprovação de Titulos' From aCoors[1], aCoors[2] To aCoors[3], aCoors[4] Pixel

	oFWLayer := FWLayer():New()
	oFWLayer:Init( oDlgPrinc, .F., .T. )

	oFWLayer:AddLine( 'UP', 50, .F. )

	oFWLayer:AddCollumn( 'ALL', 100, .T., 'UP' )

	oPanelUp := oFWLayer:GetColPanel( 'ALL', 'UP' )
	oFWLayer:AddLine( 'DOWN', 50, .F. )

	oFWLayer:AddCollumn( 'Down' ,  100, .T., 'DOWN' )

	oPanelDown  := oFWLayer:GetColPanel( 'Down' , 'DOWN' )

	oBrowseDown:= FWMBrowse():New()
	oBrowseDown:SetOwner( oPanelDown )
	oBrowseDown:SetAlias( 'ZZA' )
	oBrowseDown:SetDescription( 'Log dos Titulos' )
	oBrowseDown:SetAmbiente(.F.)
	oBrowseDown:SetWalkthru(.F.)
	oBrowseDown:DisableDetails()
	oBrowseDown:DisableConfig()
	oBrowseDown:DisableReport()
	oBrowseDown:SetMenuDef( '' )
	oBrowseDown:SetOnlyFields( { 'ZZA_USER','ZZA_NOME','ZZA_DATA','ZZA_HORA','ZZA_JUSTIF'} )
	oBrowseDown:SetProfileID( '2' )
	oBrowseDown:Activate()

	aRelacDown := {	{	'ZZA_FILIAL'	,	'E2_FILIAL'	}	,;
						{	'ZZA_PREFIX'	,	'E2_PREFIXO'	}	,;
						{	'ZZA_NUM'		,	'E2_NUM'		}	,;
						{	'ZZA_PARCEL'	,	'E2_PARCELA'	}	,;
						{	'ZZA_TIPO'		,	'E2_TIPO'		}	,;
						{	'ZZA_FORNEC'	,	'E2_FORNECE'	}	,;
						{	'ZZA_LOJA'		,	'E2_LOJA'		} }

	aRotina := MenuDef()

	oBrowseUp := FWMarkBrowse():New()
	oBrowseUp:SetOwner( oPanelUp )
	oBrowseUp:SetSemaphore(.T.)
	oBrowseUp:SetAlias( 'SE2' )
	oBrowseUp:SetDescription( "Titulos" )
	oBrowseUp:SetAmbiente(.F.)
	oBrowseUp:SetWalkthru(.F.)
	oBrowseUp:SetFieldMark( 'E2_XISMARK' )
	oBrowseUp:SetOnlyFields( { 'E2_FILIAL','E2_PREFIXO','E2_NUM','E2_PARCELA','E2_TIPO','E2_FORNECE','E2_LOJA'} )
//	oBrowseUp:SetFilterDefault( "E2_XSTATVC $ 'S|R'" )
	oBrowseUp:SetFilterDefault( "E2_FCTADV $ 'S|R'" )				// Retirar
	oBrowseUp:SetProfileID( '1' )
	oBrowseUp:ForceQuitButton()
	oBrowseUp:Activate()

	oRelacDown:= FWBrwRelation():New()
	oRelacDown:AddRelation( oBrowseUp, oBrowseDown , aRelacDown )
	oRelacDown:Activate()

	Activate MsDialog oDlgPrinc Center

Return NIL

/*
Programa    : GEFINSPA7
Funcao      : ModelDef - MVC
Data        : 17/03/2016
Autor       : André Costa
Descricao   : Função Statica - Modelagem dos Dados
Uso         : Interno
Sintaxe     : ModelDef()
Chamanda    : GEFINSPA7
*/

Static Function ModelDef

	Local oModel
	Local oStrSE2		:= FwFormStruct( 1,"SE2" )

	oModel := MPFormModel():New("AND_MVC", /*bPre*/,/*bPost*/, /*bCommit*/, /*bCancel*/)
	oModel:SetDescription("Titulo Contas a Pagar")
	oModel:addFields('Model_SE2',,oStrSE2)

Return oModel

/*
Programa    : GEFINSPA7
Funcao      : ViewDef - MVC
Data        : 17/03/2016
Autor       : André Costa
Descricao   : Função Statica - Visualização dos Dados
Uso         : Interno
Sintaxe     : ViewDef()
Chamanda    : GEFINSPA7
*/

Static Function ViewDef

	Local oModel		:= FwLoadModel( "GEFINSPA7" )
	Local oView	  	:= Nil
	Local oStruSE2	:= FwFormStruct( 2,"SE2")

	oView := FwFormView():New()
	oView:SetUseCursor(.F.)
	oView:SetModel( oModel )
	oView:AddField( "VIEW_SE2", oStruSE2, "Model_SE2")
	oView:CreateHorizontalBox( 'TELA', 100 )
	oView:SetOwnerView( "VIEW_SE2", "TELA" )

Return( oView )

/*
Programa    : GEFINSPA7
Funcao      : MenuDef - MVC
Data        : 17/03/2016
Autor       : André Costa
Descricao   : Função Statica - Menu
Uso         : Interno
Sintaxe     : MenuDef()
Chamanda    : GEFINSPA7
*/

Static Function MenuDef

	Local aRotina := {}

	ADD OPTION aRotina Title 'Visualizar'	Action 'VIEWDEF.GEFINSPA7'					OPERATION 2 ACCESS 0
	ADD OPTION aRotina Title 'Aprovar'		ACTION "StaticCall(GEFINSPA7,xAprova)"		OPERATION 3 ACCESS 0
	ADD OPTION aRotina Title 'Reprovar'	Action "StaticCall(GEFINSPA7,xReprova)"	OPERATION 4 ACCESS 0

Return aRotina

/*
Programa    : GEFINSPA7
Funcao      : xReprova - MVC
Data        : 17/03/2016
Autor       : André Costa
Descricao   : Função Statica - Controle de Gravação para Rerprovação dos Titulos
Uso         : Interno
Sintaxe     : StaticCall( GEFINSPA7 , xReprova )
Chamanda    : MenuDef
*/

Static Function xReprova
	Local aArea := GetArea()

	Begin Sequence

		If !( xJustifica() )
			Break
		EndIf

		RecLock("ZZA",.T.)

			ZZA->ZZA_FILIAL	:= SE2->E2_FILIAL
			ZZA->ZZA_PREFIX	:= SE2->E2_PREFIXO
			ZZA->ZZA_NUM		:= SE2->E2_NUM
			ZZA->ZZA_TIPO		:= SE2->E2_TIPO
			ZZA->ZZA_FORNEC	:= SE2->E2_FORNECE
			ZZA->ZZA_LOJA		:= SE2->E2_LOJA
			ZZA->ZZA_USER		:= __cUserID
			ZZA->ZZA_NOME		:= cUserName
			ZZA->ZZA_JUSTIF	:= MV_PAR01
			ZZA->ZZA_DATA		:= Date()
			ZZA->ZZA_HORA		:= Time()

		ZZA->( MsUnlock() )

		RecLock("SE2",.F.)

	//		SE2->E2_XSTATVC	:= ''
			SE2->E2_FCTADV	:= ''					// Retirar
			SE2->E2_XISMARK	:= ''

		SE2->( MsUnlock() )

	End Sequence

	RestArea( aArea )

Return

/*
Programa    : GEFINSPA7
Funcao      : xAprova
Data        : 17/03/2016
Autor       : André Costa
Descricao   : Função Statica - Controle de Gravação para Aprovação dos Titulos
Uso         : Interno
Sintaxe     : StaticCall( GEFINSPA7 , xAprova )
Chamanda    : MenuDef
*/


Static Function xAprova
	Local aArea	:= GetArea()
	Local xCont	:= 0

	For X := 1 To Len( oBrowseUp:oBrowse:aVisibleReg )

		DbGoTo( oBrowseUp:oBrowse:aVisibleReg[X] )

		If ! ( oBrowseUp:IsMark( oBrowseUp:Mark() ) )
			Loop
		EndIf

		RecLock("ZZA",.T.)

			ZZA->ZZA_FILIAL	:= SE2->E2_FILIAL
			ZZA->ZZA_PREFIX	:= SE2->E2_PREFIXO
			ZZA->ZZA_NUM		:= SE2->E2_NUM
			ZZA->ZZA_TIPO		:= SE2->E2_TIPO
			ZZA->ZZA_FORNEC	:= SE2->E2_FORNECE
			ZZA->ZZA_LOJA		:= SE2->E2_LOJA
			ZZA->ZZA_USER		:= __cUserID
			ZZA->ZZA_NOME		:= cUserName
			ZZA->ZZA_JUSTIF	:= 'APROVADO'
			ZZA->ZZA_DATA		:= Date()
			ZZA->ZZA_HORA		:= Time()

		ZZA->( MsUnlock() )

		RecLock("SE2",.F.)

//			SE2->E2_XSTATVC	:= 'A'
			SE2->E2_FCTADV	:= 'A'					// Retirar
			SE2->E2_XISMARK	:= ''

		SE2->( MsUnlock() )

		xCont++

	Next X

	oBrowseUp:Refresh(.t.)
	oBrowseDown:Refresh(.t.)

	If xCont # 0
		MsgInfo("Foram Aprovados " + cValtoChar( xCont ) + " Titulos do Contas a Pagar.","Informação")
	Else
		MsgInfo("Não foram encontrados Titulos Marcados para Aprovação","Informação")
	EndIf

	RestArea( aArea )

Return

/*
Programa    : GEFINSPA7
Funcao      : xJustifica
Data        : 17/03/2016
Autor       : André Costa
Descricao   : Função Statica - Controle de Perguntas
Uso         : Interno
Sintaxe     : xJustifica()
Chamanda    : xReprova()
*/


Static Function xJustifica

	Local aParamBox	:= {}
	Local aRet			:= {}

	Local lRetorno	:= .F.
	Local lCanSave	:= .F.
	Local lUserSave	:= .F.

	Local xLoad		:= "GEFINSPA7"
	Local xJustific	:= Space(30)

	aAdd(aParamBox,{1,"Justificativa",xJustific,"@!"	,"StaticCall(GEFINSPA7,xValJusti)"	,"","",50,.F.})

	If	ParamBox(aParamBox,"Justificativa",@aRet,/*bOk*/,/*aButtons*/,/*lCentered*/,/*nPosX*/,/*nPosy*/,/*oDlgWizard*/,xLoad,lCanSave,lUserSave)
		lRetorno	:= .T.
	Endif

Return( lRetorno )


/*
Programa    : GEFINSPA7
Funcao      : xValJusti
Data        : 17/03/2016
Autor       : André Costa
Descricao   : Função Statica - Validação das Perguntas
Uso         : Interno
Sintaxe     : StaticCall(GEFINSPA7,xValJusti)
Chamanda    : xJustifica
*/


Static Function xValJusti
	Local lRetorno := .F.

	Begin Sequence

		If Empty( MV_PAR01 )

			Aviso("Atenção","Para Reprovação necessario informara Justificativa.",{"OK"})
			Break

		EndIf

		lRetorno := .T.

	End Sequence

Return(lRetorno)





