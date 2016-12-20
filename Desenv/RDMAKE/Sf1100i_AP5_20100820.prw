#include "rwmake.ch"

User Function Sf1100i()

Private V_Tipo,V_Alias,V_Order,V_Recno

V_Alias := Alias()
V_Order := IndexOrd()
V_Recno := 0
xDUPLIC := .T.
GefConta := " "
GefCusto := " "
xPrefixo := ""
xNumero  := ""
V_Tipo := " "

If !Eof()
	V_Recno := Recno()
Endif

// Gera ou não Titulo a pagar
DbSelectArea("SE2")
// Substituído por Ricardo - Em: 16/05/2008 - Não estava tratando o fornecedor na Chave, então quando existia NF
// iguais de fornecedores diferente estava pegando o CC errado.
dbSetOrder(6)
dbGoTop()
// xDUPLIC := IIF(dbSeek(xFilial("SE2")+SF1->F1_SERIE+SF1->F1_DOC),.T.,.F.)
xDUPLIC := IIF(dbSeek(xFilial("SE2")+SF1->F1_FORNECE+SF1->F1_LOJA+SF1->F1_SERIE+SF1->F1_DOC),.T.,.F.)
// xDUPLIC := IIF(dbSeek(xFilial("SE2")SF1->F1_SERIE+SF1->F1_DOC),.T.,.F.)

xPrefixo := SF1->F1_SERIE
xNumero  := SF1->F1_DOC

DbSelectArea("SD1")
dbSetOrder(1)
dbGoTop()
If dbSeek(xFilial("SD1")+ xNumero + xPrefixo + SF1->F1_FORNECE + SF1->F1_LOJA)
	GefConta := Alltrim(SD1->D1_CONTA)
	GefCusto := Alltrim(SD1->D1_CC)
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Posiciona o Arquivo SF4.                                     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea('SF4')
dbSetOrder(1)
MsSeek(xFilial()+SD1->D1_TES)


// Sem gerar Financeiro
If !xDUPLIC
	Return
Endif


@ 190,001 TO 350,420 DIALOG _oDlg1 TITLE "Dados adicionais da Nota : " + SF1->F1_DOC
//@ 005,005 TO 130,180
@ 005,005 TO 060,110
@ 015,010 Say OEMTOANSI("Forma de Pagamento : ")
@ 015,080 Get V_Tipo Picture "@!"
@ 035,010 Say OEMTOANSI("Digite : 1- Boleto 2- Doc 3- Cheque ")
@ 015,120 BMPBUTTON TYPE 01 ACTION CLOSE(_ODLG1)
Activate Dialog _oDlg1 centered


If !Empty(V_Tipo)
	
	// Avalia o(s) Titulo(s) Financeiro e a Nota Fiscal
	//While !Eof() .And. xFilial() == SE2->E2_FILIAL .And. xPrefixo == SE2->E2_PREFIXO .And.  xNumero == SE2->E2_NUM
	DbSelectArea("SE2")
//	DbSetOrder(1)
	DbSetOrder(6)	
	// DbSeek(xFilial("SE2")+SF1->F1_SERIE+SF1->F1_DOC)
	dbSeek(xFilial("SE2")+SF1->F1_FORNECE+SF1->F1_LOJA+SF1->F1_SERIE+SF1->F1_DOC)
	While !Eof() .and. SE2->E2_FORNECE+SE2->E2_LOJA+SE2->E2_PREFIXO+SE2->E2_NUM ==  SF1->F1_FORNECE + SF1->F1_LOJA + SF1->F1_SERIE + SF1->F1_DOC
		If Reclock("SE2",.F.)
			Replace SE2->E2_FORMPAG    With  V_Tipo
			Replace SE2->E2_CCONT      With  GefCusto
			Replace SE2->E2_CONTAD     With  GefConta
			MsUnlock()
		Endif
		DbSkip()
	Enddo
	
Endif

DbSelectArea(V_Alias)
DbSetOrder(V_Order)
//If V_Recno > 0
//   DbGoto(V_Recno)
//Endif

aAreaSE2	:= SE2->(GetArea())
aArea		:= GetArea()

// Pontera no SE2 e soma todos os impostos que realmente foram gerados
DbSelectArea("SE2")
DbSetOrder(6)
DbSeek(xFilial("SE2")+SF1->F1_FORNECE+SF1->F1_LOJA+SF1->F1_PREFIXO+SF1->F1_DOC)
// Busca Todas as parcelas do Titulos para verificar valor de impostos total
nTotCof:=0
nTotCsl:=0
nTotPis:=0
Do While xFilial("SE2")+SE2->E2_FORNECE+SE2->E2_LOJA+SE2->E2_PREFIXO+SE2->E2_NUM==xFilial("SE2")+SF1->F1_FORNECE+SF1->F1_LOJA+SF1->F1_PREFIXO+SF1->F1_DOC
	nTotCof	+=SE2->E2_VRETCOF
	nTotCsl	+=SE2->E2_VRETCSL
	nTotPis	+=SE2->E2_VRETPIS
	DbSkip()
EndDo
// Grava no SF1 valor total de Impostos que gerarão titulos
RecLock("SF1",.F.)
SF1->F1_VALCOF	:=nTotCof
SF1->F1_VALPIS	:=nTotPis
SF1->F1_VALCSLL	:=nTotCsl
MsUnlock()

RestArea(aAreaSE2)
RestArea(aArea)

Return
