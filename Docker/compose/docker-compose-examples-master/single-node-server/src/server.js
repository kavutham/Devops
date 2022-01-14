const express = require('express');


const app = express();

const port = 3070;

app.get('/', (req, res) => {
  console.log('default route');
  res.send('App works!!!!')
});

app.get('/hello/:name', (req,res) => {
    res.send(`sdfsfsdfdf, ${req.params.name}`);
});


app.get('*', (req, res) => {
  console.log('users route');
  res.send('App works!!!!!');
});

app.listen(port, (err) => {
  if (err) {
    logger.error('Error::', err);
  }
  console.log(`running server on from port:::::::${port}`);
});