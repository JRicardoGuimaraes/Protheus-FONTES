#INCLUDE "rwmake.ch"
#INCLUDE "protheus.ch"
/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �FA280QRY  � Autor � Saulo Muniz        � Data �  18/11/04   ���
�������������������������������������������������������������������������͹��
���Descricao � Destinado a gravacao de dados complementares (especifico   ���
���          � Gefco) na rotina de substituicao Fatura Receber            ���
���          � ( FINA280 )                                                ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP7 - Financeiro / Ctas Receber / Faturas Receber (FINA280)���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
User Function FA280QRY
Local aArea:=GetArea()
Local aAreaSA1:=SA1->(GetArea())
Local cQuery := ""
Local oGetNumCVA
Local oMoldura
Local oNumCVA
Local oSButton1


//���������������������������������������������������������������������Ŀ
//� Declaracao de Variaveis                                             �
//�����������������������������������������������������������������������
//  
Static oDlg

Private cCusto   := Space(10)
Private _cCliMAN := AllTrim(GETNewPar("MV_XCLIMAN","04858701|15882200"))
PRIVATE cGetNumCVA := SPACE(TAMSX3("E1_NUMCVA")[1])

lRet := ""

// Verifica se existe portador - Saulo Muniz ( 18/07/06 )

lRet := " E1_PORTADO = '' "  
dbSelectArea("SA1")
dbSetOrder(1)
dbSeek(xFilial("SA1")+cCli+cLoja)

If SA1->A1_XLIBPG == "2"  //Libera mediante preenchimento do campo SE1->E1_XDTLIB
	lRet+=" AND E1_XDTLIB <> ' ' "
EndIf

// Por: Ricardo Guimar�es - Em: 14/03/14 - Para atender o Projeto MAN
If cCli + cLoja $ _cCliMAN
  DEFINE MSDIALOG oDlg TITLE "Informar Numero do CVA(MAN)" FROM 000, 000  TO 120, 250 COLORS 0, 16777215 PIXEL

    @ 002, 002 GROUP oMoldura TO 043, 116 OF oDlg COLOR 0, 16777215 PIXEL
    @ 014, 007 SAY oNumCVA PROMPT "Informe o N�mero do CVA" SIZE 091, 008 OF oDlg COLORS 0, 16777215 PIXEL
    @ 023, 007 MSGET oGetNumCVA VAR cGetNumCVA SIZE 090, 010 OF oDlg PICTURE "@!" COLORS 0, 16777215 PIXEL
    DEFINE SBUTTON oSButton1 FROM 046, 090 TYPE 01 OF oDlg ENABLE ACTION oDlg:End()

  ACTIVATE MSDIALOG oDlg CENTERED
  
  If !Empty(cGetNumCVA)
  	lRet += " AND E1_NUMCVA = '" + AllTrim(cGetNumCVA) + "' "
  	PUTMV("MV_XNUMCVA",cGetNumCVA)
  EndIf	
EndIf

RestArea(aAreaSA1)
RestArea(aArea)
Return lRet
