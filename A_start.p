run "B_connect.p" no-error.

    if error-status:error
        then display "Aten�ao! Erro ao conectar ao banco de dados BT" skip.

run "C_import_to_table.p" no-error.

    if error-status:error
        then display "Aten�ao! Erro ao importar dados para a tabela" skip.

run "D_calcNumOperacao.p" no-error.

    if error-status:error
        then display "Aten�ao! Erro ao calcular o campo de N�mero da Opera��o" skip.
     
run "E_gravaOper.p" no-error.

    if error-status:error
        then display "Aten�ao! Erro ao gravar na tabela de Opera��es" skip.



    
