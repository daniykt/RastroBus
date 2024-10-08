CREATE DATABASE RastroBus;
USE RastroBus;

CREATE TABLE PontosOnibus (
    ponto_id INT PRIMARY KEY AUTO_INCREMENT,
    numero INT NOT NULL, 
    cor ENUM('verde', 'azul', 'vermelha') NOT NULL, 
    endereco VARCHAR(255) NOT NULL, 
    latitude DECIMAL(9, 6) NOT NULL, 
    longitude DECIMAL(9, 6) NOT NULL
);

CREATE TABLE Horarios (
    id INT PRIMARY KEY AUTO_INCREMENT,
    ponto_id INT,
    hora_chegada TIME NOT NULL,  
    FOREIGN KEY (ponto_id) REFERENCES PontosOnibus(ponto_id) ON DELETE CASCADE ON UPDATE CASCADE 
);

SELECT 
    po.numero AS numero_ponto, 
    po.cor, 
    po.endereco, 
    po.latitude, 
    po.longitude, 
    h.hora_chegada
FROM 
    PontosOnibus po
JOIN 
    Horarios h ON po.ponto_id = h.ponto_id
WHERE 
    po.cor = 'verde'; 





