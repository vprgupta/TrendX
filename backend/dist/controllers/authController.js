"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.logout = exports.login = exports.register = void 0;
const User_1 = __importDefault(require("../models/User"));
const jwt_1 = require("../utils/jwt");
const register = async (req, res) => {
    const { email, password, name } = req.body;
    const existingUser = await User_1.default.findOne({ email });
    if (existingUser) {
        return res.status(400).json({ error: 'Email already registered' });
    }
    const user = await User_1.default.create({ email, password, name });
    const token = (0, jwt_1.generateToken)(user._id.toString());
    res.status(201).json({
        message: 'User registered successfully',
        token,
        user: {
            id: user._id,
            email: user.email,
            name: user.name
        }
    });
};
exports.register = register;
const login = async (req, res) => {
    const { email, password } = req.body;
    const user = await User_1.default.findOne({ email });
    if (!user) {
        return res.status(401).json({ error: 'Invalid credentials' });
    }
    const isMatch = await user.comparePassword(password);
    if (!isMatch) {
        return res.status(401).json({ error: 'Invalid credentials' });
    }
    const token = (0, jwt_1.generateToken)(user._id.toString());
    res.json({
        message: 'Login successful',
        token,
        user: {
            id: user._id,
            email: user.email,
            name: user.name,
            preferences: user.preferences
        }
    });
};
exports.login = login;
const logout = async (req, res) => {
    res.json({ message: 'Logout successful' });
};
exports.logout = logout;
