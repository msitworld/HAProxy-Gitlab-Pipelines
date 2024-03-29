const http = require('http');
const port = process.env.PORT || 3000;

const server = http.createServer((req, res) => {
  res.statusCode = 200;

  const timestamp = Date.now();
  
  res.end(`Current timestamp: ${timestamp}\n`);
});

server.listen(port, () => {
  console.log(`Server running on http://localhost:${port}/`);
});
