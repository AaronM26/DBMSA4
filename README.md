Student Management System - COMP3005 A4
Author
Aaron McLean
Student ID: 101226419

Overview
This project is a part of the COMP3005 course assignment 4. It implements a basic Student Management System using Swift for the frontend and Node.js with Express for the backend, interfacing with a PostgreSQL database. The system allows for performing CRUD (Create, Read, Update, Delete) operations on student data.

Features
The application supports the following functionalities:

Fetch All Students: Retrieves and displays a list of all students.
Add Student: Adds a new student record to the database.
Update Student Email: Updates the email address of an existing student.
Delete Student: Removes a student record from the database.
Setup Instructions
Database Setup
Install PostgreSQL and create a new database named Demo.
Use the provided SQL scripts to set up the students table and insert initial data.
Server Setup
Navigate to the server directory.
Run npm install to install dependencies.
Start the server using node server.js.
Application Setup
Open the Swift project in Xcode.
Ensure that the backend server is running.
Build and run the application using Xcode.
How to Use
On launching the application, you will see four sections, each corresponding to a CRUD operation.
Enter the required information in the text fields and use the buttons to perform actions.
The "Fetch All Students" button will display the list of students in the app.
Backend API
The Node.js server provides endpoints for each of the CRUD operations, connecting to the PostgreSQL database to execute queries.

Error Handling
The application and server include basic error handling for network requests and database operations.

Video Demonstration
A demonstration video showing the functionality of the application is available here. https://youtu.be/NK_MsYPk7K0
