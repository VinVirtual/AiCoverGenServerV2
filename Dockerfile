# Use an official Python runtime as a parent image
FROM pytorch/pytorch:2.2.1-cuda12.1-cudnn8-devel

# Set the working directory in the container
WORKDIR /app

# Install dependencies
RUN apt-get update && \
    apt-get install -y ffmpeg sox build-essential git && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Create necessary directories
RUN mkdir -p /tmp/downloads /tmp/demix /tmp/spectrogram /tmp/song_output

# Copy the current directory contents into the container at /app
COPY . /app

# Install Python dependencies
RUN pip install --no-cache-dir -r app/requirements.txt

# Download models
RUN cd app/assets/ && python download_models.py && cd ../..

# Expose the port the app runs on
EXPOSE 8000

# Define environment variable
ENV PYTHONUNBUFFERED=1

# Run the command to start the server
CMD ["uvicorn", "app.main:app", "--reload", "--host", "0.0.0.0"]