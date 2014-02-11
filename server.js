var express = require('express');
var app = express();

app.get('/', function(req, res) {
   fs = require('fs')
   fs.readFile('/srv/www/app1/shared/config/app_data.yml', 'utf8', function (err,data) {
     if (err) {
       return console.log(err);
     }
     res.sendfile(data);
   });
   res.sendfile('./index.html');
});

app.use(express.static('public'));

app.listen(80);
console.log('Listening on port 80');
