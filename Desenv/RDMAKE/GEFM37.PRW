#include "rwmake.ch"   

User Function M460NUM() 

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  � GEFM37    � SAULO MUNIZ                  � Data �  . .     ���
�������������������������������������������������������������������������Ĵ��
���Descri��o �  							              		          ���
�������������������������������������������������������������������������Ĵ��
���Utilizacao� Especifico para GEFCO                                      ���
�������������������������������������������������������������������������Ĵ��
���   DATA   � Programador   �Manutencao Efetuada                         ���
�������������������������������������������������������������������������Ĵ��
��� 20/06/03 � Saulo         �                                            ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

_mOldArea	:=	Alias()
_mOldInde	:=	IndexOrd()
_mOldRecn	:=	Recno()

xPedido := ParamIxb[1,1]
xItem   := ParamIxb[1,2]
xSeq    := ParamIxb[1,3]
//MsgInfo(xPedido+"-"+xItem+"-"+xSeq)

//DbSelectArea("SC9")
//xPed := SC9->C9_PEDIDO

DbSelectArea("SC5")
DbsetOrder(1)
DbSeek(xFilial()+xPedido)

//MsgStop(cNumero+"-"+cSerie+" | "+SC5->C5_GEFSER+"-"+SC5->C5_GEFDOC)

cNumero := SC5->C5_GEFDOC
cSerie  := SC5->C5_GEFSER  

If Empty(cNumero)
	MsgInfo('Escolha um serie !')
	_lSerie := Sx5NumNota(cSerie)
	Return
Endif

DbSelectArea(_mOldArea)
DbSetOrder(_mOldInde)
DbGoto(_mOldRecn)

Return