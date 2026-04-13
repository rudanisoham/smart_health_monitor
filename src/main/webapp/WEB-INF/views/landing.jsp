<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ include file="/WEB-INF/views/layout/guest-header.jsp" %>

<!-- Hero Section -->
<section id="home" class="animate__animated animate__fadeIn border-0 rounded-bottom-5">
    <div class="container py-lg-5">
        <div class="row align-items-center gy-lg-10 gy-5">
            <div class="col-lg-6">
                <span class="badge bg-primary glass-card border-0 py-2 px-3 mb-3 shadow-none text-white fs-6">Welcome to ${siteContent.projectTitle != null ? siteContent.projectTitle : "Smart Health"}</span>
                <h1 class="display-3 fw-bold mb-4 animate__animated animate__fadeInLeft pb-2 text-primary" style="animation-delay: 0.2s;">
                    ${siteContent.projectTitle != null ? siteContent.projectTitle : "Smart Health Monitor"}
                </h1>
                <p class="lead text-secondary mb-5 animate__animated animate__fadeInLeft pe-lg-5 ps-lg-2" style="animation-delay: 0.4s;">
                    ${siteContent.tagline != null ? siteContent.tagline : "Your health, our priority."}
                </p>
                <div class="d-flex flex-wrap gap-3 animate__animated animate__fadeInLeft" style="animation-delay: 0.6s;">
                    <a href="#about" class="btn btn-primary btn-lg rounded-pill px-5 py-3 shadow-sm">
                        <i class="bi bi-rocket me-2"></i>Get Started
                    </a>
                    <a href="#features" class="btn btn-glass btn-lg px-5 py-3 shadow-sm border-0">
                        <i class="bi bi-info-circle me-2"></i>Learn More
                    </a>
                </div>
            </div>
            
        </div>
    </div>
</section>

<!-- About Section -->
<section id="about" class="bg-white py-lg-10 shadow-none border-0">
    <div class="container px-lg-5">
        <div class="row align-items-center gy-5">
            <div class="col-lg-5 order-2 order-lg-1 animate__animated animate__fadeInLeft">
                <div class="glass-card p-5 border-0 bg-light shadow-sm">
                    <h2 class="section-title text-primary fs-3 mb-4">About Us</h2>
                    <p class="text-secondary landing-text pe-lg-2 ps-lg-2 fs-5" style="line-height: 1.8;">
                        ${siteContent.aboutDescription != null ? siteContent.aboutDescription : "Empowering patients and doctors with unified health tracking solutions."}
                    </p>
                    <div class="mt-5 d-flex gap-4">
                        <div class="text-center">
                            <h3 class="fw-bold text-primary mb-1">50+</h3>
                            <small class="text-muted">Doctors</small>
                        </div>
                        <div class="text-center border-start ps-4">
                            <h3 class="fw-bold text-primary mb-1">1000+</h3>
                            <small class="text-muted">Patients</small>
                        </div>
                        <div class="text-center border-start ps-4">
                            <h3 class="fw-bold text-primary mb-1">15+</h3>
                            <small class="text-muted">Departments</small>
                        </div>
                    </div>
                </div>
            </div>
            <div class="col-lg-6 offset-lg-1 order-1 order-lg-2 animate__animated animate__fadeInRight">
                <img src="https://img.freepik.com/free-vector/doctor-character-background_1270-84.jpg" alt="About Image" class="img-fluid rounded-5 shadow-lg border-0">
            </div>
        </div>
    </div>
</section>

<!-- Features Section -->
<section id="features" class="bg-light py-lg-15 shadow-none border-0">
    <div class="container px-lg-5 text-center">
        <h2 class="section-title text-primary fs-3 mb-5">System Features</h2>
        <p class="text-secondary mb-10 w-75 mx-auto fs-5">Experience our wide range of features designed for a better healthcare ecosystem.</p>
        
        <div class="row gy-5">
            <c:forEach var="feature" items="${features}">
                <div class="col-lg-4 col-md-6 animate__animated animate__zoomIn">
                    <div class="glass-card feature-card h-100 p-5 bg-white border-0 shadow-sm">
                        <div class="feature-icon bg-blue-100 bg-opacity-25 rounded-circle d-inline-flex p-4 mb-4 text-primary">
                            <i class="bi ${feature.icon} fs-1"></i>
                        </div>
                        <h4 class="fw-bold mb-3">${feature.title}</h4>
                        <p class="text-secondary mb-0">${feature.description}</p>
                    </div>
                </div>
            </c:forEach>
        </div>
    </div>
</section>

<!-- Panels Section -->
<section id="panels" class="bg-white py-lg-15 shadow-none border-0 rounded-top-5">
    <div class="container px-lg-10 text-center">
        <h2 class="section-title text-primary fs-3 mb-10">Access Our Panels</h2>
        <div class="row gy-5">
            <!-- Patient Card -->
            <div class="col-lg-3 col-md-6">
                <div class="glass-card panel-card p-5 border-0 bg-light shadow-sm text-center h-100">
                    <div class="rounded-circle bg-primary bg-opacity-25 p-4 d-inline-flex mb-4 text-primary">
                        <i class="bi bi-person fs-1"></i>
                    </div>
                    <h3 class="fw-bold mb-3">Patient Panel</h3>
                    <p class="text-secondary mb-5">Access your health vitals, book appointments, and view prescriptions seamlessly.</p>
                    <a href="${pageContext.request.contextPath}/auth/patient/login" class="btn btn-primary rounded-pill px-5 py-2 w-100 shadow-sm border-0">Login as Patient</a>
                </div>
            </div>
            <!-- Doctor Card -->
            <div class="col-lg-3 col-md-6">
                <div class="glass-card panel-card p-5 bg-white border-0 shadow-lg text-center h-100" style="transform: scale(1.05); z-index: 1;">
                    <div class="rounded-circle bg-success bg-opacity-25 p-4 d-inline-flex mb-4 text-success">
                        <i class="bi bi-person-badge fs-1"></i>
                    </div>
                    <h3 class="fw-bold mb-3">Doctor Panel</h3>
                    <p class="text-secondary mb-5">Monitor patient statuses, analyze vitals, and provide professional medical advice.</p>
                    <a href="${pageContext.request.contextPath}/auth/doctor/login" class="btn btn-success rounded-pill px-5 py-2 w-100 shadow-sm border-0">Login as Doctor</a>
                </div>
            </div>
            <!-- Admin Card -->
            <div class="col-lg-3 col-md-6">
                <div class="glass-card panel-card p-5 border-0 bg-light shadow-sm text-center h-100">
                    <div class="rounded-circle bg-danger bg-opacity-25 p-4 d-inline-flex mb-4 text-danger">
                        <i class="bi bi-person-lock fs-1"></i>
                    </div>
                    <h3 class="fw-bold mb-3">Admin Panel</h3>
                    <p class="text-secondary mb-5">Oversee system operations, manage staff, and analyze organizational data.</p>
                    <a href="${pageContext.request.contextPath}/auth/admin/login" class="btn btn-danger rounded-pill px-5 py-2 w-100 shadow-sm border-0">Login as Admin</a>
                </div>
            </div>
            <!-- Reception Card -->
            <div class="col-lg-3 col-md-6">
                <div class="glass-card panel-card p-5 border-0 bg-light shadow-sm text-center h-100">
                    <div class="rounded-circle bg-warning bg-opacity-25 p-4 d-inline-flex mb-4 text-warning">
                        <i class="bi bi-front fs-1"></i>
                    </div>
                    <h3 class="fw-bold mb-3">Reception Panel</h3>
                    <p class="text-secondary mb-5">Manage patient admissions, assign departments, and maintain hospital queue flow.</p>
                    <a href="${pageContext.request.contextPath}/auth/reception/login" class="btn btn-warning text-white rounded-pill px-5 py-2 w-100 shadow-sm border-0">Login Reception</a>
                </div>
            </div>
        </div>
    </div>
</section>

<%@ include file="/WEB-INF/views/layout/guest-footer.jsp" %>
