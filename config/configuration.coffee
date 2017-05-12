package_json = require('../package.json')

serviceName = "deals"
domainName = "builddirect.com"

node_env = if process.env.NODE_ENV? then process.env.NODE_ENV.toLowerCase() else 'local'
port_suffix = '105'
# setup defaults for port, scheme and host.
ports = {
  local: '3000',
  dev: '8' + port_suffix,
  production: '4' + port_suffix
}
port = ports[node_env]
scheme = 'https'
host = serviceName + '.' + node_env + '.' + domainName

if node_env is 'production'
  host = serviceName + '.' + domainName
else if node_env is 'local'
  host = 'localhost'
  scheme = 'http'

config =
  env: node_env
  port: process.env.EXTERNAL_PORT || port
  host: process.env.HOST || host
  scheme: process.env.SCHEME || scheme
  db: process.env.DB || 'mongodb://localhost:27017/deals'
  internal_port: process.env.PORT || '3000'
  basepath: '/'
  version: package_json.version
  timeout: process.env.TIMEOUT || 15000
  serviceName: serviceName

config.host_url = config.host + ':' + config.port

module.exports = config