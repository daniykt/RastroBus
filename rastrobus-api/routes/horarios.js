import express from 'express';
import { Horario } from '../model/horario.js';

const router = express.Router();

router.get('/', async (req, res) => {
    try {
        const horarios = await Horario.findAll();
        res.json(horarios);
    } catch (error) {
        res.status(500).json({ error: error.message });
    }
});

router.post('/', async (req, res) => {
    try {
        const horario = await Horario.create(req.body);
        res.status(201).json(horario);
    } catch (error) {
        res.status(400).json({ error: error.message });
    }
});

export default router;
