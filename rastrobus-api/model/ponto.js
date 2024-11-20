import { DataTypes } from "sequelize";
import { sequelize } from "../db/database.js";

const Ponto = sequelize.define('Ponto', {
    id: {
        type: DataTypes.INTEGER,
        autoIncrement: true,
        primaryKey: true,
    },
    numero: {
        type: DataTypes.INTEGER,
        allowNull: false,
    },
    cor: {
        type: DataTypes.ENUM('verde', 'vermelha', 'azul'),
        allowNull: false,
    },
    endereco: {
        type: DataTypes.STRING(255),
        allowNull: false,
        validate: {
            len: {
                args: [1, 255],
                msg: "O endereço dever entre 1 e 255 caracteres"
            }
        }
    },
    bairro: {
        type: DataTypes.STRING(150),
        allowNull: false,
        validate: {
            len: {
                args: [1, 150],
                msg: "O bairro dever entre 1 e 150 caracteres"
            }
        }
    },
    latitude: {
        type: DataTypes.DECIMAL(16, 9),
        allowNull: false,
    },
    longitude: {
        type: DataTypes.DECIMAL(16, 9),
        allowNull: false,
    },
    imagem: {
        type: DataTypes.TEXT,
        allowNull: false,
    },
}, {
    tableName: "pontos",
    timestamps: false
});

export { Ponto };