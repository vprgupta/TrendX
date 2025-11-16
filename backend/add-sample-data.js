const axios = require('axios');

const BASE_URL = 'http://localhost:3000/api';

const sampleTrends = [
  {
    title: "AI Revolution in 2024",
    content: "Artificial Intelligence is transforming every industry",
    platform: "youtube",
    category: "technology",
    country: "global",
    metrics: { views: 1500000, likes: 45000, shares: 12000, comments: 8500 }
  },
  {
    title: "Climate Change Solutions",
    content: "New renewable energy technologies emerging",
    platform: "twitter",
    category: "environment",
    country: "global",
    metrics: { views: 890000, likes: 23000, shares: 15000, comments: 4200 }
  },
  {
    title: "Space Exploration Updates",
    content: "Latest Mars mission discoveries",
    platform: "reddit",
    category: "science",
    country: "usa",
    metrics: { views: 650000, likes: 18000, shares: 7500, comments: 3100 }
  },
  {
    title: "Cryptocurrency Market Trends",
    content: "Bitcoin and Ethereum price analysis",
    platform: "youtube",
    category: "finance",
    country: "global",
    metrics: { views: 2100000, likes: 67000, shares: 28000, comments: 15600 }
  },
  {
    title: "Health & Wellness Tips",
    content: "Mental health awareness growing globally",
    platform: "twitter",
    category: "health",
    country: "global",
    metrics: { views: 1200000, likes: 34000, shares: 19000, comments: 7800 }
  }
];

const sampleUsers = [
  { name: "John Doe", email: "john@example.com", password: "password123" },
  { name: "Jane Smith", email: "jane@example.com", password: "password123" },
  { name: "Mike Johnson", email: "mike@example.com", password: "password123" },
  { name: "Sarah Wilson", email: "sarah@example.com", password: "password123" }
];

async function addSampleData() {
  console.log('🌱 Adding sample data to TrendX...\n');

  try {
    // Add sample users
    console.log('Adding sample users...');
    const tokens = [];
    
    for (const user of sampleUsers) {
      try {
        const response = await axios.post(`${BASE_URL}/auth/register`, user);
        tokens.push(response.data.token);
        console.log(`✅ Added user: ${user.name}`);
      } catch (error) {
        if (error.response?.data?.error?.includes('already registered')) {
          console.log(`⚠️  User ${user.name} already exists`);
        } else {
          console.log(`❌ Error adding user ${user.name}:`, error.response?.data?.error);
        }
      }
    }

    // Add sample trends
    console.log('\nAdding sample trends...');
    const token = tokens[0]; // Use first user's token
    
    if (token) {
      for (const trend of sampleTrends) {
        try {
          await axios.post(`${BASE_URL}/trends`, trend, {
            headers: { Authorization: `Bearer ${token}` }
          });
          console.log(`✅ Added trend: ${trend.title}`);
        } catch (error) {
          console.log(`❌ Error adding trend ${trend.title}:`, error.response?.data?.error);
        }
      }
    } else {
      console.log('⚠️  No token available, adding trends without auth...');
      for (const trend of sampleTrends) {
        try {
          await axios.post(`${BASE_URL}/trends`, trend);
          console.log(`✅ Added trend: ${trend.title}`);
        } catch (error) {
          console.log(`❌ Error adding trend ${trend.title}:`, error.response?.data?.error);
        }
      }
    }

    console.log('\n🎉 Sample data added successfully!');
    console.log('📊 Open admin-dashboard.html in your browser to view the data');
    
  } catch (error) {
    console.error('❌ Failed to add sample data:', error.message);
    if (error.code === 'ECONNREFUSED') {
      console.log('💡 Make sure the backend server is running:');
      console.log('   cd backend && npm run dev');
    }
  }
}

addSampleData();