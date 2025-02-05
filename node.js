const express = require('express');
const app = express();
const http = require('http');
const server = http.createServer(app);
const { Server } = require("socket.io");
const io = new Server(server);
const axios = require('axios');

app.use(express.json()); 

app.get('/', (req, res) => {
  res.sendFile(__dirname + '/index.html');
});

io.on('connection', (socket) => {
  console.log('A user connected');

  socket.on('messagebyUser', async (message) => {
    io.emit('messagebyUser', message);

    try {
        // Send the user's message (question) to Flask
        const response = await axios.post('http://127.0.0.1:2100/query', { question: message.text });

        // Flask should return JSON { "answer": "Here is the result..." }
        const aiMessage = { name: "AI", text: response.data.answer };

        // Emit the AI message to all connected clients
        io.emit('messagebyUser', aiMessage);
    } catch (error) {
        console.error("Error fetching AI response:", error.response ? error.response.data : error.message);
        io.emit('messagebyUser', { name: "AI", text: "Error processing your request." });
    }
});


  socket.on('disconnect', () => {
    console.log('User disconnected');
  });
});

server.listen(3000, () => {
  console.log('Listening on *:3000');
});