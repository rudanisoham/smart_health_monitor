<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ include file="/WEB-INF/views/layout/guest-header.jsp" %>

<!-- Hero Section -->
<section id="home" class="min-vh-100 d-flex align-items-center position-relative overflow-hidden pt-15 pb-10" style="background: linear-gradient(rgba(0, 51, 102, 0.8), rgba(0, 51, 102, 0.6)), url('https://images.unsplash.com/photo-1519494026892-80bbd2d6fd0d?q=80&w=2053&auto=format&fit=crop') center/cover no-repeat fixed;">
    <div class="container position-relative z-1">
        <div class="row align-items-center gy-5 pt-5">
            <div class="col-lg-8 text-center text-lg-start animate__animated animate__fadeInLeft">
                <span class="badge bg-light text-primary px-3 py-2 rounded-pill mb-4 fw-bold letter-spacing-1 shadow-sm">
                    <i class="bi bi-hospital me-2"></i>PREMIER HEALTHCARE FACILITY
                </span>
                <h1 class="display-2 fw-bolder text-white mb-4 lh-tight" style="font-family: 'Inter', sans-serif;">
                    Exceptional Care,<br>Close to <span class="text-info">Home.</span>
                </h1>
                <p class="lead text-white-50 mb-5 fs-4 pr-lg-5">
                    Welcome to Smart Health Hospital, where advanced medical technology meets compassionate patient care. Experience world-class healthcare tailored to your needs.
                </p>
                <div class="d-flex flex-column flex-sm-row gap-3 justify-content-center justify-content-lg-start">
                    <a href="${pageContext.request.contextPath}/auth/patient/register" class="btn btn-info btn-lg rounded-pill px-5 py-3 shadow-lg hover-up text-white fw-bold border-0">
                        <i class="bi bi-calendar-plus me-2"></i>Book Appointment
                    </a>
                    <a href="#about" class="btn btn-outline-light btn-lg rounded-pill px-5 py-3 hover-up fw-bold border-2">
                        Learn More <i class="bi bi-arrow-down-circle ms-2"></i>
                    </a>
                </div>
            </div>
        </div>
    </div>
    <!-- Wave Shape Divider -->
    <div class="position-absolute bottom-0 w-100" style="line-height:0;">
        <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 1200 120" preserveAspectRatio="none" style="height: 60px; width: 100%; fill: #f8fafc;">
            <path d="M321.39,56.44c58-10.79,114.16-30.13,172-41.86,82.39-16.72,168.19-17.73,250.45-.39C823.78,31,906.67,72,985.66,92.83c70.05,18.48,146.53,26.09,214.34,3V120H0V95.8C89.71,67.6,211.2,74.32,321.39,56.44Z"></path>
        </svg>
    </div>
</section>

<!-- Quick Actions Box -->
<div class="container position-relative z-2" style="margin-top: -80px;">
    <div class="row bg-white rounded-4 shadow-xl p-4 g-4 text-center mx-2 mx-md-0">
        <div class="col-md-3 border-end-md border-light-subtle action-item">
            <div class="text-primary mb-3"><i class="bi bi-telephone text-primary fs-1"></i></div>
            <h5 class="fw-bold text-dark">Emergency Cases</h5>
            <p class="text-muted mb-0 small">1-800-SMART-HEALTH</p>
        </div>
        <div class="col-md-3 border-end-md border-light-subtle action-item">
            <div class="text-info mb-3"><i class="bi bi-clock text-info fs-1"></i></div>
            <h5 class="fw-bold text-dark">Working Hours</h5>
            <p class="text-muted mb-0 small">24/7 Available Hours</p>
        </div>
        <div class="col-md-3 border-end-md border-light-subtle action-item">
            <div class="text-success mb-3"><i class="bi bi-geo-alt text-success fs-1"></i></div>
            <h5 class="fw-bold text-dark">Clinic Location</h5>
            <p class="text-muted mb-0 small">123 MedCity Avenue</p>
        </div>
        <div class="col-md-3 action-item">
            <div class="text-danger mb-3"><i class="bi bi-heart-pulse text-danger fs-1"></i></div>
            <h5 class="fw-bold text-dark">Blood Bank</h5>
            <p class="text-muted mb-0 small">Available 24/7</p>
        </div>
    </div>
</div>

<!-- About Section -->
<section id="about" class="py-20 bg-light">
    <div class="container">
        <div class="row align-items-center gy-5">
            <div class="col-lg-6 position-relative px-4 mb-5 mb-lg-0">
                <div class="position-absolute top-0 start-0 translate-middle bg-info rounded-circle opacity-25" style="width: 250px; height: 250px; filter: blur(50px);"></div>
                
                <!-- Single premium image of doctors interacting/smiling -->
                <img src="https://images.unsplash.com/photo-1551076805-e1869033e561?q=80&w=1932&auto=format&fit=crop" alt="Hospital Care Team" class="img-fluid rounded-4 shadow-lg position-relative z-1 w-100" style="object-fit: cover; height: 500px;">
                
                <!-- Floating 25+ Badge -->
                <div class="position-absolute bottom-0 end-0 bg-white p-4 rounded-4 shadow-lg z-2 m-4 m-md-5 animate__animated animate__bounceIn d-flex align-items-center gap-3 border border-light" style="animation-delay: 0.5s;">
                    <h3 class="text-primary fw-bolder mb-0 display-4">25<span class="text-info">+</span></h3>
                    <div class="border-start border-2 border-light ps-3">
                        <p class="text-muted mb-0 fw-bold small text-uppercase tracking-wider">Years of</p>
                        <p class="text-dark mb-0 fw-bold fs-6 tracking-wider">Excellence</p>
                    </div>
                </div>
            </div>
            
            <div class="col-lg-6 ps-lg-5 z-2">
                <h6 class="text-info fw-bold text-uppercase tracking-wider mb-2">About Our Hospital</h6>
                <h2 class="display-5 fw-bolder mb-4 text-dark">Dedicated to Providing the <span class="text-primary">Best Healthcare</span></h2>
                <p class="text-secondary fs-5 mb-5 lh-relaxed">
                    Smart Health Hospital is a premier medical institution committed to delivering exceptional patient care. Our state-of-the-art facilities and dedicated team of specialists ensure you receive the highest standard of medical treatment in a compassionate environment.
                </p>
                
                <!-- Stacked list exactly like user requested, but styled elegantly -->
                <div class="d-flex align-items-center gap-4 mb-3 p-3 px-4 bg-white rounded-4 shadow-sm transition hover-up hover-shadow-xl border-0" style="border-left: 4px solid var(--bs-info) !important;">
                    <div class="bg-success bg-opacity-10 text-success rounded-circle d-flex align-items-center justify-content-center flex-shrink-0" style="width: 40px; height: 40px;">
                        <i class="bi bi-check-lg fs-4"></i>
                    </div>
                    <span class="fs-5 fw-bold text-dark">Advanced Medical Technologies</span>
                </div>
                
                <div class="d-flex align-items-center gap-4 mb-3 p-3 px-4 bg-white rounded-4 shadow-sm transition hover-up hover-shadow-xl border-0" style="border-left: 4px solid var(--bs-info) !important;">
                    <div class="bg-success bg-opacity-10 text-success rounded-circle d-flex align-items-center justify-content-center flex-shrink-0" style="width: 40px; height: 40px;">
                        <i class="bi bi-check-lg fs-4"></i>
                    </div>
                    <span class="fs-5 fw-bold text-dark">Highly Qualified Medical Professionals</span>
                </div>
                
                <div class="d-flex align-items-center gap-4 mb-5 p-3 px-4 bg-white rounded-4 shadow-sm transition hover-up hover-shadow-xl border-0" style="border-left: 4px solid var(--bs-info) !important;">
                    <div class="bg-success bg-opacity-10 text-success rounded-circle d-flex align-items-center justify-content-center flex-shrink-0" style="width: 40px; height: 40px;">
                        <i class="bi bi-check-lg fs-4"></i>
                    </div>
                    <span class="fs-5 fw-bold text-dark">Comprehensive Emergency Care 24/7</span>
                </div>
                
                <a href="${pageContext.request.contextPath}/auth/patient/register" class="btn btn-primary btn-lg rounded-pill px-5 py-3 hover-up shadow-sm">Meet Our Specialists</a>
            </div>
        </div>
    </div>
</section>

<!-- Departments Section -->
<section id="features" class="py-20 bg-white">
    <div class="container">
        <div class="text-center mb-15">
            <h6 class="text-info fw-bold text-uppercase tracking-wider mb-2">Our Specialties</h6>
            <h2 class="display-5 fw-bolder mb-3 text-dark">Centers of <span class="text-primary">Excellence</span></h2>
            <p class="text-secondary fs-5 w-75 mx-auto">We offer a wide range of specialized medical services powered by advanced technology and leading experts.</p>
        </div>
        
        <div class="row gy-4">
            <c:forEach var="feature" items="${features}">
                 <!-- Mapped feature items to clinical feel -->
                <div class="col-lg-4 col-md-6 animate__animated animate__fadeInUp">
                    <div class="card h-100 border-0 shadow-sm p-4 transition hover-up hover-shadow-xl rounded-4 text-center service-card" style="border-bottom: 4px solid transparent !important;">
                        <div class="rounded-circle bg-light d-inline-flex p-4 mb-4 text-primary mx-auto icon-wrapper transition">
                            <i class="bi ${feature.icon} fs-1"></i>
                        </div>
                        <h4 class="fw-bold text-dark mb-3">${feature.title}</h4>
                        <p class="text-secondary mb-0 lh-base">${feature.description}</p>
                    </div>
                </div>
            </c:forEach>
        </div>
    </div>
</section>

<!-- System Portals Section -->
<section id="panels" class="py-20 bg-light position-relative">
    <div class="position-absolute top-0 start-0 w-100 h-100 bg-white" style="clip-path: polygon(0 0, 100% 0, 100% 80%, 0 100%); opacity: 0.4;"></div>
    <div class="container position-relative z-1">
        <div class="text-center mb-12">
            <h6 class="text-info fw-bold text-uppercase tracking-wider mb-2">Hospital Network</h6>
            <h2 class="display-5 fw-bolder mb-3 text-dark">Access Your <span class="text-primary">Medical Portals</span></h2>
            <p class="text-secondary fs-5">Secure access points for our patients and dedicated healthcare providers.</p>
        </div>
        
        <div class="row g-4 justify-content-center">
            <!-- Patient Module -->
            <div class="col-xl-4 col-md-6 animate__animated animate__fadeInUp">
                <a href="${pageContext.request.contextPath}/auth/patient/login" class="text-decoration-none">
                    <div class="card border-0 shadow-sm rounded-4 h-100 hover-up portal-mini-card p-4 d-flex flex-row align-items-center bg-white border-start border-4 border-info">
                        <div class="bg-info bg-opacity-10 text-info rounded-circle d-flex align-items-center justify-content-center flex-shrink-0" style="width: 60px; height: 60px;">
                            <i class="bi bi-person fs-3"></i>
                        </div>
                        <div class="ms-4">
                            <h5 class="fw-bold text-dark mb-1">Patient Portal</h5>
                            <p class="text-muted small mb-0 lh-tight">Lab results, appointments, & history.</p>
                        </div>
                        <div class="ms-auto text-info opacity-50 icon-arrow transition">
                            <i class="bi bi-chevron-right fs-4"></i>
                        </div>
                    </div>
                </a>
            </div>
            
            <!-- Doctor Module -->
            <div class="col-xl-4 col-md-6 animate__animated animate__fadeInUp" style="animation-delay: 0.1s;">
                <a href="${pageContext.request.contextPath}/auth/doctor/login" class="text-decoration-none">
                    <div class="card border-0 shadow-sm rounded-4 h-100 hover-up portal-mini-card p-4 d-flex flex-row align-items-center bg-white border-start border-4 border-primary">
                        <div class="bg-primary bg-opacity-10 text-primary rounded-circle d-flex align-items-center justify-content-center flex-shrink-0" style="width: 60px; height: 60px;">
                            <i class="bi bi-person-badge fs-3"></i>
                        </div>
                        <div class="ms-4">
                            <h5 class="fw-bold text-dark mb-1">Doctor Portal</h5>
                            <p class="text-muted small mb-0 lh-tight">Manage schedules, charts, & Rx.</p>
                        </div>
                        <div class="ms-auto text-primary opacity-50 icon-arrow transition">
                            <i class="bi bi-chevron-right fs-4"></i>
                        </div>
                    </div>
                </a>
            </div>

            <!-- Reception Module -->
            <div class="col-xl-4 col-md-6 animate__animated animate__fadeInUp" style="animation-delay: 0.2s;">
                <a href="${pageContext.request.contextPath}/auth/reception/login" class="text-decoration-none">
                    <div class="card border-0 shadow-sm rounded-4 h-100 hover-up portal-mini-card p-4 d-flex flex-row align-items-center bg-white border-start border-4 border-warning">
                        <div class="bg-warning bg-opacity-10 text-warning rounded-circle d-flex align-items-center justify-content-center flex-shrink-0" style="width: 60px; height: 60px;">
                            <i class="bi bi-person-video2 fs-3"></i>
                        </div>
                        <div class="ms-4">
                            <h5 class="fw-bold text-dark mb-1">Reception Desk</h5>
                            <p class="text-muted small mb-0 lh-tight">Patient intake & bed admissions.</p>
                        </div>
                        <div class="ms-auto text-warning opacity-50 icon-arrow transition">
                            <i class="bi bi-chevron-right fs-4"></i>
                        </div>
                    </div>
                </a>
            </div>

             <!-- Medical Staff Module -->
            <div class="col-xl-4 col-md-6 animate__animated animate__fadeInUp" style="animation-delay: 0.3s;">
                <a href="${pageContext.request.contextPath}/auth/medical/login" class="text-decoration-none">
                    <div class="card border-0 shadow-sm rounded-4 h-100 hover-up portal-mini-card p-4 d-flex flex-row align-items-center bg-white border-start border-4 border-success">
                        <div class="bg-success bg-opacity-10 text-success rounded-circle d-flex align-items-center justify-content-center flex-shrink-0" style="width: 60px; height: 60px;">
                            <i class="bi bi-capsule fs-3"></i>
                        </div>
                        <div class="ms-4">
                            <h5 class="fw-bold text-dark mb-1">Medical Services</h5>
                            <p class="text-muted small mb-0 lh-tight">Lab controls & hospital pharmacy.</p>
                        </div>
                        <div class="ms-auto text-success opacity-50 icon-arrow transition">
                            <i class="bi bi-chevron-right fs-4"></i>
                        </div>
                    </div>
                </a>
            </div>
            
            <!-- Admin Module -->
            <div class="col-xl-4 col-md-6 animate__animated animate__fadeInUp" style="animation-delay: 0.4s;">
                <a href="${pageContext.request.contextPath}/auth/admin/login" class="text-decoration-none">
                    <div class="card border-0 shadow-sm rounded-4 h-100 hover-up portal-mini-card p-4 d-flex flex-row align-items-center bg-white border-start border-4 border-dark">
                        <div class="bg-dark bg-opacity-10 text-dark rounded-circle d-flex align-items-center justify-content-center flex-shrink-0" style="width: 60px; height: 60px;">
                            <i class="bi bi-shield-check fs-3"></i>
                        </div>
                        <div class="ms-4">
                            <h5 class="fw-bold text-dark mb-1">IT & Admin</h5>
                            <p class="text-muted small mb-0 lh-tight">Infrastructure & security roles.</p>
                        </div>
                        <div class="ms-auto text-dark opacity-50 icon-arrow transition">
                            <i class="bi bi-chevron-right fs-4"></i>
                        </div>
                    </div>
                </a>
            </div>
        </div>
    </div>
</section>

<style>
    :root {
        --bs-primary: #004d99; /* Deep Hospital Blue */
        --bs-primary-rgb: 0, 77, 153;
        --bs-info: #00b3b3;   /* Teal / Medical Green accent */
        --bs-info-rgb: 0, 179, 179;
    }
    
    body {
        font-family: 'Inter', system-ui, -apple-system, sans-serif;
    }

    /* Redefine primary/info colors for this page explicitly */
    .text-primary { color: var(--bs-primary) !important; }
    .bg-primary { background-color: rgba(var(--bs-primary-rgb), var(--bs-bg-opacity, 1)) !important; }
    .btn-primary { background-color: var(--bs-primary); border-color: var(--bs-primary); color: white; }
    .btn-primary:hover { background-color: #003366; border-color: #003366; color: white; }
    
    .text-info { color: var(--bs-info) !important; }
    .bg-info { background-color: rgba(var(--bs-info-rgb), var(--bs-bg-opacity, 1)) !important; }
    .btn-info { background-color: var(--bs-info); border-color: var(--bs-info); color: white; }
    .btn-info:hover { background-color: #008080; border-color: #008080; color: white; }
    .btn-outline-info { border-color: var(--bs-info); color: var(--bs-info); }
    .btn-outline-info:hover { background-color: var(--bs-info); color: white; }

    .hover-up { transition: transform 0.3s ease, box-shadow 0.3s ease; }
    .hover-up:hover { transform: translateY(-7px) !important; box-shadow: 0 15px 30px rgba(0,0,0,0.1) !important; }
    
    .transition { transition: all 0.3s ease; }
    .shadow-xl { box-shadow: 0 20px 40px rgba(0,0,0,0.08) !important; }
    .letter-spacing-1 { letter-spacing: 1px; }
    .tracking-wider { letter-spacing: 0.1em; }
    .lh-relaxed { line-height: 1.8; }
    
    .pt-15 { padding-top: 8rem; }
    .pb-10 { padding-bottom: 6rem; }
    .py-20 { padding: 7rem 0; }
    .mb-15 { margin-bottom: 5rem; }
    .mb-12 { margin-bottom: 4rem; }
    
    .transform-scale-105 { transform: scale(1.05); }
    
    .action-item i { transition: transform 0.3s cubic-bezier(0.175, 0.885, 0.32, 1.275); }
    .action-item:hover i { transform: scale(1.3); }
    
    .service-card:hover { border-bottom-color: var(--bs-info) !important; }
    .service-card:hover .icon-wrapper { background-color: var(--bs-primary) !important; color: white !important; }
    .service-card .icon-wrapper i { transition: transform 0.3s ease; }
    .service-card:hover .icon-wrapper i { transform: scale(1.1); }

    @media (min-width: 768px) {
        .border-end-md { border-right: 1px solid #dee2e6 !important; }
    }
    @media (max-width: 1200px) {
        .transform-scale-105 { transform: scale(1); }
    }
</style>

<%@ include file="/WEB-INF/views/layout/guest-footer.jsp" %>
