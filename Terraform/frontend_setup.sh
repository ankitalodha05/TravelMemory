#!/bin/bash
sudo apt update -y
sudo apt install -y nodejs npm
git clone https://github.com/ankitalodha05/TravelMemory.git
cd frontend
echo "const API_URL = 'http://<backend-public-ip>:5000'; export default API_URL;" > src/url.js
npm install
npm start &
