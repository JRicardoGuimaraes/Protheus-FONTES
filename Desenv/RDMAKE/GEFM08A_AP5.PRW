#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 18/10/00

User Function GEFM08A()        // incluido pelo assistente de conversao do AP5 IDE em 18/10/00

//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
//� Declaracao de variaveis utilizadas no programa atraves da funcao    �
//� SetPrvt, que criara somente as variaveis definidas pelo usuario,    �
//� identificando as variaveis publicas do sistema utilizadas no codigo �
//� Incluido pelo assistente de conversao do AP5 IDE                    �
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�

SetPrvt("_VSENHA,")

/*/
複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複�
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇�
굇旼컴컴컴컴컴컴컴컴컴컫컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컫컴컴컴컴컴컴컴컴엽�
굇쿑uncao    : GEFM08A � Autor : Saulo                   � Data :18/08/00 낢�
굇쳐컴컴컴컴컴컴컴컴컴컨컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컨컴컴컴컴컴컴컴컴눙�
굇쿏escricao : Programa pesquisa de titulos (pagar)                       낢�
굇읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴袂�
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇�
賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽�
/*/

_vsenha := 0

  @ 000,000 To 100,360 Dialog Gefm08 Title "Pesquisa Por Valor"
  @ 015,010 Say "Digite o Valor : "
  @ 015,050 Get  _vSenha Picture "@e 9,999,999,999.99"
  @ 035,050 BmpButton Type 1 Action bOk()// Substituido pelo assistente de conversao do AP5 IDE em 18/10/00 ==>   @ 035,050 BmpButton Type 1 Action Execute(bOk)
  @ 035,110 BmpButton Type 2 Action Close(Gefm08)
  Activate Dialog Gefm08 Centered
  Close(Gefm08)

RETURN

// Substituido pelo assistente de conversao do AP5 IDE em 18/10/00 ==> Function bOk
Static Function bOk()
************
DbSelectArea("SE2")
DbSetOrder(10)
DbgoTop()
Dbseek(xFilial("SE2")+STR(_VSENHA,17,2))
//Dbseek(xFilial("SE2")+TRANSFORM(_VSENHA,"99999999999.99"))
Close(Gefm08)
Return

