<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<jsp:include page="/WEB-INF/views/common/header.jsp" />
<jsp:include page="/WEB-INF/views/common/navbar.jsp" />
<main class="flex-1 bg-gray-50">
    <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-8">
        <h1 class="text-3xl font-bold text-gray-900 mb-8">Reports & <span class="gradient-text">Analytics</span></h1>

        <!-- Summary Cards -->
        <div class="grid grid-cols-2 lg:grid-cols-4 gap-4 mb-8">
            <div class="bg-white rounded-2xl p-6 shadow-sm border border-gray-100">
                <p class="text-sm text-gray-500">Total Appointments</p>
                <p class="text-3xl font-bold text-gray-900 mt-1">${totalAppointments}</p>
            </div>
            <div class="bg-white rounded-2xl p-6 shadow-sm border border-gray-100">
                <p class="text-sm text-gray-500">Total Revenue</p>
                <p class="text-3xl font-bold text-green-600 mt-1">Rs. <fmt:formatNumber value="${totalRevenue}" pattern="#,##0" /></p>
            </div>
            <div class="bg-white rounded-2xl p-6 shadow-sm border border-gray-100">
                <p class="text-sm text-gray-500">Active Doctors</p>
                <p class="text-3xl font-bold text-primary-600 mt-1">${totalDoctors}</p>
            </div>
            <div class="bg-white rounded-2xl p-6 shadow-sm border border-gray-100">
                <p class="text-sm text-gray-500">Registered Patients</p>
                <p class="text-3xl font-bold text-accent-600 mt-1">${totalPatients}</p>
            </div>
        </div>

        <!-- Appointment Status Breakdown -->
        <div class="grid grid-cols-1 lg:grid-cols-2 gap-6 mb-8">
            <div class="bg-white rounded-2xl shadow-sm border border-gray-100 p-6">
                <h2 class="text-lg font-bold text-gray-900 mb-4">Appointment Status Breakdown</h2>
                <div class="space-y-4">
                    <div>
                        <div class="flex justify-between mb-1"><span class="text-sm font-medium text-yellow-700">Rescheduled</span><span class="text-sm font-bold">${rescheduledCount}</span></div>
                        <div class="w-full bg-gray-200 rounded-full h-3"><div class="bg-orange-400 h-3 rounded-full" style="width: ${totalAppointments > 0 ? (rescheduledCount * 100 / totalAppointments) : 0}%"></div></div>
                    </div>
                    <div>
                        <div class="flex justify-between mb-1"><span class="text-sm font-medium text-blue-700">Confirmed</span><span class="text-sm font-bold">${confirmedCount}</span></div>
                        <div class="w-full bg-gray-200 rounded-full h-3"><div class="bg-blue-400 h-3 rounded-full" style="width: ${totalAppointments > 0 ? (confirmedCount * 100 / totalAppointments) : 0}%"></div></div>
                    </div>
                    <div>
                        <div class="flex justify-between mb-1"><span class="text-sm font-medium text-green-700">Completed</span><span class="text-sm font-bold">${completedCount}</span></div>
                        <div class="w-full bg-gray-200 rounded-full h-3"><div class="bg-green-400 h-3 rounded-full" style="width: ${totalAppointments > 0 ? (completedCount * 100 / totalAppointments) : 0}%"></div></div>
                    </div>
                    <div>
                        <div class="flex justify-between mb-1"><span class="text-sm font-medium text-red-700">Cancelled</span><span class="text-sm font-bold">${cancelledCount}</span></div>
                        <div class="w-full bg-gray-200 rounded-full h-3"><div class="bg-red-400 h-3 rounded-full" style="width: ${totalAppointments > 0 ? (cancelledCount * 100 / totalAppointments) : 0}%"></div></div>
                    </div>
                </div>
            </div>
            <div class="bg-white rounded-2xl shadow-sm border border-gray-100 p-6">
                <h2 class="text-lg font-bold text-gray-900 mb-4">Quick Summary</h2>
                <div class="grid grid-cols-2 gap-4">
                    <div class="bg-orange-50 rounded-xl p-4 text-center border border-orange-100">
                        <div class="text-2xl font-bold text-orange-600">${rescheduledCount}</div>
                        <div class="text-xs text-gray-500 mt-1">Rescheduled</div>
                    </div>
                    <div class="bg-blue-50 rounded-xl p-4 text-center border border-blue-100">
                        <div class="text-2xl font-bold text-blue-600">${confirmedCount}</div>
                        <div class="text-xs text-gray-500 mt-1">Confirmed</div>
                    </div>
                    <div class="bg-green-50 rounded-xl p-4 text-center border border-green-100">
                        <div class="text-2xl font-bold text-green-600">${completedCount}</div>
                        <div class="text-xs text-gray-500 mt-1">Completed</div>
                    </div>
                    <div class="bg-red-50 rounded-xl p-4 text-center border border-red-100">
                        <div class="text-2xl font-bold text-red-600">${cancelledCount}</div>
                        <div class="text-xs text-gray-500 mt-1">Cancelled</div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Payment History -->
        <div class="bg-white rounded-2xl shadow-sm border border-gray-100 overflow-hidden">
            <div class="px-6 py-4 border-b border-gray-100"><h2 class="text-lg font-bold text-gray-900">Payment Records</h2></div>
            <div class="overflow-x-auto">
                <table class="w-full">
                    <thead class="bg-gray-50"><tr>
                        <th class="px-6 py-3 text-left text-xs font-semibold text-gray-500 uppercase">Patient</th>
                        <th class="px-6 py-3 text-left text-xs font-semibold text-gray-500 uppercase">Doctor</th>
                        <th class="px-6 py-3 text-left text-xs font-semibold text-gray-500 uppercase">Amount</th>
                        <th class="px-6 py-3 text-left text-xs font-semibold text-gray-500 uppercase">Method</th>
                        <th class="px-6 py-3 text-left text-xs font-semibold text-gray-500 uppercase">Transaction</th>
                        <th class="px-6 py-3 text-left text-xs font-semibold text-gray-500 uppercase">Status</th>
                    </tr></thead>
                    <tbody class="divide-y divide-gray-100">
                    <c:forEach var="p" items="${payments}">
                        <tr class="hover:bg-gray-50 transition-colors">
                            <td class="px-6 py-4 text-sm text-gray-900">${p.patientName}</td>
                            <td class="px-6 py-4 text-sm text-gray-600">${p.doctorName}</td>
                            <td class="px-6 py-4 text-sm font-semibold text-gray-900">Rs. ${p.amount}</td>
                            <td class="px-6 py-4"><span class="px-3 py-1 rounded-full text-xs font-semibold ${p.paymentMethod == 'khalti' ? 'bg-purple-100 text-purple-700' : 'bg-green-100 text-green-700'}">${p.paymentMethod}</span></td>
                            <td class="px-6 py-4 text-sm text-gray-500 font-mono">${p.transactionId != null ? p.transactionId : '-'}</td>
                            <td class="px-6 py-4"><span class="px-3 py-1 rounded-full text-xs font-bold ${p.status == 'completed' ? 'bg-green-100 text-green-700' : 'bg-yellow-100 text-yellow-700'}">${p.status}</span></td>
                        </tr>
                    </c:forEach>
                    <c:if test="${empty payments}">
                        <tr><td colspan="6" class="px-6 py-8 text-center text-gray-500">No payment records yet.</td></tr>
                    </c:if>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
</main>
<jsp:include page="/WEB-INF/views/common/footer.jsp" />
