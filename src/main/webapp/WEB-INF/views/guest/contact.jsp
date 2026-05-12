<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<jsp:include page="/WEB-INF/views/common/header.jsp" />
<jsp:include page="/WEB-INF/views/common/navbar.jsp" />

<main class="flex-1 bg-gray-50">

    <!-- Hero -->
    <section class="bg-gradient-to-br from-accent-700 via-accent-600 to-primary-600 text-white py-16">
        <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 text-center">
            <div class="inline-flex items-center justify-center w-16 h-16 bg-white/20 rounded-2xl mb-6">
                <i class="fas fa-headset text-3xl"></i>
            </div>
            <h1 class="text-4xl md:text-5xl font-black mb-4">Contact <span class="text-accent-200">Support</span></h1>
            <p class="text-lg text-blue-100 max-w-xl mx-auto">
                Have a question, issue, or feedback? We're here to help. Reach out and our team will respond within 24 hours.
            </p>
        </div>
    </section>

    <section class="py-16">
        <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">

            <!-- Success Banner -->
            <c:if test="${param.success == 'true'}">
                <div class="mb-8 p-5 bg-green-50 border border-green-200 rounded-2xl flex items-start gap-4">
                    <div class="w-10 h-10 bg-green-100 rounded-xl flex items-center justify-center flex-shrink-0">
                        <i class="fas fa-check-circle text-green-600 text-lg"></i>
                    </div>
                    <div>
                        <p class="font-bold text-green-800">Message sent successfully!</p>
                        <p class="text-green-700 text-sm mt-0.5">Thank you for reaching out. Our support team will get back to you within 24 hours.</p>
                    </div>
                </div>
            </c:if>

            <!-- Error Banner -->
            <c:if test="${not empty error}">
                <div class="mb-8 p-5 bg-red-50 border border-red-200 rounded-2xl flex items-start gap-4">
                    <i class="fas fa-exclamation-circle text-red-500 mt-0.5"></i>
                    <p class="text-red-700 text-sm">${error}</p>
                </div>
            </c:if>

            <div class="grid grid-cols-1 lg:grid-cols-3 gap-8">

                <!-- Contact Info Cards -->
                <div class="space-y-4">
                    <div class="bg-white rounded-2xl p-6 shadow-sm border border-gray-100">
                        <div class="w-12 h-12 bg-primary-50 rounded-xl flex items-center justify-center mb-4">
                            <i class="fas fa-map-marker-alt text-primary-600 text-xl"></i>
                        </div>
                        <h3 class="font-bold text-gray-900 mb-1">Our Location</h3>
                        <p class="text-gray-500 text-sm">Kathmandu Metropolitan City<br>Bagmati Province, Nepal</p>
                    </div>
                    <div class="bg-white rounded-2xl p-6 shadow-sm border border-gray-100">
                        <div class="w-12 h-12 bg-green-50 rounded-xl flex items-center justify-center mb-4">
                            <i class="fas fa-phone-alt text-green-600 text-xl"></i>
                        </div>
                        <h3 class="font-bold text-gray-900 mb-1">Phone Support</h3>
                        <p class="text-gray-500 text-sm">+977-1-4000000</p>
                        <p class="text-xs text-gray-400 mt-1">Mon – Fri, 9:00 AM – 5:00 PM</p>
                    </div>
                    <div class="bg-white rounded-2xl p-6 shadow-sm border border-gray-100">
                        <div class="w-12 h-12 bg-blue-50 rounded-xl flex items-center justify-center mb-4">
                            <i class="fas fa-envelope text-blue-600 text-xl"></i>
                        </div>
                        <h3 class="font-bold text-gray-900 mb-1">Email Support</h3>
                        <p class="text-gray-500 text-sm">support@docconnect.com.np</p>
                        <p class="text-gray-500 text-sm">info@docconnect.com.np</p>
                    </div>
                    <div class="bg-white rounded-2xl p-6 shadow-sm border border-gray-100">
                        <div class="w-12 h-12 bg-purple-50 rounded-xl flex items-center justify-center mb-4">
                            <i class="fas fa-clock text-purple-600 text-xl"></i>
                        </div>
                        <h3 class="font-bold text-gray-900 mb-1">Support Hours</h3>
                        <div class="text-sm text-gray-500 space-y-1">
                            <div class="flex justify-between"><span>Monday – Friday</span><span class="font-medium text-gray-700">9 AM – 6 PM</span></div>
                            <div class="flex justify-between"><span>Saturday</span><span class="font-medium text-gray-700">10 AM – 4 PM</span></div>
                            <div class="flex justify-between"><span>Sunday</span><span class="font-medium text-red-500">Closed</span></div>
                        </div>
                    </div>
                </div>

                <!-- Inquiry Form -->
                <div class="lg:col-span-2 bg-white rounded-2xl shadow-sm border border-gray-100 p-8">
                    <h2 class="text-2xl font-black text-gray-900 mb-2">Send Us a Message</h2>
                    <p class="text-gray-500 text-sm mb-8">Fill in the form below and we'll respond as soon as possible.</p>

                    <form method="post" action="${pageContext.request.contextPath}/contact" class="space-y-5">
                        <input type="hidden" name="csrfToken" value="${csrfToken}">

                        <div class="grid grid-cols-1 sm:grid-cols-2 gap-5">
                            <div>
                                <label class="block text-sm font-semibold text-gray-700 mb-1.5">Full Name <span class="text-red-500">*</span></label>
                                <input type="text" name="name" required placeholder="Bhabin Dulal"
                                       value="${not empty param.name ? param.name : ''}"
                                       class="w-full px-4 py-2.5 border border-gray-200 rounded-xl text-sm focus:outline-none focus:ring-2 focus:ring-primary-500/20 focus:border-primary-500 transition-all">
                            </div>
                            <div>
                                <label class="block text-sm font-semibold text-gray-700 mb-1.5">Email Address <span class="text-red-500">*</span></label>
                                <input type="email" name="email" required placeholder="you@example.com"
                                       value="${not empty param.email ? param.email : ''}"
                                       class="w-full px-4 py-2.5 border border-gray-200 rounded-xl text-sm focus:outline-none focus:ring-2 focus:ring-primary-500/20 focus:border-primary-500 transition-all">
                            </div>
                        </div>

                        <div>
                            <label class="block text-sm font-semibold text-gray-700 mb-1.5">Subject</label>
                            <select name="subject" class="w-full px-4 py-2.5 border border-gray-200 rounded-xl text-sm focus:outline-none focus:ring-2 focus:ring-primary-500/20 focus:border-primary-500 transition-all text-gray-700">
                                <option value="General Inquiry">General Inquiry</option>
                                <option value="Appointment Issue">Appointment Issue</option>
                                <option value="Payment Problem">Payment Problem</option>
                                <option value="Doctor Information">Doctor Information</option>
                                <option value="Account Support">Account Support</option>
                                <option value="Technical Issue">Technical Issue</option>
                                <option value="Feedback">Feedback / Suggestion</option>
                            </select>
                        </div>

                        <div>
                            <label class="block text-sm font-semibold text-gray-700 mb-1.5">Message <span class="text-red-500">*</span></label>
                            <textarea name="message" required rows="6" placeholder="Describe your issue or inquiry in detail..."
                                      class="w-full px-4 py-2.5 border border-gray-200 rounded-xl text-sm focus:outline-none focus:ring-2 focus:ring-primary-500/20 focus:border-primary-500 transition-all resize-none">${not empty param.message ? param.message : ''}</textarea>
                        </div>

                        <div class="flex items-center justify-between pt-2">
                            <p class="text-xs text-gray-400"><span class="text-red-500">*</span> Required fields</p>
                            <button type="submit"
                                    class="px-8 py-2.5 bg-gradient-to-r from-primary-600 to-primary-700 text-white font-bold rounded-xl hover:from-primary-700 hover:to-primary-800 transition-all shadow-lg shadow-primary-500/25 flex items-center gap-2">
                                <i class="fas fa-paper-plane"></i> Send Message
                            </button>
                        </div>
                    </form>
                </div>
            </div>

            <!-- FAQ Section -->
            <div class="mt-16">
                <h2 class="text-3xl font-black text-gray-900 text-center mb-10">Frequently Asked <span class="gradient-text">Questions</span></h2>
                <div class="grid grid-cols-1 md:grid-cols-2 gap-5">
                    <div class="bg-white rounded-2xl p-6 shadow-sm border border-gray-100">
                        <h4 class="font-bold text-gray-900 mb-2 flex items-center gap-2"><i class="fas fa-question-circle text-primary-500"></i> How do I book an appointment?</h4>
                        <p class="text-gray-500 text-sm leading-relaxed">Browse doctors from the Doctors page, select a doctor, choose an available date and time slot, add any notes, and confirm your booking. Payment can be made via Khalti or at the clinic.</p>
                    </div>
                    <div class="bg-white rounded-2xl p-6 shadow-sm border border-gray-100">
                        <h4 class="font-bold text-gray-900 mb-2 flex items-center gap-2"><i class="fas fa-question-circle text-primary-500"></i> Can I cancel my appointment?</h4>
                        <p class="text-gray-500 text-sm leading-relaxed">Appointments with a Confirmed status can be managed from your dashboard. Contact support if you need to cancel a completed or rescheduled appointment.</p>
                    </div>
                    <div class="bg-white rounded-2xl p-6 shadow-sm border border-gray-100">
                        <h4 class="font-bold text-gray-900 mb-2 flex items-center gap-2"><i class="fas fa-question-circle text-primary-500"></i> What payment methods are accepted?</h4>
                        <p class="text-gray-500 text-sm leading-relaxed">We accept payments via Khalti digital wallet. Cash payments at the clinic are also supported — just select that option during booking.</p>
                    </div>
                    <div class="bg-white rounded-2xl p-6 shadow-sm border border-gray-100">
                        <h4 class="font-bold text-gray-900 mb-2 flex items-center gap-2"><i class="fas fa-question-circle text-primary-500"></i> How do I get my appointment receipt?</h4>
                        <p class="text-gray-500 text-sm leading-relaxed">Go to My Appointments, find the appointment, and click the Receipt or Export PDF button. The receipt includes your turn number, doctor details, and payment information.</p>
                    </div>
                    <div class="bg-white rounded-2xl p-6 shadow-sm border border-gray-100">
                        <h4 class="font-bold text-gray-900 mb-2 flex items-center gap-2"><i class="fas fa-question-circle text-primary-500"></i> I forgot my password. What should I do?</h4>
                        <p class="text-gray-500 text-sm leading-relaxed">Please contact support via this form with your registered email. Our team will assist you with account recovery within one business day.</p>
                    </div>
                    <div class="bg-white rounded-2xl p-6 shadow-sm border border-gray-100">
                        <h4 class="font-bold text-gray-900 mb-2 flex items-center gap-2"><i class="fas fa-question-circle text-primary-500"></i> How do I update my profile information?</h4>
                        <p class="text-gray-500 text-sm leading-relaxed">Log in and navigate to My Profile from the top navigation menu. You can update your name, phone number, address, and date of birth from there.</p>
                    </div>
                </div>
            </div>

        </div>
    </section>

</main>

<jsp:include page="/WEB-INF/views/common/footer.jsp" />
