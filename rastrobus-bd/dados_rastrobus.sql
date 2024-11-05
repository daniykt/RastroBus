CREATE DATABASE rastrobus;
USE rastrobus;
drop database rastrobus;

CREATE TABLE pontos (
    id INT PRIMARY KEY AUTO_INCREMENT,
    numero INT NOT NULL, 
    cor ENUM('#00FF00', '#0000FF', '#FF0000') NOT NULL, 
    endereco VARCHAR(255) NOT NULL, 
    bairro varchar(150) not null,
    latitude DECIMAL(9, 6) NOT NULL, 
    longitude DECIMAL(9, 6) NOT NULL,
    imagem longtext
);

CREATE TABLE Horarios (
    id INT PRIMARY KEY AUTO_INCREMENT,
    ponto_id INT,
    hora_chegada TIME NOT NULL,  
    FOREIGN KEY (ponto_id) REFERENCES horarios(id) ON DELETE CASCADE ON UPDATE CASCADE 
);







