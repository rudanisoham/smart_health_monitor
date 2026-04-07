<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${siteContent.projectTitle != null ? siteContent.projectTitle : "Smart Health Monitor"}</title>
    <!-- Google Fonts -->
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <!-- Bootstrap 5 CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Bootstrap Icons -->
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css">
    <!-- Animate.css -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/animate.css/4.1.1/animate.min.css"/>
    
    <style>
        :root {
            --primary-color: #0d6efd;
            --glass-bg: rgba(255, 255, 255, 0.2);
            --glass-border: rgba(255, 255, 255, 0.4);
            --glass-blur: blur(15px);
        }

        body {
            font-family: 'Poppins', sans-serif;
            background: linear-gradient(135deg, #f5f7fa 0%, #c3cfe2 100%);
            min-height: 100vh;
        }

        .navbar-glass {
            background: rgba(255, 255, 255, 0.1);
            backdrop-filter: var(--glass-blur);
            -webkit-backdrop-filter: var(--glass-blur);
            border-bottom: 1px solid var(--glass-border);
            padding: 1rem 0;
            transition: all 0.3s ease;
        }

        .navbar-glass.scrolled {
            background: rgba(255, 255, 255, 0.8);
            padding: 0.5rem 0;
        }

        .nav-link {
            font-weight: 500;
            color: #333 !important;
            margin: 0 10px;
            position: relative;
        }

        .nav-link::after {
            content: '';
            position: absolute;
            width: 0;
            height: 2px;
            bottom: -5px;
            left: 0;
            background-color: var(--primary-color);
            transition: width 0.3s ease;
        }

        .nav-link:hover::after {
            width: 100%;
        }

        .btn-glass {
            background: var(--glass-bg);
            backdrop-filter: var(--glass-blur);
            border: 1px solid var(--glass-border);
            color: #333;
            font-weight: 500;
            border-radius: 30px;
            padding: 8px 25px;
            transition: all 0.3s ease;
        }

        .btn-glass:hover {
            background: var(--primary-color);
            color: white;
            transform: translateY(-2px);
            box-shadow: 0 10px 20px rgba(0,0,0,0.1);
        }

        .glass-card {
            background: rgba(255, 255, 255, 0.2);
            backdrop-filter: var(--glass-blur);
            border: 1px solid var(--glass-border);
            border-radius: 20px;
            box-shadow: 0 8px 32px rgba(31, 38, 135, 0.1);
            transition: all 0.3s ease;
        }

        .glass-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 15px 45px rgba(31, 38, 135, 0.2);
        }

        section {
            padding: 100px 0;
        }

        .section-title {
            font-weight: 700;
            margin-bottom: 50px;
            position: relative;
            display: inline-block;
        }

        .section-title::after {
            content: '';
            position: absolute;
            width: 50%;
            height: 4px;
            bottom: -10px;
            left: 25%;
            background: var(--primary-color);
            border-radius: 2px;
        }
    </style>
</head>
<body>

    <nav class="navbar navbar-expand-lg fixed-top navbar-glass">
        <div class="container">
            <a class="navbar-brand fw-bold text-primary" href="${pageContext.request.contextPath}/">
                <i class="bi bi-heart-pulse-fill me-2"></i>${siteContent.projectTitle != null ? siteContent.projectTitle : "Smart Health"}
            </a>
            <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
                <span class="navbar-toggler-icon"></span>
            </button>
            <div class="collapse navbar-collapse" id="navbarNav">
                <ul class="navbar-nav mx-auto">
                    <li class="nav-item">
                        <a class="nav-link active" href="${pageContext.request.contextPath}/#home">Home</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="${pageContext.request.contextPath}/#about">About</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="${pageContext.request.contextPath}/#features">Features</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="${pageContext.request.contextPath}/#panels">Panels</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="${pageContext.request.contextPath}/contact">Contact</a>
                    </li>
                </ul>
                <div class="d-flex align-items-center">
                    <div class="dropdown me-3">
                        <button class="btn btn-glass dropdown-toggle" type="button" id="loginDropdown" data-bs-toggle="dropdown" aria-expanded="false">
                            <i class="bi bi-box-arrow-in-right me-1"></i>Login
                        </button>
                        <ul class="dropdown-menu dropdown-menu-end glass-card border-0 p-2" aria-labelledby="loginDropdown">
                            <li><a class="dropdown-item rounded" href="${pageContext.request.contextPath}/auth/patient/login"><i class="bi bi-person me-2"></i>Patient Login</a></li>
                            <li><a class="dropdown-item rounded" href="${pageContext.request.contextPath}/auth/doctor/login"><i class="bi bi-person-badge me-2"></i>Doctor Login</a></li>
                            <li><a class="dropdown-item rounded" href="${pageContext.request.contextPath}/auth/admin/login"><i class="bi bi-person-lock me-2"></i>Admin Login</a></li>
                        </ul>
                    </div>
                    <a href="${pageContext.request.contextPath}/auth/patient/register" class="btn btn-primary rounded-pill px-4 shadow-sm">
                        <i class="bi bi-person-plus me-1"></i>Register
                    </a>
                </div>
            </div>
        </div>
    </nav>
