<%@ taglib prefix="c" uri="jakarta.tags.core" %>
    <%@ include file="/WEB-INF/views/layout/guest-header.jsp" %>

        <section class="py-20 bg-light mt-5 overflow-hidden">
            <div class="container">
                <div class="text-center mb-15 animate__animated animate__fadeIn">
                    <h2 class="display-4 fw-bold mb-4 text-dark">Get in <span class="text-primary">Touch</span></h2>
                    <p class="lead text-secondary w-75 mx-auto fs-5">
                        Have questions about our smart health platform? Our medical support team is here to help you
                        24/7.
                    </p>
                </div>

                <div class="row g-5 align-items-stretch">
                    <div class="col-lg-5 animate__animated animate__fadeInLeft">
                        <div class="card h-100 border-0 shadow-xl p-5 rounded-4 bg-white">
                            <h4 class="fw-bold mb-5 fs-3 text-dark">Contact Information</h4>

                            <div
                                class="d-flex mb-5 align-items-center bg-light p-4 rounded-4 transition hover-bg-white shadow-sm-hover border border-transparent hover-border-primary">
                                <div class="rounded-circle bg-primary bg-opacity-10 p-3 text-primary me-4">
                                    <i class="bi bi-geo-alt fs-3"></i>
                                </div>
                                <div>
                                    <h6 class="fw-bold mb-1">Our Location</h6>
                                    <p class="text-secondary mb-0 small">${siteContent.address != null ?
                                        siteContent.address : "Healthcare hub, India"}</p>
                                </div>
                            </div>

                            <div
                                class="d-flex mb-5 align-items-center bg-light p-4 rounded-4 transition hover-bg-white shadow-sm-hover border border-transparent hover-border-success">
                                <div class="rounded-circle bg-success bg-opacity-10 p-3 text-success me-4">
                                    <i class="bi bi-telephone fs-3"></i>
                                </div>
                                <div>
                                    <h6 class="fw-bold mb-1">Call Support</h6>
                                    <p class="text-secondary mb-0 small">${siteContent.contactPhone != null ?
                                        siteContent.contactPhone : "+91-1234567890"}</p>
                                </div>
                            </div>

                            <div
                                class="d-flex mb-5 align-items-center bg-light p-4 rounded-4 transition hover-bg-white shadow-sm-hover border border-transparent hover-border-danger">
                                <div class="rounded-circle bg-danger bg-opacity-10 p-3 text-danger me-4">
                                    <i class="bi bi-envelope fs-3"></i>
                                </div>
                                <div>
                                    <h6 class="fw-bold mb-1">Email Inquiry</h6>
                                    <p class="text-secondary mb-0 small">${siteContent.contactEmail != null ?
                                        siteContent.contactEmail : "support@smarthealth.com"}</p>
                                </div>
                            </div>

                            <div class="mt-8">
                                <h5 class="fw-bold mb-4 small text-uppercase letter-spacing-1 text-muted">Follow our
                                    Updates</h5>
                                <div class="d-flex gap-3">
                                    <a href="#"
                                        class="btn btn-primary rounded-circle p-3 d-flex align-items-center justify-content-center"
                                        style="width: 48px; height: 48px;"><i class="bi bi-facebook fs-5"></i></a>
                                    <a href="#"
                                        class="btn btn-info text-white rounded-circle p-3 d-flex align-items-center justify-content-center"
                                        style="width: 48px; height: 48px;"><i class="bi bi-twitter-x fs-5"></i></a>
                                    <a href="#"
                                        class="btn btn-danger rounded-circle p-3 d-flex align-items-center justify-content-center"
                                        style="width: 48px; height: 48px;"><i class="bi bi-instagram fs-5"></i></a>
                                </div>
                            </div>
                        </div>
                    </div>

                    <div class="col-lg-7 animate__animated animate__fadeInRight">
                        <div
                            class="card h-100 border-0 shadow-xl p-5 rounded-4 bg-white position-relative overflow-hidden">
                            <div class="position-absolute top-0 end-0 p-5 opacity-5">
                                <i class="bi bi-chat-dots-fill display-1"></i>
                            </div>

                            <h4 class="fw-bold mb-5 fs-3 text-dark position-relative z-1">Send a Feedback</h4>

                            <c:if test="${not empty success}">
                                <div
                                    class="alert alert-success border-0 rounded-4 p-4 mb-5 animate__animated animate__slideInDown">
                                    <div class="d-flex align-items-center gap-3">
                                        <i class="bi bi-check-circle-fill fs-4"></i>
                                        <span class="fw-bold">${success}</span>
                                    </div>
                                </div>
                            </c:if>

                            <form action="<%= request.getContextPath() %>/contact" method="POST"
                                class="row g-4 position-relative z-1">
                                <div class="col-md-6">
                                    <label class="form-label small fw-bold text-uppercase text-muted">Full Name</label>
                                    <input type="text" name="fullName"
                                        class="form-control form-control-lg rounded-3 bg-light border-0 px-4"
                                        placeholder="e.g. John Doe" required>
                                </div>
                                <div class="col-md-6">
                                    <label class="form-label small fw-bold text-uppercase text-muted">Email
                                        Address</label>
                                    <input type="email" name="email"
                                        class="form-control form-control-lg rounded-3 bg-light border-0 px-4"
                                        placeholder="e.g. john@example.com" required>
                                </div>
                                <div class="col-12">
                                    <label class="form-label small fw-bold text-uppercase text-muted">Subject</label>
                                    <input type="text" name="subject"
                                        class="form-control form-control-lg rounded-3 bg-light border-0 px-4"
                                        placeholder="How can we help?" required>
                                </div>
                                <div class="col-12">
                                    <label class="form-label small fw-bold text-uppercase text-muted">Message
                                        Details</label>
                                    <textarea name="message"
                                        class="form-control form-control-lg rounded-3 bg-light border-0 px-4" rows="5"
                                        placeholder="Tell us more about your feedback..." required></textarea>
                                </div>
                                <div class="col-12 mt-5">
                                    <button type="submit"
                                        class="btn btn-primary btn-lg rounded-pill w-100 py-3 fw-bold shadow-lg hover-up">
                                        <i class="bi bi-send-fill me-2"></i>Send Feedback
                                    </button>
                                </div>
                            </form>
                        </div>
                    </div>
                </div>
            </div>
        </section>

        <style>
            .py-20 {
                padding: 8rem 0;
            }

            .mb-15 {
                margin-bottom: 5rem;
            }

            .shadow-xl {
                box-shadow: 0 20px 40px rgba(0, 0, 0, 0.06) !important;
            }

            .shadow-sm-hover:hover {
                box-shadow: 0 10px 20px rgba(0, 0, 0, 0.05) !important;
            }

            .hover-bg-white:hover {
                background: white !important;
            }

            .hover-up:hover {
                transform: translateY(-5px);
            }

            .transition {
                transition: all 0.3s ease;
            }

            .letter-spacing-1 {
                letter-spacing: 1px;
            }

            .hover-border-primary:hover {
                border-color: var(--bs-primary) !important;
            }

            .hover-border-success:hover {
                border-color: var(--bs-success) !important;
            }

            .hover-border-danger:hover {
                border-color: var(--bs-danger) !important;
            }
        </style>

        <%@ include file="/WEB-INF/views/layout/guest-footer.jsp" %>