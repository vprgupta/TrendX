"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
const express_1 = __importDefault(require("express"));
const cors_1 = __importDefault(require("cors"));
const dotenv_1 = __importDefault(require("dotenv"));
const mongoose_1 = __importDefault(require("mongoose"));
require("express-async-errors");
const auth_1 = __importDefault(require("./routes/auth"));
const trends_1 = __importDefault(require("./routes/trends"));
const users_1 = __importDefault(require("./routes/users"));
const errorHandler_1 = require("./middleware/errorHandler");
dotenv_1.default.config();
const app = (0, express_1.default)();
const PORT = process.env.PORT || 3000;
// Middleware
app.use((0, cors_1.default)());
app.use(express_1.default.json());
// MongoDB Connection
const connectDB = async () => {
    try {
        await mongoose_1.default.connect(process.env.MONGODB_URI || 'mongodb://localhost:27017/trendx');
        console.log('✅ MongoDB Connected');
    }
    catch (error) {
        console.error('❌ MongoDB Connection Error:', error);
        process.exit(1);
    }
};
// Routes
app.use('/api/auth', auth_1.default);
app.use('/api/trends', trends_1.default);
app.use('/api/user', users_1.default);
// Health check
app.get('/api/health', (req, res) => {
    res.json({ status: 'OK', message: 'TrendX Backend is running' });
});
// Error handler
app.use(errorHandler_1.errorHandler);
// Start server
const startServer = async () => {
    await connectDB();
    app.listen(PORT, () => {
        console.log(`🚀 TrendX Backend running on port ${PORT}`);
    });
};
startServer();
