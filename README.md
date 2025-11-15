README — Ordem de execução dos scripts do banco de dados



Este repositório contém os scripts para criar e popular o banco SneezePharma.

Siga a ordem abaixo para executar os arquivos: cada etapa depende da anterior.



Ordem (executar exatamente nesta sequência)



CREATE\_DATABASE.sql



ADD\_KEY\_CONSTRAINTS.sql



CREATE\_TRIGGERS.sql



INSERT\_DATA.sql



PROCEDURES.sql



Por que essa ordem?



CREATE\_DATABASE: cria o banco e as tabelas base — deve rodar primeiro.



ADD\_KEY\_CONSTRAINTS: adiciona chaves estrangeiras, índices e chaves primárias que ligam as tabelas; precisa das tabelas criadas.



CREATE\_TRIGGERS: cria triggers que validam/inibem inserções; colocar as triggers antes do INSERT\_DATA garante que as validações ocorram ao popular o banco.



INSERT\_DATA: popula tabelas com dados iniciais (cuidado: triggers podem bloquear inserts inválidos).



PROCEDURES: cria stored procedures; podem depender de tabelas, constraints e dados já presentes.



Recomendações gerais antes de executar



Execute em uma cópia de desenvolvimento / teste primeiro, nunca diretamente em produção.



Verifique permissões: a conta usada precisa ter permissão para criar banco, tabelas, constraints e procedures.



Se algum INSERT falhar por causa de FK/CHECK/TRIGGER, corrija a ordem ou os dados de INSERT\_DATA conforme necessário.



Sempre revisar CREATE\_TRIGGERS.sql — triggers podem fazer ROLLBACK de transações se dados inválidos forem enviados.



Exemplos de execução

1\) Usando SQL Server Management Studio (SSMS)



Para cada arquivo, abra no SSMS, selecione o connection/server apropriado e clique em Execute (F5).



Rode primeiro CREATE\_DATABASE.sql conectado ao servidor (banco master).



Para os demais, conecte-se ao servidor e verifique que o USE <seuBanco> correto está presente no script (ou rode USE SneezePharma; antes).



2\) Usando sqlcmd (linha de comando)

\# Exemplo: Windows / Powershell

sqlcmd -S <SERVIDOR> -U <USUARIO> -P <SENHA> -i CREATE\_DATABASE.sql



\# Depois, executar os scripts que precisam do banco criado:

sqlcmd -S <SERVIDOR> -U <USUARIO> -P <SENHA> -d SneezePharma -i ADD\_KEY\_CONSTRAINTS.sql

sqlcmd -S <SERVIDOR> -U <USUARIO> -P <SENHA> -d SneezePharma -i CREATE\_TRIGGERS.sql

sqlcmd -S <SERVIDOR> -U <USUARIO> -P <SENHA> -d SneezePharma -i INSERT\_DATA.sql

sqlcmd -S <SERVIDOR> -U <USUARIO> -P <SENHA> -d SneezePharma -i PROCEDURES.sql



3\) Usando PowerShell (Invoke-Sqlcmd)

Invoke-Sqlcmd -ServerInstance "<SERVIDOR>" -Database "master" -InputFile "CREATE\_DATABASE.sql"

Invoke-Sqlcmd -ServerInstance "<SERVIDOR>" -Database "SneezePharma" -InputFile "ADD\_KEY\_CONSTRAINTS.sql"

Invoke-Sqlcmd -ServerInstance "<SERVIDOR>" -Database "SneezePharma" -InputFile "CREATE\_TRIGGERS.sql"

Invoke-Sqlcmd -ServerInstance "<SERVIDOR>" -Database "SneezePharma" -InputFile "INSERT\_DATA.sql"

Invoke-Sqlcmd -ServerInstance "<SERVIDOR>" -Database "SneezePharma" -InputFile "PROCEDURES.sql"



Dicas práticas e boas normas



SET NOCOUNT ON; no início de procedures e scripts que executam muitos comandos evita mensagens (N rows affected) e melhora performance nas chamadas por aplicações.



Considere envolver inserções relacionadas em transações (BEGIN TRAN / COMMIT / ROLLBACK) quando fizer import em massa.



Se for popular muitas linhas em INSERT\_DATA, e constraints causarem erros, comente temporariamente triggers restritivas para facilitar a carga (apenas em ambiente de teste!).



Teste CREATE\_TRIGGERS com exemplos que disparem as validações — assim você garante que as regras funcionam como esperado.



Problemas comuns \& como resolver



Erro de FK ao inserir: verifique se os dados de referência (ex.: categorias, situações, fornecedores) foram inseridos primeiro.



Triggers bloqueando inserts: leia o código da trigger para entender a regra e corrija os dados ou a regra se necessário.



Procedures falham por falta de objeto: confirme se os scripts anteriores foram executados sem erro.



Link — desenho relacional das tabelas



Diagrama relacional (drawdb)

