run "B_connect.p" no-error.

    if error-status:error
        then display "Atençao! Erro ao conectar ao banco de dados BT" skip.

run "C_import_to_table.p" no-error.

    if error-status:error
        then display "Atençao! Erro ao importar dados para a tabela" skip.

run "D_calcNumOperacao.p" no-error.

    if error-status:error
        then display "Atençao! Erro ao calcular o campo de Número da Operação" skip.
     
run "E_gravaOper.p" no-error.

    if error-status:error
        then display "Atençao! Erro ao gravar na tabela de Operações" skip.



    
