SubSchema1 = {
    type: Object,
    objectType: "schema"
    options: {strict: false, _id: false}
    schema: {
        anotherId: String
        otherIds: [String]
    }
}
SubSchema2 = {
    type: Object,
    objectType: "schema"
    options: {strict: false, _id: false}
    schema: {
        anotherId: String
        otherIds: [String]
    }
}

root = {
    type: Object,
    objectType: "schema"
    options: {strict: false, _id: true}
    schema: {
        anId: String
        
        subSchema1: [SubSchema1]
        
        subSchema2: SubSchema2
    }
}
module.exports = root