
FROM ubuntu:latest
# Set the working directory inside the container
WORKDIR /app
# Copy the rest of the application files
COPY . /app
# Install Node.js, npm, and all dependencies listed 
RUN apt-get update && apt-get install -y nodejs npm git && npm install
# Expose the application port
EXPOSE 3001
# Start the application
CMD ["node", "index.js"]
