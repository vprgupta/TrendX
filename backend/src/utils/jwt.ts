import jwt from 'jsonwebtoken';

const JWT_SECRET = process.env.JWT_SECRET || 'fallback_secret';
const JWT_EXPIRE = process.env.JWT_EXPIRE || '7d';

export const generateToken = (userId: string): string => {
  return jwt.sign({ userId }, JWT_SECRET, { expiresIn: JWT_EXPIRE as any });
};

export const verifyToken = (token: string): any => {
  return jwt.verify(token, JWT_SECRET);
};