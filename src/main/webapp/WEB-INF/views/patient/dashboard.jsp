<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<jsp:include page="/WEB-INF/views/common/header.jsp" />
<jsp:include page="/WEB-INF/views/common/navbar.jsp" />

<main class="flex-1 bg-gray-50">
    <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-8">
        <!-- Welcome -->
        <div class="mb-8 slide-up">
            <h1 class="text-3xl font-bold text-gray-900">Welcome, <span class="gradient-text">${sessionScope.userName}</span></h1>
            <p class="text-gray-500 mt-1">Here's an overview of your appointments</p>
        </div>

        <!-- Stats Cards -->
        <div class="grid grid-cols-2 lg:grid-cols-4 gap-4 mb-8">
            <div class="bg-white rounded-2xl p-6 shadow-sm border border-gray-100 card-hover">
                <div class="flex items-center justify-between">
                    <div>
                        <p class="text-sm text-gray-500 font-medium">Total</p>
                        <p class="text-3xl font-bold text-gray-900 mt-1">${totalCount}</p>
                    </div>
                    <div class="w-12 h-12 bg-primary-50 rounded-2xl flex items-center justify-center">
                        <i class="fas fa-calendar text-primary-600 text-xl"></i>
                    </div>
                </div>
            </div>
            <div class="bg-white rounded-2xl p-6 shadow-sm border border-gray-100 card-hover">
                <div class="flex items-center justify-between">
                    <div>
                        <p class="text-sm text-gray-500 font-medium">Upcoming</p>
                        <p class="text-3xl font-bold text-blue-600 mt-1">${upcomingCount}</p>
                    </div>
                    <div class="w-12 h-12 bg-blue-50 rounded-2xl flex items-center justify-center">
                        <i class="fas fa-clock text-blue-600 text-xl"></i>
                    </div>
                </div>
            </div>
            <div class="bg-white rounded-2xl p-6 shadow-sm border border-gray-100 card-hover">
                <div class="flex items-center justify-between">
                    <div>
                        <p class="text-sm text-gray-500 font-medium">Completed</p>
                        <p class="text-3xl font-bold text-green-600 mt-1">${completedCount}</p>
                    </div>
                    <div class="w-12 h-12 bg-green-50 rounded-2xl flex items-center justify-center">
                        <i class="fas fa-check-circle text-green-600 text-xl"></i>
                    </div>
                </div>
            </div>
            <div class="bg-white rounded-2xl p-6 shadow-sm border border-gray-100 card-hover">
                <div class="flex items-center justify-between">
                    <div>
                        <p class="text-sm text-gray-500 font-medium">Cancelled</p>
                        <p class="text-3xl font-bold text-red-600 mt-1">${cancelledCount}</p>
                    </div>
                    <div class="w-12 h-12 bg-red-50 rounded-2xl flex items-center justify-center">
                        <i class="fas fa-times-circle text-red-600 text-xl"></i>
                    </div>
                </div>
            </div>
        </div>

        <!-- Quick Actions -->
        <div class="grid grid-cols-1 md:grid-cols-3 gap-4 mb-8">
            <a href="${pageContext.request.contextPath}/doctors" class="bg-gradient-to-r from-primary-600 to-primary-700 text-white rounded-2xl p-6 card-hover shadow-lg shadow-primary-500/20 group" id="quick-find-doctor">
                <div class="flex items-center space-x-4">
                    <div class="w-12 h-12 bg-white/20 rounded-2xl flex items-center justify-center group-hover:bg-white/30 transition-colors">
                        <i class="fas fa-search text-xl"></i>
                    </div>
                    <div>
                        <h3 class="font-bold text-lg">Find a Doctor</h3>
                        <p class="text-blue-100 text-sm">Browse and search doctors</p>
                    </div>
                </div>
            </a>
            <a href="${pageContext.request.contextPath}/patient/appointments" class="bg-gradient-to-r from-accent-600 to-accent-700 text-white rounded-2xl p-6 card-hover shadow-lg shadow-accent-500/20 group" id="quick-appointments">
                <div class="flex items-center space-x-4">
                    <div class="w-12 h-12 bg-white/20 rounded-2xl flex items-center justify-center group-hover:bg-white/30 transition-colors">
                        <i class="fas fa-calendar-check text-xl"></i>
                    </div>
                    <div>
                        <h3 class="font-bold text-lg">My Appointments</h3>
                        <p class="text-teal-100 text-sm">View all bookings</p>
                    </div>
                </div>
            </a>
            <a href="${pageContext.request.contextPath}/patient/profile" class="bg-gradient-to-r from-gray-700 to-gray-800 text-white rounded-2xl p-6 card-hover shadow-lg shadow-gray-500/20 group" id="quick-profile">
                <div class="flex items-center space-x-4">
                    <div class="w-12 h-12 bg-white/20 rounded-2xl flex items-center justify-center group-hover:bg-white/30 transition-colors">
                        <i class="fas fa-user-cog text-xl"></i>
                    </div>
                    <div>
                        <h3 class="font-bold text-lg">My Profile</h3>
                        <p class="text-gray-300 text-sm">Manage your account</p>
                    </div>
                </div>
            </a>
        </div>

        <!-- Recent Appointments -->
        <div class="bg-white rounded-2xl shadow-sm border border-gray-100 overflow-hidden">
            <div class="px-6 py-4 border-b border-gray-100 flex justify-between items-center">
                <h2 class="text-lg font-bold text-gray-900">Recent Appointments</h2>
                <a href="${pageContext.request.contextPath}/patient/appointments" class="text-primary-600 text-sm font-medium hover:text-primary-700">View All <i class="fas fa-arrow-right ml-1"></i></a>
            </div>
            <c:choose>
                <c:when test="${empty appointments}">
                    <div class="p-12 text-center">
                        <div class="w-16 h-16 bg-gray-100 rounded-2xl flex items-center justify-center mx-auto mb-4">
                            <i class="fas fa-calendar-times text-gray-400 text-2xl"></i>
                        </div>
                        <p class="text-gray-500 mb-4">You haven't made any appointments yet.</p>
                        <a href="${pageContext.request.contextPath}/doctors" class="inline-flex items-center px-6 py-2.5 bg-primary-600 text-white rounded-xl font-medium hover:bg-primary-700 transition-all">
                            <i class="fas fa-search mr-2"></i>Find a Doctor
                        </a>
                    </div>
                </c:when>
                <c:otherwise>
                    <div class="overflow-x-auto">
                        <table class="w-full" id="dashboard-appointments-table">
                            <thead class="bg-gray-50">
                            <tr>
                                <th class="px-6 py-3 text-left text-xs font-semibold text-gray-500 uppercase">Doctor</th>
                                <th class="px-6 py-3 text-left text-xs font-semibold text-gray-500 uppercase">Date</th>
                                <th class="px-6 py-3 text-left text-xs font-semibold text-gray-500 uppercase">Time</th>
                                <th class="px-6 py-3 text-left text-xs font-semibold text-gray-500 uppercase">Status</th>
                                <th class="px-6 py-3 text-left text-xs font-semibold text-gray-500 uppercase">Payment</th>
                            </tr>
                            </thead>
                            <tbody class="divide-y divide-gray-100">
                            <c:forEach var="apt" items="${appointments}" begin="0" end="4">
                                <tr class="hover:bg-gray-50 transition-colors">
                                    <td class="px-6 py-4">
                                        <div class="font-medium text-gray-900">${apt.doctorName}</div>
                                        <div class="text-xs text-gray-500">${apt.specializationName}</div>
                                    </td>
                                    <td class="px-6 py-4 text-sm text-gray-600">${apt.appointmentDate}</td>
                                    <td class="px-6 py-4 text-sm text-gray-600">${apt.slotTime}</td>
                                    <td class="px-6 py-4">
                                        <span class="inline-flex items-center gap-1 px-3 py-1 rounded-full text-xs font-semibold ${apt.status == 'confirmed' ? 'bg-blue-100 text-blue-700' : apt.status == 'completed' ? 'bg-green-100 text-green-700' : apt.status == 'rescheduled' ? 'bg-orange-100 text-orange-700' : apt.status == 'cancelled' ? 'bg-red-100 text-red-700' : 'bg-gray-100 text-gray-600'}"><i class="fas ${apt.status == 'confirmed' ? 'fa-check-circle' : apt.status == 'completed' ? 'fa-check-double' : apt.status == 'rescheduled' ? 'fa-calendar-alt' : apt.status == 'cancelled' ? 'fa-times-circle' : 'fa-clock'}"></i>${apt.status == 'confirmed' ? 'Confirmed' : apt.status == 'completed' ? 'Completed' : apt.status == 'rescheduled' ? 'Rescheduled' : apt.status == 'cancelled' ? 'Cancelled' : apt.status}</span>
                                    </td>
                                    <td class="px-6 py-4">
                                        <span class="inline-flex items-center gap-1 px-3 py-1 rounded-full text-xs font-semibold ${apt.paymentStatus == 'completed' ? 'bg-green-100 text-green-700' : apt.paymentStatus == 'pending' ? 'bg-yellow-100 text-yellow-700' : apt.paymentStatus == 'failed' ? 'bg-red-100 text-red-700' : 'bg-gray-100 text-gray-600'}"><i class="fas ${apt.paymentStatus == 'completed' ? 'fa-check-circle' : apt.paymentStatus == 'pending' ? 'fa-clock' : apt.paymentStatus == 'failed' ? 'fa-times-circle' : 'fa-minus-circle'}"></i>${apt.paymentStatus == 'completed' ? 'Paid' : apt.paymentStatus == 'pending' ? 'Awaiting Payment' : apt.paymentStatus == 'failed' ? 'Failed' : 'Unpaid'}</span>
                                    </td>
                                </tr>
                            </c:forEach>
                            </tbody>
                        </table>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>
    </div>
</main>

<jsp:include page="/WEB-INF/views/common/footer.jsp" />
