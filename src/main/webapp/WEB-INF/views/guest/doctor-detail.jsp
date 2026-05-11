<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<jsp:include page="/WEB-INF/views/common/header.jsp" />
<jsp:include page="/WEB-INF/views/common/navbar.jsp" />

<main class="flex-1">
    <div class="max-w-4xl mx-auto px-4 sm:px-6 lg:px-8 py-10">
        <!-- Back button -->
        <a href="${pageContext.request.contextPath}/doctors" class="inline-flex items-center text-primary-600 hover:text-primary-700 font-medium mb-6 transition-colors">
            <i class="fas fa-arrow-left mr-2"></i>Back to Doctors
        </a>

        <!-- Doctor Profile Card -->
        <div class="bg-white rounded-2xl shadow-lg border border-gray-100 overflow-hidden fade-in">
            <div class="bg-gradient-to-r from-primary-600 to-accent-600 p-8">
                <div class="flex flex-col md:flex-row items-start md:items-center space-y-4 md:space-y-0 md:space-x-6">
                    <div class="w-24 h-24 bg-white/20 backdrop-blur-sm rounded-2xl flex items-center justify-center">
                        <i class="fas fa-user-md text-white text-4xl"></i>
                    </div>
                    <div class="text-white">
                        <h1 class="text-3xl font-bold">${doctor.fullName}</h1>
                        <p class="text-blue-100 text-lg mt-1">${doctor.specializationName}</p>
                        <p class="text-blue-200 text-sm mt-1">${doctor.qualification}</p>
                    </div>
                </div>
            </div>

            <div class="p-8">
                <!-- Info Grid -->
                <div class="grid grid-cols-2 md:grid-cols-4 gap-4 mb-8">
                    <div class="bg-primary-50 rounded-xl p-4 text-center">
                        <div class="text-2xl font-bold text-primary-600">${doctor.experienceYears}</div>
                        <div class="text-sm text-gray-500">Years Exp.</div>
                    </div>
                    <div class="bg-accent-50 rounded-xl p-4 text-center">
                        <div class="text-2xl font-bold text-accent-600">Rs. ${doctor.consultationFee}</div>
                        <div class="text-sm text-gray-500">Consultation Fee</div>
                    </div>
                    <div class="bg-blue-50 rounded-xl p-4 text-center">
                        <div class="text-2xl font-bold text-blue-600">${doctor.gender != null ? doctor.gender : 'N/A'}</div>
                        <div class="text-sm text-gray-500">Gender</div>
                    </div>
                    <div class="bg-green-50 rounded-xl p-4 text-center">
                        <div class="text-2xl font-bold text-green-600"><i class="fas fa-check-circle"></i></div>
                        <div class="text-sm text-gray-500">Available</div>
                    </div>
                </div>

                <!-- Bio -->
                <c:if test="${doctor.bio != null && !doctor.bio.isEmpty()}">
                    <div class="mb-8">
                        <h2 class="text-xl font-bold text-gray-900 mb-3">About</h2>
                        <p class="text-gray-600 leading-relaxed">${doctor.bio}</p>
                    </div>
                </c:if>

                <!-- Contact Info -->
                <div class="mb-8">
                    <h2 class="text-xl font-bold text-gray-900 mb-3">Contact Information</h2>
                    <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
                        <c:if test="${doctor.email != null}">
                            <div class="flex items-center space-x-3 text-gray-600">
                                <div class="w-10 h-10 bg-primary-50 rounded-xl flex items-center justify-center">
                                    <i class="fas fa-envelope text-primary-600"></i>
                                </div>
                                <span>${doctor.email}</span>
                            </div>
                        </c:if>
                        <c:if test="${doctor.phone != null}">
                            <div class="flex items-center space-x-3 text-gray-600">
                                <div class="w-10 h-10 bg-accent-50 rounded-xl flex items-center justify-center">
                                    <i class="fas fa-phone text-accent-600"></i>
                                </div>
                                <span>${doctor.phone}</span>
                            </div>
                        </c:if>
                    </div>
                </div>

                <!-- Availability -->
                <div class="mb-8">
                    <h2 class="text-xl font-bold text-gray-900 mb-3">Weekly Schedule</h2>
                    <c:choose>
                        <c:when test="${empty slots}">
                            <p class="text-gray-500">No slots available currently.</p>
                        </c:when>
                        <c:otherwise>
                            <div class="grid grid-cols-1 md:grid-cols-2 gap-3">
                                <c:forEach var="slot" items="${slots}">
                                    <div class="flex items-center justify-between bg-gray-50 rounded-xl p-4 border border-gray-100">
                                        <div class="flex items-center space-x-3">
                                            <div class="w-10 h-10 bg-primary-100 rounded-xl flex items-center justify-center">
                                                <i class="fas fa-calendar-day text-primary-600 text-sm"></i>
                                            </div>
                                            <div>
                                                <div class="font-semibold text-gray-800 text-sm">
                                                    <c:choose>
                                                        <c:when test="${slot.specificDate != null}">
                                                            <i class="fas fa-calendar-star text-primary-600 mr-1"></i> Special Date: ${slot.specificDate}
                                                        </c:when>
                                                        <c:otherwise>${slot.dayOfWeek}</c:otherwise>
                                                    </c:choose>
                                                </div>
                                                <div class="text-gray-500 text-xs">${slot.formattedTimeRange}</div>
                                            </div>
                                        </div>
                                        <span class="px-3 py-1 bg-green-100 text-green-700 text-xs font-medium rounded-full">Available</span>
                                    </div>
                                </c:forEach>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>

                <!-- Book Button -->
                <div class="flex flex-col sm:flex-row gap-4">
                    <a href="${pageContext.request.contextPath}/patient/book?doctorId=${doctor.id}" class="flex-1 text-center py-4 bg-gradient-to-r from-primary-600 to-primary-700 text-white font-semibold rounded-xl hover:from-primary-700 hover:to-primary-800 transition-all shadow-lg shadow-primary-500/25 text-lg" id="detail-book-btn">
                        <i class="fas fa-calendar-plus mr-2"></i>Book Appointment
                    </a>
                    <a href="${pageContext.request.contextPath}/doctors" class="flex-1 text-center py-4 border-2 border-gray-200 text-gray-700 font-semibold rounded-xl hover:bg-gray-50 transition-all text-lg">
                        <i class="fas fa-list mr-2"></i>View Other Doctors
                    </a>
                </div>
            </div>
        </div>
    </div>
</main>

<jsp:include page="/WEB-INF/views/common/footer.jsp" />
