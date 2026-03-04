# iRembo AI-Powered Document Verification System (Legacy PHP Module)

This directory contains the PHP-based application module for the document verification system. It provides the citizen interface for various document applications and a regional administrative dashboard.

## 📂 Project Structure

- **Application Forms**: Core PHP forms for citizens to apply for documents:
  - `applicationnationalid.php` - National ID Application
  - `applicationpassport.php` - Passport Application / Replacement
  - `applicationcriminalrecord.php` - Criminal Record Clearance
  - `applicationdrivinglicense.php` - Driving License (New/Replacement/Provisional)
  - `applicationmarriagecertificate.php` - Marriage Registration
  - `applicationgoodconduct.php` - Certificate of Good Conduct
- **Authentication**: `login.php`, `signup.php`, and `forgotpassword.php`.
- **Dashboards**:
  - `userdashboard.php` - Citizen portal for tracking application status.
  - `adminsection/` - Administrative tools for reviewing submissions.
- **Core Components**:
  - `database/` - Database connection and configuration files.
  - `backendcodes/` - Server-side logic for processing form submissions.
  - `sectioncodes/` - Reusable UI sections and snippets.
  - `lib/` - External libraries and helper functions.
- **Assets**: `css/`, `js/`, `scss/` folders providing the look and feel.

## 🚀 Getting Started

### Prerequisites
- **Web Server**: Apache (XAMPP, WAMP, or MAMP recommended)
- **PHP**: Version 7.2 or higher (Check `PHPMailer` compatibility if using legacy versions)
- **Database**: MySQL / MariaDB
- **Tools**: Browser (Chrome/Firefox/Edge)

### Installation & Setup

1.  **Clone/Move Files**:
    Place the `aipowered` folder into your web server's root directory:
    - Windows (XAMPP): `C:\xampp\htdocs\aipowered`
    - Linux: `/var/www/html/aipowered`

2.  **Database Configuration**:
    - Open your MySQL administration tool (like phpMyAdmin).
    - Create a new database named `iremboaipowered`.
    - **Import the SQL schema**: Navigate to `database/iremboaipowered.sql` and import it into your new database.
    - **Update connection settings**: Edit `backendcodes/connection.php` to match your database credentials (DB_HOST, DB_USER, DB_PASS, DB_NAME).

3.  **Run the Application**:
    - Start Apache and MySQL from your control panel (e.g., XAMPP Control Panel).
    - Open your browser and navigate to: `http://localhost/aipowered/index.php`

## 🛠️ Usage Flow

1.  **Registration**: New users sign up via `signup.php`.
2.  **Application**: Citizens select a service (e.g., National ID) from the dashboard and fill out the required details and upload documents.
3.  **Processing**: The system uses `backendcodes/` (e.g., `sendapplicationnationalid.php`) to store the application and relevant document paths in the database.
4.  **Admin Review**: Authorized officers log in via `adminlogin.php` to review, verify, and decision on submitted applications.

## 🛡️ Key Features
- **Comprehensive Document Suite**: Covers all major Rwandan civil document types.
- **Account Management**: Secure citizen registration and login with session handling (`sessionstart.php`).
- **Application Tracking**: Real-time status updates for citizens.
- **Integrated Styling**: SCSS-based modern interface designed for fast user interaction.

---
*Part of the ml-document-verifier ecosystem.*
