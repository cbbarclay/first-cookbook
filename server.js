var express = require('express');
var app = express();

app.get('/', function(req, res) {
    res.setHeader('Content-Type', 'text/plain');
    res.writeHead(200);
    var stream = fs.createReadStream('/srv/www/app1/shared/config/app_data.yml');
    util.pump(stream, res, function(error) {
        res.end();
        return;
    }
});

app.use(express.static('public'));

app.listen(80);
console.log('Listening on port 80');
