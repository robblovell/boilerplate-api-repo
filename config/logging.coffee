package_json = require('../package.json')

winston = require('winston')
Sentry = require('winston-sentry')
require('winston-loggly-bulk')
config = require('./configuration')
node_env = if process.env.NODE_ENV? then process.env.NODE_ENV.toLowerCase() else 'local'
try
  winstonConfig = {
    transports: [
      new winston.transports.Console()
    ]
  }
  if process.env.RAVEN_KEY?
    winstonConfig.transports.push(
      new Sentry({
        level: "warn",
        dsn: process.env.RAVEN_KEY,
        environment: node_env,
        tags: { service: "routing-service", version: package_json, environment: node_env },
        extra: { service: "routing-service", version: package_json, environment: node_env }
      })
    )
  logger = new winston.Logger(winstonConfig)
  if process.env.LOGGLY_KEY?
    logger.add(winston.transports.Loggly, {
      token: process.env.LOGGLY_KEY,
      subdomain: "builddirect",
      tags: [config.serviceName, "#{node_env}"],
      json:true
    });

  # replace console.log with winston logger.
  #preservedConsoleLog = console.log
  console.log = () ->
  #  preservedConsoleLog.apply(console, arguments)
    if arguments.length is 1
      logger.log.apply(logger, ["info",arguments[0]])
    else
      logger.log.apply(logger, arguments)
    return
catch error
  console.log("Error with logging instantiation: #{JSON.stringify(error.message)}")
  return