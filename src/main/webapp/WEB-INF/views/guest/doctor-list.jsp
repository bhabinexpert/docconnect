<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<jsp:include page="/WEB-INF/views/common/header.jsp" />
<jsp:include page="/WEB-INF/views/common/navbar.jsp" />

<main class="flex-1">
    <!-- Page Header -->
    <div class="bg-gradient-to-r from-primary-600 to-accent-600 py-12">
        <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
            <h1 class="text-3xl font-bold text-white mb-2">Find a Doctor</h1>
            <p class="text-blue-100">Search and filter through our network of qualified doctors</p>
        </div>
    </div>

    <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-8">
        <!-- Search & Filter -->
        <div class="bg-white rounded-2xl shadow-sm border border-gray-100 p-6 mb-8 -mt-6 relative z-10">
            <form method="get" action="${pageContext.request.contextPath}/doctors" class="flex flex-col md:flex-row gap-4" id="doctorSearchForm">
                <div class="flex-1 relative">
                    <div class="absolute inset-y-0 left-0 pl-4 flex items-center pointer-events-none"><i class="fas fa-search text-gray-400"></i></div>
                    <input type="text" name="keyword" value="${keyword}" placeholder="Search by name, specialization..."
                           class="w-full pl-11 pr-4 py-3 border border-gray-200 rounded-xl focus:ring-2 focus:ring-primary-500 focus:border-primary-500 transition-all" id="searchKeyword">
                </div>
                <div class="w-full md:w-64">
                    <select name="specialization" class="w-full px-4 py-3 border border-gray-200 rounded-xl focus:ring-2 focus:ring-primary-500 focus:border-primary-500 transition-all" id="searchSpecialization">
                        <option value="">All Specializations</option>
                        <c:forEach var="spec" items="${specializations}">
                            <option value="${spec.id}" ${selectedSpecialization == spec.id ? 'selected' : ''}>${spec.name}</option>
                        </c:forEach>
                    </select>
                </div>
                <div class="w-full md:w-48">
                    <select name="sortBy" class="w-full px-4 py-3 border border-gray-200 rounded-xl focus:ring-2 focus:ring-primary-500 focus:border-primary-500 transition-all" onchange="this.form.submit()">
                        <option value="">Sort By</option>
                        <option value="experience" ${sortBy == 'experience' ? 'selected' : ''}>Experience</option>
                        <option value="fee_low" ${sortBy == 'fee_low' ? 'selected' : ''}>Fee: Low to High</option>
                        <option value="fee_high" ${sortBy == 'fee_high' ? 'selected' : ''}>Fee: High to Low</option>
                        <option value="name" ${sortBy == 'name' ? 'selected' : ''}>Name</option>
                    </select>
                </div>
                <button type="submit" class="px-8 py-3 bg-primary-600 text-white font-semibold rounded-xl hover:bg-primary-700 transition-all shadow-lg shadow-primary-500/25" id="searchBtn">
                    <i class="fas fa-search mr-2"></i>Search
                </button>
            </form>
        </div>

        <!-- Results count -->
        <div class="mb-6 flex items-center justify-between">
            <p class="text-gray-500">
                <span class="font-semibold text-gray-900">${doctors.size()}</span> doctor(s) found
                <c:if test="${keyword != null && !keyword.isEmpty()}"> for "<span class="text-primary-600 font-medium">${keyword}</span>"</c:if>
            </p>
        </div>

        <!-- Doctor Grid -->
        <c:choose>
            <c:when test="${empty doctors}">
                <div class="text-center py-16">
                    <div class="w-20 h-20 bg-gray-100 rounded-3xl flex items-center justify-center mx-auto mb-4">
                        <i class="fas fa-user-md text-gray-400 text-3xl"></i>
                    </div>
                    <h3 class="text-xl font-bold text-gray-700 mb-2">No Doctors Found</h3>
                    <p class="text-gray-500">Try adjusting your search criteria or browse all doctors.</p>
                    <a href="${pageContext.request.contextPath}/doctors" class="mt-4 inline-block px-6 py-2 bg-primary-600 text-white rounded-xl font-medium hover:bg-primary-700 transition-all">View All</a>
                </div>
            </c:when>
            <c:otherwise>
                <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
                    <c:forEach var="doctor" items="${doctors}">
                        <div class="bg-white rounded-2xl overflow-hidden card-hover shadow-sm border border-gray-100 fade-in" id="list-doctor-${doctor.id}">
                            <div class="p-6">
                                <div class="flex items-start space-x-4">
                                    <div class="w-16 h-16 bg-gradient-to-br from-primary-100 to-accent-100 rounded-2xl flex items-center justify-center flex-shrink-0">
                                        <i class="fas fa-user-md text-primary-600 text-2xl"></i>
                                    </div>
                                    <div class="flex-1 min-w-0">
                                        <h3 class="font-bold text-gray-900 text-lg">${doctor.fullName}</h3>
                                        <p class="text-primary-600 font-medium text-sm">${doctor.specializationName}</p>
                                        <p class="text-gray-500 text-sm">${doctor.qualification}</p>
                                    </div>
                                </div>
                                <div class="mt-4 grid grid-cols-2 gap-3 text-sm">
                                    <div class="bg-gray-50 rounded-xl p-3 text-center">
                                        <div class="font-bold text-primary-600">${doctor.experienceYears} yrs</div>
                                        <div class="text-gray-500 text-xs">Experience</div>
                                    </div>
                                    <div class="bg-gray-50 rounded-xl p-3 text-center">
                                        <div class="font-bold text-accent-600">Rs. ${doctor.consultationFee}</div>
                                        <div class="text-gray-500 text-xs">Fee</div>
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
            </c:otherwise>
        </c:choose>
    </div>
</main>

<jsp:include page="/WEB-INF/views/common/footer.jsp" />
