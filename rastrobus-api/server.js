import express from 'express';
import dotenv from 'dotenv';
import pontos from './routes/pontos.js';
import horarios from './routes/horarios.js'
import { sequelize } from './db/database.js';
import swaggerUI from 'swagger-ui-express';
import swagger from './swagger/swagger.js';
import cors from 'cors';

dotenv.config();

const app = express();
const PORT = 3000;

app.use(express.json());
app.use(cors({
    origin: '*'
}));


app.use("/ponto", pontos);
app.use("/horario", horarios);
app.use("/swagger", swaggerUI.serve, swaggerUI.setup(swagger));

sequelize.sync()
  .then(() => {
    app.listen(PORT, () => {
      console.log(`Servidor rodando na porta ${PORT}`);
    });
  })
  .catch((err) => console.error('Erro ao sincronizar o banco de dados:', err));


