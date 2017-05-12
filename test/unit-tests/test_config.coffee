chai = require('chai')
expect = chai.expect
should = chai.should()
assert = chai.assert
version = require('../../package.json').version
mock = require('mock-require')
config = require('../../config/configuration')
#verifyMessage = ""
times = 0
class Logger
  constructor: (config) ->

  log: (level, message) ->
    times += 1
    if times > 1
      message.should.be.equal('CONFIGURATION: no neo4j database connection string specified.')
    #        else
    #            message.should.be.equal(verifyMessage)
    #        console.log(level + " " + message)
    return

class Sentry
  constructor: (config) ->
#        console.log(config)
    return

mock('winston', {
  Logger: Logger
})
mock('winston-sentry', Sentry)

describe 'Test Read Configuration', () ->
  require_config = () ->
    for key,value of require.cache
      if (key.includes('configuration'))
        delete(require.cache[key])
    return require('../../config/configuration')

  base_dir = __dirname.replace('test', 'config')

  it 'reads local configuration environment', (done) ->
    process.env.NODE_ENV = 'local'
    times = 0

    config = require_config()

    config.env.should.be.equal("local")
    config.port.should.be.equal("3000")
    config.host.should.be.equal("localhost")
    config.scheme.should.be.equal("http")
    config.db.should.be.equal("mongodb://localhost:27017/#{config.serviceName}")
    config.internal_port.should.be.equal("3000")
    config.basepath.should.be.equal("/")
    config.version.should.be.equal(version)
    config.timeout.should.be.equal(15000)
    config.host_url.should.be.equal("localhost:3000")
    done()
    return

  it 'reads dev configuration environment', (done) ->
    process.env.NODE_ENV = 'dev'
    times = 0
    config = require_config()

    config.env.should.be.equal("dev")
    config.port.should.be.equal("8105")
    config.host.should.be.equal("#{config.serviceName}.dev.builddirect.com")
    config.scheme.should.be.equal("https")
    config.db.should.be.equal("mongodb://localhost:27017/#{config.serviceName}")
    config.internal_port.should.be.equal("3000")
    config.basepath.should.be.equal("/")
    config.version.should.be.equal(version)
    config.timeout.should.be.equal(15000)

    done()
    return

  it 'reads production configuration environment', (done) ->
    process.env.NODE_ENV = 'production'
    times = 0
    process.env.DB = "mongodb://test:27017/#{config.serviceName}"
    config = require_config()

    config.env.should.be.equal("production")
    config.port.should.be.equal("4105")
    config.host.should.be.equal("#{config.serviceName}.builddirect.com")
    config.scheme.should.be.equal("https")
    config.db.should.be.equal("mongodb://test:27017/#{config.serviceName}")
    config.internal_port.should.be.equal("3000")
    config.basepath.should.be.equal("/")
    config.version.should.be.equal(version)
    config.timeout.should.be.equal(15000)
    done()
    return
