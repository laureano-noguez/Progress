
function numOper returns integer (input par1 as character):

    def var vpositionhashtag as integer.
    def var vnumaux         as character.
    def var vnumoper        as character.

    assign vpositionhashtag = index(par1,"#").
    assign vnumaux      = substring(par1,vpositionhashtag + 1,10).
    
    if num-entries(vnumaux," ") >= 1
    then assign vnumoper = string(int((entry(1,vnumaux," ")))) no-error.
                         
    if vnumoper <> ?
    then return int(vnumoper).
    else return 0.

end function.                 



define buffer b-arquivo for arquivo.
define variable hwindow as handle no-undo.

create window hwindow
    assign width        = 220 /* máximo por volta de 250 - monitor de 17 lg */
           height       = 32 /* as duas linhas de cima são para cabeçalho*/
           status-area  = false
           message-area = false
           three-d      = true.
         
def var vcont as integer.

assign vcont = 0.

for each arquivo exclusive-lock use-index contlinha:
                             
    /*if index(arquivo.linha,"stop loss") = 0 and index(arquivo.linha,"take profit") = 0 then next.*/

    assign arquivo.numOperacao = numOper(arquivo.linha).

    /*if index(arquivo.linha,"order") = 0 then next.            */

end.

    /*         
for each arquivo no-lock use-index contlinha:

    display
        arquivo.linha format "x(120)" 
        arquivo.numoperacao 
         with frame f01 width 215 in window hwindow down.

      

end.
      */
