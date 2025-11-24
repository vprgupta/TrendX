"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
const mongoose_1 = __importDefault(require("mongoose"));
const bcryptjs_1 = __importDefault(require("bcryptjs"));
const userSchema = new mongoose_1.default.Schema({
    email: { type: String, required: true, unique: true },
    password: { type: String, required: true },
    name: { type: String, required: true },
    role: { type: String, enum: ['user', 'admin', 'moderator'], default: 'user' },
    status: { type: String, enum: ['active', 'inactive', 'blocked'], default: 'active' },
    lastActive: { type: Date, default: Date.now },
    savedTrends: [{ type: mongoose_1.default.Schema.Types.ObjectId, ref: 'Trend' }],
    preferences: {
        platforms: [String],
        countries: [String],
        categories: [String]
    },
    stats: {
        following: { type: Number, default: 0 },
        bookmarks: { type: Number, default: 0 },
        views: { type: Number, default: 0 }
    }
}, { timestamps: true });
userSchema.pre('save', async function (next) {
    if (!this.isModified('password'))
        return next();
    this.password = await bcryptjs_1.default.hash(this.password, 10);
    next();
});
userSchema.methods.comparePassword = async function (password) {
    return bcryptjs_1.default.compare(password, this.password);
};
exports.default = mongoose_1.default.model('User', userSchema);
