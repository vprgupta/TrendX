"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.disconnectDB = exports.connectDB = void 0;
const mongoose_1 = __importDefault(require("mongoose"));
const mongodb_memory_server_1 = require("mongodb-memory-server");
let mongoServer;
const connectDB = async () => {
    try {
        if (process.env.NODE_ENV === 'development' && !process.env.MONGODB_URI?.includes('mongodb+srv')) {
            // Use in-memory database for development
            mongoServer = await mongodb_memory_server_1.MongoMemoryServer.create();
            const mongoUri = mongoServer.getUri();
            await mongoose_1.default.connect(mongoUri);
            console.log('✅ Connected to In-Memory MongoDB');
        }
        else {
            // Use provided MongoDB URI (local or cloud)
            await mongoose_1.default.connect(process.env.MONGODB_URI || 'mongodb://localhost:27017/trendx');
            console.log('✅ MongoDB Connected');
        }
    }
    catch (error) {
        console.error('❌ MongoDB Connection Error:', error);
        process.exit(1);
    }
};
exports.connectDB = connectDB;
const disconnectDB = async () => {
    try {
        await mongoose_1.default.disconnect();
        if (mongoServer) {
            await mongoServer.stop();
        }
    }
    catch (error) {
        console.error('Error disconnecting from database:', error);
    }
};
exports.disconnectDB = disconnectDB;
