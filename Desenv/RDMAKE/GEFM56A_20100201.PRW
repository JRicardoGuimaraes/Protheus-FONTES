#include "rwmake.ch"    
#include "topconn.ch"
#INCLUDE "tbiconn.ch"

/**********************************************************************
* Programa.......: GEFM56A()                                          *
* Autor..........: Marcelo Aguiar Pimentel                            *
* Data...........: 30/03/07                                           *
* Descricao......: Importação de Nota Fiscal - CTRC                   *
*                                                                     *
***********************************************************************
* Modificado por.:                                                    *
* Data...........:                                                    *
* Motivo.........:                                                    *
*                                                                     *
**********************************************************************/

User Function GEFM56S()
	u_gefm56x(.t.)
Return

User Function GEFM56X(lAutoI)
Private lAutoImp:=iif(lAutoI = Nil,.f.,lAutoI)

If !lAutoImp
	If MsgYesNo("Esta rotina irá fazer a Importação de Nota Fiscal - CTRC para o Microsiga."+chr(10)+"Deseja continuar?","Atenção!")
		Processa({|| RunImp() },"Importando notas...")
	EndIf
Else
	RPCSetType(3) // Nao consome o numero de licencas
	PREPARE ENVIRONMENT EMPRESA "01" FILIAL "01" MODULO "FIN" TABLES "SZ5","SZM"
	Processa({|| RunImp() },"Importando notas...")
	RESET ENVIRONMENT
EndIf
Return
/*****************************************************************************
* Funcao....: RunImp()                                                       *
* Autor.....: Marcelo Aguiar Pimentel                                        *
* Data......: 30/03/07                                                       *
* Descricao.: Importa Nota Fiscal CTRC                                       *
*                                                                            *
*****************************************************************************/
Static Function RunImp()
******************************************************************************
Local _nCntReg := 0

dbSelectArea("SZ5")
dbSetOrder(1)

dbSelectArea("SZM")
dbSetOrder(1)

CONOUT("Montando lista para importar!!!")

cQry:="SELECT * FROM NF_CTRC_ADHOC"
cQry+=" WHERE FLGIMPORTADO = 'N'"
//Essas duas linhas foram utilizadas somente na base teste.
//cQry+="   AND LNGCTRC >='175660'"
//cQry+="ORDER BY LNGCTRC"

TcQuery cQry Alias "TRB" New

TcSetField("TRB","NUMPESO","N",TamSX3("Z5_PESO")[1])

ProcRegua(RecCount()) // Numero de registros a processar

CONOUT("Início de importação!!!")
dbGoTop()
    	
While !Eof()
	dbSelectArea("SZM")
	dbSeek(ALLTRIM(STR(TRB->LNGPOLOCOLETA)))
	_cFilial:=SZM->ZM_FILIAL
	dbSelectArea("TRB")	    	
//  	CONOUT("Filial : " + _cFilial  + "  Nota : "+alltrim(str(TRB->LNGCTRC)))
   	IncProc("Filial : " + _cFilial  + "  Nota : "+alltrim(str(TRB->LNGCTRC)))
   	
	xDoc	 	:= alltrim(STRZERO(TRB->LNGCTRC,6))
	cDoc     	:= IIf(Len(xDoc) < 6,"0"+xDoc,xDoc)
	cSerie   	:= SZM->ZM_SERCTRC // Space(3) - Por: J Ricardo - Em: 08/10/2007 - Passou a tratar série
    xTipoCgc 	:= ""
    cSerNf   	:= ""
    cNumNf   	:=	alltrim(str(TRB->LNGNF))
    dDataNf  	:= stod(TRB->DTAEMISSAO)
    nValnf   	:= TRB->NUMTOTALNF
    cCgcRem  	:= TRB->NUMCGCREMETENTE
    cCgcDest 	:= TRB->NUMCGCDESTINATARIO
    cCgcConsig	:= TRB->NUMCGCCONSIGNA
    cTomador 	:= TRB->INTFRETE
    cCgcTomador := ""
    nPeso		:= TRB->NUMPESO
    // R/D/C
    Do Case 
    	Case Alltrim(cTomador) == "R" 
        	xTipoCgc  := cCgcDest
			cCgcTomador := cCgcRem
	  	Case Alltrim(cTomador) == "D" 
    		xTipoCgc  := cCgcRem	    
			cCgcTomador := cCgcDest	
	  	Case Alltrim(cTomador) == "C" 
    		xTipoCgc  := cCgcDest	       	
			cCgcTomador := cCgcConsig
	  	OtherWise
    		xTipoCgc  := ""
	EndCase
        
	dbSelectArea("SZ5")
	If !dbSeek(_cFilial + cDoc + cNumNf )
    	dbSelectArea("SZ5")
    	Reclock("SZ5",.T.)
     		SZ5->Z5_FILIAL  := _cFilial
            SZ5->Z5_CGCREM  := xTipoCgc
        	SZ5->Z5_SERIE   := cSerNf
    		SZ5->Z5_NUM     := cNumNf
    		SZ5->Z5_VALOR   := nValnf
    		SZ5->Z5_DTNOTA  := dDataNf
    		SZ5->Z5_CTRC    := cDoc
    		SZ5->Z5_SERCTR  := cSerie	
    		SZ5->Z5_TOMADOR	:= cTomador
    		SZ5->Z5_CGCTOMA := 	cCgcTomador
    		SZ5->Z5_PESO	:= nPeso
    	Msunlock()        
	Endif

	_nCntReg++
        
	DbselectArea("TRB")
	Dbskip()

EndDo

CONOUT("Atualizando Log!!!")

cQry:="UPDATE NF_CTRC_ADHOC "
cQry+="   SET FLGIMPORTADO = 'S'"
cQry+=" WHERE FLGIMPORTADO = 'N'"
TcSQLExec(cQry)
TcSQLExec("COMMIT")

CONOUT("Final de importação!!!")
CONOUT("Foram importados " + StrZero(_nCntReg,10))

dbSelectArea("TRB")
dbCloseArea()
Return