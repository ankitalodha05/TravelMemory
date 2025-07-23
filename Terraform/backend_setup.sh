#!/bin/bash
sudo apt update -y
sudo apt install -y nodejs npm
git clone https://github.com/ankitalodha05/TravelMemory.git
cd backend
echo MONGO_URI='mongodb+srv://ankitalodha05:HXbLCIGpRkRg9gNn@cluster10.as960.mongodb.net/ankitalodha" > .env
npm install
nohup node index.js > output.log 2>&1 &
