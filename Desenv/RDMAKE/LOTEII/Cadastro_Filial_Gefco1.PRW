#INCLUDE "rwmake.ch"

/*
*---------------------------------------------------------------------------*
* Fun��o     |GEFFIL     | Autor | Jesus Oliveira        | Data | 21.01.10  *
*---------------------------------------------------------------------------*
* Descri��o  |Tela de Manuten�ao dodo cadastro das filiais GEFCO para       *
*            |integra��o na interface Lote II.                              *
*---------------------------------------------------------------------------*
*/

User Function GEFFIL()


//���������������������������������������������������������������������Ŀ
//� Declaracao de Variaveis                                             �
//�����������������������������������������������������������������������

Local cVldAlt := ".T." // Validacao para permitir a alteracao. Pode-se utilizar ExecBlock.
Local cVldExc := ".T." // Validacao para permitir a exclusao. Pode-se utilizar ExecBlock.
Private cString := "SZX"

//	dbSelectArea("SZC")
//	dbSetOrder(1)
	
	AxCadastro(cString,"Cadastro de Filiais GEFCO",cVldExc,cVldAlt)

Return
