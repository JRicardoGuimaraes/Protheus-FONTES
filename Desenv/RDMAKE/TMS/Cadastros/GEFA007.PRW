#include "rwmake.ch"      
#include "topconn.ch"       
#include "protheus.ch"
/*/
����������������������������������������������������������������������������������
����������������������������������������������������������������������������������
������������������������������������������������������������������������������Ŀ��
���Funcao    �GEFA007   � Autor � Katia Alves Bianchi     � Data �  08/03/2013 ���
������������������������������������������������������������������������������Ĵ��
���Descricao �Tela de manutencao da tabela M5 do SX5 de Tipo de Tabela         ���
�������������������������������������������������������������������������������ٱ�
����������������������������������������������������������������������������������
����������������������������������������������������������������������������������
/*/
User Function GEFA007()   
cCadastro := "Tipo de Tabela" 
aAutoCab    := {}
aAutoItens  := {}
PRIVATE aRotina := { { "" ,  "AxPesqui"  , 0 , 1},;  // "Pesquisar"
       				  { "",   "C160Visual", 0 , 2},;  // "Visualizar"
					  { "",   "C160Inclui", 0 , 3},;  // "Incluir"
					  { "",   "C160Altera", 0 , 4},;  // "Alterar"
					  { "",   "C160Deleta", 0 , 5} }  // "Excluir"
DbSelectArea("SX5")           
DbSetOrder(1)
If !DbSeek(xFilial("SX5")+"M5",.F.)
   MsgAlert(xFilial("SX5"))
   MsgAlert("Nao foi possivel localizar a tabela M5 no cadastro de tabelas (SX5) !")
Else   
   c160altera("SX5",,3)
Endif   
return         