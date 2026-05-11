<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<jsp:include page="/WEB-INF/views/common/header.jsp" />
<jsp:include page="/WEB-INF/views/common/navbar.jsp" />

<main class="flex-1 bg-gray-50">
    <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-8">
        <div class="flex justify-between items-center mb-8">
            <h1 class="text-3xl font-bold text-gray-900">Manage Doctors</h1>
            <a href="${pageContext.request.contextPath}/admin/doctors?action=add" class="px-6 py-2.5 bg-primary-600 text-white font-medium rounded-xl hover:bg-primary-700 transition-all shadow-lg shadow-primary-500/25" id="add-doctor-btn">
                <i class="fas fa-plus mr-2"></i>Add Doctor
            </a>
        </div>
        <c:if test="${param.success != null}"><div class="mb-6 p-4 bg-green-50 border border-green-200 rounded-xl flex items-center space-x-3"><i class="fas fa-check-circle text-green-500"></i><span class="text-green-700 text-sm">${param.success}</span></div></c:if>
        <c:if test="${param.error != null}"><div class="mb-6 p-4 bg-red-50 border border-red-200 rounded-xl flex items-center space-x-3"><i class="fas fa-exclamation-circle text-red-500"></i><span class="text-red-700 text-sm">${param.error}</span></div></c:if>

        <div class="bg-white rounded-2xl shadow-sm border border-gray-100 overflow-hidden">
            <div class="overflow-x-auto">
                <table class="w-full" id="doctors-table">
                    <thead class="bg-gray-50"><tr>
                        <th class="px-6 py-3 text-left text-xs font-semibold text-gray-500 uppercase">Name</th>
                        <th class="px-6 py-3 text-left text-xs font-semibold text-gray-500 uppercase">Specialization</th>
                        <th class="px-6 py-3 text-left text-xs font-semibold text-gray-500 uppercase">Fee</th>
                        <th class="px-6 py-3 text-left text-xs font-semibold text-gray-500 uppercase">Exp.</th>
                        <th class="px-6 py-3 text-left text-xs font-semibold text-gray-500 uppercase">Status</th>
                        <th class="px-6 py-3 text-left text-xs font-semibold text-gray-500 uppercase">Actions</th>
                    </tr></thead>
                    <tbody class="divide-y divide-gray-100">
                        <c:forEach var="doc" items="${doctors}">
                            <tr class="hover:bg-gray-50 transition-colors">
                                <td class="px-6 py-4">
                                    <div class="font-medium text-gray-900">${doc.fullName}</div>
                                    <div class="text-xs text-gray-500">${doc.email}</div>
                                </td>
                                <td class="px-6 py-4 text-sm text-gray-600">${doc.specializationName}</td>
                                <td class="px-6 py-4 text-sm font-semibold text-gray-900">Rs. ${doc.consultationFee}</td>
                                <td class="px-6 py-4 text-sm text-gray-600">${doc.experienceYears} yrs</td>
                                <td class="px-6 py-4"><span class="px-3 py-1 rounded-full text-xs font-bold ${doc.active ? 'bg-green-100 text-green-700' : 'bg-red-100 text-red-700'}">${doc.active ? 'Active' : 'Inactive'}</span></td>
                                <td class="px-6 py-4">
                                    <a href="${pageContext.request.contextPath}/admin/doctors?action=edit&id=${doc.id}" class="text-primary-600 hover:text-primary-700 font-medium text-sm mr-3"><i class="fas fa-edit"></i> Edit</a>
                                    <form method="post" action="${pageContext.request.contextPath}/admin/doctors" class="inline" onsubmit="return confirm('Delete this doctor?')">
                                        <input type="hidden" name="csrfToken" value="${csrfToken}">
                                        <input type="hidden" name="action" value="delete">
                                        <input type="hidden" name="id" value="${doc.id}">
                                        <button type="submit" class="text-red-600 hover:text-red-700 font-medium text-sm"><i class="fas fa-trash"></i> Delete</button>
                                    </form>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
</main>
<jsp:include page="/WEB-INF/views/common/footer.jsp" />
