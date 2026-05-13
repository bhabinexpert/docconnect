<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<jsp:include page="/WEB-INF/views/common/header.jsp" />
<jsp:include page="/WEB-INF/views/common/navbar.jsp" />
<main class="flex-1 bg-gray-50">
    <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-8">
        <h1 class="text-3xl font-bold text-gray-900 mb-8">Manage Users</h1>
        <c:if test="${param.success != null}"><div class="mb-6 p-4 bg-green-50 border border-green-200 rounded-xl flex items-center space-x-3"><i class="fas fa-check-circle text-green-500"></i><span class="text-green-700 text-sm">${param.success}</span></div></c:if>
        <!-- Filter -->
        <div class="mb-6 flex space-x-3">
            <a href="${pageContext.request.contextPath}/admin/users" class="px-5 py-2 rounded-xl font-medium text-sm ${selectedRole == null ? 'bg-primary-600 text-white' : 'bg-white text-gray-700 border border-gray-200 hover:bg-gray-50'} transition-all">All</a>
            <a href="${pageContext.request.contextPath}/admin/users?role=patient" class="px-5 py-2 rounded-xl font-medium text-sm ${selectedRole == 'patient' ? 'bg-primary-600 text-white' : 'bg-white text-gray-700 border border-gray-200 hover:bg-gray-50'} transition-all">Patients</a>
            <a href="${pageContext.request.contextPath}/admin/users?role=admin" class="px-5 py-2 rounded-xl font-medium text-sm ${selectedRole == 'admin' ? 'bg-primary-600 text-white' : 'bg-white text-gray-700 border border-gray-200 hover:bg-gray-50'} transition-all">Admins</a>
        </div>
        <div class="bg-white rounded-2xl shadow-sm border border-gray-100 overflow-hidden">
            <div class="overflow-x-auto">
                <table class="w-full" id="users-table">
                    <thead class="bg-gray-50"><tr>
                        <th class="px-6 py-3 text-left text-xs font-semibold text-gray-500 uppercase">Name</th>
                        <th class="px-6 py-3 text-left text-xs font-semibold text-gray-500 uppercase">Email</th>
                        <th class="px-6 py-3 text-left text-xs font-semibold text-gray-500 uppercase">Phone</th>
                        <th class="px-6 py-3 text-left text-xs font-semibold text-gray-500 uppercase">Role</th>
                        <th class="px-6 py-3 text-left text-xs font-semibold text-gray-500 uppercase">Status</th>
                        <th class="px-6 py-3 text-left text-xs font-semibold text-gray-500 uppercase">Joined</th>
                        <th class="px-6 py-3 text-left text-xs font-semibold text-gray-500 uppercase">Actions</th>
                    </tr></thead>
                    <tbody class="divide-y divide-gray-100">
                    <c:forEach var="u" items="${users}">
                        <tr class="hover:bg-gray-50 transition-colors">
                            <td class="px-6 py-4 text-sm font-medium text-gray-900">${u.fullName}</td>
                            <td class="px-6 py-4 text-sm text-gray-600">${u.email}</td>
                            <td class="px-6 py-4 text-sm text-gray-600">${u.phone != null ? u.phone : '-'}</td>
                            <td class="px-6 py-4"><span class="px-3 py-1 rounded-full text-xs font-bold ${u.role == 'admin' ? 'bg-purple-100 text-purple-700' : 'bg-blue-100 text-blue-700'}">${u.role}</span></td>
                            <td class="px-6 py-4"><span class="px-3 py-1 rounded-full text-xs font-bold ${u.active ? 'bg-green-100 text-green-700' : 'bg-red-100 text-red-700'}">${u.active ? 'Active' : 'Inactive'}</span></td>
                            <td class="px-6 py-4 text-sm text-gray-500">${u.createdAt}</td>
                            <td class="px-6 py-4">
                                <div class="flex items-center space-x-3">
                                    <form method="post" action="${pageContext.request.contextPath}/admin/users" class="inline">
                                        <input type="hidden" name="csrfToken" value="${csrfToken}">
                                        <input type="hidden" name="action" value="toggle">
                                        <input type="hidden" name="userId" value="${u.id}">
                                        <input type="hidden" name="isActive" value="${!u.active}">
                                        <button type="submit" class="text-sm font-medium ${u.active ? 'text-red-600 hover:text-red-700' : 'text-green-600 hover:text-green-700'} transition-colors">
                                                ${u.active ? 'Deactivate' : 'Activate'}
                                        </button>
                                    </form>
                                    <form method="post" action="${pageContext.request.contextPath}/admin/users" class="inline" onsubmit="return confirm('Reset password for ${u.fullName} to reset123?')">
                                        <input type="hidden" name="csrfToken" value="${csrfToken}">
                                        <input type="hidden" name="action" value="resetPassword">
                                        <input type="hidden" name="userId" value="${u.id}">
                                        <button type="submit" class="text-sm font-medium text-gray-500 hover:text-primary-600 transition-colors">
                                            <i class="fas fa-key mr-1"></i>Reset
                                        </button>
                                    </form>
                                </div>
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
