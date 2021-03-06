#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 18/10/00

User Function GEFM04A()        // incluido pelo assistente de conversao do AP5 IDE em 18/10/00

//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
//� Declaracao de variaveis utilizadas no programa atraves da funcao    �
//� SetPrvt, que criara somente as variaveis definidas pelo usuario,    �
//� identificando as variaveis publicas do sistema utilizadas no codigo �
//� Incluido pelo assistente de conversao do AP5 IDE                    �
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�

SetPrvt("VNUMFATURA,OLDAREA,OLDORDER,OLDOREC,RECE2,")

/*/
複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複�
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇�
굇旼컴컴컴컴컴컴컴컴컴컫컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컫컴컴컴컴컴컴컴컴엽�
굇쿑uncao    : GEFM04A � Autor : Cicero JS - SP/ZL       � Data :03/04/00 낢�
굇쳐컴컴컴컴컴컴컴컴컴컨컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컨컴컴컴컴컴컴컴컴눙�
굇쿏escricao : Exclusao da Juncao de titulos para a geracao de Faturas    낢�
굇읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴袂�
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇�
賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽�
/*/

vNumFatura := "000000"

@ 000,000 To 200,360 Dialog oGefm04a Title "Separacao da Fatura"
@ 015,010 Say "Numero da Fatura"
@ 015,060 Say ":"
@ 015,066 Get  vNumFatura Size 33,10

@ 080,060 BmpButton Type 1 Action bOk()// Substituido pelo assistente de conversao do AP5 IDE em 18/10/00 ==> @ 080,060 BmpButton Type 1 Action Execute(bOk)
@ 080,120 BmpButton Type 2 Action Close(oGefm04a)
Activate Dialog oGefm03a Centered
Close(oGefm03a)

************

Return(nil)        // incluido pelo assistente de conversao do AP5 IDE em 18/10/00

// Substituido pelo assistente de conversao do AP5 IDE em 18/10/00 ==> Function bOk
Static Function bOk()
************

 OldArea  := Alias()
 OldOrder := IndexOrd()
 OldORec  := Recno()

 Processa({|| SeparaFat()},"Processando...")// Substituido pelo assistente de conversao do AP5 IDE em 18/10/00 ==>  Processa({|| Execute(SeparaFat)},"Processando...")

 DbSelectArea(OldArea)
 DbSetOrder(OldOrder)
 DbGoTo(OldORec)

 Close(oGefm03a)
Return

*****************
// Substituido pelo assistente de conversao do AP5 IDE em 18/10/00 ==> Function SeparaFat
Static Function SeparaFat()
*****************

DbSelectArea("SE2")
ProcRegua(RecCount())
DbSetOrder(1)
DbGoTop()


RecE2 := Recno()

// Localiza a fatura a ser excluida
DbSeek(xFilial()+"FAT"+vNumFatura)

If Found()
   ALERT ("DELETA FATURA: " + SE2->E2_PREFIXO+" "+SE2->E2_NUM)
   RecLock("SE2",.F.)
    Delete
   MsunLock()
Else
   Alert ("Esta fatura nao existe!")
   Return
EndIf

DbSetOrder(14)
DbGoTop()

While !Eof()
 If (SE2->E2_FATURA == vNumFatura)
      //Reverter a baixa...
      Alert ("REVERTER A BAIXA: "+SE2->E2_FATURA + " - CRT "+SE2->E2_NUM)
      RecLock("SE2",.F.)
        SE2->E2_BAIXA   := ctod("  /  /  ")    // dDataBase
        SE2->E2_MOVIMEN := ctod("  /  /  ")    // dDataBase
        SE2->E2_SALDO   := SE2->E2_VALOR         // 0
        SE2->E2_VALLIQ  := 0                     // SE2->E2_valor
        SE2->E2_FATURA  := ""                    // vNumFat
        SE2->E2_OK      := ""                    // "x"
//      SE2->E2_DTFATUR := ctod("  /  /  ")    // dDataBase
//      SE2->E2_STATUS  := "A"               //  "B"
      MsunLock()
  EndIf
  DbSkip()
  IncProc()
EndDo

DbSelectArea("SE2")
DbGoTo(RecE2)

Return
