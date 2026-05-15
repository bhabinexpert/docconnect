<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<jsp:include page="/WEB-INF/views/common/header.jsp" />
<jsp:include page="/WEB-INF/views/common/navbar.jsp" />

<main class="flex-1 bg-gray-50">
    <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-8">
        <div class="flex justify-between items-center mb-8">
            <div>
                <h1 class="text-3xl font-bold text-gray-900">My Appointments</h1>
                <p class="text-gray-500 mt-1">${appointments.size()} total appointments</p>
            </div>
            <a href="${pageContext.request.contextPath}/doctors" class="px-6 py-2.5 bg-primary-600 text-white font-medium rounded-xl hover:bg-primary-700 transition-all shadow-lg shadow-primary-500/25" id="new-appointment-btn">
                <i class="fas fa-plus mr-2"></i>New Appointment
            </a>
        </div>

        <c:if test="${param.success != null}">
            <div class="mb-6 p-4 bg-green-50 border border-green-200 rounded-xl flex items-center space-x-3">
                <i class="fas fa-check-circle text-green-500"></i><span class="text-green-700 text-sm">${param.success}</span>
            </div>
        </c:if>
        <c:if test="${param.error != null}">
            <div class="mb-6 p-4 bg-red-50 border border-red-200 rounded-xl flex items-center space-x-3">
                <i class="fas fa-exclamation-circle text-red-500"></i><span class="text-red-700 text-sm">${param.error}</span>
            </div>
        </c:if>

        <c:choose>
            <c:when test="${empty appointments}">
                <div class="bg-white rounded-2xl shadow-sm border border-gray-100 p-12 text-center">
                    <div class="w-20 h-20 bg-gray-100 rounded-3xl flex items-center justify-center mx-auto mb-4">
                        <i class="fas fa-calendar-times text-gray-400 text-3xl"></i>
                    </div>
                    <h3 class="text-xl font-bold text-gray-700 mb-2">No Appointments Yet</h3>
                    <p class="text-gray-500 mb-6">Book your first appointment with a doctor.</p>
                    <a href="${pageContext.request.contextPath}/doctors" class="px-8 py-3 bg-primary-600 text-white font-semibold rounded-xl hover:bg-primary-700 transition-all">Find Doctors</a>
                </div>
            </c:when>
            <c:otherwise>
                <div class="space-y-4">
                    <c:forEach var="apt" items="${appointments}">
                        <div class="bg-white rounded-2xl shadow-sm border border-gray-100 p-6 card-hover fade-in" id="apt-${apt.id}">
                            <div class="flex flex-col md:flex-row md:items-center justify-between gap-4">
                                <div class="flex items-start space-x-4">
                                    <div class="w-12 h-12 bg-gradient-to-br from-primary-100 to-accent-100 rounded-2xl flex items-center justify-center flex-shrink-0">
                                        <i class="fas fa-user-md text-primary-600"></i>
                                    </div>
                                    <div>
                                        <h3 class="font-bold text-gray-900">${apt.doctorName}</h3>
                                        <p class="text-sm text-primary-600">${apt.specializationName}</p>
                                        <div class="flex flex-wrap gap-3 mt-2 text-sm text-gray-500 items-center">
                                            <span><i class="fas fa-calendar mr-1"></i>${apt.appointmentDate}</span>
                                            <span><i class="fas fa-clock mr-1"></i>${apt.slotTime}</span>
                                        </div>
                                    </div>
                                </div>
                                <div class="flex items-center space-x-3">
                                    <div class="text-right mr-4">
                                        <p class="text-[10px] uppercase tracking-widest font-black text-gray-400">Turn</p>
                                        <p class="text-xl font-black text-primary-600">#${apt.turnNumber}</p>
                                    </div>
                                    <c:choose>
                                        <c:when test="${apt.paymentStatus != 'completed' && apt.status != 'cancelled'}">
                                            <span class="px-4 py-1.5 rounded-full text-xs font-bold bg-yellow-100 text-yellow-700">
                                                <i class="fas fa-clock mr-1"></i>Payment Pending
                                            </span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="px-4 py-1.5 rounded-full text-xs font-bold
                                                    ${apt.status == 'confirmed'   ? 'bg-blue-100 text-blue-700' :
                                                      apt.status == 'completed'   ? 'bg-green-100 text-green-700' :
                                                      apt.status == 'rescheduled' ? 'bg-orange-100 text-orange-700' :
                                                      apt.status == 'cancelled'   ? 'bg-red-100 text-red-700' :
                                                                                    'bg-yellow-100 text-yellow-700'}">
                                                <i class="fas ${apt.status == 'confirmed' ? 'fa-check-circle' :
                                                                apt.status == 'completed' ? 'fa-check-double' :
                                                                apt.status == 'rescheduled' ? 'fa-calendar-alt' :
                                                                apt.status == 'cancelled' ? 'fa-times-circle' :
                                                                'fa-clock'} mr-1"></i>
                                                ${apt.status == 'confirmed' ? 'Confirmed' :
                                                        apt.status == 'completed' ? 'Completed' :
                                                                apt.status == 'rescheduled' ? 'Rescheduled' :
                                                                        apt.status == 'cancelled' ? 'Cancelled' : apt.status}
                                            </span>
                                        </c:otherwise>
                                    </c:choose>

                                    <c:if test="${apt.paymentStatus != 'completed' && apt.status != 'cancelled'}">
                                        <a href="${pageContext.request.contextPath}/patient/payment?appointmentId=${apt.id}" class="px-4 py-1.5 bg-purple-600 text-white text-xs font-bold rounded-full hover:bg-purple-700 transition-all flex items-center">
                                            <i class="fas fa-wallet mr-1"></i> Pay Now
                                        </a>
                                    </c:if>
                                    <c:if test="${apt.paymentStatus == 'completed' && (apt.status == 'confirmed' || apt.status == 'completed' || apt.status == 'rescheduled')}">
                                        <a href="${pageContext.request.contextPath}/patient/appointment/receipt?id=${apt.id}" target="_blank" class="px-4 py-1.5 bg-primary-600 text-white text-xs font-bold rounded-full hover:bg-primary-700 transition-all flex items-center">
                                            <i class="fas fa-print mr-1"></i> Receipt
                                        </a>
                                        <a href="${pageContext.request.contextPath}/patient/appointment/receipt?id=${apt.id}&export=true" target="_blank" class="px-4 py-1.5 bg-green-600 text-white text-xs font-bold rounded-full hover:bg-green-700 transition-all flex items-center">
                                            <i class="fas fa-file-pdf mr-1"></i> Export
                                        </a>
                                    </c:if>
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
