#INCLUDE "rwmake.ch"
/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �GEFCTB17  � Autor � SAULO MUNIZ        � Data �  04/03/06   ���
�������������������������������������������������������������������������͹��
���Descricao � RELATORIO DE FECHAMENTO MENSAL COMPRAS                     ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � GEFCO                                                      ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

User Function GEFCTB17

//���������������������������������������������������������������������Ŀ
//� Declaracao de Variaveis                                             �
//�����������������������������������������������������������������������

Local cDesc1       := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2       := "de acordo com os parametros informados pelo usuario."
Local cDesc3       := "Relatorio Fechamento Por U.O."
Local cPict        := ""
Local nLin         := 80
Local Cabec1       := "| DESCRICAO             |  FORA SEDE  |  SEDE ADM  | BENEDITINOS |   RB 45    |    P.REAL    |   BARUERI    |    PAVUNA   |  VILA GUI.  |  SJ PINHAIS  |  CAMPINAS  |  SEPETIBA  |  V.OLIMPIA  |   SANTOS    | CONTAGEM  |" 
Local Cabec2       := ""
Local imprime      := .T.
Local aOrd         := {}
Private lEnd       := .F.
Private lAbortPrint:= .F.
Private CbTxt      := ""
Private limite     := 132
Private tamanho    := "G"
Private nomeprog   := "GEFCTB10" // Coloque aqui o nome do programa para impressao no cabecalho
Private nTipo      := 18
Private aReturn    := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey   := 0
Private cbtxt      := Space(10)
Private cbcont     := 00
Private CONTFL     := 01
Private m_pag      := 01
Private wnrel      := "GEFCTB10" // Coloque aqui o nome do arquivo usado para impressao em disco
Private cString    := "SZ2"
Private cPerg      := "GEF002"   //"CTR040"

titulo := "COMPRAS GEFCO "

lData := .F.
lHora := .F.
   
//�����������������������������������������������������������������������Ŀ
//� Variaveis utilizadas para parametros								  �
//� mv_par01				// Data Inicial                  	  		  �
//� mv_par02				// Data Final                        		  �
//� mv_par03				// Conta Inicial                         	  �
//� mv_par04				// Conta Final  							  �
//� mv_par05				// Unidade Operacional (U.O.)	        	  �		
//� mv_par06				// Configura��o	(001= Historique; 002= FinRm) �		
//� mv_par07				// Tipo de Processamento    	        	  �		
//� mv_par08				// Progress�o               	        	  �		
//� mv_par09				// Imprime Log (Sim/N�o)       	        	  �		
//�������������������������������������������������������������������������

If !Pergunte(cPerg,.T.)                           // Pergunta no SX1
   Return
EndIf

xMes := MesExtenso(Substr(Dtoc(MV_PAR01),4,2))

// Nome do Departamento no Relat�rio
DbselectArea("SZ1")
DbSetOrder(1) 
Dbgotop()
Dbseek(xFilial("SZ1")+MV_PAR05)
xDescZ1 := Alltrim(SZ1->Z1_DESCR)

 If MV_PAR08 == 1
    titulo  := titulo +"( "+ xDescZ1 +" ) "+xMes
 Else
    titulo  := titulo +"PROGRESS�O ( "+ xDescZ1 +" ) "+xMes 
 Endif
 
//���������������������������������������������������������������������Ŀ
//� Monta a interface padrao com o usuario...                           �
//�����������������������������������������������������������������������
wnrel := SetPrint(cString,NomeProg,"",@titulo,cDesc1,cDesc2,cDesc3,.T.,aOrd,.T.,Tamanho,,.T.)

If nLastKey == 27
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
   Return
Endif

nTipo := If(aReturn[4]==1,15,18)

//���������������������������������������������������������������������Ŀ
//� Processamento. RPTSTATUS monta janela com a regua de processamento. �
//�����������������������������������������������������������������������
RptStatus({|| RunReport(Cabec1,Cabec2,Titulo,nLin) },Titulo)


Return

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Fun��o    �RUNREPORT � Autor � AP6 IDE            � Data �  14/04/05   ���
�������������������������������������������������������������������������͹��
���Descri��o � Funcao auxiliar chamada pela RPTSTATUS. A funcao RPTSTATUS ���
���          � monta a janela com a regua de processamento.               ���
�������������������������������������������������������������������������͹��
���Uso       � Programa principal                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

Static Function RunReport(Cabec1,Cabec2,Titulo,nLin)

xTotal  := 0
xTotalG := 0

nVl1 := 0
nVl2 := 0
nVl3 := 0
nVl4 := 0
nVl5 := 0
nVl6 := 0
nVl7 := 0
nVl8 := 0
nVl9 := 0
nVl10 := 0
nVl11 := 0
nVl12 := 0
nVl13 := 0
nVl14 := 0
nVl15 := 0
nVlFora := 0
nVlForaSede := 0

xDtProc  := " "  
_xLogDt  := {}  
_xLogHr  := {}  
_xLog    := {}  


dbSelectArea("SZ4")
dbSetOrder(1) // 1
dbGoTop()
//Dbseek(xFilial("SZ4")+Alltrim(MV_PAR05))
SetRegua(RecCount())

While !EOF() //.And. Alltrim(SZ4->Z4_COD) ==  Alltrim(MV_PAR05) //.And. SZ2->Z2_CODPLA == "015"

   IncRegua()

   //���������������������������������������������������������������������Ŀ
   //� Verifica o cancelamento pelo usuario...                             �
   //�����������������������������������������������������������������������
   If lAbortPrint
      @nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
      Exit
   Endif
     
   //���������������������������������������������������������������������Ŀ
   //� Impressao do cabecalho do relatorio. . .                            �
   //�����������������������������������������������������������������������
   If nLin > 55 // Salto de P�gina. Neste caso o formulario tem 55 linhas...
      Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
      nLin := 8
   Endif      
  
   
   //@ nlin, 000 PSAY Chr(18)                // Impressao Normal
   @ nlin, 000 PSAY Chr(15)                // Compressao de Impressao

// DE/PARA FILIAL COM C.CUSTO
   xFilCtb := Alltrim(SZ4->Z4_FILORIG)

   Do Case
      Case xFilCtb == "001"
           xFilRet := "MATRIZ"
      Case xFilCtb == "002"
           xFilRet := "BENEDITINOS"
      Case xFilCtb == "004"
           xFilRet :="PORTO REAL"
      Case xFilCtb == "005"
           xFilRet :="BARUERI"
      Case xFilCtb == "006"
           xFilRet :="PAVUNA"
      Case xFilCtb == "007"
           xFilRet :="V.GUILHERME"
      Case xFilCtb == "008"
           xFilRet :="S.J.PINHAIS"
      Case xFilCtb == "009"
           xFilRet :="CONTAGEM"
      Case xFilCtb == "010"
           xFilRet :="CAMPINAS"
      Case xFilCtb == "011"
           xFilRet :="SEPETIBA"
      Case xFilCtb == "012"
           xFilRet :="V.OLIMPIA"
      Case xFilCtb == "013"
           xFilRet :="SANTOS"
      Case xFilCtb == "014"
           xFilRet :="RIO BRANCO"
      Case xFilCtb == "015" // VITORIA N�O LIBERADA NO SISTEMA
           xFilRet :="VITORIA"
      OtherWise	                 
        Msginfo("Filial n�o cadastrada !")
        Return
   EndCase
  
     
   @nLin,001 PSAY Alltrim(SZ4->Z4_DESCR)
   @nLin,045 PSAY xFilRet
   @nLin,050 PSAY SZ4->Z4_ATIVIDA
   @nLin,055 PSAY SZ4->Z4_SALDO   Picture "@E 999,999,999.99"                     

    
     nLin  := nLin + 1 
    xTotal := xTotal + SZ4->Z4_SALDO
           
   dbSelectArea("SZ4")
   dbSkip()          
 
EndDo


 nLin := nLin + 1     
 @nLin,001 PSAY Replicate("-",210)
 nLin := nLin + 2 

//@ nlin, 000 PSAY Chr(18)                // Impressao Normal
@nLin,042 PSAY "Total Geral ..:" 
@nLin,055 PSAY xTotal   Picture "@E 999,999,999,999.99"  

 
  nLin := nLin + 2     
 @nLin,001 PSAY Replicate("-",55)
  nLin := nLin + 1 

SET DEVICE TO SCREEN
If aReturn[5]==1
   dbCommitAll()
   SET PRINTER TO
   OurSpool(wnrel)
Endif
MS_FLUSH()

Return