<%@ taglib prefix="c" uri="jakarta.tags.core" %>

    <footer class="glass-card mt-auto border-0 py-5 rounded-top-5">
        <div class="container text-center text-md-start">
            <div class="row gy-4">
                <div class="col-lg-4 col-md-6">
                    <h4 class="fw-bold text-primary mb-3">
                        <i class="bi bi-heart-pulse-fill me-2"></i>${siteContent.projectTitle != null ? siteContent.projectTitle : "Smart Health"}
                    </h4>
                    <p class="text-secondary">${siteContent.tagline != null ? siteContent.tagline : "Your health, our priority."}</p>
                    <div class="d-flex gap-3">
                        <a href="#" class="btn btn-glass btn-sm fs-5 rounded-circle shadow-sm"><i class="bi bi-facebook"></i></a>
                        <a href="#" class="btn btn-glass btn-sm fs-5 rounded-circle shadow-sm"><i class="bi bi-twitter"></i></a>
                        <a href="#" class="btn btn-glass btn-sm fs-5 rounded-circle shadow-sm"><i class="bi bi-linkedin"></i></a>
                        <a href="#" class="btn btn-glass btn-sm fs-5 rounded-circle shadow-sm"><i class="bi bi-instagram"></i></a>
                    </div>
                </div>
                <div class="col-lg-2 col-md-6">
                    <h5 class="fw-bold mb-3">Links</h5>
                    <ul class="list-unstyled text-secondary">
                        <li class="mb-2"><a href="${pageContext.request.contextPath}/" class="text-decoration-none transition shadow">Home</a></li>
                        <li class="mb-2"><a href="#about" class="text-decoration-none transition shadow">About Us</a></li>
                        <li class="mb-2"><a href="#features" class="text-decoration-none transition shadow">Features</a></li>
                        <li class="mb-2"><a href="#panels" class="text-decoration-none transition shadow">Panels</a></li>
                    </ul>
                </div>
                <div class="col-lg-3 col-md-6">
                    <h5 class="fw-bold mb-3">Panels</h5>
                    <ul class="list-unstyled text-secondary">
                        <li class="mb-2"><a href="${pageContext.request.contextPath}/auth/admin/login" class="text-decoration-none transition shadow">Admin Panel</a></li>
                        <li class="mb-2"><a href="${pageContext.request.contextPath}/auth/doctor/login" class="text-decoration-none transition shadow">Doctor Panel</a></li>
                        <li class="mb-2"><a href="${pageContext.request.contextPath}/auth/patient/login" class="text-decoration-none transition shadow">Patient Panel</a></li>
                    </ul>
                </div>
                <div class="col-lg-3 col-md-6">
                    <h5 class="fw-bold mb-3">Contact</h5>
                    <ul class="list-unstyled text-secondary">
                        <li class="mb-2"><i class="bi bi-geo-alt me-2 text-primary"></i> ${siteContent.address != null ? siteContent.address : "Location, India"}</li>
                        <li class="mb-2"><i class="bi bi-telephone me-2 text-primary"></i> ${siteContent.contactPhone != null ? siteContent.contactPhone : "+91-1234567890"}</li>
                        <li class="mb-2"><i class="bi bi-envelope me-2 text-primary"></i> ${siteContent.contactEmail != null ? siteContent.contactEmail : "support@smarthealth.com"}</li>
                    </ul>
                </div>
            </div>
            <hr class="my-4 border-secondary opacity-25">
            <div class="text-center">
                <small class="text-secondary">&copy; <script>document.write(new Date().getFullYear())</script> ${siteContent.projectTitle != null ? siteContent.projectTitle : "Smart Health Monitor"}. All Rights Reserved.</small>
            </div>
        </div>
    </footer>

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
