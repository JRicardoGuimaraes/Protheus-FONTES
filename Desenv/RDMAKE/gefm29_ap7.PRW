#include "rwmake.ch"        // incluido pelo assistente de conversao do AP6 IDE em 15/02/04

User Function gefm29()        // incluido pelo assistente de conversao do AP6 IDE em 15/02/04

//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
//� Declaracao de variaveis utilizadas no programa atraves da funcao    �
//� SetPrvt, que criara somente as variaveis definidas pelo usuario,    �
//� identificando as variaveis publicas do sistema utilizadas no codigo �
//� Incluido pelo assistente de conversao do AP6 IDE                    �
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�

SetPrvt("DDATAFEC,XDATAFIN,DTFECHA,")


/*
  複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複
  굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇
  굇旼컴컴컴컴컴컴컴컴컴컫컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴쩡컴컴컴컴컴컴컴커굇
  굇� Programa: Gefm29   � Autor: Saulo Muniz           � Data: 11/02/04 낢�
  굇쳐컴컴컴컴컴컴컴컴컴컨컴컴컴컴컴컴컴컴컫컴컴컴컴컴컴좔컴컴컴컴컴컴컴캑굇
  굇� Empresa:   Gefco do Brasil Ltda      � Usuario: Contabilidade      낢�
  굇쳐컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컨컴컴컴컴컴컴컴컴컴컴컴컴컴컴캑굇
  굇� Descricao: Realiza o Fechamento dos movimentos relativos aos       낢�
  굇� parametros digitados .                                             낢�
  굇읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸굇
  굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇
  賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽
*/

DbSelectArea("SX6")

dDataFec:= GetMV("MV_ULMES")
xDataFin:= GetMV("MV_DATAFIN")
DtFecha := Ddatabase

//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
//� Montagem da tela de processamento.                                  �
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�

   @ 200,1 TO 400,400 DIALOG TelaInicial TITLE OemToAnsi("Rotina de Bloqueio Contabil/Financeiro - Gefco ")
   @ 02,10 TO 080,190
   @ 10,018 Say " Este programa atualiza os arquivos para realizar o processo ,"
   @ 20,018 Say " de bloqueio dos lancamentos de notas fiscais fora do periodo"
   @ 30,018 Say " selecionado. "
   @ 46,018 Say " Digite a data do Bloqueio : "
   @ 65,100 GET DtFecha PICTURE "@D" Size 33,10 
   @ 85,130 BMPBUTTON TYPE 01 ACTION Contas() // Substituido pelo assistente de conversao do AP6 IDE em 15/02/04 ==>    @ 85,130 BMPBUTTON TYPE 01 ACTION Execute(Contas)
   @ 85,160 BMPBUTTON TYPE 02 ACTION Close(TelaInicial)
   Activate Dialog TelaInicial Centered

Return

//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
//� Inicializa a regua de processamento                                 �
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�

// Substituido pelo assistente de conversao do AP6 IDE em 15/02/04 ==> Function Contas
Static Function Contas()
  Processa({|| Atualiza()},"Processando...")// Substituido pelo assistente de conversao do AP6 IDE em 15/02/04 ==>   Processa({|| Execute(Atualiza)},"Processando...")
Return

// Substituido pelo assistente de conversao do AP6 IDE em 15/02/04 ==> Function Atualiza
Static Function Atualiza()

//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
//� Verificar data do ultimo fechamento em SX6.                  �
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
If dDataFec >= dDataBase
      Help( " ", 1, "FECHTO" )
      Return
EndIf

//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
//� Verifica parametro MV_DATAFIN pela data de digitacao.        �
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
If dDataFec >= dDatabase
	Return
Endif


ProcRegua(RecCount())
   
   PutMV("MV_ULMES",DtFecha+1)
   PutMV("MV_DATAFIN",DtFecha+1)
   PutMV("MV_DATADE",DtFecha+1)
        
   IncProc()

   MsgInfo("Fechamento Executado.")
   Close(TelaInicial)

Return
