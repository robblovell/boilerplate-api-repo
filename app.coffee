express = require('express')
path = require('path')
cors = require('cors')
timeout = require('connect-timeout')
docs = require("express-mongoose-docs")
favicon = require('serve-favicon')
#logger = require('morgan')
cookieParser = require('cookie-parser')
bodyParser = require('body-parser')
routes = require('./routes/index')
require('./config/logging')

config = require('./config/configuration')

haltOnTimedout = (req, res, next) ->
  next() if (!req.timedout)

app = express()

# view engine setup
app.set('views', path.join(__dirname, 'views'))
app.set('view engine', 'jade')

# uncomment after placing your favicon in /public
app.use(favicon(path.join(__dirname, 'public/images', 'favicon.ico')))

app.use(cors())
app.use(bodyParser.json())
app.use(bodyParser.urlencoded({ extended: false }))
app.use(cookieParser())
app.use(require('stylus').middleware(path.join(__dirname, 'public')))
app.use(express.static(path.join(__dirname, 'public')))

app.use('/', routes)
app.use(haltOnTimedout)

mongoose = require('mongoose')
mongoose.Promise = require('bluebird')
mongoose.set("debug",true)
mongoose.connect(config.db) # connect to our database

# link the resource
Resources = {
  Shells: require('./resources/shells/endpoint')(app)
}

swagger = require('./routes/swagger')
swagger(app, Resources, '/api', config)
docs(app, mongoose)

# error handlers
# development error handler
# will print stacktrace
if (app.get('env') == 'development' or app.get('env') == 'local')
  # development error handleripho
  # will print stacktrace
  app.use((err, req, res, next) ->
    if (err?)
      res.status(err.status || 500)
      res.render('error', {
        message: err.message,
        error: err
      })
  )
  app.use(haltOnTimedout)

else
# production error handler
# no stacktraces leaked to user
  app.use((err, req, res, next) ->
    if (err?)
      res.status(err.status || 500)
      res.render('error', {
        message: err.message,
        error: {}
      })
  )
  app.use(haltOnTimedout)

module.exports = [app, config]
