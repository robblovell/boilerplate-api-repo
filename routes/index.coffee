express = require('express')
router = express.Router()
package_json = require('../package.json');
config = require('../config/configuration')
# GET home page.
router.get('/', (req, res, next) ->
    res.render('index', { title: 'Build Direct API Resource Server', url: req.protocol + '://' + req.get('host') + req.originalUrl })
)
semantics = package_json.version.split('.')
dt1 = new Date();

datetime1 = dt1.toDateString()+' '+dt1.toTimeString()
# GET health check page.
router.get('/ping', (req, res, next) ->
    dt2 = new Date();

    datetime2 = dt2.toUTCString()

    version = {
        "version": {
            "major": semantics[0]
            "minor": semantics[1]
            "build": semantics[2]
        },
        "serviceName": "#{config.serviceName}, Version=#{package_json.version}."
        "utcStartDate": datetime1
        "utcRequestDate": datetime2
#        "environment": process.env
#        "configuration": config
#        "secrets": JSON.stringify(process.env)
    }
    res.render('ping', { version: JSON.stringify(version,null,4) })
)
module.exports = router