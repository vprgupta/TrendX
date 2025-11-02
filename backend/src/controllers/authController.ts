import { Request, Response } from 'express';
import User from '../models/User';
import { generateToken } from '../utils/jwt';

export const register = async (req: Request, res: Response) => {
  const { email, password, name } = req.body;

  const existingUser = await User.findOne({ email });
  if (existingUser) {
    return res.status(400).json({ error: 'Email already registered' });
  }

  const user = await User.create({ email, password, name });
  console.log('🎉 New user registered:', { email, name, id: user._id });
  const token = generateToken(user._id.toString());

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

export const login = async (req: Request, res: Response) => {
  const { email, password } = req.body;
  console.log('🔐 Login attempt:', email);

  const user = await User.findOne({ email });
  if (!user) {
    console.log('❌ User not found:', email);
    return res.status(401).json({ error: 'Invalid credentials' });
  }

  const isMatch = await user.comparePassword(password);
  if (!isMatch) {
    return res.status(401).json({ error: 'Invalid credentials' });
  }

  const token = generateToken(user._id.toString());
  console.log('✅ Login successful:', email);

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

export const logout = async (req: Request, res: Response) => {
  // Note: JWT tokens are stateless, so logout is handled client-side
  // The client should remove the token from storage
  console.log('🚪 User logged out');
  res.json({ 
    message: 'Logout successful',
    instruction: 'Remove token from client storage'
  });
};

export const getAllUsers = async (req: Request, res: Response) => {
  const users = await User.find({}).select('-password').sort({ createdAt: -1 });
  console.log(`📊 Users requested - Total: ${users.length}`);
  res.json({
    users,
    count: users.length,
    message: `Found ${users.length} registered users`
  });
};
