module.exports =
  {
    type: Object,
    objectType: "schema"
    options: {strict: false}
    schema:
      {
        bareField1: String
        bareField2: Number
        bareField3: Boolean
        idField: {type: String, required: true, fake: "random.uuid"}
        stringField: {type: String, required: true, fake: "lorem.word", taxonomy: ["one", "two", "three"]}
        numberField: {type: Number, required: false, fake: "random.number"}
        booleanField: {type: Boolean, required: false, fake: "random.boolean"}
        arrayOfObjectsField: [
          {
            type: Object,
            objectType: "schema"
            options: {strict: false}
            schema: {Fieldid2: {type: String, required: true, fake: "random.uuid"}}
          }
        ]
        arrayOfObjectsFieldsType2: [
          {Fieldid2: {type: String, required: true, fake: "random.uuid"}}
        ]
        objectField: {
          type: Object,
          objectType: "object",
          schema: {
            idField3: {type: String, required: true, fake: "random.uuid"}
            numberField3: {type: Number, required: false, fake: "random.number"}
            booleanField3: {type: Boolean, required: false, fake: "random.boolean"}
            arrayOfObjectsField3: [
              {
                type: Object,
                objectType: "schema"
                options: {strict: false}
                schema: {Fieldid2: {type: String, required: true, fake: "random.uuid"}}
              }
            ]
            arrayOfObjectsFields3Type2: [
              {Fieldid2: {type: String, required: true, fake: "random.uuid"}}
            ]
            objectField3Type2: {
              idField3: {type: String, required: true, fake: "random.uuid"}
              numberField3: {type: Number, required: false, fake: "random.number"}
              booleanField3: {type: Boolean, required: false, fake: "random.boolean"}
            }
          }
        }
        objectFieldType2: {
          idField3: {type: String, required: true, fake: "random.uuid"}
          numberField3: {type: Number, required: false, fake: "random.number"}
          booleanField3: {type: Boolean, required: false, fake: "random.boolean"}
        }
        arrayField: [{type: Number, required: false, fake: "random.number"}]
      }
  }

  

  
