/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  FLIMPAND  �Autor  �    Marcos Furtado   � Data �  21/07/06   ���
�������������������������������������������������������������������������͹��
���Desc.     � Funcao chamado pela valida��o do campo E2_XGERAND para     ���
���          � limpar o conte�do dos campos referentes a ND.              ���
�������������������������������������������������������������������������͹��
���Uso       � Financeiro                                                 ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function FLIMPAND

If FunName() == 'FINA050'
	If M->E2_XGERAND == 'N' 
		M->E2_XNUMND  := Space(06)
/*		M->E2_XCODND  := Space(05)
		M->E2_XPROCND := Space(11)
		M->E2_XCLIND  := Space(06)
		M->E2_XLOJAND := Space(02)
		M->E2_XVLRND  := 0          */
		M->E2_XVLRFRT := 0          		
	EndIF                               
EndIF

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  HistCPND  �Autor  �    Marcos Furtado   � Data �  14/08/06   ���
�������������������������������������������������������������������������͹��
���Desc.     � Retorna numeros de NDs criadas para o titulo a pagar.      ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Financeiro                                                 ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function HistCPND	
Local cRet := " "

DbSelectArea("SZ7")    
DbSetOrder(1)
DbSeek(xFilial("SZ7")+SE2->E2_NUM+SE2->E2_FORNECE+SE2->E2_LOJA)

While !Eof() .And. SZ7->Z7_FILIAL+SZ7->Z7_NUMTIT+SZ7->Z7_FORNEC+SZ7->Z7_LOJAFOR = xFilial("SZ7")+SE2->E2_NUM+SE2->E2_FORNECE+SE2->E2_LOJA
//	cRet := cRet + alltrim(SZ7->Z7_NUMERO) +", " 	
	cRet := cRet + alltrim(SZ7->Z7_NUMERO)+" " +alltrim(SZ7->Z7_PROC)+", " 	&& Alterado 05/03/08 - adicionado campo Z7_PROC

	DbSelectArea("SZ7")    
	DbSkip()
End	
                                        
cRet := subStr(cRet,1,len(cRet)-2)

Return(cRet)

return(.T.)
                        

