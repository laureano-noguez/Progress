def var varq as char.
def var vcont as integer.
def var vcaminho-arquivo as char.
def var vcod-teste as integer.

def buffer b-arquivo for arquivo.

for each arquivo:

    delete arquivo.

end.


for each oper:

    delete oper.

end.


assign vcaminho-arquivo = "c:\temp\operacao.txt".

display "Iniciando importação em " string(time,"HH:MM:SS") skip.
/*colocar nome do arquivo*/

find last b-arquivo no-lock use-index codTeste no-error.

if avail b-arquivo
then assign vcod-teste = b-arquivo.codTeste + 1.
else assign vcod-teste = 1.

input from value(vcaminho-arquivo).

assign vcont = 0.

   repeat:
                       
        import unformatted varq.

        assign vcont = vcont + 1.

        create arquivo.
        assign arquivo.linha = varq
               arquivo.datexp = today
               arquivo.hora = time
               arquivo.contlinha = vcont
               arquivo.codTeste = vcod-teste.

   end.                           

if can-find(first arquivo)
    then display "Importação concluída em " string(time,"HH:MM:SS") skip.
    else display "Nenhuma linha foi importada!" skip.

/*display "nenhuma linha foi importada, por favor verifique o arquivo em c:\temp\operacao.txt" skip.*/


