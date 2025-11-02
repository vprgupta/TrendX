"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.updatePreferences = exports.getPreferences = exports.removeSavedTrend = exports.saveTrend = exports.getSavedTrends = exports.getStats = exports.updateProfile = exports.getProfile = void 0;
const User_1 = __importDefault(require("../models/User"));
const getProfile = async (req, res) => {
    const user = await User_1.default.findById(req.user._id).select('-password');
    res.json({ user });
};
exports.getProfile = getProfile;
const updateProfile = async (req, res) => {
    const { name, email } = req.body;
    const user = await User_1.default.findByIdAndUpdate(req.user._id, { name, email }, { new: true }).select('-password');
    res.json({ user });
};
exports.updateProfile = updateProfile;
const getStats = async (req, res) => {
    const user = await User_1.default.findById(req.user._id);
    if (!user)
        return res.status(404).json({ error: 'User not found' });
    res.json({ stats: user.stats });
};
exports.getStats = getStats;
const getSavedTrends = async (req, res) => {
    const user = await User_1.default.findById(req.user._id).populate('savedTrends');
    if (!user)
        return res.status(404).json({ error: 'User not found' });
    res.json({ trends: user.savedTrends });
};
exports.getSavedTrends = getSavedTrends;
const saveTrend = async (req, res) => {
    const { trendId } = req.body;
    const user = await User_1.default.findByIdAndUpdate(req.user._id, { $addToSet: { savedTrends: trendId }, $inc: { 'stats.bookmarks': 1 } }, { new: true });
    res.json({ message: 'Trend saved' });
};
exports.saveTrend = saveTrend;
const removeSavedTrend = async (req, res) => {
    const { id } = req.params;
    await User_1.default.findByIdAndUpdate(req.user._id, { $pull: { savedTrends: id }, $inc: { 'stats.bookmarks': -1 } });
    res.json({ message: 'Trend removed' });
};
exports.removeSavedTrend = removeSavedTrend;
const getPreferences = async (req, res) => {
    const user = await User_1.default.findById(req.user._id);
    if (!user)
        return res.status(404).json({ error: 'User not found' });
    res.json({ preferences: user.preferences });
};
exports.getPreferences = getPreferences;
const updatePreferences = async (req, res) => {
    const { platforms, countries, categories } = req.body;
    const user = await User_1.default.findByIdAndUpdate(req.user._id, { preferences: { platforms, countries, categories } }, { new: true });
    if (!user)
        return res.status(404).json({ error: 'User not found' });
    res.json({ preferences: user.preferences });
};
exports.updatePreferences = updatePreferences;
