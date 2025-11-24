"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
const express_1 = __importDefault(require("express"));
const cors_1 = __importDefault(require("cors"));
const helmet_1 = __importDefault(require("helmet"));
const express_rate_limit_1 = __importDefault(require("express-rate-limit"));
const dotenv_1 = __importDefault(require("dotenv"));
const path_1 = __importDefault(require("path"));
const http_1 = require("http");
const socket_io_1 = require("socket.io");
require("express-async-errors");
const auth_1 = __importDefault(require("./routes/auth"));
const trends_1 = __importDefault(require("./routes/trends"));
const users_1 = __importDefault(require("./routes/users"));
const admin_1 = __importDefault(require("./routes/admin"));
const sessions_1 = __importDefault(require("./routes/sessions"));
const errorHandler_1 = require("./middleware/errorHandler");
const database_1 = require("./config/database");
dotenv_1.default.config();
const app = (0, express_1.default)();
const server = (0, http_1.createServer)(app);
const io = new socket_io_1.Server(server, {
    cors: { origin: '*', methods: ['GET', 'POST'] }
});
// Middleware to pass io to routes
app.use((req, res, next) => {
    req.io = io;
    next();
});
const PORT = process.env.PORT || 3000;
// Make io available globally
app.set('io', io);
// Security middleware
app.use((0, helmet_1.default)());
app.use((0, cors_1.default)());
app.use(express_1.default.json({ limit: '10mb' }));
// Rate limiting
const generalLimiter = (0, express_rate_limit_1.default)({
    windowMs: 15 * 60 * 1000, // 15 minutes
    max: 100, // limit each IP to 100 requests per windowMs
    message: { error: 'Too many requests, please try again later' }
});
const authLimiter = (0, express_rate_limit_1.default)({
    windowMs: 15 * 60 * 1000,
    max: 5, // limit auth requests
    message: { error: 'Too many auth attempts, please try again later' }
});
app.use('/api/', generalLimiter);
app.use('/api/auth/', authLimiter);
// Serve static files (HTML dashboards)
app.use(express_1.default.static(path_1.default.join(__dirname, '..')));
// Routes
app.use('/api/auth', auth_1.default);
app.use('/api/trends', trends_1.default);
app.use('/api/users', users_1.default);
app.use('/api/admin', admin_1.default);
app.use('/api/sessions', sessions_1.default);
// Serve dashboard (with optional auth)
app.get('/dashboard', (req, res) => {
    // TODO: Add authentication check if DASHBOARD_AUTH=true
    res.sendFile(path_1.default.join(__dirname, '../admin-dashboard-csp-fixed.html'));
});
// API Documentation endpoint
app.get('/api/docs', (req, res) => {
    res.json({
        version: '1.0.0',
        title: 'TrendX API Documentation',
        endpoints: {
            auth: {
                'POST /api/auth/login': 'User login',
                'POST /api/auth/register': 'User registration',
                'POST /api/auth/logout': 'User logout'
            },
            trends: {
                'GET /api/trends': 'Get all trends',
                'GET /api/trends/:platform': 'Get platform trends',
                'POST /api/trends': 'Create trend'
            },
            admin: {
                'GET /api/admin/stats': 'Dashboard statistics',
                'GET /api/admin/users': 'User management',
                'GET /api/admin/analytics': 'Analytics data'
            }
        }
    });
});
// Health check
app.get('/api/health', (req, res) => {
    res.json({ status: 'OK', message: 'TrendX Backend is running' });
});
// Error handler
app.use(errorHandler_1.errorHandler);
const trendScheduler_1 = require("./jobs/trendScheduler");
// Start server
const startServer = async () => {
    await (0, database_1.connectDB)();
    // Initialize background jobs
    (0, trendScheduler_1.initializeScheduler)();
    server.listen(PORT, () => {
        console.log(`🚀 TrendX Backend running on port ${PORT}`);
    });
};
// Socket.IO connection handling
io.on('connection', (socket) => {
    console.log('Client connected:', socket.id);
    socket.on('disconnect', () => {
        console.log('Client disconnected:', socket.id);
    });
});
startServer();
