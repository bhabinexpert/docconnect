<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<jsp:include page="/WEB-INF/views/common/header.jsp" />
<jsp:include page="/WEB-INF/views/common/navbar.jsp" />

<main class="flex-1 bg-gray-50">
    <div class="max-w-2xl mx-auto px-4 sm:px-6 lg:px-8 py-8">
        <h1 class="text-3xl font-bold text-gray-900 mb-8">Complete Payment</h1>

        <%-- Info banner — shown when payment is still pending --%>
        <c:if test="${requestScope.existingPayment == null || requestScope.existingPayment.status != 'completed'}">
            <div class="mb-6 p-4 bg-blue-50 border border-blue-200 rounded-xl flex items-center space-x-3">
                <i class="fas fa-info-circle text-blue-500 text-lg"></i>
                <span class="text-blue-700 text-sm font-medium">Your appointment slot is reserved. Complete payment below to confirm your booking.</span>
            </div>
        </c:if>
        <c:if test="${param.error != null}">
            <div class="mb-6 p-4 bg-red-50 border border-red-200 rounded-xl flex items-center space-x-3">
                <i class="fas fa-exclamation-circle text-red-500"></i>
                <span class="text-red-700 text-sm">${param.error}</span>
            </div>
        </c:if>

        <%-- Already paid --%>
        <c:if test="${requestScope.existingPayment != null && requestScope.existingPayment.status == 'completed'}">
            <div class="bg-white rounded-2xl shadow-sm border border-green-200 p-8 text-center">
                <div class="w-20 h-20 bg-green-100 rounded-full flex items-center justify-center mx-auto mb-4">
                    <i class="fas fa-check-circle text-green-500 text-4xl"></i>
                </div>
                <h2 class="text-2xl font-bold text-green-700 mb-2">Payment Successful!</h2>
                <p class="text-gray-500 mb-1">Your appointment has been confirmed.</p>
                <p class="text-gray-400 text-sm mb-6">
                    Transaction ID: <span class="font-mono font-semibold">${requestScope.existingPayment.transactionId}</span>
                </p>
                <a href="${pageContext.request.contextPath}/patient/appointments"
                   class="inline-block px-8 py-3 bg-primary-600 text-white font-semibold rounded-xl hover:bg-primary-700 transition-all">
                    View My Appointments
                </a>
            </div>
        </c:if>

        <%-- Payment form — shown when payment not yet completed --%>
        <c:if test="${requestScope.existingPayment == null || requestScope.existingPayment.status != 'completed'}">

            <%-- Appointment summary card --%>
            <div class="bg-white rounded-2xl shadow-sm border border-gray-100 p-6 mb-6">
                <h2 class="text-lg font-bold text-gray-900 mb-4">Appointment Summary</h2>
                <div class="space-y-3 text-sm">
                    <div class="flex justify-between">
                        <span class="text-gray-500">Doctor:</span>
                        <span class="font-semibold">${appointment.doctorName}</span>
                    </div>
                    <div class="flex justify-between">
                        <span class="text-gray-500">Specialization:</span>
                        <span class="font-semibold">${appointment.specializationName}</span>
                    </div>
                    <div class="flex justify-between">
                        <span class="text-gray-500">Date:</span>
                        <span class="font-semibold">${appointment.appointmentDate}</span>
                    </div>
                    <div class="flex justify-between">
                        <span class="text-gray-500">Time Slot:</span>
                        <span class="font-semibold">${appointment.slotTime}</span>
                    </div>
                    <hr class="border-gray-100">
                    <div class="flex justify-between text-base">
                        <span class="font-bold text-gray-900">Consultation Fee:</span>
                        <span class="font-bold text-primary-600">Rs. ${appointment.consultationFee}</span>
                    </div>
                </div>
            </div>

            <%-- Khalti payment card --%>
            <div class="bg-white rounded-2xl shadow-sm border border-gray-100 p-6">
                <h2 class="text-lg font-bold text-gray-900 mb-1">Pay with Khalti</h2>
                <p class="text-gray-500 text-sm mb-6">
                    Click the button below. You will be redirected to Khalti's secure payment page.
                </p>

                    <%-- Khalti branding --%>
                <div class="flex items-center justify-center mb-6">
                    <div class="p-6 rounded-2xl border-2 border-purple-300 bg-purple-50 text-center w-full max-w-xs">
                        <div class="w-16 h-16 bg-purple-100 rounded-2xl flex items-center justify-center mx-auto mb-3">
                            <i class="fas fa-wallet text-purple-600 text-2xl"></i>
                        </div>
                        <div class="font-bold text-gray-800 text-lg">Khalti</div>
                        <div class="text-xs text-purple-500 font-medium mt-1">Secure Digital Payment</div>
                    </div>
                </div>

                <div class="bg-purple-50 rounded-xl p-4 mb-6 border border-purple-100">
                    <p class="text-purple-700 text-sm">
                        <i class="fas fa-shield-alt mr-2"></i>
                        <strong>How it works:</strong> You will be redirected to Khalti's secure checkout page.
                        After payment, you will automatically return here with your appointment confirmed.
                    </p>
                </div>

                    <%-- Single POST form — no JavaScript needed --%>
                <form method="post" action="${pageContext.request.contextPath}/patient/payment"
                      id="khaltiForm">
                    <input type="hidden" name="csrfToken" value="${csrfToken}">
                    <c:choose>
                        <c:when test="${pending == true}">
                            <input type="hidden" name="pending" value="true">
                        </c:when>
                        <c:otherwise>
                            <input type="hidden" name="appointmentId" value="${appointment.id}">
                        </c:otherwise>
                    </c:choose>

                    <button type="submit" id="payBtn"
                            class="w-full py-4 bg-gradient-to-r from-purple-600 to-purple-700 text-white font-bold rounded-xl hover:from-purple-700 hover:to-purple-800 transition-all shadow-lg shadow-purple-500/25 text-lg flex items-center justify-center gap-3">
                        <i class="fas fa-lock"></i>
                        Pay Rs. ${appointment.consultationFee} via Khalti
                    </button>
                </form>

                <script>
                    // Disable button on submit to prevent double-click
                    document.getElementById('khaltiForm').addEventListener('submit', function () {
                        var btn = document.getElementById('payBtn');
                        btn.disabled = true;
                        btn.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Redirecting to Khalti...';
                    });
                </script>
            </div>

        </c:if>
    </div>
</main>

<jsp:include page="/WEB-INF/views/common/footer.jsp" />
