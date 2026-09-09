const express = require('express');
const app = express();
const PORT = 3000;

app.get('/', (req, res) => {
    res.json({
        status: "success",
        project: "Linux Hardened Web Server",
        message: "Node.js application running securely behind Apache Reverse Proxy",
        timestamp: new Date().toISOString(),
        client_ip: req.headers['x-forwarded-for'] || req.socket.remoteAddress
    });
});

app.get('/health', (req, res) => {
    res.status(200).send("OK - Server Healthy");
});

app.listen(PORT, '127.0.0.1', () => {
    console.log(\Backend server running on http://127.0.0.1:\\);
});
