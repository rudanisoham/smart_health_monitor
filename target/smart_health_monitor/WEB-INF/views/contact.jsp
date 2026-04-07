<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ include file="/WEB-INF/views/layout/guest-header.jsp" %>

<section class="py-15 bg-light mt-5 pt-10 border-0 shadow-none">
    <div class="container px-lg-5">
        <div class="text-center mb-10 pb-5">
            <h2 class="display-3 fw-bold mb-4 text-primary">Get In Touch</h2>
            <p class="lead text-secondary w-75 mx-auto fs-5 ps-lg-2 pe-lg-2">Have questions about our smart health platform? Reach out to us anytime and our team will be happy to help.</p>
        </div>

        <div class="row align-items-stretch gy-5">
            <div class="col-lg-5 animate__animated animate__fadeInLeft mb-5">
                <div class="glass-card shadow-sm border-0 p-5 bg-white h-100">
                    <h4 class="fw-bold mb-5 fs-3 text-primary">Contact Details</h4>
                    <div class="d-flex mb-5 ps-3">
                        <div class="rounded-circle bg-primary bg-opacity-25 p-3 text-primary me-4">
                            <i class="bi bi-geo-alt fs-4"></i>
                        </div>
                        <div>
                            <h6 class="fw-bold fs-5 mb-1">Our Location</h6>
                            <p class="text-secondary mb-0">${siteContent.address != null ? siteContent.address : "Location, India"}</p>
                        </div>
                    </div>
                    <div class="d-flex mb-5 ps-3">
                        <div class="rounded-circle bg-success bg-opacity-25 p-3 text-success me-4">
                            <i class="bi bi-telephone fs-4"></i>
                        </div>
                        <div>
                            <h6 class="fw-bold fs-5 mb-1">Call Us</h6>
                            <p class="text-secondary mb-0">${siteContent.contactPhone != null ? siteContent.contactPhone : "+91-1234567890"}</p>
                        </div>
                    </div>
                    <div class="d-flex mb-3 ps-3">
                        <div class="rounded-circle bg-danger bg-opacity-25 p-3 text-danger me-4">
                            <i class="bi bi-envelope fs-4"></i>
                        </div>
                        <div>
                            <h6 class="fw-bold fs-5 mb-1">Email Support</h6>
                            <p class="text-secondary mb-0">${siteContent.contactEmail != null ? siteContent.contactEmail : "support@smarthealth.com"}</p>
                        </div>
                    </div>
                    
                    <div class="mt-15 animate__animated animate__zoomIn">
                        <h4 class="fw-bold mb-5 ps-3 fs-3 text-primary">Follow Us</h4>
                        <div class="d-flex gap-4 ps-3">
                            <a href="#" class="btn btn-primary rounded-circle shadow-sm p-4 d-inline-flex"><i class="bi bi-facebook fs-4"></i></a>
                            <a href="#" class="btn btn-info rounded-circle shadow-sm p-4 d-inline-flex text-white"><i class="bi bi-twitter-x fs-4"></i></a>
                            <a href="#" class="btn btn-danger rounded-circle shadow-sm p-4 d-inline-flex"><i class="bi bi-instagram fs-4"></i></a>
                            <a href="#" class="btn btn-primary rounded-circle shadow-sm p-4 d-inline-flex" style="background:#0077b5;"><i class="bi bi-linkedin fs-4"></i></a>
                        </div>
                    </div>
                </div>
            </div>

            <div class="col-lg-7 animate__animated animate__fadeInRight mb-5">
                <div class="glass-card shadow-sm border-0 p-5 bg-white h-100">
                    <h4 class="fw-bold mb-5 fs-3 text-primary">Send Message</h4>
                    <form action="#" class="row gy-5">
                        <div class="col-md-6 mb-3">
                            <label class="form-label fw-bold small text-uppercase">Full Name</label>
                            <input type="text" class="form-control rounded-pill border-0 bg-light p-3 px-4 ps-4 pe-4" placeholder="Enter Full Name">
                        </div>
                        <div class="col-md-6 mb-3">
                            <label class="form-label fw-bold small text-uppercase">Email Address</label>
                            <input type="email" class="form-control rounded-pill border-0 bg-light p-3 px-4 ps-4 pe-4" placeholder="Enter Email Email">
                        </div>
                        <div class="col-12 mb-3">
                            <label class="form-label fw-bold small text-uppercase">Subject</label>
                            <input type="text" class="form-control rounded-pill border-0 bg-light p-3 px-4 ps-4 pe-4" placeholder="Enter Subject">
                        </div>
                        <div class="col-12 mb-5">
                            <label class="form-label fw-bold small text-uppercase">Message Details</label>
                            <textarea class="form-control rounded-4 border-0 bg-light p-4 px-4 ps-4 pe-4" rows="6" placeholder="Enter Message"></textarea>
                        </div>
                        <div class="col-12">
                            <button type="submit" class="btn btn-primary rounded-pill px-10 py-3 w-100 fw-bold fs-5 shadow-sm border-0">Send Feedback</button>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>
</section>

<%@ include file="/WEB-INF/views/layout/guest-footer.jsp" %>
