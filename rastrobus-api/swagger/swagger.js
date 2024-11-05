import swaggerJsDoc from 'swagger-jsdoc';

const options = {
  definition: {
    openapi: '3.0.0',
    info: {
      title: 'Rastro Bus API',
      version: '1.0.0',
      description: 'Documentação da API Rastro Bus',
    },
    servers: [
      {
        url: 'http://localhost:3000', // URL do seu servidor
      },
    ],
  },
  apis: ['./routes/pontos.js'], 
};

const specs = swaggerJsDoc(options);
export default specs;
