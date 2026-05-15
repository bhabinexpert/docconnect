<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<jsp:include page="/WEB-INF/views/common/header.jsp" />
<jsp:include page="/WEB-INF/views/common/navbar.jsp" />
<main class="flex-1 bg-gray-50">
    <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-8">

        <div class="flex justify-between items-center mb-8">
            <div>
                <h1 class="text-3xl font-bold text-gray-900">Manage Appointments</h1>
                <p class="text-gray-500 mt-1">${appointments.size()} total appointments</p>
            </div>
        </div>

        <c:if test="${param.success != null}">
            <div class="mb-6 p-4 bg-green-50 border border-green-200 rounded-xl flex items-center space-x-3">
                <i class="fas fa-check-circle text-green-500"></i>
                <span class="text-green-700 text-sm">${param.success}</span>
            </div>
        </c:if>
        <c:if test="${param.error != null}">
            <div class="mb-6 p-4 bg-red-50 border border-red-200 rounded-xl flex items-center space-x-3">
                <i class="fas fa-exclamation-circle text-red-500"></i>
                <span class="text-red-700 text-sm">${param.error}</span>
            </div>
        </c:if>

        <div class="bg-white rounded-2xl shadow-sm border border-gray-100 overflow-hidden">
            <c:choose>
                <c:when test="${empty appointments}">
                    <div class="flex flex-col items-center justify-center py-24 text-center px-6">
                        <div class="w-20 h-20 bg-gray-100 rounded-3xl flex items-center justify-center mb-4">
                            <i class="fas fa-calendar-times text-gray-400 text-3xl"></i>
                        </div>
                        <h3 class="text-xl font-bold text-gray-700 mb-2">No Appointments Yet</h3>
                        <p class="text-gray-500 max-w-sm">Appointments will appear here once patients book and pay for their consultations.</p>
                    </div>
                </c:when>
                <c:otherwise>
                    <div class="overflow-x-auto">
                        <table class="w-full" id="admin-appointments-table">
                            <thead class="bg-gray-50 border-b border-gray-100">
                            <tr>
                                <th class="px-4 py-3 text-left text-xs font-semibold text-gray-500 uppercase tracking-wider">ID</th>
                                <th class="px-4 py-3 text-left text-xs font-semibold text-gray-500 uppercase tracking-wider">Turn</th>
                                <th class="px-4 py-3 text-left text-xs font-semibold text-gray-500 uppercase tracking-wider">Patient</th>
                                <th class="px-4 py-3 text-left text-xs font-semibold text-gray-500 uppercase tracking-wider">Doctor</th>
                                <th class="px-4 py-3 text-left text-xs font-semibold text-gray-500 uppercase tracking-wider">Date</th>
                                <th class="px-4 py-3 text-left text-xs font-semibold text-gray-500 uppercase tracking-wider">Time</th>
                                <th class="px-4 py-3 text-left text-xs font-semibold text-gray-500 uppercase tracking-wider">Status</th>
                                <th class="px-4 py-3 text-left text-xs font-semibold text-gray-500 uppercase tracking-wider">Payment</th>
                                <th class="px-4 py-3 text-left text-xs font-semibold text-gray-500 uppercase tracking-wider">Update</th>
                                <th class="px-4 py-3 text-left text-xs font-semibold text-gray-500 uppercase tracking-wider">Export</th>
                            </tr>
                            </thead>
                            <tbody class="divide-y divide-gray-100">
                            <c:forEach var="apt" items="${appointments}">
                                <tr class="hover:bg-gray-50 transition-colors">
                                    <td class="px-4 py-4 text-sm font-medium text-gray-400">#${apt.id}</td>
                                    <td class="px-4 py-4">
                                        <span class="inline-flex items-center justify-center w-8 h-8 rounded-full bg-primary-100 text-primary-700 text-sm font-black">${apt.turnNumber}</span>
                                    </td>
                                    <td class="px-4 py-4">
                                        <div class="text-sm font-semibold text-gray-900">${apt.patientName}</div>
                                        <div class="text-xs text-gray-400">${apt.patientEmail}</div>
                                    </td>
                                    <td class="px-4 py-4">
                                        <div class="text-sm font-semibold text-gray-800">${apt.doctorName}</div>
                                        <div class="text-xs text-primary-500">${apt.specializationName}</div>
                                    </td>
                                    <td class="px-4 py-4 text-sm text-gray-600 whitespace-nowrap">${apt.appointmentDate}</td>
                                    <td class="px-4 py-4 text-sm text-gray-600 whitespace-nowrap">${apt.slotTime}</td>
                                    <td class="px-4 py-4">
                                        <c:choose>
                                            <c:when test="${apt.paymentStatus != 'completed' && apt.status != 'cancelled'}">
                                                <span class="inline-flex items-center gap-1 px-3 py-1 rounded-full text-xs font-bold bg-yellow-100 text-yellow-700"><i class="fas fa-clock"></i>Payment Pending</span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="inline-flex items-center gap-1 px-3 py-1 rounded-full text-xs font-bold ${apt.status == 'confirmed' ? 'bg-blue-100 text-blue-700' : apt.status == 'completed' ? 'bg-green-100 text-green-700' : apt.status == 'rescheduled' ? 'bg-orange-100 text-orange-700' : apt.status == 'cancelled' ? 'bg-red-100 text-red-700' : 'bg-yellow-100 text-yellow-700'}"><i class="fas ${apt.status == 'confirmed' ? 'fa-check-circle' : apt.status == 'completed' ? 'fa-check-double' : apt.status == 'rescheduled' ? 'fa-calendar-alt' : apt.status == 'cancelled' ? 'fa-times-circle' : 'fa-clock'}"></i>${apt.status == 'confirmed' ? 'Confirmed' : apt.status == 'completed' ? 'Completed' : apt.status == 'rescheduled' ? 'Rescheduled' : apt.status == 'cancelled' ? 'Cancelled' : apt.status}</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td class="px-4 py-4">
                                        <span class="inline-flex items-center gap-1 px-3 py-1 rounded-full text-xs font-bold ${apt.paymentStatus == 'completed' ? 'bg-green-100 text-green-700' : apt.paymentStatus == 'pending' ? 'bg-yellow-100 text-yellow-700' : 'bg-gray-100 text-gray-500'}"><i class="fas ${apt.paymentStatus == 'completed' ? 'fa-check-circle' : apt.paymentStatus == 'pending' ? 'fa-clock' : 'fa-times-circle'}"></i>${apt.paymentStatus == 'completed' ? 'Paid' : apt.paymentStatus == 'pending' ? 'Pending' : 'Unpaid'}</span>
                                    </td>
                                    <td class="px-4 py-4">
                                        <form method="post" action="${pageContext.request.contextPath}/admin/appointments" class="flex items-center gap-2">
                                            <input type="hidden" name="csrfToken" value="${csrfToken}">
                                            <input type="hidden" name="action" value="updateStatus">
                                            <input type="hidden" name="appointmentId" value="${apt.id}">
                                            <select name="status" class="text-xs border border-gray-200 rounded-lg px-2 py-1.5 focus:ring-2 focus:ring-primary-500 focus:border-primary-500">
                                                <option value="confirmed"   ${apt.status == 'confirmed'   ? 'selected' : ''}>Confirmed</option>
                                                <option value="completed"   ${apt.status == 'completed'   ? 'selected' : ''}>Completed</option>
                                                <option value="rescheduled" ${apt.status == 'rescheduled' ? 'selected' : ''}>Rescheduled</option>
                                                <option value="cancelled"   ${apt.status == 'cancelled'   ? 'selected' : ''}>Cancelled</option>
                                            </select>
                                            <button type="submit" class="px-2 py-1.5 bg-primary-600 text-white text-xs font-bold rounded-lg hover:bg-primary-700 transition-all">
                                                <i class="fas fa-save"></i>
                                            </button>
                                        </form>
                                    </td>
                                    <td class="px-4 py-4">
                                        <c:if test="${apt.paymentStatus == 'completed'}">
                                            <a href="${pageContext.request.contextPath}/admin/appointment/receipt?id=${apt.id}&export=true"
                                               target="_blank"
                                               title="Export as PDF"
                                               class="inline-flex items-center gap-1.5 px-3 py-1.5 bg-purple-600 text-white text-xs font-bold rounded-lg hover:bg-purple-700 transition-all shadow-sm">
                                                <i class="fas fa-file-pdf"></i> PDF
                                            </a>
                                        </c:if>
                                        <c:if test="${apt.paymentStatus != 'completed'}">
                                            <span class="text-xs text-gray-400">Unavailable</span>
                                        </c:if>
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
