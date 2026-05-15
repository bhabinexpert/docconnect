<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<jsp:include page="/WEB-INF/views/common/header.jsp" />
<jsp:include page="/WEB-INF/views/common/navbar.jsp" />

<main class="flex-1 bg-gray-50">
    <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-8">
        <div class="mb-8 slide-up">
            <h1 class="text-3xl font-bold text-gray-900">Admin <span class="gradient-text">Dashboard</span></h1>
            <p class="text-gray-500 mt-1">Overview of your healthcare platform</p>
        </div>

        <!-- Stats -->
        <div class="grid grid-cols-2 lg:grid-cols-5 gap-4 mb-8">
            <div class="bg-white rounded-2xl p-6 shadow-sm border border-gray-100 card-hover">
                <div class="flex items-center justify-between mb-3">
                    <div class="w-10 h-10 bg-primary-50 rounded-xl flex items-center justify-center"><i class="fas fa-users text-primary-600"></i></div>
                </div>
                <p class="text-2xl font-bold text-gray-900">${totalPatients}</p>
                <p class="text-sm text-gray-500">Patients</p>
            </div>
            <div class="bg-white rounded-2xl p-6 shadow-sm border border-gray-100 card-hover">
                <div class="flex items-center justify-between mb-3">
                    <div class="w-10 h-10 bg-accent-50 rounded-xl flex items-center justify-center"><i class="fas fa-user-md text-accent-600"></i></div>
                </div>
                <p class="text-2xl font-bold text-gray-900">${totalDoctors}</p>
                <p class="text-sm text-gray-500">Doctors</p>
            </div>
            <div class="bg-white rounded-2xl p-6 shadow-sm border border-gray-100 card-hover">
                <div class="flex items-center justify-between mb-3">
                    <div class="w-10 h-10 bg-blue-50 rounded-xl flex items-center justify-center"><i class="fas fa-calendar text-blue-600"></i></div>
                </div>
                <p class="text-2xl font-bold text-gray-900">${totalAppointments}</p>
                <p class="text-sm text-gray-500">Appointments</p>
            </div>
            <div class="bg-white rounded-2xl p-6 shadow-sm border border-gray-100 card-hover">
                <div class="flex items-center justify-between mb-3">
                    <div class="w-10 h-10 bg-yellow-50 rounded-xl flex items-center justify-center"><i class="fas fa-clock text-yellow-600"></i></div>
                </div>
                <p class="text-2xl font-bold text-orange-600">${pendingAppointments}</p>
                <p class="text-sm text-gray-500">Pending</p>
            </div>
            <div class="bg-white rounded-2xl p-6 shadow-sm border border-gray-100 card-hover">
                <div class="flex items-center justify-between mb-3">
                    <div class="w-10 h-10 bg-green-50 rounded-xl flex items-center justify-center"><i class="fas fa-money-bill-wave text-green-600"></i></div>
                </div>
                <p class="text-2xl font-bold text-green-600">Rs. <fmt:formatNumber value="${totalRevenue}" pattern="#,##0" /></p>
                <p class="text-sm text-gray-500">Revenue</p>
            </div>
        </div>

        <!-- Quick Admin Links -->
        <div class="grid grid-cols-2 md:grid-cols-3 lg:grid-cols-6 gap-4 mb-8">
            <a href="${pageContext.request.contextPath}/admin/doctors" class="bg-white rounded-2xl p-4 shadow-sm border border-gray-100 card-hover text-center group">
                <div class="w-10 h-10 bg-primary-50 rounded-xl flex items-center justify-center mx-auto mb-2 group-hover:bg-primary-100 transition-colors"><i class="fas fa-user-md text-primary-600"></i></div>
                <span class="font-semibold text-gray-800 text-xs">Doctors</span>
            </a>
            <a href="${pageContext.request.contextPath}/admin/specializations" class="bg-white rounded-2xl p-4 shadow-sm border border-gray-100 card-hover text-center group">
                <div class="w-10 h-10 bg-indigo-50 rounded-xl flex items-center justify-center mx-auto mb-2 group-hover:bg-indigo-100 transition-colors"><i class="fas fa-stethoscope text-indigo-600"></i></div>
                <span class="font-semibold text-gray-800 text-xs">Specialties</span>
            </a>
            <a href="${pageContext.request.contextPath}/admin/slots" class="bg-white rounded-2xl p-4 shadow-sm border border-gray-100 card-hover text-center group">
                <div class="w-10 h-10 bg-accent-50 rounded-xl flex items-center justify-center mx-auto mb-2 group-hover:bg-accent-100 transition-colors"><i class="fas fa-calendar-alt text-accent-600"></i></div>
                <span class="font-semibold text-gray-800 text-xs">Slots</span>
            </a>
            <a href="${pageContext.request.contextPath}/admin/appointments" class="bg-white rounded-2xl p-4 shadow-sm border border-gray-100 card-hover text-center group">
                <div class="w-10 h-10 bg-blue-50 rounded-xl flex items-center justify-center mx-auto mb-2 group-hover:bg-blue-100 transition-colors"><i class="fas fa-check-circle text-blue-600"></i></div>
                <span class="font-semibold text-gray-800 text-xs">Appointments</span>
            </a>
            <a href="${pageContext.request.contextPath}/admin/users" class="bg-white rounded-2xl p-4 shadow-sm border border-gray-100 card-hover text-center group">
                <div class="w-10 h-10 bg-orange-50 rounded-xl flex items-center justify-center mx-auto mb-2 group-hover:bg-orange-100 transition-colors"><i class="fas fa-users-cog text-orange-600"></i></div>
                <span class="font-semibold text-gray-800 text-xs">Users</span>
            </a>
            <a href="${pageContext.request.contextPath}/admin/reports" class="bg-white rounded-2xl p-4 shadow-sm border border-gray-100 card-hover text-center group">
                <div class="w-10 h-10 bg-purple-50 rounded-xl flex items-center justify-center mx-auto mb-2 group-hover:bg-purple-100 transition-colors"><i class="fas fa-chart-bar text-purple-600"></i></div>
                <span class="font-semibold text-gray-800 text-xs">Reports</span>
            </a>
        </div>

        <!-- Recent Appointments Table -->
        <div class="bg-white rounded-2xl shadow-sm border border-gray-100 overflow-hidden">
            <div class="px-6 py-4 border-b border-gray-100 flex justify-between items-center">
                <h2 class="text-lg font-bold text-gray-900">Recent Appointments</h2>
                <a href="${pageContext.request.contextPath}/admin/appointments" class="text-primary-600 text-sm font-medium hover:text-primary-700">View All</a>
            </div>
            <div class="overflow-x-auto">
                <table class="w-full" id="admin-recent-appointments">
                    <thead class="bg-gray-50">
                    <tr>
                        <th class="px-6 py-3 text-left text-xs font-semibold text-gray-500 uppercase">Patient</th>
                        <th class="px-6 py-3 text-left text-xs font-semibold text-gray-500 uppercase">Doctor</th>
                        <th class="px-6 py-3 text-left text-xs font-semibold text-gray-500 uppercase">Date</th>
                        <th class="px-6 py-3 text-left text-xs font-semibold text-gray-500 uppercase">Time</th>
                        <th class="px-6 py-3 text-left text-xs font-semibold text-gray-500 uppercase">Status</th>
                    </tr>
                    </thead>
                    <tbody class="divide-y divide-gray-100">
                    <c:forEach var="apt" items="${recentAppointments}">
                        <tr class="hover:bg-gray-50 transition-colors">
                            <td class="px-6 py-4 text-sm font-medium text-gray-900">${apt.patientName}</td>
                            <td class="px-6 py-4 text-sm text-gray-600">
                                <div class="font-medium">${apt.doctorName}</div>
                                <div class="text-[10px] text-primary-500">${apt.specializationName}</div>
                            </td>
                            <td class="px-6 py-4 text-sm text-gray-600">${apt.appointmentDate}</td>
                            <td class="px-6 py-4 text-sm text-gray-600">
                                <div class="font-medium">${apt.slotTime}</div>
                                <div class="text-[10px] text-gray-400">
                                    <i class="fas fa-hospital mr-1"></i>Physical Visit
                                </div>
                            </td>
                            <td class="px-6 py-4"><span class="inline-flex items-center gap-1 px-3 py-1 rounded-full text-xs font-bold ${apt.status == 'confirmed' ? 'bg-blue-100 text-blue-700' : apt.status == 'completed' ? 'bg-green-100 text-green-700' : apt.status == 'rescheduled' ? 'bg-orange-100 text-orange-700' : 'bg-red-100 text-red-700'}"><i class="fas ${apt.status == 'confirmed' ? 'fa-check-circle' : apt.status == 'completed' ? 'fa-check-double' : apt.status == 'rescheduled' ? 'fa-calendar-alt' : 'fa-times-circle'}"></i>${apt.status == 'confirmed' ? 'Confirmed' : apt.status == 'completed' ? 'Completed' : apt.status == 'rescheduled' ? 'Rescheduled' : 'Cancelled'}</span></td>
                        </tr>
                    </c:forEach>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
</main>

<jsp:include page="/WEB-INF/views/common/footer.jsp" />
