DROP VIEW IF EXISTS PedidosClientes;
DROP TRIGGER IF EXISTS CalcularTotalPedidos;
DROP TABLE IF EXISTS Pedidos;
DROP TABLE IF EXISTS Clientes;


-- Criar tabela Clientes
CREATE TABLE Clientes (
    IDCliente INT AUTO_INCREMENT PRIMARY KEY,
    Nome VARCHAR(50),
    Sobrenome VARCHAR(50),
    Email VARCHAR(100),
    TotalPedidos DECIMAL(10, 2) DEFAULT 0
);

-- Inserir dados de exemplo na tabela Clientes
INSERT INTO Clientes (Nome, Sobrenome, Email) VALUES
('João', 'Silva', 'joao@email.com'),
('Maria', 'Santos', 'maria@email.com');

-- Criar tabela Pedidos
CREATE TABLE Pedidos (
    IDPedido INT AUTO_INCREMENT PRIMARY KEY,
    IDCliente INT,
    Detalhes VARCHAR(200),
    Valor DECIMAL(10, 2),
    FOREIGN KEY (IDCliente) REFERENCES Clientes(IDCliente)
);

-- Inserir dados de exemplo na tabela Pedidos
INSERT INTO Pedidos (IDCliente, Detalhes, Valor) VALUES
(1, 'Pedido 1 - Detalhes', 50.00),
(2, 'Pedido 2 - Detalhes', 75.00);

DELIMITER //

CREATE TRIGGER CalcularTotalPedidos
AFTER INSERT ON Pedidos
FOR EACH ROW
BEGIN
    DECLARE total DECIMAL(10, 2);
    SELECT SUM(Valor) INTO total FROM Pedidos WHERE IDCliente = NEW.IDCliente;
    UPDATE Clientes SET TotalPedidos = total WHERE IDCliente = NEW.IDCliente;
END;
//

DELIMITER ;

CREATE VIEW PedidosClientes AS
SELECT c.IDCliente, c.Nome, c.Sobrenome, p.IDPedido, p.Detalhes, p.Valor
FROM Clientes c
JOIN Pedidos p ON c.IDCliente = p.IDCliente;


SELECT pc.IDCliente, pc.Nome, pc.Sobrenome, SUM(pc.Valor) AS ValorTotalPedidos
FROM PedidosClientes pc
GROUP BY pc.IDCliente, pc.Nome, pc.Sobrenome;

