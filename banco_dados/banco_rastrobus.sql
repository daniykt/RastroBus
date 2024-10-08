create database onibus;
use onibus;

CREATE TABLE PontosDeOnibus (
    id INT PRIMARY KEY AUTO_INCREMENT,
    nome VARCHAR(100) NOT NULL,
    endereco VARCHAR(255) NOT NULL,
    latitude DECIMAL(9, 6) NOT NULL,
    longitude DECIMAL(9, 6) NOT NULL
);

-- Tabela: LinhasDeOnibus
CREATE TABLE LinhasDeOnibus (
    id INT PRIMARY KEY AUTO_INCREMENT,
    numero INT NOT NULL,
    cor ENUM('verde', 'azul', 'vermelha') NOT NULL,
    nome VARCHAR(100) NOT NULL
);

-- Tabela: LinhasPontos
CREATE TABLE LinhasPontos (
    id INT PRIMARY KEY AUTO_INCREMENT,
    linha_id INT,
    ponto_id INT,
    ordem INT,
    FOREIGN KEY (linha_id) REFERENCES LinhasDeOnibus(id),
    FOREIGN KEY (ponto_id) REFERENCES PontosDeOnibus(id)
);

-- Tabela: Horarios
CREATE TABLE Horarios (
    id INT PRIMARY KEY AUTO_INCREMENT,
    linha_id INT,
    ponto_id INT,
    hora_chegada TIME NOT NULL,
    frequencia INT NOT NULL, -- em minutos
    FOREIGN KEY (linha_id) REFERENCES LinhasDeOnibus(id),
    FOREIGN KEY (ponto_id) REFERENCES PontosDeOnibus(id)
);


/* - onsulta para filtrar pontos
SELECT 
    p.nome AS ponto_nome,
    l.numero AS linha_numero,
    l.cor AS linha_cor,
    l.nome AS linha_nome
FROM 
    LinhasPontos lp
JOIN 
    PontosDeOnibus p ON lp.ponto_id = p.id
JOIN 
    LinhasDeOnibus l ON lp.linha_id = l.id
WHERE 
    l.cor IN ('verde');  -- Filtra as linhas pela cor desejada
*/

/* - introduzindo dados
-- Inserindo Pontos de Ônibus
INSERT INTO PontosDeOnibus (nome, endereco, latitude, longitude) VALUES
('Praça Central', 'Praça Central, s/n', -23.550520, -46.633308),
('Av. Brasil', 'Av. Brasil, 1000', -23.551200, -46.635600),
('Terminal Rodoviário', 'Rua da Estação, 150', -23.552000, -46.632000),
('Rua das Flores', 'Rua das Flores, 200', -23.553000, -46.634500);

-- Inserindo Linhas de Ônibus
INSERT INTO LinhasDeOnibus (numero, cor, nome) VALUES
(1, 'verde', 'Linha Verde - Centro'),
(2, 'azul', 'Linha Azul - Parque'),
(3, 'vermelha', 'Linha Vermelha - Shopping');

-- Inserindo a relação entre Linhas e Pontos de Ônibus
INSERT INTO LinhasPontos (linha_id, ponto_id, ordem) VALUES
(1, 1, 1),  -- Linha Verde na Praça Central
(1, 2, 2),  -- Linha Verde na Av. Brasil
(2, 2, 1),  -- Linha Azul na Av. Brasil
(2, 3, 2),  -- Linha Azul no Terminal Rodoviário
(3, 1, 1),  -- Linha Vermelha na Praça Central
(3, 4, 2);  -- Linha Vermelha na Rua das Flores

-- Inserindo Horários
INSERT INTO Horarios (linha_id, ponto_id, hora_chegada, frequencia) VALUES
(1, 1, '08:00:00', 10),  -- Linha Verde na Praça Central
(1, 2, '08:05:00', 10),
(2, 2, '08:10:00', 15),
(2, 3, '08:15:00', 15),
(3, 1, '08:20:00', 12),
(3, 4, '08:25:00', 12);

*/