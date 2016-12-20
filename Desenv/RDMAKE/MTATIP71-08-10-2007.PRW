#include "rwmake.ch"        
#include "tOPCONN.ch"

User Function MTATIP71(lEnt1,lEnt2,aArray1,aArray2,aArray3,aArray4)    
Local aArea := GetArea()
Local aArray := ParamIxb
Local cCnpjCPf := ""
                                        

/*Private V_Alias,V_Order

V_Alias := Alias()
V_Order := IndexOrd()*/

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ make data for file temp                                      ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
  /*
   dbSelectArea("R71")
   Reclock("R71",.T.)
    R71->A71_CGCTOM  := 
    R71->A71_IETOM   := 
    R71->A71_DTCONH  :=    
    R71->A71_UFTOM   :=    
    R71->A71_MODCON  :=    
    R71->A71_SERCON  :=    
    R71->A71_SUBCON  :=    
    R71->A71_NUMCON  :=    
    R71->A71_UFREM   :=    
    R71->A71_CGCREM  :=    
    R71->A71_IEREM   :=    
    R71->A71_DTNOTA  :=    
    R71->A71_MODNOT  :=    
    R71->A71_SERNOT  :=  
    R71->A71_NUMNOT  :=    
    R71->A71_VALNOT  :=        
   Msunlock()
*/    
if AllTrim(aArray[2][1][5]) == '5359' .or. AllTrim(aArray[2][1][5]) == '6359'
	RestArea(aArea)
	Return
Endif

dbSelectArea("SZ5")    
DbSetOrder(1)                                           
//Deve ser implentado a série do CTRC também
//If DbSeek(xFilial("SZ5")+SF3->F3_NFISCAL+SF3->F2_SERIE)

If DbSeek(xFilial("SZ5")+AllTrim(aArray[2][1][1]))
//    While !Eof() .And. SZ5->Z5_FILIAL+SZ5->Z5_CTRC+ SZ5->Z5_SERCTR == SF3->F3_FILIAL+SF3->F2_NFISCAL+SF3->F2_SERIE
    While !Eof() .And. SZ5->Z5_CTRC == AllTrim(aArray[2][1][1]) .And. SZ5->Z5_FILIAL == xFilial("SZ5")
/*		SZ5->Z5_FILIAL  := _cFilial
	    SZ5->Z5_CGCREM  := xTipoCgc
	    SZ5->Z5_SERIE   := cSerNf
	    SZ5->Z5_NUM     := cNumNf
	    SZ5->Z5_VALOR   := nValnf
	    SZ5->Z5_DTNOTA  := dDataNf
	    SZ5->Z5_CTRC    := cDoc
	    SZ5->Z5_SERCTR  := cSerie	*/
	
        DbSelectArea("SA1")         
        DbSetOrder(1)
        DbSeek(xFilial("SA1")+AllTrim(aArray[2][1][3])+AllTrim(aArray[2][1][4]))
        
        //SA1->(dbSeek(xFilial("SA1")+(cAliasDT6)->DT6_CLIDEV+(cAliasDT6)->DT6_LOJDEV))

/*		R70->A70_EMISS	:=	aArrayF3[1][10]
		R70->A70_MODELO	:=	AModNot(aArrayF3[1][7])
		R70->A70_SERIE	:=	Substr(aArrayF3[1][2],1,1)
		R70->A70_SUBSER	:=  Substr(aArrayF3[1][2],2,2)
		R70->A70_NFISC	:=	aArrayF3[1][1]
		R70->A70_CFOP	:=	aArrayF3[1][5]
		R70->A70_SITUAC	:=	"S"						   */
   	
	   	Reclock("R71",.T.)
	   	R71->A71_CGCTOM := SA1->A1_CGC
		R71->A71_IETOM  := aRETDIG(SA1->A1_INSCR,.T.)
		R71->A71_DTCONH := aArray[2][1][10] 
		R71->A71_UFTOM  := SA1->A1_EST
		R71->A71_MODCON := AModNot(aArray[2][1][7])
		R71->A71_SERCON := Substr(aArray[2][1][2],1,1)
		R71->A71_SUBCON := Substr(aArray[2][1][2],2,2)
		R71->A71_NUMCON := aArray[2][1][1]
/*		Do Case 
		   Case (cAliasDT6)->DT6_DEVFRE == "1" //Remetente
			   SA1->(dbSeek(xFilial("SA1")+(cAliasDT6)->DT6_CLIDES+(cAliasDT6)->DT6_LOJDES))
		   Case (cAliasDT6)->DT6_DEVFRE == "2" //Destinatario
			   SA1->(dbSeek(xFilial("SA1")+(cAliasDT6)->DT6_CLIREM+(cAliasDT6)->DT6_LOJREM))
		   Case (cAliasDT6)->DT6_DEVFRE == "3" //Consignatario
			   SA1->(dbSeek(xFilial("SA1")+(cAliasDT6)->DT6_CLICON+(cAliasDT6)->DT6_LOJCON))
		   Case (cAliasDT6)->DT6_DEVFRE == "4" //Despachante
			   SA1->(dbSeek(xFilial("SA1")+(cAliasDT6)->DT6_CLIDPC+(cAliasDT6)->DT6_LOJDPC))							   							   						
		EndCase*/

//		R71->A71_UFREM  := SA1->A1_EST
		R71->A71_CGCREM := SA1->A1_CGC
		R71->A71_IEREM  := aRETDIG(SA1->A1_INSCR,.T.)
		
//		If CGC(strzero(SZ5->Z5_CGCREM,14)) 
        DbSelectArea("SA1")    
        DbSetOrder(3)
//		If CGC(replicate("0",14 - len(AllTrim(SZ5->Z5_CGCREM)))+AllTrim(SZ5->Z5_CGCREM)) 
//			cCnpjCPf := strzero(SZ5->Z5_CGCREM,14)
			cCnpjCPf := replicate("0",14 - len(AllTrim(SZ5->Z5_CGCREM)))+AllTrim(SZ5->Z5_CGCREM)						
			
	        IF DbSeek(xFilial("SA1")+cCnpjCPf)        
				R71->A71_UFREM  := SA1->A1_EST
				R71->A71_CGCREM := SA1->A1_CGC
				R71->A71_IEREM  := aRETDIG(SA1->A1_INSCR,.T.)
			Else
				cCnpjCPf := ""
			EndIF
				
//		EndIF	
//		If CGC(strzero(SZ5->Z5_CGCREM,11)) .And. Empty(cCnpjCPf)                                
//		If CGC(replicate("0",11 - len(AllTrim(SZ5->Z5_CGCREM)))+AllTrim(SZ5->Z5_CGCREM)) .And. Empty(cCnpjCPf)                            
		If Empty(cCnpjCPf)                            
//			cCnpjCPf := CGC(strzero(SZ5->Z5_CGCREM,11))                                                                 
			cCnpjCPf := replicate("0",11 - len(AllTrim(SZ5->Z5_CGCREM)))+AllTrim(SZ5->Z5_CGCREM)									

	        IF DbSeek(xFilial("SA1")+cCnpjCPf)        
				R71->A71_UFREM  := SA1->A1_EST
				R71->A71_CGCREM := SA1->A1_CGC
				R71->A71_IEREM  := aRETDIG(SA1->A1_INSCR,.T.)
			Else
				cCnpjCPf := ""
			EndIF
			
		EndIF
		
/*        DbSelectArea("SA1")    
        DbSetOrder(3)
//        IF DbSeek(xFilial("SA1")+SZ5->Z5_CGCREM)
        IF DbSeek(xFilial("SA1")+cCnpjCPf)        
			R71->A71_UFREM  := SA1->A1_EST
			R71->A71_CGCREM := SA1->A1_CGC
			R71->A71_IEREM  := aRETDIG(SA1->A1_INSCR,.T.)
		ElseIf !Empty(SZ5->Z5_EST) 
			R71->A71_UFREM  := SZ5->Z5_EST
//			R71->A71_CGCREM := SZ5->Z5_CGCREM
			R71->A71_CGCREM := cCnpjCPf
			R71->A71_IEREM  := aRETDIG(SZ5->Z5_INSCR,.T.)
		EndIF                      */

		If Empty(R71->A71_UFREM)
			cQuery := "SELECT * FROM remetente WHERE ltrim(rtrim(str(convert(decimal(15, 0), replace(rtrim(ltrim('"+AllTrim(SZ5->Z5_CGCREM)+"')), ' ', '')), 15, 0))) = cnpj "
			TCQUERY cQuery ALIAS "_REM" NEW
			If !Empty(_REM->CNPJ)
				R71->A71_UFREM  := _REM->UF
				R71->A71_CGCREM := SZ5->Z5_CGCREM
				R71->A71_IEREM  := aRETDIG(IIF(Empty(_REM->INSCRICAO),"ISENTO",_REM->INSCRICAO),.T.)
    		EndIF
			dbSelectARea("_REM")
			dbCloseArea()
        EndIF

		If Empty(R71->A71_UFREM) .And. !Empty(SZ5->Z5_EST) 
			R71->A71_UFREM  := SZ5->Z5_EST
			R71->A71_CGCREM := SZ5->Z5_CGCREM
			R71->A71_IEREM  := aRETDIG(SZ5->Z5_INSCR,.T.)
        EndIF

		If Empty(R71->A71_UFREM)
	        DbSelectArea("SA1")         
	        DbSetOrder(1)
	        DbSeek(xFilial("SA1")+AllTrim(aArray[2][1][3])+AllTrim(aArray[2][1][4]))
//			R71->A71_UFREM  := SA1->A1_EST
//			If alltrim(R71->A71_UFREM) == "EX"
//			If alltrim(SA1->A1_EST) == "EX"
			//SELECT * FROM NF_CTRC_ADHOC where LNGNF = 6073
				cQry:="SELECT ZM_ADFIL "
				cQry+="  FROM "+RetSqlName("SZM")
				cQry+=" WHERE ZM_FILIAL = '"+SZ5->Z5_FILIAL+"'"
				cQry+="   AND D_E_L_E_T_ <> '*'"
				TcQuery cQry Alias "TZM" New
					cFilAd:=TZM->ZM_ADFIL
				dbCloseArea()				
				cQuery:= "SELECT NUMCGCREMETENTE "
				cQuery+= "  FROM NF_CTRC_ADHOC"
				cQuery+= " WHERE LNGPOLOCOLETA = "+cFilAd
				cQuery+="    AND LNGNF =   "+alltrim(str(val(SZ5->Z5_NUM)))
				cQuery+= "   AND LNGCTRC = "+alltrim(str(val(SZ5->Z5_CTRC)))
				TcQuery cQuery Alias "CTRC_ADHOC" New
				cCgcRem:=""
				If !Eof()
					cCgcRem:=CTRC_ADHOC->NUMCGCREMETENTE

	// por Marcelo A. Pimentel 12/06/07
	// para verificar quais notas no AdHoc estão com 7 digitos para poder alterar na tabela NF_CTRC_ADHOC
	// caso apresente probblema.
	//				If Empty(cCgcRem)
	//					ApMsgInfo(SZ5->Z5_NUM,"Z5_NUM")
	//					ApMsgInfo(SZ5->Z5_CTRC,"Z5_CTRC")
	//					cCgcRem:="ERRO"
	//				EndIf
//					dbCloseArea()
					cQuery := "SELECT * "
					cQuery += "  FROM remetente "
	//				cQuery += " WHERE ltrim(rtrim(str(convert(decimal(15, 0), replace(rtrim(ltrim('"+AllTrim(SZ5->Z5_CGCREM)+"')), ' ', '')), 15, 0))) = cnpj "
					cQuery += " WHERE ltrim(rtrim(str(convert(decimal(15, 0), replace(rtrim(ltrim('"+AllTrim(cCgcRem)+"')), ' ', '')), 15, 0))) = cnpj "
					TCQUERY cQuery ALIAS "_REM" NEW
					If !Empty(_REM->CNPJ)
						R71->A71_UFREM  := _REM->UF
						R71->A71_CGCREM := _REM->CNPJ
						R71->A71_IEREM  := aRETDIG(IIF(Empty(_REM->INSCRICAO),"ISENTO",_REM->INSCRICAO),.T.)
					EndIf				
					dbSelectARea("_REM")
					dbCloseArea()
					
				Else
					R71->A71_UFREM  := SA1->A1_EST
					R71->A71_CGCREM := SA1->A1_CGC
					R71->A71_IEREM  := aRETDIG(SA1->A1_INSCR,.T.)
							
	    		EndIF
				dbSelectARea("CTRC_ADHOC")
				dbCloseArea()
//			EndIf
			
        EndIF

		If Empty(SZ5->Z5_DTNOTA)
			R71->A71_DTNOTA := aArray[2][1][10] 				
		Else
			R71->A71_DTNOTA := SZ5->Z5_DTNOTA		
		EndIF
		R71->A71_MODNOT := "01"
//		R71->A71_SERNOT := DTC->DTC_SERNFC
		R71->A71_NUMNOT := SZ5->Z5_NUM
		R71->A71_VALNOT := SZ5->Z5_VALOR
		DbSelectArea("SZ5")
		DbSkip()
	End

EndIF

/*DbSelectArea(V_Alias)
DbSetOrder(V_Order)*/
RestArea(aArea)

Return