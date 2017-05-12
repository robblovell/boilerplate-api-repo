chai = require('chai')
expect = chai.expect
should = chai.should()
assert = chai.assert

MakeMongoose = require('../../source/resource-schema-helpers/make-mongoose-schema/index')

schema = require('../fakes/fakeSchema')

describe 'Test Make Mongoose Schema', () ->
  
  it 'converts a mongoose schema object to a real mongoose schema', (done) ->
    mongooseSchemaFactory = new MakeMongoose(schema)
    
    make = mongooseSchemaFactory.make()
    for k,v of make.obj
      v.should.not.be.null

    (make.obj.bareField1.name).should.be.equal("String")
    (make.obj.bareField2.name).should.be.equal("Number")
    (make.obj.bareField3.name).should.be.equal("Boolean")
    (make.obj.idField.type.name).should.be.equal("String")
    (make.obj.stringField.type.name).should.be.equal("String")
    (make.obj.numberField.type.name).should.be.equal("Number")
    (make.obj.booleanField.type.name).should.be.equal("Boolean")

    assert.isAbove(make.obj.arrayOfObjectsField.length, 0)
    (typeof make.obj.arrayOfObjectsField[0]).should.be.equal("object")
    make.obj.arrayOfObjectsField[0].obj.Fieldid2.type.name.should.be.equal("String")
  
    assert.isAbove(make.obj.arrayOfObjectsFieldsType2.length, 0)
    (typeof make.obj.arrayOfObjectsFieldsType2[0]).should.be.equal("object")
    make.obj.arrayOfObjectsFieldsType2[0].obj.Fieldid2.type.name.should.be.equal("String")

    (make.obj.objectField.idField3.type.name).should.be.equal("String")
    (make.obj.objectField.numberField3.type.name).should.be.equal("Number")
    (make.obj.objectField.booleanField3.type.name).should.be.equal("Boolean")
  
    (make.obj.objectFieldType2.idField3.type.name).should.be.equal("String")
    (make.obj.objectFieldType2.numberField3.type.name).should.be.equal("Number")
    (make.obj.objectFieldType2.booleanField3.type.name).should.be.equal("Boolean")
    
    assert.isAbove(make.obj.arrayField.length, 0)
    make.obj.arrayField[0].type.name.should.be.equal("Number")

    done()
    return
    
    