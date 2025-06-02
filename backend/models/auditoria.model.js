const getMongoClient = require("../config/mongoConnection");

const Auditoria = {
    create: async (data) => {
        try {
            const mongoClient = await getMongoClient();
            const db = mongoClient.db("nomina");
            const collection = db.collection("auditoria");
            await collection.insertOne({
                ...data,
                fecha: new Date()
            });
        } catch (error) {
            throw error;
        }
    },
    
    findAll: async () => {
        try {
            const mongoClient = await getMongoClient();
            const db = mongoClient.db("nomina");
            const collection = db.collection("auditoria");
            const result = await collection.find().toArray();
            console.table(result);
            return result;
        } catch (error) {
            throw error;
        }
    }
};

module.exports = Auditoria;