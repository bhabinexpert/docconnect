<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<jsp:include page="/WEB-INF/views/common/header.jsp" />
<jsp:include page="/WEB-INF/views/common/navbar.jsp" />

<!-- Hero Section -->
<section class="hero-gradient relative overflow-hidden">
    <div class="absolute inset-0">
        <div class="absolute top-20 left-10 w-72 h-72 bg-white/10 rounded-full blur-3xl"></div>
        <div class="absolute bottom-10 right-10 w-96 h-96 bg-accent-400/10 rounded-full blur-3xl"></div>
    </div>
    <div class="relative max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-20 lg:py-28">
        <div class="max-w-3xl">
            <div class="inline-flex items-center px-4 py-1.5 bg-white/15 backdrop-blur-sm rounded-full text-white text-sm font-medium mb-6 slide-up">
                <span class="w-2 h-2 bg-accent-400 rounded-full mr-2 pulse-dot"></span>
                Trusted by 10,000+ patients across Nepal
            </div>
            <h1 class="text-4xl md:text-5xl lg:text-6xl font-extrabold text-white leading-tight mb-6 slide-up">
                Your Health,<br>
                <span class="text-accent-300">Our Priority</span>
            </h1>
            <p class="text-lg md:text-xl text-blue-100 mb-8 max-w-2xl leading-relaxed slide-up">
                Find the best doctors in Nepal and book your appointments instantly. Quality healthcare is now just a click away.
            </p>
            <div class="flex flex-col sm:flex-row gap-4 slide-up">
                <a href="${pageContext.request.contextPath}/doctors" class="inline-flex items-center justify-center px-8 py-4 bg-white text-primary-700 font-semibold rounded-xl hover:bg-gray-50 transition-all duration-300 shadow-xl shadow-black/10 text-lg" id="hero-find-doctors">
                    <i class="fas fa-search mr-2"></i>Find a Doctor
                </a>
                <a href="${pageContext.request.contextPath}/register" class="inline-flex items-center justify-center px-8 py-4 bg-white/15 backdrop-blur-sm text-white font-semibold rounded-xl hover:bg-white/25 transition-all duration-300 border border-white/25 text-lg" id="hero-register">
                    <i class="fas fa-user-plus mr-2"></i>Register Now
                </a>
            </div>
        </div>
    </div>
</section>

<!-- Stats Section -->
<section class="relative -mt-10 z-10 max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 mb-16">
    <div class="grid grid-cols-2 md:grid-cols-4 gap-4">
        <div class="glass rounded-2xl p-6 text-center card-hover shadow-lg">
            <div class="text-3xl font-bold text-primary-600 mb-1">50+</div>
            <div class="text-sm text-gray-500 font-medium">Expert Doctors</div>
        </div>
        <div class="glass rounded-2xl p-6 text-center card-hover shadow-lg">
            <div class="text-3xl font-bold text-accent-600 mb-1">10+</div>
            <div class="text-sm text-gray-500 font-medium">Specializations</div>
        </div>
        <div class="glass rounded-2xl p-6 text-center card-hover shadow-lg">
            <div class="text-3xl font-bold text-primary-600 mb-1">10K+</div>
            <div class="text-sm text-gray-500 font-medium">Happy Patients</div>
        </div>
        <div class="glass rounded-2xl p-6 text-center card-hover shadow-lg">
            <div class="text-3xl font-bold text-accent-600 mb-1">24/7</div>
            <div class="text-sm text-gray-500 font-medium">Online Booking</div>
        </div>
    </div>
</section>

<!-- Specializations Section -->
<section class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-16">
    <div class="text-center mb-12">
        <h2 class="text-3xl md:text-4xl font-bold text-gray-900 mb-4">Our <span class="gradient-text">Specializations</span></h2>
        <p class="text-gray-500 text-lg max-w-2xl mx-auto">Browse through our wide range of medical specializations to find the right doctor for you.</p>
    </div>
    <div class="grid grid-cols-2 md:grid-cols-3 lg:grid-cols-5 gap-4">
        <c:forEach var="spec" items="${specializations}">
            <a href="${pageContext.request.contextPath}/doctors?specialization=${spec.id}" class="bg-white rounded-2xl p-6 text-center card-hover shadow-sm border border-gray-100 group" id="spec-${spec.id}">
                <div class="w-14 h-14 bg-gradient-to-br from-primary-50 to-accent-50 rounded-2xl flex items-center justify-center mx-auto mb-3 group-hover:from-primary-100 group-hover:to-accent-100 transition-colors">
                    <i class="fas ${spec.iconClass} text-primary-600 text-xl"></i>
                </div>
                <h3 class="font-semibold text-gray-800 text-sm">${spec.name}</h3>
            </a>
        </c:forEach>
    </div>
</section>

<!-- Featured Doctors Section -->
<section class="bg-gradient-to-b from-gray-50 to-white max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-16">
    <div class="text-center mb-12">
        <h2 class="text-3xl md:text-4xl font-bold text-gray-900 mb-4">Meet Our <span class="gradient-text">Top Doctors</span></h2>
        <p class="text-gray-500 text-lg max-w-2xl mx-auto">Our experienced doctors are ready to provide you with the best healthcare services.</p>
    </div>
    <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
        <c:forEach var="doctor" items="${featuredDoctors}">
            <div class="bg-white rounded-2xl overflow-hidden card-hover shadow-sm border border-gray-100 fade-in" id="doctor-card-${doctor.id}">
                <div class="p-6">
                    <div class="flex items-start space-x-4">
                        <div class="w-16 h-16 bg-gradient-to-br from-primary-100 to-accent-100 rounded-2xl flex items-center justify-center flex-shrink-0">
                            <i class="fas fa-user-md text-primary-600 text-2xl"></i>
                        </div>
                        <div class="flex-1 min-w-0">
                            <h3 class="font-bold text-gray-900 text-lg">${doctor.fullName}</h3>
                            <p class="text-primary-600 font-medium text-sm">${doctor.specializationName}</p>
                            <p class="text-gray-500 text-sm mt-0.5">${doctor.qualification}</p>
                        </div>
                    </div>
                    <div class="mt-4 flex items-center justify-between text-sm">
                        <div class="flex items-center space-x-4">
                            <span class="text-gray-500"><i class="fas fa-briefcase mr-1 text-accent-500"></i>${doctor.experienceYears} yrs</span>
                            <span class="text-gray-500"><i class="fas fa-money-bill-wave mr-1 text-green-500"></i>Rs. ${doctor.consultationFee}</span>
                        </div>
                    </div>
                    <div class="mt-4 flex space-x-3">
                        <a href="${pageContext.request.contextPath}/doctor?id=${doctor.id}" class="flex-1 text-center py-2.5 rounded-xl border border-primary-200 text-primary-600 font-medium text-sm hover:bg-primary-50 transition-all">
                            View Profile
                        </a>
                        <a href="${pageContext.request.contextPath}/patient/book?doctorId=${doctor.id}" class="flex-1 text-center py-2.5 rounded-xl bg-primary-600 text-white font-medium text-sm hover:bg-primary-700 transition-all shadow-lg shadow-primary-500/25">
                            Book Now
                        </a>
                    </div>
                </div>
            </div>
        </c:forEach>
    </div>
    <div class="text-center mt-10">
        <a href="${pageContext.request.contextPath}/doctors" class="inline-flex items-center px-8 py-3.5 bg-white rounded-xl text-primary-600 font-semibold border-2 border-primary-200 hover:bg-primary-50 hover:border-primary-300 transition-all duration-300" id="home-view-all-doctors">
            View All Doctors <i class="fas fa-arrow-right ml-2"></i>
        </a>
    </div>
</section>

<!-- How It Works Section -->
<section class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-16">
    <div class="text-center mb-12">
        <h2 class="text-3xl md:text-4xl font-bold text-gray-900 mb-4">How It <span class="gradient-text">Works</span></h2>
        <p class="text-gray-500 text-lg">Book your appointment in just 3 simple steps</p>
    </div>
    <div class="grid grid-cols-1 md:grid-cols-3 gap-8">
        <div class="text-center fade-in">
            <div class="w-20 h-20 bg-gradient-to-br from-primary-500 to-primary-600 rounded-3xl flex items-center justify-center mx-auto mb-6 shadow-xl shadow-primary-500/25">
                <i class="fas fa-search text-white text-2xl"></i>
            </div>
            <h3 class="text-xl font-bold text-gray-900 mb-2">1. Search Doctor</h3>
            <p class="text-gray-500">Browse our network of qualified doctors by specialization, name, or location.</p>
        </div>
        <div class="text-center fade-in">
            <div class="w-20 h-20 bg-gradient-to-br from-accent-500 to-accent-600 rounded-3xl flex items-center justify-center mx-auto mb-6 shadow-xl shadow-accent-500/25">
                <i class="fas fa-calendar-check text-white text-2xl"></i>
            </div>
            <h3 class="text-xl font-bold text-gray-900 mb-2">2. Book Appointment</h3>
            <p class="text-gray-500">Select a convenient time slot and book your appointment online instantly.</p>
        </div>
        <div class="text-center fade-in">
            <div class="w-20 h-20 bg-gradient-to-br from-primary-500 to-accent-500 rounded-3xl flex items-center justify-center mx-auto mb-6 shadow-xl shadow-primary-500/25">
                <i class="fas fa-check-circle text-white text-2xl"></i>
            </div>
            <h3 class="text-xl font-bold text-gray-900 mb-2">3. Get Confirmed</h3>
            <p class="text-gray-500">Complete payment via Khalti or eSewa and receive instant confirmation.</p>
        </div>
    </div>
</section>

<jsp:include page="/WEB-INF/views/common/footer.jsp" />
