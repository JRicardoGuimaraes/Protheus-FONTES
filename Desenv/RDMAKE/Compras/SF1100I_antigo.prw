/*
臼麺様様様様謡様様様様様瞥様様様詫様様様様様様様様様擁様様様詫様様様様様様恒�
臼�Programa  �SF1100I   �Autor  � PAPA        � Data �  10/07/07          艮�
臼�Desc.     � Ponto de Entrada apos a gera艫o dos titulos no financeiro  艮�
臼�          � e antes da contabiliza艫o de compras.                      艮�
臼�Uso       � Compras                                                    艮�
臼麺様様様様謡様様様様様瞥様様様詫様様様様様様様様様擁様様様詫様様様様様様恒�
*/


User Function SF1100I()

Local aAreaSE2	:= SE2->(GetArea())
Local aArea		:= GetArea()

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
// Grava no SF1 valor total de Impostos que gerar�o titulos
RecLock("SF1",.F.)
	SF1->F1_VALCOFI	:=nTotCof
	SF1->F1_VALPIS	:=nTotPis
	SF1->F1_VALCSSL	:=nTotCsl
MsUnlock()

RestArea(aAreaSE2)
RestArea(aArea)
Return