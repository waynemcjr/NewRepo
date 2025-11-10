USE SneezePharma
GO

--Join clientes ativos
select c.idCliente, CONCAT(c.Nome, ' ', c.Sobrenome) as Nome, c.CPF, c.DataNascimento, c.DataCadastro,
sc.Situacao,
MAX(v.DataVenda) AS UltimaCompra,
CONCAT(tc.CodPais,' ', tc.CodArea, tc.Numero) AS Telefone
from clientes c
LEFT JOIN TelefonesClientes tc
on c.idCliente = tc.idCliente
LEFT JOIN SituacaoCliente sc
on sc.id = c.Situacao
LEFT JOIN Vendas v
on v.idCliente = c.idCliente
where sc.Situacao = 'Ativo'
GROUP BY c.idCliente, c.Nome, c.Sobrenome, c.CPF, c.DataNascimento, c.DataCadastro, sc.Situacao, tc.CodPais, tc.CodArea, tc.Numero

--Join clientes inativos
select c.idCliente, CONCAT(c.Nome, ' ', c.Sobrenome) as Nome, c.CPF, c.DataNascimento, c.DataCadastro,
sc.Situacao,
MAX(v.DataVenda) AS UltimaCompra,
CONCAT(tc.CodPais,' ', tc.CodArea, tc.Numero) AS Telefone
from clientes c
LEFT JOIN TelefonesClientes tc
on c.idCliente = tc.idCliente
LEFT JOIN SituacaoCliente sc
on sc.id = c.Situacao
LEFT JOIN Vendas v
on v.idCliente = c.idCliente
where sc.Situacao = 'Inativo'
GROUP BY c.idCliente, c.Nome, c.Sobrenome, c.CPF, c.DataNascimento, c.DataCadastro, sc.Situacao, tc.CodPais, tc.CodArea, tc.Numero

--Join clientes restritos
SELECT CONCAT(c.Nome, ' ',c.Sobrenome) as Nome, c.CPF, c.DataCadastro
FROM ClientesRestritos cr
JOIN Clientes c
on c.idCliente = cr.idCliente

--Join fornecedores ativos
SELECT f.idFornecedor, f.CNPJ, f.RazaoSocial, f.DataAbertura, f.DataCadastro, f.Pais,
MAX(c.DataCompra) AS UltimoFornecimento, 
sf.Situacao
FROM Fornecedores f
JOIN SituacaoFornecedor sf
ON sf.id = f.Situacao
LEFT JOIN Compras c
ON c.idFornecedor = f.idFornecedor
WHERE sf.Situacao = 'Ativo'
GROUP BY f.idFornecedor, f.CNPJ, f.RazaoSocial, f.DataAbertura, f.DataCadastro, f.Pais, sf.Situacao

--Join fornecedores inativos
SELECT f.idFornecedor, f.CNPJ, f.RazaoSocial, f.DataAbertura, f.DataCadastro, f.Pais,
MAX(c.DataCompra) AS UltimoFornecimento,
sf.Situacao
FROM Fornecedores f
JOIN SituacaoFornecedor sf
ON sf.id = f.Situacao
LEFT JOIN Compras c
ON c.idFornecedor = f.idFornecedor
WHERE sf.Situacao = 'Inativo'
GROUP BY f.CNPJ, f.RazaoSocial, f.DataAbertura, f.DataCadastro, f.Pais, sf.Situacao

--Join fornecedores restritos
SELECT f.CNPJ, f.RazaoSocial, f.DataCadastro
FROM FornecedoresBloqueados fb
JOIN Fornecedores f
ON fb.idFornecedor = f.idFornecedor

--Join compras
SELECT c.idCompra, f.RazaoSocial, f.CNPJ,
pa.Nome AS PrincipioAtivo,
it.Quantidade, it.ValorUnitario, it.ValorTotal,
c.DataCompra
FROM Compras c
JOIN Fornecedores f
ON c.idFornecedor = f.idFornecedor
JOIN ItensCompras it
ON c.idCompra = it.idCompra
JOIN PrincipiosAtivos pa
ON pa.idPrincipio = it.idPrincipio

--Join vendas
select v.idVenda,
CONCAT(c.nome, ' ', c.Sobrenome) as NomeCliente, c.CPF,
iv.Quantidade,
m.Nome, m.ValorVenda as ValorUnitario, (iv.Quantidade * m.ValorVenda) as ValorTotalVenda,
v.DataVenda
from Vendas v
JOIN Clientes c
ON c.idCliente = v.idCliente
JOIN ItensVendas iv
ON iv.idVenda = v.idVenda
JOIN Medicamentos m
ON m.idMedicamento = iv.idMedicamento

--Join medicamentos ativos
select m.idMedicamento, m.Nome, m.ValorVenda as ValorUnitario, m.DataCadastro,
st.Situacao,
c.Nome AS Categoria,
m.CDB,
MAX(v.DataVenda) AS DataUltimaVenda
from Medicamentos m
LEFT JOIN SituacaoMedicamento st
ON m.Situacao = st.id
LEFT JOIN Categorias c
ON c.id = m.Categoria
LEFT JOIN ItensVendas iv
ON iv.idMedicamento = m.idMedicamento
LEFT JOIN Vendas v
ON v.idVenda = iv.idVenda
WHERE st.Situacao = 'Ativo'
GROUP BY m.idMedicamento, m.Nome, m.ValorVenda, m.DataCadastro, st.Situacao, c.Nome, m.CDB

--Join medicamentos inativos
select m.idMedicamento, m.Nome, m.ValorVenda as ValorUnitario, m.DataCadastro,
st.Situacao,
c.Nome AS Categoria,
m.CDB,
MAX(v.DataVenda) AS DataUltimaVenda
from Medicamentos m
LEFT JOIN SituacaoMedicamento st
ON m.Situacao = st.id
LEFT JOIN Categorias c
ON c.id = m.Categoria
LEFT JOIN ItensVendas iv
ON iv.idMedicamento = m.idMedicamento
LEFT JOIN Vendas v
ON v.idVenda = iv.idVenda
WHERE st.Situacao = 'Inativo'
GROUP BY m.idMedicamento, m.Nome, m.ValorVenda, m.DataCadastro, st.Situacao, c.Nome, m.CDB

--Join principio ativo ativo
select pa.idPrincipio, pa.Nome, pa.DataCadastro, sp.Situacao,
MAX(c.DataCompra) AS UltimoFornecimento
from PrincipiosAtivos pa
JOIN SituacaoPrincipioAtivo sp
ON pa.Situacao = sp.id
LEFT JOIN ItensCompras ic
ON ic.idPrincipio = pa.idPrincipio
LEFT JOIN Compras c
ON c.idCompra = ic.idCompra
WHERE sp.Situacao = 'Ativo'
GROUP BY pa.idPrincipio, pa.Nome, pa.DataCadastro, sp.Situacao

--Join principio ativo inativo
select pa.Nome, pa.DataCadastro, sp.Situacao,
MAX(c.DataCompra) AS UltimoFornecimento
from PrincipiosAtivos pa
JOIN SituacaoPrincipioAtivo sp
ON pa.Situacao = sp.id
LEFT JOIN ItensCompras ic
ON ic.idPrincipio = pa.idPrincipio
LEFT JOIN Compras c
ON c.idCompra = ic.idCompra
WHERE sp.Situacao = 'Inativo'
GROUP BY pa.Nome, pa.DataCadastro, sp.Situacao

--Join produções
select p.idProducao, m.Nome AS Medicamento, m.ValorVenda,
p.Quantidade, (p.Quantidade * m.ValorVenda) AS ValorDeVendaProduzido,
pa.Nome AS PrincipioAtivo, i.Quantidade AS QtdPrincipioAtivo, p.DataProducao
from Producoes p
LEFT JOIN Medicamentos m
ON m.idMedicamento = p.idMedicamento
LEFT JOIN Ingredientes i
ON i.idProducao = p.idProducao
LEFT JOIN PrincipiosAtivos pa
ON pa.idPrincipio = i.idPrincipio