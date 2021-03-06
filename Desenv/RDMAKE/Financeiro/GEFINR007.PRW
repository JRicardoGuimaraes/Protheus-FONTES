#INCLUDE "rwmake.ch"
#INCLUDE "TOPCONN.ch"
/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  GEFIN006     � Autor � Marcos Furtado   � Data �  13/06/06   ���
�������������������������������������������������������������������������͹��
���Descricao � Relatorio de Fornecedores Ativos                           ���
���          � 															  ���
�������������������������������������������������������������������������͹��
���Uso       � Financeiro                                                 ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

User Function GEFINR007()


//���������������������������������������������������������������������Ŀ
//� Declaracao de Variaveis                                             �
//�����������������������������������������������������������������������

Local cDesc1         := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2         := "de Fornecedores ativos.                            "
Local cDesc3         := "riodo de acordo com o parametro."
Local cPict          := ""
Local titulo       := "Relatorio de Fornecedores Ativos"
Local nLin         := 80

Local Cabec1       := "Codigo Loja     Tipo CNPJ/CPF          Nome do Cliente"
Local Cabec2       := ""
Local imprime      := .T.
Local aOrd := {}
Private lEnd         := .F.
Private lAbortPrint  := .F.
Private CbTxt        := ""
Private limite           := 132
Private tamanho          := "M"
Private nomeprog         := "GEFINR007" // Coloque aqui o nome do programa para impressao no cabecalho
Private nTipo            := 15
Private aReturn          := { "Zebrado", 1, "Administracao", 1, 2, 1, "", 1}
Private nLastKey        := 0
Private cPerg       := "GEFN07"
Private cbtxt      := Space(10)
Private cbcont     := 00
Private CONTFL     := 01
Private m_pag      := 01
Private wnrel      := "GEFINR007" // Coloque aqui o nome do arquivo usado para impressao em disco

Private cString := "SE2"

dbSelectArea("SE2")
dbSetOrder(1)

ValidPerg()
pergunte(cPerg,.F.)

//���������������������������������������������������������������������Ŀ
//� Monta a interface padrao com o usuario...                           �
//�����������������������������������������������������������������������

wnrel := SetPrint(cString,NomeProg,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.T.,aOrd,.T.,Tamanho,,.T.)

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
���Fun��o    �RUNREPORT � Autor � AP6 IDE            � Data �  13/06/06   ���
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

Local nOrdem
Local cQuery := "" 
Local nQtd := 0
                  
cQuery  = "SELECT DISTINCT A2_COD, A2_LOJA, A2_TIPO, A2_CGC, A2_NOME  "
cQuery += " FROM " + RetSqlName("SA2") + " SA2, "
cQuery += " " + RetSqlName("SE2") + " SE2  "
cQuery += " WHERE SA2.D_E_L_E_T_ <> '*' AND  "
cQuery += " SE2.D_E_L_E_T_ <> '*' AND  "
cQuery += " A2_FILIAL = '" + xFilial("SA2") + "' AND " 
cQuery += " E2_FORNECE = A2_COD  AND  "
cQuery += " E2_LOJA = A2_LOJA AND  "
cQuery += " E2_FILIAL >= '" + MV_PAR03 + "' AND E2_FILIAL <= '" + MV_PAR04 + "' AND "
cQuery += " E2_EMISSAO >= '" + DTOS(MV_PAR01) + "' AND E2_EMISSAO <= '" + DTOS(MV_PAR02) +"' "
cQuery += " ORDER BY A2_COD, A2_LOJA
TCQuery cQuery ALIAS "TRB" New     

dbSelectArea("TRB")

//���������������������������������������������������������������������Ŀ
//� SETREGUA -> Indica quantos registros serao processados para a regua �
//�����������������������������������������������������������������������

SetRegua(RecCount())

dbGoTop()
While !EOF()

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
   //012345678901234567890123456789012345678901234567890123456789
   //Codigo Loja     Tipo CNPJ/CPF         Nome do Cliente"

   @nLin,00 PSAY TRB->A2_COD
   @nLin,07 PSAY TRB->A2_LOJA
   @nLin,16 PSAY TRB->A2_TIPO
   @nLin,21 PSAY TRB->A2_CGC
   @nLin,38 PSAY TRB->A2_NOME   
   
   nQtd ++
   nLin ++ 
   dbSelectArea("TRB")
   dbSkip() // Avanca o ponteiro do registro no arquivo
   IncRegua()
EndDo      
                     
nLin ++ 
@nLin,00 PSAY "Total de Geral: "+ transform(nQtd,"@E 999999")

dbSelectArea("TRB")
DbCloseArea()

//���������������������������������������������������������������������Ŀ
//� Finaliza a execucao do relatorio...                                 �
//�����������������������������������������������������������������������

SET DEVICE TO SCREEN

//���������������������������������������������������������������������Ŀ
//� Se impressao em disco, chama o gerenciador de impressao...          �
//�����������������������������������������������������������������������

If aReturn[5]==1
   dbCommitAll()
   SET PRINTER TO
   OurSpool(wnrel)
Endif

MS_FLUSH()

Return


***************************
Static Function ValidPerg()
***************************

Local _sAlias := Alias()
Local aRegs := {}
Local i,j

DbSelectArea("SX1")
dbSetOrder(1)
//cPerg := PADR(cPerg,6)
cPerg := PADR(cPerg,LEN(SX1->X1_GRUPO))

Aadd(aRegs,{cPerg,"01","Data de Emissao de ..","","","mv_ch1","D",008,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","",""})
Aadd(aRegs,{cPerg,"02","Data de Emissao Ate..","","","mv_ch2","D",008,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","",""})
Aadd(aRegs,{cPerg,"03","Filial de ...........","","","mv_ch2","C",002,0,0,"G","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","","",""})
Aadd(aRegs,{cPerg,"04","Filial ate...........","","","mv_ch2","C",002,0,0,"G","","mv_par04","","","","","","","","","","","","","","","","","","","","","","","","","",""})

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

DbSelectArea(_sAlias)

Return(.T.)
