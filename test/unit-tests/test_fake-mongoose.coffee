chai = require('chai')
expect = chai.expect
should = chai.should()
assert = chai.assert

FakeMongoose = require('../../source/resource-schema-helpers/fake-mongoose/index')
schemaFake = require('../fakes/fakeSchema')

describe 'Test Fake Mongoose', () ->
  it 'converts mongoose schema with fake attributes to plain js object', (done) ->
    fakeFactory = new FakeMongoose(schemaFake)
    fake = fakeFactory.fake()
    for k,v of fake
      v.should.not.be.null

    (typeof fake.bareField1).should.be.equal("string")
    (typeof fake.bareField2).should.be.equal("number")
    (typeof fake.bareField3).should.be.equal("boolean")
    (typeof fake.idField).should.be.equal("string")
    (typeof fake.stringField).should.be.equal("string")
    (typeof fake.numberField).should.be.equal("number")
    (typeof fake.booleanField).should.be.equal("boolean")

    assert.isAbove(fake.arrayOfObjectsField.length, 0)
    (typeof fake.arrayOfObjectsField[0]).should.be.equal("object")
    (typeof fake.arrayOfObjectsField[0].Fieldid2).should.be.equal("string")

    assert.isAbove(fake.arrayOfObjectsFieldsType2.length, 0)
    (typeof fake.arrayOfObjectsFieldsType2[0]).should.be.equal("object")
    (typeof fake.arrayOfObjectsFieldsType2[0].Fieldid2).should.be.equal("string")

    (typeof fake.objectField.idField3).should.be.equal("string")
    (typeof fake.objectField.numberField3).should.be.equal("number")
    (typeof fake.objectField.booleanField3).should.be.equal("boolean")

    (typeof fake.objectFieldType2.idField3).should.be.equal("string")
    (typeof fake.objectFieldType2.numberField3).should.be.equal("number")
    (typeof fake.objectFieldType2.booleanField3).should.be.equal("boolean")

    assert.isAbove(fake.arrayField.length, 0)
    (typeof fake.arrayField[0]).should.be.equal("number")

    done()
    return

  it 'converts mongoose schema with fake attributes to example schema js object', (done) ->
    fakeFactory = new FakeMongoose(schemaFake, true, true)
    fake = fakeFactory.make()
    for k,v of fake
      v.should.not.be.null

    (fake.bareField1.type.name).should.be.equal("String")
    (fake.bareField1.required).should.be.equal(false)
    (fake.bareField1.fake).should.be.equal("lorem.word")

    (fake.bareField2.type.name).should.be.equal("Number")
    (fake.bareField2.required).should.be.equal(false)
    (fake.bareField2.fake).should.be.equal("random.number")

    (fake.bareField3.type.name).should.be.equal("Boolean")
    (fake.bareField3.required).should.be.equal(false)
    (fake.bareField3.fake).should.be.equal("random.boolean")

    (fake.idField).should.be.equal(schemaFake.schema.idField)
    (fake.stringField).should.be.equal(schemaFake.schema.stringField)
    (fake.numberField).should.be.equal(schemaFake.schema.numberField)
    (fake.booleanField).should.be.equal(schemaFake.schema.booleanField)

    assert.isAbove(fake.arrayOfObjectsField.length, 0)
    (typeof fake.arrayOfObjectsField[0]).should.be.equal("object")
    (fake.arrayOfObjectsField[0].Fieldid2).should.be.equal(schemaFake.schema.arrayOfObjectsField[0].schema.Fieldid2)

    assert.isAbove(fake.arrayOfObjectsFieldsType2.length, 0)
    (typeof fake.arrayOfObjectsFieldsType2[0]).should.be.equal("object")
    (fake.arrayOfObjectsFieldsType2[0].Fieldid2).should.be.equal(schemaFake.schema.arrayOfObjectsFieldsType2[0].Fieldid2)

    (fake.objectField.idField3).should.be.equal(schemaFake.schema.objectField.schema.idField3)
    (fake.objectField.numberField3).should.be.equal(schemaFake.schema.objectField.schema.numberField3)
    (fake.objectField.booleanField3).should.be.equal(schemaFake.schema.objectField.schema.booleanField3)

    (fake.objectFieldType2.idField3).should.be.equal(schemaFake.schema.objectFieldType2.idField3)
    (fake.objectFieldType2.numberField3).should.be.equal(schemaFake.schema.objectFieldType2.numberField3)
    (fake.objectFieldType2.booleanField3).should.be.equal(schemaFake.schema.objectFieldType2.booleanField3)

    assert.isAbove(fake.arrayField.length, 0)
    (fake.arrayField[0]).should.be.equal(schemaFake.schema.arrayField[0])

    done()
    return

