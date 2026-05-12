<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<jsp:include page="/WEB-INF/views/common/header.jsp" />
<jsp:include page="/WEB-INF/views/common/navbar.jsp" />

<main class="flex-1 bg-gray-50">
    <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-8">
        <h1 class="text-3xl font-bold text-gray-900 mb-8">Payment History</h1>

        <c:choose>
            <c:when test="${empty payments}">
                <div class="bg-white rounded-2xl shadow-sm border border-gray-100 p-12 text-center">
                    <div class="w-20 h-20 bg-gray-100 rounded-3xl flex items-center justify-center mx-auto mb-4"><i class="fas fa-credit-card text-gray-400 text-3xl"></i></div>
                    <h3 class="text-xl font-bold text-gray-700 mb-2">No Payments Yet</h3>
                    <p class="text-gray-500">Your payment history will appear here after making payments.</p>
                </div>
            </c:when>
            <c:otherwise>
                <div class="bg-white rounded-2xl shadow-sm border border-gray-100 overflow-hidden">
                    <div class="overflow-x-auto">
                        <table class="w-full" id="payments-table">
                            <thead class="bg-gray-50">
                            <tr>
                                <th class="px-6 py-3 text-left text-xs font-semibold text-gray-500 uppercase">ID</th>
                                <th class="px-6 py-3 text-left text-xs font-semibold text-gray-500 uppercase">Doctor</th>
                                <th class="px-6 py-3 text-left text-xs font-semibold text-gray-500 uppercase">Date</th>
                                <th class="px-6 py-3 text-left text-xs font-semibold text-gray-500 uppercase">Amount</th>
                                <th class="px-6 py-3 text-left text-xs font-semibold text-gray-500 uppercase">Method</th>
                                <th class="px-6 py-3 text-left text-xs font-semibold text-gray-500 uppercase">Transaction ID</th>
                                <th class="px-6 py-3 text-left text-xs font-semibold text-gray-500 uppercase">Status</th>
                            </tr>
                            </thead>
                            <tbody class="divide-y divide-gray-100">
                            <c:forEach var="p" items="${payments}">
                                <tr class="hover:bg-gray-50 transition-colors">
                                    <td class="px-6 py-4 text-sm font-medium text-gray-900">#${p.id}</td>
                                    <td class="px-6 py-4 text-sm text-gray-600">${p.doctorName}</td>
                                    <td class="px-6 py-4 text-sm text-gray-600">${p.appointmentDate}</td>
                                    <td class="px-6 py-4 text-sm font-semibold text-gray-900">Rs. ${p.amount}</td>
                                    <td class="px-6 py-4"><span class="px-3 py-1 rounded-full text-xs font-semibold ${p.paymentMethod == 'khalti' ? 'bg-purple-100 text-purple-700' : 'bg-green-100 text-green-700'}">${p.paymentMethod}</span></td>
                                    <td class="px-6 py-4 text-sm text-gray-500 font-mono">${p.transactionId != null ? p.transactionId : '-'}</td>
                                    <td class="px-6 py-4"><span class="px-3 py-1 rounded-full text-xs font-bold ${p.status == 'completed' ? 'bg-green-100 text-green-700' : p.status == 'pending' ? 'bg-yellow-100 text-yellow-700' : 'bg-red-100 text-red-700'}">${p.status}</span></td>
                                </tr>
                            </c:forEach>
                            </tbody>
                        </table>
                    </div>
                </div>
            </c:otherwise>
        </c:choose>
    </div>
</main>

<jsp:include page="/WEB-INF/views/common/footer.jsp" />
