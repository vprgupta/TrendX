"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
const mongoose_1 = __importDefault(require("mongoose"));
const trendSchema = new mongoose_1.default.Schema({
    platform: { type: String, required: true },
    title: { type: String, required: true },
    content: String,
    author: String,
    likes: { type: Number, default: 0 },
    comments: { type: Number, default: 0 },
    shares: { type: Number, default: 0 },
    country: String,
    category: String,
    videoId: String,
    mediaUrl: String,
    externalUrl: String,
    rank: Number
}, { timestamps: true });
exports.default = mongoose_1.default.model('Trend', trendSchema);
