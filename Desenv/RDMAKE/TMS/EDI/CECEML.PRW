#include 'Protheus.ch'
#include 'Totvs.ch'

//-------------------------------------------------------------------------------------------------
/* {2LGI} CECEML
@autor		: Luz Alexandre
@descricao	: Funcao principal da rotina
@since		: Jun./2014
@using		: Preenchimento de layout de EDI CECEML
@review     : 
*/
//-------------------------------------------------------------------------------------------------
User Function CECEML(cReg,cPos)

// --- Variaveis utilizadas
Local _cPos		:= cPos
Local _cReg		:= cReg
Local _cRet		:= '' 
Local _aArea	:= GetArea()
Local _aAreaDTP	:= DTP->(GetArea())
Local _aDePara	:= {}      
Local _nPos		:= 0

// --- Retorna vazio se nao enviado parametro
If Empty(_cPos) .or. Empty(_cReg)
	Return _cRet
EndIf

// --- Adiciona codigos de/para na array conforme manual do layout.
_aDePara	:= {;
				{'01','C3'  },;
				{'02','BR12'},;
				{'03','BR04'},;
				{'04','LEVE'},;
				{'05','LEVE'},;
				{'06','BR01'},;
				{'15','C3'  },;
				{'16','C3' } }
				
// --- Posiciona o lote
DTP->(dbSetOrder(1))
DTP->(dbSeek(xFilial('DTP')+DT6->DT6_LOTNFC))

// --- Registro 329 --- Layout CECEML 
// --- Posicao inicial 004 - Tipo de Transporte
If _cReg	==	'329' .and. _cPos	== '004'

	// --- Localiza o tipo de veiculo informado a partir do lote DTP
	_cRet	:= GetAdvFVal('DA3','DA3_TIPVEI',xFilial('DA3')+DTP->DTP_CODVEI,1,'')
    
    // --- Tabela De/Para 
    _nPos	:= Ascan( _aDePara, {|x| x[1] == _cRet } )
    
    // --- Troca o codigo do meio de transporte
    If _nPos > 0
    	_cRet	:= _aDePara[_nPos,2]
    EndIf
    
//ElseIf _cReg	==	'329' .and. _cPos	== '999'

//ElseIf _cReg	==	'329' .and. _cPos	== '999'

EndIf

// --- Retorna conteudo localizado
Return _cRet
