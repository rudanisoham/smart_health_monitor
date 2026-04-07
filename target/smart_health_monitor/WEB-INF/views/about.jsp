<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ include file="/WEB-INF/views/layout/guest-header.jsp" %>

<section class="py-15 bg-light shadow-none border-0 mt-5 pt-10">
    <div class="container px-lg-5">
        <div class="row align-items-center mb-10 gy-5">
            <div class="col-lg-6 animate__animated animate__fadeInLeft">
                <h2 class="display-3 fw-bold mb-4 text-primary">Our Mission</h2>
                <p class="lead text-secondary ps-lg-2 pe-lg-2 fs-5 mb-5">
                    Our mission is to empower both patients and healthcare providers through innovative data-driven solutions that simplify health monitoring and ensure proactive care.
                </p>
                <div class="glass-card shadow-sm border-0 p-5 bg-white">
                    <h4 class="fw-bold mb-3"><i class="bi bi-check-circle-fill text-success me-2"></i> Visionary Healthcare</h4>
                    <p class="text-secondary text-justify mb-5">
                        We envision a world where advanced AI and real-time monitoring work together to prevent health crises before they happen, making specialized care accessible for everyone at anytime.
                    </p>
                    <a href="${pageContext.request.contextPath}/auth/patient/register" class="btn btn-primary rounded-pill px-5 shadow-sm">Join Our Mission</a>
                </div>
            </div>
            <div class="col-lg-6 animate__animated animate__fadeInRight">
                <img src="https://img.freepik.com/free-vector/healthy-heart-concept-illustration_114360-1921.jpg" alt="About Detailed" class="img-fluid rounded-5 shadow-lg border-0 bg-white">
            </div>
        </div>

        <div class="row mt-lg-15 py-lg-15 text-center px-lg-10">
            <div class="col-md-4 mb-5">
                <div class="p-5 glass-card shadow-sm border-0 bg-white h-100">
                    <div class="rounded-circle bg-blue-100 p-4 d-inline-flex mb-4 text-primary">
                        <i class="bi bi-shield-lock-fill fs-2"></i>
                    </div>
                    <h5 class="fw-bold fs-4 mb-3">Secure Privacy</h5>
                    <p class="text-secondary mb-0">Your medical data is encrypted and handled with the highest security standards available.</p>
                </div>
            </div>
            <div class="col-md-4 mb-5">
                <div class="p-5 glass-card shadow-sm border-0 bg-white h-100">
                    <div class="rounded-circle bg-success-light p-4 d-inline-flex mb-4 text-success">
                        <i class="bi bi-cpu-fill fs-2"></i>
                    </div>
                    <h5 class="fw-bold fs-4 mb-3">AI Integration</h5>
                    <p class="text-secondary mb-0">Utilizing advanced algorithms to detect anomalies in your vitals and alert doctors instantly.</p>
                </div>
            </div>
            <div class="col-md-4 mb-5">
                <div class="p-5 glass-card shadow-sm border-0 bg-white h-100">
                    <div class="rounded-circle bg-warning-light p-4 d-inline-flex mb-4 text-warning">
                        <i class="bi bi-globe fs-2"></i>
                    </div>
                    <h5 class="fw-bold fs-4 mb-3">Global Access</h5>
                    <p class="text-secondary mb-0">Monitor your health from anywhere in the world and stay connected to your healthcare provider.</p>
                </div>
            </div>
        </div>
    </div>
</section>

<%@ include file="/WEB-INF/views/layout/guest-footer.jsp" %>
