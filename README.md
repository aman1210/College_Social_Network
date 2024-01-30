# CONNECT US : College Social Network


Embark on an exciting journey with the College Social Network – our crowning achievement in the **Final year Group Project!** Crafted with passion and innovation, our platform empowers students, fostering real-time communication, creative collaboration, and a strong sense of community beyond the classroom.

## Features

- **User Authentication:** Secure sign-up and login functionality.
- **Profile Creation:** Users can create and customize their profiles.
- **Friendship:** Connect with other users and build your network.
- **Posts and Feeds:** Share updates, thoughts, and multimedia with your network.
- **Groups:** Create or join groups based on interests, courses, or activities.
- **Real-time Chat:** Instant messaging for one-on-one or group conversations.
- **Events:** Create and join events happening on campus.

## Technologies Used

- **Frontend:**
  - **Flutter:** UI toolkit for building natively compiled applications for mobile, web, and desktop from a single codebase.
  - **Dart:** Programming language optimized for building mobile, desktop, server, and web applications.

- **Backend:**
  - Node.js as the server runtime
  - Express.js as the web application framework
  - MongoDB as the database
  - Mongoose for MongoDB object modeling
  - Cloudinary: Cloud-based media management for image and video uploads.

- **Authentication:**
  - JSON Web Tokens (JWT) for secure authentication
  - Passport.js for authentication middleware

- **Real-time Communication:**
  - WebSocket for real-time chat functionality
  - Socket.io for WebSocket abstraction

## API Endpoints

### User Authentication

- `POST /login`: OAuth authentication.
- `POST /signup`: User basic details, username, and password. Creates a user to be verified by a moderator.

### Posts

- `GET /posts`: Get all posts approved by a moderator.
- `POST /post`: Upload a post to be verified by a moderator.
- `PATCH /post`: Upload an edited post to be verified by a moderator.
- `POST /report`: Upload a report with post id and reason to be verified by a moderator.
- `DELETE /post`: Delete a post by post id. Can be deleted by the author or moderator.

### User and Community

- `GET /user`: Get user profile details by user id.
- `GET /community`: Get a list of users with specified ids, including name and profile photo.

### Events

- `GET /events`: Get a list of upcoming 2-3 events.

### Search

- `GET /search`: Get a list of matching posts based on search parameters (To be decided).

### Birthday

- `GET /birthday`: Get a list of users celebrating their birthdays.

### Likes and Comments

- `POST /like`: Like a post by post id.
- `POST /comment`: Comment on a post with post id and comment along with timestamp.

### Admin Functions

- `GET /admin/users`: Get a list of users to be verified.
- `GET /admin/posts`: Get a list of posts to be verified.
- `GET /admin/reports`: Get a list of reports to be verified.
- `POST /admin/user`: Approve or reject user verification by user id.
- `POST /admin/post`: Approve or reject post verification by post id.
- `POST /admin/report`: Approve or reject a report by report id.
- `DELETE /admin/user`: Delete a user by user id.

### Account Management

- `DELETE /user`: Delete the user's own account by user id.

## Getting Started

To get started with the College Social Network, follow these steps:

1. Clone the repository:
   ```bash
   git clone https://github.com/mynkprtp/College_Social_Network.git
2. Install dependencies:
    ```bash
    cd College_Social_Network
    npm install
3. Set up your constants in .env file:
- Configure the Mongodb database connection
- Configure the Cloudinary key
- Configure the JWT key and secret
4. Start the backend server:
    ```bash
    cd .\backend
    npm start
5. Start the backend server:
    ```bash
    cd .\frontend
    npm start
6. Visit http://localhost:3000 in your web browser.

## Contributing
- If you would like to contribute to the project, please follow our contribution guidelines.

## License
- This project is licensed under the MIT License.

## Acknowledgments
- Special thanks to contributors who have helped make this project possible.
- Feel free to reach out if you have any questions or suggestions!

##
### Feel free to reach out if you have any questions or suggestions!
