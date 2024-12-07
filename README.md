
# FluentPet Backend

FluentPet Backend is a scalable, fault-tolerant Ruby on Rails application designed to support the integration of IoT devices, enabling pet owners to interact with their pets. The system handles the upload and management of dog profiles, processes button events from IoT devices, and manages audio recordings uploaded in response to button presses. Built with scalability and reliability in mind, it uses modern microservices principles and integrates with AWS for cloud services.

## Features
1 Dog Profile Management:

Users can upload dog profiles with photos, names, breeds, and ages.
Photos are stored securely in AWS S3, and public URLs are generated for app display.
Metadata, including file size and format, is extracted and stored.

2 IoT Button Event Processing:

IoT devices send button press events (via HTTP or MQTT).
The backend handles high-throughput event storage using AWS DynamoDB.
Supports processing of event patterns for real-time analysis.
Audio Recording Management:

3 IoT devices upload audio recordings as responses to button presses.
Audio files are validated, securely stored in AWS S3, and public URLs are generated.
Metadata, including duration and timestamps, is stored for future reference.
Scalable and Fault-Tolerant Architecture:

4 Auto-scaling AWS services ensure performance under high load.
Background jobs and retries handle transient errors gracefully.
Monitoring and Alerting:

5 AWS CloudWatch monitors system health, with alerts via AWS SNS.
Sidekiq handles background job processing and retries.

## Technologies Used

- Framework: Ruby on Rails
- Cloud Services: AWS S3, DynamoDB
- Background Jobs: Sidekiq
- IoT Protocols: MQTT, HTTP
- Database: PostgreSQL for relational data, DynamoDB for write-intensive event storage
- Caching: Redis (for optimizing read queries)
- Containerization: Docker (optional, for deployment)

## Getting Started
### Prerequisites

1 Ruby 3.0+
2 Rails 7.0+
3 PostgreSQL
4 Redis
5 AWS Account with S3, DynamoDB

## Setup Instructions

### 1 Clone the Repository:

`git clone https://github.com/vic778/fluentpet-backend`

`cd fluentpet_backend`
### 2 Install Dependencies:

`bundle install`

### 3 Set Up Database:

### 4 Configure config/database.yml with PostgreSQL credentials.

 `db:create db:migrate`

 
run the server `rails server`
Start Sidekiq: Ensure Redis is running, then start Sidekiq:

`bundle exec sidekiq`

## API Endpoints

### Dog Profiles

    Method	Endpoint	Description
    POST	/dog_profiles	Upload a dog's profile.
    Request Body:
    json
    Copy code
    {
    "dog_profile": {
        "name": "Buddy",
        "breed": "Golden Retriever",
        "age": 3,
        "photo": "<file>"
    }
    }
    Response:
    json
    Copy code
    {
    "id": 1,
    "photo_url": "https://your-bucket.s3.amazonaws.com/path/to/photo.jpg"
    }

### Button Events

    Method	Endpoint	Description
    POST	/button_events	Record a button press event.
    Request Body:
    json
    Copy code
    {
    "button_id": "button123",
    "timestamp": "2024-01-01T12:00:00Z",
    "event_type": "pressed"
    }
    Response:
    json
    Copy code
    {
    "message": "Event saved"
    }
### Audio Files

    Method	Endpoint	Description
    POST	/audio_files	Upload an audio recording.
    Request Body:
    json
    Copy code
    {
    "audio_file": {
        "button_id": "button123",
        "timestamp": "2024-01-01T12:00:00Z",
        "duration": 10,
        "file": "<audio file>"
    }
    }
    Response:
    json
    Copy code
    {
    "id": 1,
    "file_url": "https://your-bucket.s3.amazonaws.com/path/to/audio.mp3"
    }

## Architecture

### Microservices Overview

#### Dog Profile Service:

- Handles dog profile creation and photo uploads.
- AWS S3 for photo storage, PostgreSQL for metadata.

#### Button Event Service:

- Processes button press events from IoT devices.
- AWS DynamoDB for event storage.

#### Audio Processing Service:

- Handles audio file uploads and validations.
- AWS S3 for audio storage, PostgreSQL for metadata.

#### Scaling and Fault Tolerance

- Retries: Background jobs retry failed operations (e.g., file uploads).
- Monitoring: AWS CloudWatch logs system performance and sends alerts.
- Load Balancing: Use Elastic Load Balancer (ELB) for distributing traffic.
- Auto-scaling: Scale AWS services dynamically based on traffic.

#### Future Improvements

- Real-Time Analytics: Add Kinesis or Kafka for processing button press patterns.
- Mobile App Support: Enhance API for real-time queries using WebSockets.
- Advanced Caching: Implement Redis caching for event and audio metadata.

## Author

👤 **Victor Barh**

- GitHub: [@Vvic778](https://github.com/vic778)
- Twitter: [@victoirBarh](https://twitter.com/)
- LinkedIn: [LinkedIn](https://linkedin.com/in/victoir-barh)

### License
This project is licensed under the MIT License. See the LICENSE file for details.