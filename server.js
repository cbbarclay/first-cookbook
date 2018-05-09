var express = require('express');
var app = express();

app.get('/', function(req, res) {
    res.setHeader('Content-Type', 'text/plain');
    res.send(JSON.stringify({'environment': process.env.TEST_ENV}));
    res.sendfile('/srv/www/app1/shared/config/app_data.yml');
});

app.use(express.static('public'));

app.listen(80);
console.log('Listening on port 80');
gdfgdfg
