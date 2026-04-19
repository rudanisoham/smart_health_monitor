<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<footer class="bg-dark text-white py-5 mt-auto" style="background-color: #002b49 !important;">
    <div class="container text-center text-md-start">
        <div class="row gy-4 mb-4">
            <div class="col-lg-4 col-md-6 pe-lg-5">
                <h4 class="fw-bold text-white mb-3 d-flex align-items-center justify-content-center justify-content-md-start">
                    <i class="bi bi-hospital fs-3 text-info me-2"></i> ${siteContent.projectTitle != null ? siteContent.projectTitle : "Smart Health"}
                </h4>
                <p class="text-white-50 lh-relaxed mb-4">
                    ${siteContent.tagline != null ? siteContent.tagline : "Delivering excellence in healthcare with advanced medical monitoring and compassionate care across our integrated network."}
                </p>
                <div class="d-flex gap-3 justify-content-center justify-content-md-start">
                    <a href="#" class="btn btn-outline-light btn-sm fs-5 rounded-circle" style="width: 40px; height: 40px; display: flex; align-items: center; justify-content: center;"><i class="bi bi-facebook"></i></a>
                    <a href="#" class="btn btn-outline-light btn-sm fs-5 rounded-circle" style="width: 40px; height: 40px; display: flex; align-items: center; justify-content: center;"><i class="bi bi-twitter-x"></i></a>
                    <a href="#" class="btn btn-outline-light btn-sm fs-5 rounded-circle" style="width: 40px; height: 40px; display: flex; align-items: center; justify-content: center;"><i class="bi bi-linkedin"></i></a>
                    <a href="#" class="btn btn-outline-light btn-sm fs-5 rounded-circle" style="width: 40px; height: 40px; display: flex; align-items: center; justify-content: center;"><i class="bi bi-instagram"></i></a>
                </div>
            </div>
            <div class="col-lg-2 col-md-6 mt-4 mt-lg-0">
                <h5 class="fw-bold text-white mb-3 text-uppercase tracking-wider" style="font-size: 0.9rem;">Quick Links</h5>
                <ul class="list-unstyled text-white-50">
                    <li class="mb-2"><a href="${pageContext.request.contextPath}/" class="text-decoration-none text-white-50 hover-text-info transition">Home</a></li>
                    <li class="mb-2"><a href="#about" class="text-decoration-none text-white-50 hover-text-info transition">About Us</a></li>
                    <li class="mb-2"><a href="#departments" class="text-decoration-none text-white-50 hover-text-info transition">Departments</a></li>
                    <li class="mb-2"><a href="#portals" class="text-decoration-none text-white-50 hover-text-info transition">Network Portals</a></li>
                </ul>
            </div>
            <div class="col-lg-3 col-md-6 mt-4 mt-lg-0">
                <h5 class="fw-bold text-white mb-3 text-uppercase tracking-wider" style="font-size: 0.9rem;">Our Services</h5>
                <ul class="list-unstyled text-white-50">
                    <li class="mb-2"><a href="${pageContext.request.contextPath}/auth/patient/login" class="text-decoration-none text-white-50 hover-text-info transition">Patient Portal Login</a></li>
                    <li class="mb-2"><a href="${pageContext.request.contextPath}/auth/doctor/login" class="text-decoration-none text-white-50 hover-text-info transition">Doctor Console</a></li>
                    <li class="mb-2"><a href="${pageContext.request.contextPath}/auth/patient/register" class="text-decoration-none text-white-50 hover-text-info transition">Book Appointment</a></li>
                    <li class="mb-2"><a href="#" class="text-decoration-none text-white-50 hover-text-info transition">Emergency Care</a></li>
                </ul>
            </div>
            <div class="col-lg-3 col-md-6 mt-4 mt-lg-0">
                <h5 class="fw-bold text-white mb-3 text-uppercase tracking-wider" style="font-size: 0.9rem;">Contact Us</h5>
                <ul class="list-unstyled text-white-50">
                    <li class="mb-3 d-flex align-items-start justify-content-center justify-content-md-start">
                        <i class="bi bi-geo-alt-fill me-3 text-info mt-1 fs-5"></i> 
                        <span class="text-start">${siteContent.address != null ? siteContent.address : "123 MedCity Avenue, Health Tech Park, Mumbai, India"}</span>
                    </li>
                    <li class="mb-3 d-flex align-items-center justify-content-center justify-content-md-start">
                        <i class="bi bi-telephone-fill me-3 text-info fs-5"></i> 
                        <span>${siteContent.contactPhone != null ? siteContent.contactPhone : "+91-1800-SMART-HEALTH"}</span>
                    </li>
                    <li class="mb-2 d-flex align-items-center justify-content-center justify-content-md-start">
                        <i class="bi bi-envelope-fill me-3 text-info fs-5"></i> 
                        <span>${siteContent.contactEmail != null ? siteContent.contactEmail : "support@smarthealth.com"}</span>
                    </li>
                </ul>
            </div>
        </div>
        <hr class="border-secondary opacity-25 my-4">
        <div class="d-flex flex-column flex-md-row justify-content-between align-items-center">
            <small class="text-white-50 mb-2 mb-md-0">&copy; <script>document.write(new Date().getFullYear())</script> ${siteContent.projectTitle != null ? siteContent.projectTitle : "Smart Health Monitor"}. All Rights Reserved.</small>
            <div class="text-white-50 small">
                <a href="#" class="text-white-50 text-decoration-none me-3 hover-text-info">Privacy Policy</a>
                <a href="#" class="text-white-50 text-decoration-none hover-text-info">Terms of Service</a>
            </div>
        </div>
    </div>
</footer>

<style>
    .hover-text-info:hover { color: var(--bs-info) !important; text-decoration: underline !important; }
</style>

    <!-- Bootstrap 5 Bundle JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        window.onscroll = function() {
            var navbar = document.querySelector('.navbar-glass');
            if (window.scrollY > 50) {
                navbar.classList.add('scrolled');
            } else {
                navbar.classList.remove('scrolled');
            }
        };

        // Smooth scroll for anchor links
        document.querySelectorAll('a[href^="#"]').forEach(anchor => {
            anchor.addEventListener('click', function (e) {
                e.preventDefault();
                document.querySelector(this.getAttribute('href')).scrollIntoView({
                    behavior: 'smooth'
                });
            });
        });
    </script>
</body>
</html>
