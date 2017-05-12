chai = require('chai')
expect = chai.expect
should = chai.should()
assert = chai.assert
_ = require('lodash')
schemaFake = require('../fakes/fakeSchema')
FakeMongoose = require('../../source/resource-schema-helpers/fake-mongoose/index')

fakeFactory = new FakeMongoose(schemaFake)

fakeGood = fakeFactory.fake()
fakeBadTypes = fakeFactory.fake()
fakeBadTypes.idField = 12345
fakeBadTypes.stringField = true
fakeBadTypes.numberField = "string"
fakeBadTypes.booleanField = 20

fakeMissingFields = fakeFactory.fake()
delete fakeMissingFields.bareField1
delete fakeMissingFields.bareField2
delete fakeMissingFields.bareField3

Validator = require('../../source/resource-schema-helpers/validator/index')
validator = new Validator(schemaFake)

describe 'Validator', () ->

  it "Validates an good instance using it's schema", () ->
    validation = validator.validate(fakeGood)
    validation.result.should.be.equal(true)
    expect(validation.result).to.be.equal(true)
    Object.keys(validation.correctFields).length.should.be.equal(29)
    _.isEmpty(validation.extraFields).should.be.true
    _.isEmpty(validation.missingFields).should.be.true
    _.isEmpty(validation.nullFields).should.be.true
    _.isEmpty(validation.wrongType).should.be.true
    return

  it "Validates an wrong types in an instance using it's schema", () ->
    validation = validator.validate(fakeBadTypes)
    validation.result.should.be.equal(false)
    validation.wrongType.idField.should.be.equal("type wrong for idField value: 12345 type is:number but type should be: string")
    validation.wrongType.stringField.should.be.equal("type wrong for stringField value: true type is:boolean but type should be: string")
    validation.wrongType.numberField.should.be.equal("type wrong for numberField value: string type is:string but type should be: number")
    validation.wrongType.booleanField.should.be.equal("type wrong for booleanField value: 20 type is:number but type should be: boolean")
    _.isEmpty(validation.extraFields).should.be.true
    _.isEmpty(validation.missingFields).should.be.true
    _.isEmpty(validation.nullFields).should.be.true

    return

  it "Validates that fields are missing in an instance.", () ->
    validation = validator.validate(fakeMissingFields)
    validation.result.should.be.equal(true)
    validation.missingFields.bareField1.should.be.equal('Extra Field bareField1 has value: {"required":false,"fake":"lorem.word"}')
    validation.missingFields.bareField2.should.be.equal('Extra Field bareField2 has value: {"required":false,"fake":"random.number"}')
    validation.missingFields.bareField3.should.be.equal('Extra Field bareField3 has value: {"required":false,"fake":"random.boolean"}')
    Object.keys(validation.missingFields).length.should.be.equal(3)
    return

  it "Validates that fields are not missing in an instance using an example", () ->
    example = { idField: {type: String, required: true, fake: "random.uuid"}}
    validation = validator.validate(fakeGood, example)
    validation.result.should.be.equal(true)
    return

  it "Validates that fields are not null in an instance using an example", () ->
    example = { idField: {type: String, required: true, fake: "random.uuid"}}
    fakeGood.idField = null
    validation = validator.validate(fakeGood, example)
    Object.keys(validation.nullFields).length.should.be.equal(1)
    validation.nullFields.idField.should.be.equal("Field idField is null")
    validation.result.should.be.equal(true)
    return

  it "Validates that fields are correct in an instance using an example", () ->
    example = { idField: {type: String, required: true, fake: "random.uuid"}}
    validation = validator.validate(fakeMissingFields, example)
    validation.result.should.be.equal(true)
    validation.correctFields.idField.startsWith("type correct for idField value:").should.be.equal(true)
    validation.extraFields.arrayField.startsWith("Extra Field arrayField has value:").should.be.equal(true)
    Object.keys(validation.extraFields).length.should.be.equal(8)
    return

  it "Validates null date as only null", () ->
    exampleMeataSchema = {
      type: Object,
      objectType: "schema"
      options: {_id:false, strict:false}
      schema: {
        dateField: {type: Date, required: false, fake: "date.recent"}
      }
    }
    fakeExampleFactory = new FakeMongoose(exampleMeataSchema)
    fake = fakeExampleFactory.make()
    validator2 = new Validator(exampleMeataSchema)

    validation = validator2.validate(fake)
    validation.result.should.be.equal(true)
    _.isEmpty(validation.extraFields).should.be.true
    _.isEmpty(validation.missingFields).should.be.true
    _.isEmpty(validation.nullFields).should.be.true
    _.isEmpty(validation.wrongType).should.be.true
    validation.correctFields.dateField.startsWith('type correct for dateField value:').should.be.true
    Object.keys(validation.correctFields).length.should.be.equal(1)
    fake.dateField = null
    validation = validator2.validate(fake)
    validation.result.should.be.equal(true)
    _.isEmpty(validation.extraFields).should.be.true
    _.isEmpty(validation.missingFields).should.be.true
    _.isEmpty(validation.correctFields).should.be.true
    _.isEmpty(validation.wrongType).should.be.true
    Object.keys(validation.nullFields).length.should.be.equal(1)
    validation.nullFields.dateField.should.be.equal('Field dateField is null')
    return

  it "Validates values in an array", () ->
    exampleMeataSchema = {
      type: Object,
      objectType: "schema"
      options: {_id:false, strict:false}
      schema: {
        arrayField: [
          {
            type: Object,
            objectType: "schema"
            options: {_id: false, strict: false}
            schema: {
              dateField: {type: Date, required: false, fake: "date.recent"}
            }
          }
        ]
        objectField: {
          type: Object,
          objectType: "schema"
          options: {_id: false, strict: false}
          schema: {
            dateField: {type: Date, required: false, fake: "date.recent"}
          }
        }
        arrayField2: [{type: Number, required: false, fake: "random.number"}]

      }
    }
    fakeExampleFactory = new FakeMongoose(exampleMeataSchema)
    fake = fakeExampleFactory.make()
    validator3= new Validator(exampleMeataSchema)

    fake.arrayField[1] = _.cloneDeep(fake.arrayField[0])
    validation = validator3.validate(fake)
    validation.result.should.be.equal(true)
    validation.correctFields["arrayField"].startsWith("type correct for arrayField value:").should.be.true
    validation.correctFields["arrayField[0]-dateField"].startsWith("type correct for dateField value:").should.be.true
    validation.correctFields["arrayField[1]-dateField"].startsWith("type correct for dateField value:").should.be.true
    validation.correctFields["objectField"].startsWith("type correct for objectField value:").should.be.true
    validation.correctFields["objectField-dateField"].startsWith("type correct for dateField value:").should.be.true
    validation.correctFields["arrayField2"].startsWith("type correct for arrayField2 value:").should.be.true
    validation.correctFields["arrayField2[0]-number"].startsWith("type correct for number value:").should.be.true

    return

  it "Validates that fields are wrong but not strictly enforced in an instance using an example", () ->
    example = { idField: {type: Number, required: true, fake: "random.uuid", typeNotValidated: true}}
    validation = validator.validate(fakeMissingFields, example)
    validation.result.should.be.equal(true)
    validation.typeMismatch.idField.startsWith("type wrong for idField value:").should.be.equal(true)
    validation.extraFields.arrayField.startsWith("Extra Field arrayField has value:").should.be.equal(true)
    Object.keys(validation.extraFields).length.should.be.equal(8)
    return

  it "Validates using validation fuction for string", () ->
    exampleMeataSchema = {
      type: Object,
      objectType: "schema"
      options: {_id:false, strict:false}
      schema: {
        stringField: { type: String, required: false, fake: "lorem.word",
        validation: ((value) -> return (value is "correct")),
        message: "Value must be a string"
        }
      }
    }
    fakeExampleFactory = new FakeMongoose(exampleMeataSchema)
    fake = fakeExampleFactory.make()
    validator2 = new Validator(exampleMeataSchema)

    validation = validator2.validate(fake)
    validation.result.should.be.equal(false)

    _.isEmpty(validation.valueInvalid).should.be.false

    fake.stringField = "correct"
    validation = validator2.validate(fake)
    validation.result.should.be.equal(true)

    _.isEmpty(validation.valueInvalid).should.be.true
    return

  it "Validates using validation fuction for number < 15000", () ->
    exampleMeataSchema = {
      type: Object,
      objectType: "schema"
      options: {_id:false, strict:false}
      schema: {
        field: { type: Number, required: false, fake: "lorem.word",
        validation: ((value) -> return (value < 15000)),
        message: "Value must be a number < 15000"
        }
      }
    }
    fakeExampleFactory = new FakeMongoose(exampleMeataSchema)
    fake = fakeExampleFactory.make()
    validator2 = new Validator(exampleMeataSchema)

    fake.field = 15000
    validation = validator2.validate(fake)
    validation.result.should.be.equal(false)
    _.isEmpty(validation.valueInvalid).should.be.false

    fake.field = 14999
    validation = validator2.validate(fake)
    validation.result.should.be.equal(true)
    _.isEmpty(validation.valueInvalid).should.be.true
    
    return

  it "Validates using validation fuction in taxonomy", () ->
    exampleMeataSchema = {
      type: Object,
      objectType: "schema"
      options: {_id:false, strict:false}
      schema: {
        field: { type: String, required: false, fake: "lorem.word",
        validation: ((value) -> return value in @taxonomy),
        message: "Value must be in a valid package",
        taxonomy:["item", "box", "pallet", "roll", "carton", "bundle", "crate", "drum", "pail", "tube"]
        }
      }
    }
    fakeExampleFactory = new FakeMongoose(exampleMeataSchema)
    fake = fakeExampleFactory.make()
    validator2 = new Validator(exampleMeataSchema)

    fake.field = "blah"
    validation = validator2.validate(fake)
    validation.result.should.be.equal(false)
    _.isEmpty(validation.valueInvalid).should.be.false
    console.log(JSON.stringify(validation.valueInvalid))

    fake.field = "box"
    validation = validator2.validate(fake)
    validation.result.should.be.equal(true)
    _.isEmpty(validation.valueInvalid).should.be.true

    return

  it "Validates using taxonomy only", () ->
    exampleMeataSchema = {
      type: Object,
      objectType: "schema"
      options: {_id:false, strict:false}
      schema: {
        field: {
          type: String, required: false, fake: "lorem.word",
          taxonomy:["item", "box", "pallet", "roll", "carton", "bundle", "crate", "drum", "pail", "tube"]
        }
      }
    }
    fakeExampleFactory = new FakeMongoose(exampleMeataSchema)
    fake = fakeExampleFactory.make()
    validator2 = new Validator(exampleMeataSchema)

    fake.field = "blah"
    validation = validator2.validate(fake)
    validation.result.should.be.equal(false)
    _.isEmpty(validation.valueInvalid).should.be.false
    console.log(JSON.stringify(validation.valueInvalid))

    fake.field = "box"
    validation = validator2.validate(fake)
    validation.result.should.be.equal(true)
    _.isEmpty(validation.valueInvalid).should.be.true

    return

  it "Validates using validation fuction for class codes", () ->
    exampleMeataSchema = {
      type: Object,
      objectType: "schema"
      options: {_id:false, strict:false}
      schema: {
        stringField: { type: String, required: false, fake: "lorem.word",
        clean: ((value) -> return parseFloat(value).toFixed(2)),
        validation: ((value) -> return value.indexOf('.') > 0 and value.indexOf('.') is value.length-3)
        message: "Value must be a string with two decimal places."
        }
      }
    }
    fakeExampleFactory = new FakeMongoose(exampleMeataSchema)

    validator2 = new Validator(exampleMeataSchema)
    fake = fakeExampleFactory.make()

    fake.stringField = "55"
    validation = validator2.validate(fake)
    validation.result.should.be.equal(false)
    _.isEmpty(validation.valueInvalid).should.be.false

    fake.stringField = "55.00"
    validation = validator2.validate(fake)
    validation.result.should.be.equal(true)
    _.isEmpty(validation.valueInvalid).should.be.true

    fake.stringField = "55.0"
    validation = validator2.validate(fake)
    validation.result.should.be.equal(false)
    _.isEmpty(validation.valueInvalid).should.be.false

    fake.stringField = "55.0"
    validation = validator2.validate(fake)
    validation.result.should.be.equal(false)
    _.isEmpty(validation.valueInvalid).should.be.false

    fake.stringField = "72.50"
    validation = validator2.validate(fake)
    validation.result.should.be.equal(true)
    _.isEmpty(validation.valueInvalid).should.be.true
    return