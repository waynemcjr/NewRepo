-- Procedure relatório de compras por fornecedor
CREATE PROCEDURE sp_ComprasFornecedor
AS
BEGIN
	SELECT f.RazaoSocial, 
		COUNT(DISTINCT c.idCompra) AS QuantidadeCompras,
		COUNT(i.idCompra) AS ItensComprados, 
		ISNULL(SUM(i.ValorTotal), 0) AS ValorTotalGasto, 
		MAX(c.DataCompra) AS UltimaCompra
	FROM Compras c
	RIGHT JOIN Fornecedores f ON c.idFornecedor = f.idFornecedor
	LEFT JOIN ItensCompras i ON c.idCompra = i.idCompra
	GROUP BY f.RazaoSocial;
END;
GO

--Procedure para exibir medicamento mais vendido
CREATE PROCEDURE sp_MedicamentoMaisVendido
AS
BEGIN
	SELECT m.Nome, c.Nome AS Categoria,
		ISNULL(SUM(i.Quantidade), 0) AS QtdVendida, 
		COUNT(i.idVenda) AS VendasDistintas,
		ISNULL(SUM(m.ValorVenda * i.Quantidade), 0) AS ValorTotal,
		MAX(v.DataVenda) AS UltimaVenda
	FROM ItensVendas i
	RIGHT JOIN Medicamentos m ON i.idMedicamento = m.idMedicamento
	LEFT JOIN Vendas v ON i.idVenda = v.idVenda
	LEFT JOIN Categorias c ON m.Categoria = c.id
	GROUP BY m.Nome, c.Nome
	ORDER BY QtdVendida DESC;
END;
GO

--Procedure relatório de vendas por periodo
CREATE PROCEDURE sp_VendasPorPeriodo
	@DataInicio DATE,
	@DataFim DATE
AS
BEGIN
	SELECT 
		v.DataVenda, v.idVenda,
		SUM(i.Quantidade * m.ValorVenda) AS Valor,
		CONCAT(c.Nome, ' ', c.Sobrenome) AS NomeCliente,
		c.CPF, 
		SUM(i.Quantidade) AS QtdItens,
		COUNT(i.idMedicamento) AS ItensDistintos
	FROM Vendas v
	JOIN Clientes c ON v.idCliente = c.idCliente
	JOIN ItensVendas i ON v.idVenda = i.idVenda
	JOIN Medicamentos m ON i.idMedicamento = m.idMedicamento
	WHERE v.DataVenda BETWEEN @DataInicio AND @DataFim
	GROUP BY v.idVenda, v.DataVenda, c.Nome, c.Sobrenome, c.CPF;
END;
GO

--Procedure de inserção de cliente
CREATE OR ALTER PROCEDURE sp_CadastroCliente
	@CPF VARCHAR(11),
	@Nome VARCHAR(50),
	@Sobrenome VARCHAR(50),
	@DataNascimento DATE,
	@Situacao INT
AS
BEGIN
	INSERT INTO Clientes(CPF, Nome, Sobrenome, DataNascimento, DataCadastro, Situacao)
	VALUES(@CPF, @Nome, @Sobrenome, @DataNascimento, GETDATE(), @Situacao);
END;
GO

--Procedure de cadastro de fornecedor
CREATE OR ALTER PROCEDURE sp_CadastrarFornecedor
	@CNPJ VARCHAR(14),
	@RazaoSocial VARCHAR(50),
	@Pais VARCHAR(20),
	@DataAbertura DATE,
	@Situacao INT
AS
BEGIN
	INSERT INTO Fornecedores(CNPJ, RazaoSocial, Pais, DataAbertura, DataCadastro, Situacao)
	VALUES(@CNPJ, @RazaoSocial, @Pais, @DataAbertura, GETDATE(), @Situacao);
END;
GO

--Procedure de inativar cliente
CREATE OR ALTER PROCEDURE sp_InativarCliente
	@idCliente INT
AS
BEGIN
	IF((SELECT Situacao FROM Clientes WHERE idCliente = @idCliente) = 2)
	BEGIN
		RAISERROR('Cliente já está inativo!', 16, 1);
		RETURN;
	END
	UPDATE Clientes SET Situacao = 2 WHERE idCliente = @idCliente
END;
GO

--Procedure Ativar Cliente
CREATE OR ALTER PROC sp_AtivarCliente
	@idCliente INT
AS
BEGIN
	IF((SELECT Situacao FROM Clientes WHERE idCliente = @idCliente) = 1)
	BEGIN
		RAISERROR('Cliente já está ativo!', 16, 1);
		RETURN;
	END
	UPDATE Clientes SET Situacao = 1 WHERE idCliente = @idCliente
END;
GO

--Procedure de inserção de vendas
CREATE TYPE TYPEItensVendas AS TABLE(
	idMedicamento INT,
	Quantidade INT
);
GO

CREATE OR ALTER PROCEDURE sp_CadastrarVenda
	@idCliente INT,
	@itens TYPEItensVendas READONLY
AS
BEGIN
	IF ((SELECT COUNT(*) FROM @itens) > 3)
	BEGIN
		RAISERROR('A venda não pode ter mais que 3 itens!', 16, 1);
		RETURN;
	END
	IF ((SELECT COUNT(*) FROM Clientes WHERE idCliente = @idCliente) = 0)
	BEGIN
		RAISERROR('Não foi encontrado um cliente para cadastrar a venda!', 16, 1);
		RETURN;
	END
	IF ((SELECT Situacao FROM Clientes WHERE idCliente = @idCliente) = 2)
	BEGIN
		RAISERROR('Impossivel cadastrar uma compra para um cliente inativo!', 16, 1);
		RETURN;
	END

	--IF((select 1 from Medicamentos m RIGHT JOIN @itens iv ON m.idMedicamento = iv.idMedicamento) = 0)
	--BEGIN
		--RAISERROR('Não foi encontrado um medicameno para cadastrar a venda', 16, 1)
		--RETURN;
	--END

	DECLARE @idVenda INT
	INSERT INTO Vendas(idCliente, DataVenda) VALUES (@idCliente,GETDATE())

	SET @idVenda = SCOPE_IDENTITY()

	INSERT INTO ItensVendas(idVenda, idMedicamento, Quantidade)
	SELECT @idVenda, idMedicamento, Quantidade
	FROM @itens
	
END;
GO

DECLARE @tabela TYPEItensVendas

INSERT INTO @tabela VALUES (2, 87),(1, 23),(3, 15);

EXEC sp_CadastrarVenda @idCliente = 2, @itens = @tabela;
