# Blog Forum

A modern Blog Forum application built with Flutter and Supabase. The application allows users to create, view, update, and delete blog posts, interact through comments, and manage their profiles.

This project was developed as part of a technical assessment to demonstrate skills in Flutter development, state management, backend integration, authentication, database operations, and file storage.

# Features
# 🔐 Authentication
- User registration using email and password
- User login and logout
- Supabase Authentication
- Session management
- Protected user actions
# 📝 Blog Posts
- Create blog posts
- View public blog posts
- Update your own posts
- Delete your own posts
- Multiple image uploads per post
- Image preview before posting
- Delete images when editing a post
- Post ownership validation
# 💬 Comments
- Add comments to posts
- Edit your own comments
- Delete your own comments
- Upload images with comments
- View comments associated with each post
- Comment ownership validation
# 👤 Profile
- View user profile
- Update profile name
- Upload and update profile photo
- Delete profile photo
# 🛡️ Access Control
- Users can only modify or delete content that they own.
# For example:
- Users can edit/delete their own posts
- Users cannot edit/delete another user's posts
- Users can edit/delete their own comments
- Users cannot modify another user's comments

# Tech Stack
Flutter - for frontend and ui development |
Dart - programming language used |
Supabase - backend services |
Supabase Auth	- User authentication |
Supabase PostgreSQL	- Database |
Supabase Storage - Image storage |
Provider - State management |
go_router	- Application routing |
image_picker - Image selection |
dotenv - Environment variable management |
Git / GitHub - Version control |
