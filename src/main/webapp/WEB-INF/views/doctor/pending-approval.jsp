<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Pending Approval - Smart Health Doctor Portal</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        :root {
            --primary: #2563eb;
            --primary-hover: #1d4ed8;
            --bg: #f8fafc;
            --text: #1e293b;
            --text-muted: #64748b;
        }

        body {
            font-family: 'Inter', sans-serif;
            background-color: var(--bg);
            color: var(--text);
            margin: 0;
            display: flex;
            align-items: center;
            justify-content: center;
            height: 100vh;
        }

        .container {
            max-width: 500px;
            width: 90%;
            background: white;
            padding: 2.5rem;
            border-radius: 1rem;
            box-shadow: 0 10px 25px -5px rgba(0, 0, 0, 0.1), 0 8px 10px -6px rgba(0, 0, 0, 0.1);
            text-align: center;
        }

        .icon-wrapper {
            width: 80px;
            height: 80px;
            background: #eff6ff;
            color: var(--primary);
            display: flex;
            align-items: center;
            justify-content: center;
            border-radius: 50%;
            margin: 0 auto 1.5rem;
            font-size: 2rem;
        }

        h1 {
            font-size: 1.5rem;
            font-weight: 700;
            margin-bottom: 1rem;
            color: #0f172a;
        }

        p {
            line-height: 1.6;
            color: var(--text-muted);
            margin-bottom: 2rem;
        }

        .status-badge {
            display: inline-block;
            padding: 0.5rem 1rem;
            background: #fef3c7;
            color: #92400e;
            border-radius: 2rem;
            font-weight: 600;
            font-size: 0.875rem;
            margin-bottom: 2rem;
        }

        .btn-logout {
            display: inline-flex;
            align-items: center;
            gap: 0.5rem;
            background-color: #f1f5f9;
            color: #475569;
            text-decoration: none;
            padding: 0.75rem 1.5rem;
            border-radius: 0.5rem;
            font-weight: 600;
            transition: all 0.2s;
        }

        .btn-logout:hover {
            background-color: #e2e8f0;
            color: #1e293b;
        }

        .contact-support {
            margin-top: 2rem;
            font-size: 0.875rem;
            color: var(--text-muted);
        }

        .contact-support a {
            color: var(--primary);
            text-decoration: none;
            font-weight: 500;
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="icon-wrapper">
            <i class="fas fa-user-clock"></i>
        </div>
        <h1>Account Awaiting Approval</h1>
        <div class="status-badge">
            <i class="fas fa-hourglass-half"></i> Pending Administrator Review
        </div>
        <p>
            Hello Dr. ${doctor.user.fullName}, your registration request has been received and is currently being reviewed by our medical board.
            You will receive an email notification once your account has been activated.
        </p>
        
        <a href="<%= request.getContextPath() %>/auth/logout" class="btn-logout">
            <i class="fas fa-sign-out-alt"></i> Logout
        </a>

        <div class="contact-support">
            Need urgent access? <a href="#">Contact Support</a>
        </div>
    </div>
</body>
</html>
