# DocConnect Nepal

DocConnect Nepal is a **group coursework project** developed under the module **Advanced Programming and Technologies**.
It is a **Jakarta EE / Servlet-based web application** for managing doctor appointments, consultations, payments, and administration workflows.

## Group Members

This project was completed by **5 members**. The member names were taken from the Git branch names:

- Aayush
- Bhabin
- Bibash
- Pranish
- Swikriti

## Project Overview

DocConnect Nepal is a web-based appointment and doctor management system designed to help patients browse doctors, book appointments, make payments, and view receipts, while also giving administrators tools to manage doctors, slots, specializations, users, appointments, and reports.

## Main Features

### Public / Guest Features
- Home page with featured doctors
- About page
- Contact page
- Doctor listing and doctor details
- Search API for doctors
- Visitor redirection and public page handling

### Patient Features
- Register and log in
- View dashboard
- Browse and book appointments
- Payment flow for appointments
- View payment history
- View appointment receipts
- View and update profile

### Admin Features
- Admin dashboard
- Manage doctors
- Manage slots
- Manage specializations
- Manage users
- Manage appointments
- View reports
- Access denied handling for unauthorized users

### Security Features
- Authentication filter
- Role-based authorization filter
- CSRF protection filter
- Session timeout configuration
- Custom error pages for 404 and 500 errors

## Technology Stack

- **Language:** Java 11
- **Framework / Platform:** Jakarta EE 6 / Servlet + JSP
- **Build Tool:** Maven
- **Frontend Views:** JSP + JSTL
- **Database:** MySQL
- **JSON Library:** Gson
- **Server:** Jakarta-compatible servlet container such as Tomcat 10+ / other Servlet 6.0 server

## Project Structure

```text
src/main/java/com/docconnect/
├── admin/              # Admin controllers
├── appointment/        # Appointment controllers, models, services
├── doctor/             # Doctor controllers, models, services
├── filter/             # Authentication, role, CSRF, visitor filters
├── payment/            # Payment controller, model, service
├── slot/               # Slot management
├── specialization/     # Specialization management
├── user/               # User controllers, models, services
├── AboutServlet.java
├── AccessDeniedServlet.java
├── ContactServlet.java
├── HomeServlet.java
└── SearchApiServlet.java
```

## Important Application Routes

Defined in `src/main/webapp/WEB-INF/web.xml`:

- `/home` — Home page
- `/about` — About page
- `/contact` — Contact page
- `/login` — Login page
- `/register` — Registration page
- `/doctors` — Doctor listing
- `/doctor` — Doctor details
- `/patient/dashboard` — Patient dashboard
- `/patient/appointments` — Patient appointments
- `/patient/book` — Book appointment
- `/patient/payment` — Payment page
- `/patient/payments` — Payment history
- `/patient/payment/verify` — Payment callback/verification
- `/admin/dashboard` — Admin dashboard
- `/admin/doctors` — Manage doctors
- `/admin/slots` — Manage slots
- `/admin/specializations` — Manage specializations
- `/admin/users` — Manage users
- `/admin/appointments` — Manage appointments
- `/admin/reports` — Reports

## Database Configuration

Database settings are stored in:

- `src/main/resources/db.properties`

Update this file with your local MySQL credentials before running the application.

## Build and Run

### Prerequisites
- Java 11
- Maven
- MySQL
- A Servlet 6.0 compatible application server

### Build the project

```bash
mvn clean package
```

This will produce a WAR file inside the `target/` directory.

### Deploy

Deploy the generated WAR file to your servlet container and open the application through the configured server URL.

## Notes on Payment Integration

The project contains a Khalti-based payment flow for appointment payments.
For sandbox/testing, the application uses Khalti test endpoints and expects a publicly reachable callback URL for the payment verification flow.

## License / Academic Use

This project was created for academic coursework and should be used for learning and demonstration purposes unless otherwise stated by the project team.

