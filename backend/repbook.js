const express = require('express');
const { Pool } = require('pg');
const app = express();
const port = 3000;

app.use(express.json());

const pool = new Pool({
    user: "postgres",
    host: "localhost",
    database: "Demo",
    password: "Apple1206",
    port: 4126
});

app.get('/getAllStudents', async (req, res) => {
    console.log("Received request to getAllStudents");
    try {
        const result = await pool.query('SELECT * FROM students');
        console.log("getAllStudents query result:", result.rows);
        res.json(result.rows);
    } catch (err) {
        console.error("Error in getAllStudents:", err.message);
        res.status(500).send(err.message);
    }
});


app.post('/addStudent', async (req, res) => {
    console.log("Received request to addStudent with body:", req.body);
    try {
        const { first_name, last_name, email, enrollment_date } = req.body;
        const query = 'INSERT INTO students (first_name, last_name, email, enrollment_date) VALUES ($1, $2, $3, $4) RETURNING *';
        const values = [first_name, last_name, email, enrollment_date];
        const result = await pool.query(query, values);
        console.log("addStudent query result:", result.rows[0]);
        res.status(201).json(result.rows[0]);
    } catch (err) {
        console.error("Error in addStudent:", err.message);
        res.status(500).send(err.message);
    }
});

app.put('/updateStudentEmail', async (req, res) => {
    console.log("Received request to updateStudentEmail with body:", req.body);
    try {
        const { student_id, new_email } = req.body;
        const query = 'UPDATE students SET email = $2 WHERE student_id = $1 RETURNING *';
        const values = [student_id, new_email];
        const result = await pool.query(query, values);
        console.log("updateStudentEmail query result:", result.rows[0]);
        res.json(result.rows[0]);
    } catch (err) {
        console.error("Error in updateStudentEmail:", err.message);
        res.status(500).send(err.message);
    }
});

app.delete('/deleteStudent/:student_id', async (req, res) => {
    const student_id = req.params.student_id;
    console.log(`Received request to deleteStudent for student_id: ${student_id}`);
    try {
        const query = 'DELETE FROM students WHERE student_id = $1 RETURNING *';
        const result = await pool.query(query, [student_id]);
        console.log("deleteStudent query result:", result.rows[0]);
        res.json(result.rows[0]);
    } catch (err) {
        console.error("Error in deleteStudent:", err.message);
        res.status(500).send(err.message);
    }
});

app.listen(port, () => {
    console.log(`Server is running on port ${port}`);
});
