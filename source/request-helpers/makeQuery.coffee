_ = require('lodash')
ObjectId = require('mongodb').ObjectID
#  projection = {"expiryDate":1, "_id":1, "expired":1}
#  sort = { "_id": 1 }
#  example = {"expired": { "$eq": false }}
#  example = {"expiryDate":{"$gte": "$date": "2017-03-31T02:07:40.525Z"}}
#  example = {"expiryDate":{"$eq": ""2017-04-10T23:41:38.569Z""}}
#  example = {"_id": "58b849ca22b0ac4d468fec00"}
# {"_id": "58cab29608250d580ee36519", "expired": false, "expiryDate": { "$lt": "2017-03-31T02:07:40.525Z" }}
#  {"possibleDeliveries": {"$elemMatch": {"totalEstimate": "170.33"}}}
# {"request.originLocation.postalCode": "37188"}

module.exports = (model, parameters, requiredFields,  defaultQuery={}) ->

  projection = null
  if (parameters['select']?)
    projection = JSON.parse(parameters['select'])
  else if (parameters['projection']?)
    projection = JSON.parse(parameters['projection'])

  if (parameters['query']?)
    example = parameters['query']
  else if (parameters['find']?)
    example = parameters['find']
  else
    example = JSON.stringify(defaultQuery)

  example = JSON.parse(example)

  example = _.extend(example, requiredFields) if (Object.keys(requiredFields).length > 0)
  if projection?
    query = model.find(example, projection)
  else
    query = model.find(example)

  # add orderby
  # example orderby={ exipryDate: -1 }
  query = query.sort(JSON.parse(parameters['orderby'])) if parameters['orderby']
  query = query.sort(JSON.parse(parameters['sort'])) if parameters['sort']
  # add limit
  # limit=10 default 20 records
  query = query.limit(JSON.parse(parameters['limit'])) if parameters['limit']
  query = query.limit(JSON.parse(parameters['take'])) if parameters['take']
  # add skip default skip is 0
  # skip=10
  query = query.skip(JSON.parse(parameters['skip'])) if parameters['skip']
  query = query.skip(JSON.parse(parameters['offset'])) if parameters['offset']

  return query