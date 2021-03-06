//#include "topconn.ch"   
#Include "PROTHEUS.CH" 
#include "rwmake.ch"    
 
/*
*----------------------------------------------------------------------------------------------------*
* Fun��o     |F110TRAVA   | Autor | J Ricardo             | Data | 03.02.14                          *
*----------------------------------------------------------------------------------------------------*
* Descri��o  |Ponto de entrada que atua na rotina FIN110, Baixa autom�tica a receber.                *
*            |PE utilizado para n�o bloquear o registro do cliente(SA1) no momento da baixa          *
*            |                                                                                       *
*----------------------------------------------------------------------------------------------------*
*/

USER FUNCTION F110TRAVA()

// Return MsgYesNo("Trava o registro na SA1")
Return GETNEWPAR("MV_SA1TRAV",.F.)


/*
*----------------------------------------------------------------------------------------------------*
* Fun��o     |F070TRAVA   | Autor | J Ricardo             | Data | 17.04.14                          *
*----------------------------------------------------------------------------------------------------*
* Descri��o  |Ponto de entrada que atua na rotina FIN070, Baixa autom�tica a receber.                *
*            |PE utilizado para n�o bloquear o registro do cliente(SA1) no momento da baixa          *
*            |                                                                                       *
*----------------------------------------------------------------------------------------------------*
*/

USER FUNCTION F070TRAVA()

// Return MsgYesNo("Trava o registro na SA1")
Return GETNEWPAR("MV_SA1TRAV",.F.)
