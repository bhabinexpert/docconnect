<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<jsp:include page="/WEB-INF/views/common/header.jsp" />
<jsp:include page="/WEB-INF/views/common/navbar.jsp" />

<main class="flex-1 bg-gray-50">

    <!-- Hero -->
    <section class="bg-gradient-to-br from-primary-700 via-primary-600 to-accent-600 text-white py-20">
        <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 text-center">
            <div class="inline-flex items-center justify-center w-16 h-16 bg-white/20 rounded-2xl mb-6">
                <i class="fas fa-hospital-alt text-3xl"></i>
            </div>
            <h1 class="text-4xl md:text-5xl font-black mb-4">About <span class="text-accent-200">DocConnect Nepal</span></h1>
            <p class="text-lg text-blue-100 max-w-2xl mx-auto leading-relaxed">
                Bridging patients and healthcare professionals through a seamless, trusted digital platform — built for Nepal, built for you.
            </p>
        </div>
    </section>

    <!-- Mission & Vision -->
    <section class="py-16">
        <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
            <div class="grid grid-cols-1 md:grid-cols-2 gap-8 mb-16">
                <div class="bg-white rounded-2xl p-8 shadow-sm border border-gray-100">
                    <div class="w-12 h-12 bg-primary-50 rounded-xl flex items-center justify-center mb-5">
                        <i class="fas fa-bullseye text-primary-600 text-xl"></i>
                    </div>
                    <h2 class="text-2xl font-black text-gray-900 mb-3">Our Mission</h2>
                    <p class="text-gray-600 leading-relaxed">
                        To make quality healthcare accessible to every Nepali citizen by providing a reliable platform
                        where patients can discover qualified doctors, book appointments online, and manage their health
                        journey with ease — eliminating long queues and unnecessary wait times.
                    </p>
                </div>
                <div class="bg-white rounded-2xl p-8 shadow-sm border border-gray-100">
                    <div class="w-12 h-12 bg-accent-50 rounded-xl flex items-center justify-center mb-5">
                        <i class="fas fa-eye text-accent-600 text-xl"></i>
                    </div>
                    <h2 class="text-2xl font-black text-gray-900 mb-3">Our Vision</h2>
                    <p class="text-gray-600 leading-relaxed">
                        To become Nepal's most trusted healthcare appointment platform — connecting every hospital,
                        clinic, and specialist with patients across the country through transparent, technology-driven
                        healthcare solutions that put patient wellbeing first.
                    </p>
                </div>
            </div>

            <!-- Stats -->
            <div class="grid grid-cols-2 md:grid-cols-4 gap-6 mb-16">
                <div class="bg-white rounded-2xl p-6 shadow-sm border border-gray-100 text-center">
                    <p class="text-4xl font-black text-primary-600 mb-1">50+</p>
                    <p class="text-sm text-gray-500 font-medium">Verified Doctors</p>
                </div>
                <div class="bg-white rounded-2xl p-6 shadow-sm border border-gray-100 text-center">
                    <p class="text-4xl font-black text-accent-600 mb-1">10+</p>
                    <p class="text-sm text-gray-500 font-medium">Specializations</p>
                </div>
                <div class="bg-white rounded-2xl p-6 shadow-sm border border-gray-100 text-center">
                    <p class="text-4xl font-black text-green-600 mb-1">500+</p>
                    <p class="text-sm text-gray-500 font-medium">Appointments Booked</p>
                </div>
                <div class="bg-white rounded-2xl p-6 shadow-sm border border-gray-100 text-center">
                    <p class="text-4xl font-black text-purple-600 mb-1">24/7</p>
                    <p class="text-sm text-gray-500 font-medium">Online Booking</p>
                </div>
            </div>

            <!-- What We Offer -->
            <div class="mb-16">
                <h2 class="text-3xl font-black text-gray-900 text-center mb-10">What We <span class="gradient-text">Offer</span></h2>
                <div class="grid grid-cols-1 md:grid-cols-3 gap-6">
                    <div class="bg-white rounded-2xl p-6 shadow-sm border border-gray-100 group hover:shadow-md transition-all">
                        <div class="w-12 h-12 bg-blue-50 rounded-xl flex items-center justify-center mb-4 group-hover:bg-blue-100 transition-colors">
                            <i class="fas fa-search text-blue-600 text-xl"></i>
                        </div>
                        <h3 class="text-lg font-bold text-gray-900 mb-2">Find Doctors</h3>
                        <p class="text-gray-500 text-sm leading-relaxed">Search and filter doctors by specialization, name, or availability. View profiles, qualifications, and consultation fees before booking.</p>
                    </div>
                    <div class="bg-white rounded-2xl p-6 shadow-sm border border-gray-100 group hover:shadow-md transition-all">
                        <div class="w-12 h-12 bg-green-50 rounded-xl flex items-center justify-center mb-4 group-hover:bg-green-100 transition-colors">
                            <i class="fas fa-calendar-check text-green-600 text-xl"></i>
                        </div>
                        <h3 class="text-lg font-bold text-gray-900 mb-2">Easy Booking</h3>
                        <p class="text-gray-500 text-sm leading-relaxed">Book appointments in just a few clicks. Choose your preferred date and time slot, add notes for your doctor, and confirm instantly.</p>
                    </div>
                    <div class="bg-white rounded-2xl p-6 shadow-sm border border-gray-100 group hover:shadow-md transition-all">
                        <div class="w-12 h-12 bg-purple-50 rounded-xl flex items-center justify-center mb-4 group-hover:bg-purple-100 transition-colors">
                            <i class="fas fa-mobile-alt text-purple-600 text-xl"></i>
                        </div>
                        <h3 class="text-lg font-bold text-gray-900 mb-2">Digital Receipts</h3>
                        <p class="text-gray-500 text-sm leading-relaxed">Get printable appointment receipts with your turn number, doctor details, and payment summary — accessible anytime from your dashboard.</p>
                    </div>
                    <div class="bg-white rounded-2xl p-6 shadow-sm border border-gray-100 group hover:shadow-md transition-all">
                        <div class="w-12 h-12 bg-orange-50 rounded-xl flex items-center justify-center mb-4 group-hover:bg-orange-100 transition-colors">
                            <i class="fas fa-shield-alt text-orange-600 text-xl"></i>
                        </div>
                        <h3 class="text-lg font-bold text-gray-900 mb-2">Secure Payments</h3>
                        <p class="text-gray-500 text-sm leading-relaxed">Pay consultation fees securely via Khalti — Nepal's trusted digital wallet — or at the clinic. Every transaction is recorded and verifiable.</p>
                    </div>
                    <div class="bg-white rounded-2xl p-6 shadow-sm border border-gray-100 group hover:shadow-md transition-all">
                        <div class="w-12 h-12 bg-teal-50 rounded-xl flex items-center justify-center mb-4 group-hover:bg-teal-100 transition-colors">
                            <i class="fas fa-history text-teal-600 text-xl"></i>
                        </div>
                        <h3 class="text-lg font-bold text-gray-900 mb-2">Appointment History</h3>
                        <p class="text-gray-500 text-sm leading-relaxed">Keep track of all past and upcoming appointments from your personal dashboard. Export your appointment records as PDF at any time.</p>
                    </div>
                    <div class="bg-white rounded-2xl p-6 shadow-sm border border-gray-100 group hover:shadow-md transition-all">
                        <div class="w-12 h-12 bg-red-50 rounded-xl flex items-center justify-center mb-4 group-hover:bg-red-100 transition-colors">
                            <i class="fas fa-user-md text-red-600 text-xl"></i>
                        </div>
                        <h3 class="text-lg font-bold text-gray-900 mb-2">Verified Specialists</h3>
                        <p class="text-gray-500 text-sm leading-relaxed">Every doctor on our platform is verified by our admin team with credentials, NMC registration, and specialization details confirmed before listing.</p>
                    </div>
                </div>
            </div>

            <!-- Team / Institution -->
            <div class="bg-gradient-to-r from-primary-600 to-accent-600 rounded-2xl p-10 text-white text-center">
                <h2 class="text-3xl font-black mb-4">Built for Nepal's Healthcare Future</h2>
                <p class="text-blue-100 max-w-2xl mx-auto leading-relaxed mb-6">
                    DocConnect Nepal is developed as a university coursework project with a mission to demonstrate how
                    technology can transform healthcare access in Nepal. Our platform simulates a real-world hospital
                    appointment management system with secure payments, role-based access, and full appointment lifecycle management.
                </p>
                <div class="flex flex-wrap justify-center gap-4">
                    <a href="${pageContext.request.contextPath}/doctors" class="px-6 py-2.5 bg-white text-primary-600 font-bold rounded-xl hover:bg-blue-50 transition-all">
                        <i class="fas fa-search mr-2"></i>Browse Doctors
                    </a>
                    <a href="${pageContext.request.contextPath}/contact" class="px-6 py-2.5 bg-white/20 text-white font-bold rounded-xl hover:bg-white/30 transition-all border border-white/30">
                        <i class="fas fa-envelope mr-2"></i>Contact Us
                    </a>
                </div>
            </div>
        </div>
    </section>

</main>

<jsp:include page="/WEB-INF/views/common/footer.jsp" />
