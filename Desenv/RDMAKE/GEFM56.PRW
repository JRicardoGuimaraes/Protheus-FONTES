#include "rwmake.ch"    
#include "topconn.ch"
#INCLUDE "tbiconn.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    �GEFM56    � Autor � Saulo Muniz           � Data � 16.06.06 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o �Importacao de notas fiscais  : Sintegra reg.71              ���
���          � ISC                                                        ���
���          � Titulo a Receber                                          ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function GEFM56(_lAutoR)

Private lAutoRot

lAutoRot:=iif(_lAutoR = Nil,.F.,.T.)


If lAutoRot
	// Importa os arquivos do WMS-AR para as tabelas SF1 / SD1
	ConOut("Inicio de importa��o da interface SINTEGRA - SZ5")
	
	// Gera Documento de Entrada no Microsiga dos registros importados do WMS
	RPCSetType(3) // Nao consome o numero de licencas
	PREPARE ENVIRONMENT EMPRESA "01" FILIAL "01" MODULO "FIS" TABLES "SZ5","SA1","SA2","SB1"
	
	Sint71()
	
	ConOut("Final de importa��o da interface SINTEGRA - SZ5")
	
	RESET ENVIRONMENT
Else	
	//���������������������������������������������������������������������Ŀ
	//� Montagem da tela de processamento.                                  �
	//�����������������������������������������������������������������������
	@ 200,001 TO 380,380 DIALOG oLeTxt TITLE OemToAnsi("Leitura de Arquivo Sintegra 71 - SIPCO")
	@ 002,010 TO 080,190
	@ 10,018 Say " Este programa ira ler o conteudo de um arquivo texto, conforme"
	@ 18,018 Say " os parametros definidos pelo usuario, com os registros do arquivo"
	@ 26,018 Say " de Notas Fiscais "
	//@ 40,018 Say "Informe o Layout"
	//@ 40,070 COMBOBOX cTipoarq ITEMS aChoice size 20,10
	@ 60,098 BMPBUTTON TYPE 01 ACTION Processa({|| Sint71() },"Processando....")
	@ 60,128 BMPBUTTON TYPE 02 ACTION Close(oLeTxt)
		
	Activate Dialog oLeTxt Centered
EndIf

Return

Static Function Sint71()  // Vers�o VA2/VA3

//���������������������������������������������������������������������Ŀ
//� Abertura do arquivo texto                                           �
//�����������������������������������������������������������������������

cPathori := "\Importar\Sintegra\SIPCO\"
cTipo    := "*.TXT"
aFiles   := Directory(cPathOri + cTipo)

If !lAutoRot
	Close(oLeTxt)
EndIf	

For a := 1 To Len(aFiles)
	
	aCampos:={}
	AADD(aCampos,{ "LINHA" ,"C",400,0 })
	cNomArq := CriaTrab(aCampos)
	
	If (Select("TRB") <> 0)
		dbSelectArea("TRB")
		dbCloseArea("TRB")
	Endif
	dbUseArea(.T.,,cNomArq,"TRB",nil,.F.)
	
	If !File(Alltrim("\Importar\Sintegra\SIPCO\" + aFiles[a][1]))
		If lAutoRot
			ConOut("Arquivo texto nao existente.Programa cancelado.")
		Else	
			MsgBox("Arquivo texto nao existente.Programa cancelado","Informa��o","INFO")
		EndIf	
		Return
	Endif
	
	dbSelectArea("TRB")
	Append From (Alltrim("\Importar\Sintegra\SIPCO\" + aFiles[a][1])) SDF
	
	//���������������������������������������������������������������������Ŀ
	//� Inicializa a regua de processamento                                 �
	//�����������������������������������������������������������������������
	
	Processa({|| RunCont() },"Processando...")
	
	//���������������������������������������������������������������������Ŀ
	//� Copia o arquivo de trabalho e depois apaga                         �
	//�����������������������������������������������������������������������
	
	If File("\Importar\Sintegra\SIPCO\" + aFiles[a][1])
		__CopyFile("\Importar\Sintegra\SIPCO\" + aFiles[a][1],"\Importar\Sintegra\SIPCO\Antigos\" + aFiles[a][1])
		Ferase("\Importar\Sintegra\SIPCO\" + aFiles[a][1])
	Endif
	
Next

//MsgBox("Importacao concluida!!","Informacao","INFO")

Return


Static Function RunCont()


dbSelectArea("TRB")
//dbSetOrder(1)
ProcRegua(RecCount()) // Numero de registros a processar
dbGoTop()

While !Eof()

	If lAutoRot    	
   		ConOut("Filial : " + Alltrim(Substr(TRB->LINHA,07,05))  + "  Nota : "+Substr(TRB->LINHA,51,06))
	Else
   		IncProc("Filial : " + Alltrim(Substr(TRB->LINHA,07,05))  + "  Nota : "+Substr(TRB->LINHA,51,06))   	
   	EndIf	

	//���������������������������������������������������������������������Ŀ
	//� Grava os campos obtendo os valores da linha lida do arquivo texto.  �
	//�����������������������������������������������������������������������			
	//If cDoc+cSerie <> Substr(TRB->LINHA,20,06)+Substr(TRB->LINHA,26,03) .And. !Empty(cDoc)
	//Endif
        cAborta := .F.        
        xDoc     := PadR(Alltrim(Substr(TRB->LINHA,12,06)),09)
		cDoc     := IIf(Len(xDoc) < 6,"0"+xDoc,xDoc)  //Substr(TRB->LINHA,54,06)	    
		cSerie   := Space(3) //Substr(TRB->LINHA,26,03)	    
        xTipoCgc := ""
        cSerNf   := Substr(TRB->LINHA,04,03) 
        cNumNf   :=	Substr(TRB->LINHA,51,06)      
        dDataNf  := Ctod(Substr(TRB->LINHA,57,02) + "/" + Substr(TRB->LINHA,59,02) + "/" + Substr(TRB->LINHA,61,04)) 
        //dDataNf  := Ctod(Substr(TRB->LINHA,57,08)) 
        nValnf   := Val(Alltrim(Substr(TRB->LINHA,65,15))) 
//        cCgcRem  := Alltrim(Substr(TRB->LINHA,21,15)) 
        cCgcRem  := Alltrim(Substr(TRB->LINHA,21,14))         //Altera��o - Marcos Furtado - 10/08/2006  
//      cCgcDest := Alltrim(Substr(TRB->LINHA,54,15))                                              
//        cCgcDest := Alltrim(Substr(TRB->LINHA,36,15))   //Altera��o - Marcos Furtado - 09/08/2006  
        cCgcDest := Alltrim(Substr(TRB->LINHA,36,14))   //Altera��o - Marcos Furtado - 10/08/2006  
        _cFilial  := Alltrim(Substr(TRB->LINHA,07,05)) 
        //cCgcFim  := Alltrim(Substr(TRB->LINHA,,06))         
        cTomador := Alltrim(Substr(TRB->LINHA,79,02)) 
        // R/D/C
         
        If _cFilial == "02" .AND. dDataNF >= cTOd("01/07/08") .AND. dDataNF < cTOd("18/12/09")
        	// Tratamento para Filial Nova Pavuna que no SIPCO o c�digo � 02(antiga Beneditinos) - Por: Ricardo - Em: 14/10/10        
        	_cFilial := "16" // Porto do Rio
        	
        ElseIf _cFilial == "02" .AND. dDataNF >= cTOd("18/12/09")
        	// Tratamento para Filial Porto do Rio que no SIPCO o c�digo � 02(antiga Beneditinos) - Por: Ricardo - Em: 14/10/10        
        	_cFilial := "18" // Porto do Rio
        	
        EndIf
        	
        Do Case 
           Case Alltrim(cTomador) == "R" 
                xTipoCgc  := cCgcDest
	       Case Alltrim(cTomador) == "D" 
                xTipoCgc  := cCgcRem	    
	       Case Alltrim(cTomador) == "C" 
                //xTipoCgc  := ""	       // ???
                xTipoCgc  := cCgcDest	       	
	       OtherWise
                xTipoCgc  := ""

        EndCase
        
		dbSelectArea("SZ5")
		dbSetOrder(1)
		dbGoTop()
		If dbSeek(_cFilial + cDoc + cNumNf )
			//MsgBox("Nota Fiscal ja importada: " + cDoc + " Opera��o Cancelada ! ","Informacao","INFO")
    		Reclock("SZ5",.F.)
//     		SZ5->Z5_FILIAL  := _cFilial
            SZ5->Z5_CGCREM  := xTipoCgc
//        	SZ5->Z5_SERIE   := cSerNf
//	    	SZ5->Z5_NUM     := cNumNf
//    		SZ5->Z5_VALOR   := nValnf / 100
//	    	SZ5->Z5_DTNOTA  := dDataNf
/*    		SZ5->Z5_CTRC    := cDoc
    		SZ5->Z5_SERCTR  := cSerie	*/
	    	Msunlock()        
    		dbSelectArea("TRB")    		
			cAborta := .T.
		    DbSkip()
		    Loop
		Endif
		
		If !cAborta	
    		dbSelectArea("SZ5")
    		Reclock("SZ5",.T.)
     		SZ5->Z5_FILIAL  := _cFilial
            SZ5->Z5_CGCREM  := xTipoCgc
        	SZ5->Z5_SERIE   := cSerNf
	    	SZ5->Z5_NUM     := cNumNf
    		SZ5->Z5_VALOR   := nValnf / 100
	    	SZ5->Z5_DTNOTA  := dDataNf
    		SZ5->Z5_CTRC    := cDoc
    		SZ5->Z5_SERCTR  := cSerie	
	    	Msunlock()        
        
        Endif
        
		DbselectArea("TRB")
		Dbskip()

End

//fClose(nHdl)

//MsgInfo("Importacao Concluida com Sucesso !!")
DBCLOSEAREA("TRB")
       
Return