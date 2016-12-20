#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 18/10/00

User Function GEFL03()        // incluido pelo assistente de conversao do AP5 IDE em 18/10/00

//���������������������������������������������������������������������Ŀ
//� Declaracao de variaveis utilizadas no programa atraves da funcao    �
//� SetPrvt, que criara somente as variaveis definidas pelo usuario,    �
//� identificando as variaveis publicas do sistema utilizadas no codigo �
//� Incluido pelo assistente de conversao do AP5 IDE                    �
//�����������������������������������������������������������������������

SetPrvt("VALIAS,CCONTA,")

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Funcao    : GEFL03  � Autor : Ronaldo Pena            � Data :17/09/99 ���
�������������������������������������������������������������������������Ĵ��
���Descricao : Posicionamento do cliente  para Lancamento Padrao 500      ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

vAlias := Alias()
DbSelectArea("SA1")
DbSetOrder(1)
DbSeek(xFilial("SA1")+SE1->E1_CLIENTE+SE1->E1_LOJA)
cConta := SA1->A1_CONTA
DbSelectArea(vAlias)
// Substituido pelo assistente de conversao do AP5 IDE em 18/10/00 ==> __Return(cConta)
Return(cConta)        // incluido pelo assistente de conversao do AP5 IDE em 18/10/00

