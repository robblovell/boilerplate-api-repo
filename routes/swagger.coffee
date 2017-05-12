_ = require('lodash')

module.exports = (app, resources, spec='/spec', config) ->
    paths = {}
    definitions = {}
    _.each(resources, (resource) ->

        swagger = resource.swagger()
        if (swagger.paths["/estimates"]?)
            swagger.paths["/estimates"].get.parameters.push({
                  name: 'query',
                  in: 'query',
                  description: 'Query by example. Pass a JSON object to find a context. For example: {"seller": "xyz", "name": "Scope 3"}.',
                  type: 'string',
                  required: false,
                  default: ''
              }
            )
#        if (swagger.paths["/deliveries"]?)
#            swagger.paths["/deliveries"].get.parameters.push({
#                  name: 'query',
#                  in: 'query',
#                  description: 'Query by example. Pass a JSON object to find a context. For example: {"seller": "xyz", "name": "Scope 3"}.',
#                  type: 'string',
#                  required: false,
#                  default: ''
#              }
#            )

        paths = _.assign(paths, swagger.paths)
        definitions = _.assign(definitions, swagger.definitions)
#        console.log(JSON.stringify(definitions,2, null))
        return
    )

    # Define the specification.
    specification = {
        swagger: '2.0',
        info: {
            description: 'Deal ',
            version: config.version,
            title: 'Deal Service',
            contact: {
                name: 'Build Direct'
            },
#            license: {
#                name: 'MIT',
#                url: 'http://opensource.org/licenses/MIT'
#            }
        },
        host: config.host_url,
        basePath: config.basepath,
        schemes: [config.scheme],
        definitions: definitions,
        paths: paths
#        authorizations: {
#            oauth2: [
#                {scope: "full"
#                }
#            ]
#        }
    }

    # Show the specification at the URL.
    app.get(spec, (req, res, next) ->
        res.json(specification)
    )
