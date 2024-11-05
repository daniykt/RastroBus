import { DataTypes } from "sequelize";
import { sequelize } from "../db/database.js";
import { Ponto } from "../model/ponto.js"

const Horario = sequelize.define('Horario', {
    id: {
        type: DataTypes.INTEGER,
        autoIncrement: true,
        primaryKey: true,
    },
    ponto_id: {
        type: DataTypes.INTEGER,
        allowNull: false,
        references: {
            model: Ponto, // Faz referência à tabela Pontos
            key: 'id'
        },
        onDelete: 'CASCADE', // Caso um ponto seja deletado, os horários associados também são
        onUpdate: 'CASCADE'
    },
    hora_chegada: {
        type: DataTypes.TIME,
        allowNull: false,
    },
}, {
    tableName: "horarios",
    timestamps: false
});

Ponto.hasMany(Horario, { foreignKey: 'ponto_id' }); // para definir relação entre as tabelas
Horario.belongsTo(Ponto, { foreignKey: 'ponto_id' }); 

export { Horario };