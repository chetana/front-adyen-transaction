#!/bin/sh

# Start the backend server in the background
echo "🚀 Starting backend server..."
cd /app/backend && node index.js &

# Wait a moment for the backend to start
sleep 2

# Start the frontend server
echo "🚀 Starting frontend server..."
cd /app/frontend/dist && serve -s . -l 3000

# Keep the container running
wait