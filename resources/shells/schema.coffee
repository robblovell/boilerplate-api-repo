Mongoose = require('mongoose')

ResourceName = "shells"

MetaSchema = require('./schema/'+ResourceName)

MakeMongoose = require('../../source/resource-schema-helpers/make-mongoose-schema/index')
FakeMongoose = require('../../source/resource-schema-helpers/fake-mongoose/index')

MongooseSchemaFactory = new MakeMongoose(MetaSchema)
ThisSchema = MongooseSchemaFactory.make()

FakeSchemaFactory = new FakeMongoose(MetaSchema)

module.exports = {
    metaSchema: MetaSchema,
    fakeFactory: FakeSchemaFactory,
    schema: ThisSchema,
    model: Mongoose.model(ResourceName, ThisSchema),
    name: ResourceName
}
