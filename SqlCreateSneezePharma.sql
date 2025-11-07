CREATE DATABASE SneezePharma

USE SneezePharma

CREATE TABLE TelefonesClientes(
id INT NOT NULL PRIMARY KEY IDENTITY(1,1),
idCliente INT NOT NULL,
CodPais VARCHAR(3) NOT NULL,
CodAraea VARCHAR(2) NOT NULL,
Numero VARCHAR(9) NOT NULL
);

CREATE TABLE Clientes(
idCliente INT NOT NULL PRIMARY KEY IDENTITY(1,1),
CPF VARCHAR(11) NOT NULL UNIQUE,
Nome VARCHAR(50) NOT NULL,
Sobrenome VARCHAR(50) NOT NULL,
DataNascimento DATE NOT NULL,
DataCadastro DATE NOT NULL,
Situacao INT NOT NULL
);

CREATE TABLE ClientesRestritos(
id INT NOT NULL PRIMARY KEY IDENTITY(1,1),
idCliente INT NOT NULL UNIQUE
);

CREATE TABLE Vendas(
idVenda INT NOT NULL PRIMARY KEY IDENTITY(1,1),
DataVenda DATE NOT NULL,
idCliente INT NOT NULL
);

CREATE TABLE ItensVendas(
idVenda INT NOT NULL,
idMedicamento INT NOT NULL,
Quantidade INT NOT NULL
);

CREATE TABLE Medicamentos(
idMedicamento INT NOT NULL PRIMARY KEY IDENTITY(1,1),
CDB VARCHAR(13) NOT NULL UNIQUE,
Nome VARCHAR(40) NOT NULL,
Peso NUMERIC NOT NULL,
Categoria INT NOT NULL,
ValorVenda DECIMAL(6,2) NOT NULL,
DataCadastro DATE NOT NULL,
Situacao INT NOT NULL
);

CREATE TABLE Producoes(
idProducao INT NOT NULL PRIMARY KEY IDENTITY(1,1),
DataProducao DATE NOT NULL,
idMedicamento INT NOT NULL,
Quantidade INT NOT NULL
);

CREATE TABLE Ingredientes(
idProducao INT NOT NULL,
idPrincipio INT NOT NULL,
Quantidade INT NOT NULL
);

CREATE TABLE PrincipiosAtivos(
idPrincipio INT NOT NULL PRIMARY KEY IDENTITY(1,1),
Nome VARCHAR(20) NOT NULL UNIQUE,
DataCadastro DATE NOT NULL,
Situacao INT NOT NULL
);

CREATE TABLE ItensCompras(
idCompra INT NOT NULL,
idPrincipio INT NOT NULL,
Quantidade INT NOT NULL,
ValorUnitario DECIMAL(6,2) NOT NULL
);

CREATE TABLE Compras(
idCompra INT NOT NULL PRIMARY KEY IDENTITY(1,1),
DataCompra DATE NOT NULL,
idFornecedor INT NOT NULL
);

CREATE TABLE Fornecedores(
idFornecedor INT NOT NULL PRIMARY KEY IDENTITY(1,1),
CNPJ VARCHAR(14) NOT NULL UNIQUE,
RazaoSocial VARCHAR(50) NOT NULL,
Pais VARCHAR(20) NOT NULL,
DataAbertura DATE NOT NULL,
DataCadastro DATE NOT NULL,
Situacao INT NOT NULL,
);

CREATE TABLE FornecedoresBloqueados(
id INT NOT NULL PRIMARY KEY IDENTITY(1,1),
idFornecedor INT NOT NULL UNIQUE
);

CREATE TABLE Categorias(
id INT NOT NULL PRIMARY KEY IDENTITY(1,1),
Nome VARCHAR(17) UNIQUE
);

CREATE TABLE SituacaoCliente(
id INT NOT NULL PRIMARY KEY IDENTITY(1,1),
Situacao VARCHAR(7) UNIQUE
);

CREATE TABLE SituacaoPrincipioAtivo(
id INT NOT NULL PRIMARY KEY IDENTITY(1,1),
Situacao VARCHAR(7) UNIQUE
);

CREATE TABLE SituacaoMedicamento(
id INT NOT NULL PRIMARY KEY IDENTITY(1,1),
Situacao VARCHAR(7) UNIQUE
);

CREATE TABLE SituacaoFornecedor(
id INT NOT NULL PRIMARY KEY IDENTITY(1,1),
Situacao VARCHAR(7) UNIQUE
);

ALTER TABLE Clientes
ADD FOREIGN KEY (Situacao) REFERENCES SituacaoCliente(id)

ALTER TABLE TelefonesClientes
ADD FOREIGN KEY (idCliente) REFERENCES Clientes(idCliente)

ALTER TABLE ClientesRestritos
ADD FOREIGN KEY (idCliente) REFERENCES Clientes(idCliente)

ALTER TABLE Vendas
ADD FOREIGN KEY (idCliente) REFERENCES Clientes(idCliente)

ALTER TABLE ItensVendas
ADD FOREIGN KEY (idVenda) REFERENCES Vendas(idVenda)

ALTER TABLE ItensVendas
ADD FOREIGN KEY (idMedicamento) REFERENCES Medicamentos(idMedicamento)

ALTER TABLE Medicamentos
ADD FOREIGN KEY (Situacao) REFERENCES SituacaoMedicamento(id)

ALTER TABLE Medicamentos
ADD FOREIGN KEY (Categoria) REFERENCES Categorias(id)

ALTER TABLE Producoes
ADD FOREIGN KEY (idMedicamento) REFERENCES Medicamentos(idMedicamento)

ALTER TABLE Ingredientes
ADD FOREIGN KEY(idProducao) REFERENCES Producoes(idProducao)

ALTER TABLE Ingredientes
ADD FOREIGN KEY(idPrincipio) REFERENCES PrincipiosAtivos(idPrincipio)

ALTER TABLE PrincipiosAtivos
ADD FOREIGN KEY(Situacao) REFERENCES SituacaoPrincipioAtivo(id)

ALTER TABLE ItensCompras
ADD FOREIGN KEY (idPrincipio) REFERENCES PrincipiosAtivos(idPrincipio)

ALTER TABLE ItensCompras
ADD FOREIGN KEY (idCompra) REFERENCES Compras(idCompra)

ALTER TABLE Compras
ADD FOREIGN KEY (idFornecedor) REFERENCES Fornecedores(idFornecedor)

ALTER TABLE Fornecedores
ADD FOREIGN KEY (Situacao) REFERENCES SituacaoFornecedor(id)

ALTER TABLE FornecedoresBloqueados
ADD FOREIGN KEY (idFornecedor) REFERENCES Fornecedores(idFornecedor)

ALTER TABLE ItensVendas
ADD CONSTRAINT PK_ItensVenda PRIMARY KEY (idVenda, idMedicamento)

ALTER TABLE ItensCompras
ADD CONSTRAINT PK_ItensCompras PRIMARY KEY (idCompra, idPrincipio)

ALTER TABLE Ingredientes
ADD CONSTRAINT PK_Ingredientes PRIMARY KEY (idProducao, idPrincipio)