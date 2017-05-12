Resource = require('resourcejs')
handler = require('./handlers')
dependency = require('./dependency')
{ schema, model, name } = require('./schema')

urlPath = ''
resourceName = name

module.exports = (app) ->
    resource = Resource(app, urlPath, resourceName, model)
    .get({
        before: handler(dependency).getBefore
        after: handler(dependency).getAfter
    })
    .post({
        before: handler(dependency).postBefore
        after: handler(dependency).postAfter
    })
    .put({
        before: handler(dependency).putBefore
    })
    .delete({
        before: handler(dependency).deleteBefore
    })
    .index({
        before: handler(dependency).indexBefore
    })

    return resource