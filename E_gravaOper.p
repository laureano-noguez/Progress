function pontosOper returns decimal (input par-fech as character, par-ini as character, par-tipo-oper as logical):

    /***************************************************************
      par-fech      = fechamento da operação, linha padrão do for each
      par-ini       = início da operação, buffer dentro do for each
      par-tipo-oper = indica se é compra ou venda
    ***************************************************************/

    def var vpositionAt-fech as integer initial 0. /*Indica a posição da palavra "at" já que logo após ela vem o ponto de entrada e saída*/
    def var vpositionAt-ini  as integer initial 0. /*Indica a posição da palavra "at" já que logo após ela vem o ponto de entrada e saída*/

    def var vtexto-aux-fech     as char.
    def var vtexto-aux-ini      as char.

    def var vpontos-aux-fech    as char.
    def var vpontos-aux-ini     as char.
    def var i                   as integer.
    def var ret-pontos-operacao as decimal.

    assign vpositionAt-fech = index(par-fech,"at").

    assign vpositionAt-ini  = index(par-ini,"at").
                                          
    assign vtexto-aux-fech = substring(par-fech,vpositionAt-fech,10).
    assign vtexto-aux-ini  = substring(par-ini,vpositionAt-ini,10).

    /*display vtexto-aux-fech format "x(15)".*/

    /*display vtexto-aux format "x(30)" skip.*/
            
    assign vpontos-aux-fech = "".
    
    do i = 1 to 10:
        
        /*Se achar um número dentro da string grava ele no lote-aux*/
        if index("0123456789.,",substring(vtexto-aux-fech,i,1)) > 0
            then assign vpontos-aux-fech = vpontos-aux-fech + substring(vtexto-aux-fech,i,1).
            
        /*quando já encontrou o lote, assim que encontrar um espaço encerra o looping*/
        if length(vpontos-aux-fech) > 0 and substring(vtexto-aux-fech,i,1) = " " then leave.
    
    end.    
    
    assign vpontos-aux-ini = "".
    
    do i = 1 to 10:
        
        /*Se achar o caracter dentro da string de números grava ele no lote-aux*/
        if index("0123456789.,",substring(vtexto-aux-ini,i,1)) > 0
            then assign vpontos-aux-ini = vpontos-aux-ini + substring(vtexto-aux-ini,i,1).
            
        /*quando já encontrou o lote, assim que encontrar um espaço encerra o looping*/
        if length(vpontos-aux-ini) > 0 and substring(vtexto-aux-ini,i,1) = " " then leave.
    
    end.    
    
    if par-tipo-oper = true
        then assign ret-pontos-operacao = decimal(vpontos-aux-fech) - decimal(vpontos-aux-ini).
    else if par-tipo-oper = false
        then assign ret-pontos-operacao = decimal(vpontos-aux-ini) - decimal(vpontos-aux-fech).
    
    return ret-pontos-operacao.

end function.



function loteOper returns decimal (input par1 as character):

    /************************************************************
    O Lote precisa ser procurado, após as palavras Buy e Sell
    os primeiros números que aparecerem são o lote
    
    O retorno precisa ser decimal porquê corretoras internacionais
    trabalham com micro lotes (menor que 1)
    ************************************************************/

    
    def var vpositionBuySell as integer initial 0.
    def var vtexto-aux       as char.
    def var ret-lote         as decimal.
    def var i                as integer.
    def var vlote-aux         as char.
                                                 
    assign vpositionBuySell = index(par1,"Buy").

    if vpositionBuySell = 0
        then vpositionBuySell = index(par1,"Sell").
        
    /*Depois de encontrar o Buy ou o Sell coloca os próximos 15 caracteres
      dentro de uma variável*/

    if vpositionBuySell > 0
        then assign vtexto-aux = substring(par1,vpositionBuySell,15).

    /*display vtexto-aux format "x(30)" skip.*/
            
    assign vlote-aux = "".

    do i = 1 to 15:
        
        /*Se achar um número dentro da string grava ele no lote-aux*/
        if index("0123456789.,",substring(vtexto-aux,i,1)) > 0
            then assign vlote-aux = vlote-aux + substring(vtexto-aux,i,1).
            
        /*quando já encontrou o lote, assim que encontrar um espaço encerra o looping*/
        if length(vlote-aux) > 0 and substring(vtexto-aux,i,1) = " " then leave.
    
    end.    
    
    assign ret-lote = decimal(vlote-aux).

    return ret-lote.

end function.



function dataOper returns date (input par1 as character):

    def var vpositionTrade as integer.
    def var vdataaux      as character.
    def var vdataOper     as date.
    def var vespacador    as integer.


    if index(par1,"Trades") > 0
        then vespacador = 7.
        else if index(par1,"Trade") > 0
            then vespacador = 6.
    
    assign vpositionTrade = index(par1,"Trade").    
    
    assign vdataaux = substring(par1,vpositionTrade + vespacador,10).
    
    
    /*
    display vdataaux format "x(30)".

    display entry(2,vdataaux,".")
            entry(3,vdataaux,".")
            entry(1,vdataaux,".").
    */


    /*
    display vdataaux format "x(20)".
    */
    if num-entries(vdataaux,".") = 3
    then assign vdataOper = date(int(entry(2,vdataaux,".")),int(entry(3,vdataaux,".")),int(entry(1,vdataaux,"."))) no-error.
         
    return vdataOper.

end function.


function horaoper returns integer (input par1 as character):

    def var vpositiontrade as integer.
    def var vhoraaux       as character.
    def var vhoraoper      as integer.

    assign vpositiontrade = index(par1,"Trade").

    if vpositiontrade = 0
        then assign vpositiontrade = index(par1,"Trades").

    assign vhoraaux      = substring(par1,vpositiontrade + 17,8).
    
    if num-entries(vhoraaux,":") = 3
    then assign vhoraoper = int(entry(1,vhoraaux,":")) * 60 * 60 /* multiplica a hora por 60 e novamente por 60 para pegar a quantidade de segundos*/
                             + int(entry(2,vhoraaux,":")) * 60   /* multiplica os minutos por 60 para pegar a quantidade de segundos. */
                             + int(entry(3,vhoraaux,":")).

    return vhoraoper.

end function.



/*Buffer que vai guardar a linha de abertura da operação*/
define buffer b-arquivo for arquivo. 

    
define variable hwindow as handle no-undo.

create window hwindow
    assign width        = 350 /* máximo por volta de 250 - monitor de 17 lg  e 400 para monitor Dell 24 */
           height       = 32 /* as duas linhas de cima são para cabeçalho*/
           status-area  = false
           message-area = false
           three-d      = true.
             
define variable hwindow2 as handle no-undo.

create window hwindow2
    assign width        = 350 /* máximo por volta de 250 - monitor de 17 lg  e 400 para monitor Dell 24 */
           height       = 32 /* as duas linhas de cima são para cabeçalho*/
           status-area  = false
           message-area = false
           three-d      = true.


define variable hwindow3 as handle no-undo.

create window hwindow3
    assign width        = 350 /* máximo por volta de 250 - monitor de 17 lg  e 400 para monitor Dell 24 */
           height       = 32 /* as duas linhas de cima são para cabeçalho*/
           status-area  = false
           message-area = false
           three-d      = true.



def var vcont                    as integer.
def var sresp                    as logical format "Sim/Nao".

assign vcont = 0.

def temp-table tt-oper like bt.oper.

def temp-table tt-total
    field qtd-tp as integer
    field qtd-sl as integer.

def var v-sl as integer.
def var v-tp as integer.

for each arquivo no-lock /*use-index contlinha*/ by numOperacao:
    
    if arquivo.numOperacao = 0 then next.

    assign v-sl = 0
           v-tp = 0.

    /*Pega sempre o último registro que faz o fechamento da operação*/
    assign v-sl = index(arquivo.linha,"stop loss")
           v-tp = index(arquivo.linha,"take profit").
                                                         
    if v-sl = 0 and v-tp = 0 then next.

    create tt-oper.
    assign tt-oper.dataImp = today
           tt-oper.horaImp = time.


    /*if index(arquivo.linha,"order") = 0 then next.            */

    find first b-arquivo where b-arquivo.numoperacao = arquivo.numoperacao use-index numOperacao no-lock no-error.
            
    if avail b-arquivo then

    assign vcont = vcont + 1.

    assign tt-oper.dataOper = dataOper(b-arquivo.linha)
           tt-oper.horaOper = horaoper(b-arquivo.linha).
    
    if index(b-arquivo.linha,"Buy") > 0
        then assign tt-oper.tipo = true.
    else if index(b-arquivo.linha,"Sell") > 0
        then assign tt-oper.tipo = false.
    
    assign tt-oper.lote      = loteOper(b-arquivo.linha)
           tt-oper.pontos    = pontosOper(arquivo.linha, b-arquivo.linha, tt-oper.tipo)
           tt-oper.resultado = (tt-oper.lote * 0.2) * tt-oper.pontos
           tt-oper.num       = arquivo.numOperacao
           tt-oper.codTeste  = arquivo.codTeste.
    
    if v-tp > 0
    then assign tt-oper.tipoResultado = true.
    else assign tt-oper.tipoResultado = false.

    find first tt-total exclusive-lock no-error.
    if not avail tt-total
    then do:
        
        create tt-total.
        assign tt-total.qtd-tp  = 0
               tt-total.qtd-sl  = 0.
    end.
    else do:

        if v-tp > 0 and v-sl = 0 then
        assign tt-total.qtd-tp = tt-total.qtd-tp + 1.

        if v-sl > 0 and v-tp = 0 then
        assign tt-total.qtd-sl = tt-total.qtd-sl + 1.

    end.
             
    display         
            arquivo.linha format "x(30)"               
            arquivo.datexp
            string(arquivo.hora,"hh:mm:ss")
            arquivo.contlinha
            arquivo.codTeste
            arquivo.numOperacao
            tt-oper.codTeste          
            tt-oper.dataImp           
            string(tt-oper.horaImp,"HH:MM:SS")
            tt-oper.dataOper          
            string(tt-oper.horaOper,"HH:MM:SS")
            tt-oper.numOper           
            tt-oper.tipo          
            tt-oper.lote          
            tt-oper.pontos       
            tt-oper.resultado     
            tt-oper.tipoResultado 
        with frame f01 width 320 in window hwindow down.
                     
    pause.
              

end.



find first tt-oper no-lock no-error.

if avail tt-oper then
    find first oper where oper.dataOper  = tt-oper.dataOper
                      and oper.horaOper  = tt-oper.horaOper
                      and oper.resultado = tt-oper.resultado no-lock no-error.



assign sresp = false.
       

if avail oper then do:
    
    display "Já existe uma operação com as informações abaixo, esse arquivo pode ser duplicado, tem certeza de que deseja continuar a importação?" skip
               "Data Operação:       "        tt-oper.dataOper no-label skip
               "Hora Operação:       " string(tt-oper.horaOper,"HH:MM:SS") no-label skip
               "Resultado Operação:  " tt-oper.resultado no-label skip
                with frame f02  width 245 in window hwindow2 down.

    update sresp with no-label.

    
end.
if not avail oper or sresp = true then do:

    for each tt-oper no-lock:
        
        create oper.
        buffer-copy tt-oper to oper.

    end.

end.
      
assign vcont = 0.
            
def var v-total as integer.

  for each tt-total no-lock.

      assign v-total = 0.

      assign v-total = (qtd-tp + qtd-sl).

      assign vcont = vcont + 1.

      display qtd-tp label "qtde take profit" (qtd-tp * 100 / v-total) label "%" "%"  qtd-sl label "qtde stop loss" (qtd-sl * 100 / v-total) label "%" "%"   v-total label "total operações" 
          with frame f03  width 245 in window hwindow3 down.
      pause.

  end.

pause.

     
