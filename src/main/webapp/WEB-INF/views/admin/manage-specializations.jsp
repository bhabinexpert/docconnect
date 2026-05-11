<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<jsp:include page="/WEB-INF/views/common/header.jsp" />
<jsp:include page="/WEB-INF/views/common/navbar.jsp" />

<main class="flex-1 bg-gray-50">
    <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-8">
        <h1 class="text-3xl font-bold text-gray-900 mb-8">Manage <span class="gradient-text">Specializations</span></h1>

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

        <c:if test="${error != null}">
            <div class="mb-6 p-4 bg-red-50 border border-red-200 rounded-xl flex items-center space-x-3">
                <i class="fas fa-exclamation-circle text-red-500"></i>
                <span class="text-red-700 text-sm">${error}</span>
            </div>
        </c:if>

        <div class="grid grid-cols-1 lg:grid-cols-3 gap-8">
            <!-- Form -->
            <div class="lg:col-span-1">
                <div class="bg-white rounded-2xl shadow-sm border border-gray-100 p-6 sticky top-8">
                    <h2 class="text-lg font-bold text-gray-900 mb-4">
                        <i class="fas ${specialization != null ? 'fa-edit' : 'fa-plus-circle'} mr-2 text-primary-600"></i>
                        ${specialization != null ? 'Edit' : 'Add New'} Specialization
                    </h2>
                    <form method="post" action="${pageContext.request.contextPath}/admin/specializations">
                        <input type="hidden" name="csrfToken" value="${csrfToken}">
                        <input type="hidden" name="action" value="save">
                        <input type="hidden" name="id" value="${specialization.id}">

                        <div class="space-y-4">
                            <div>
                                <label class="block text-sm font-semibold text-gray-700 mb-2">Name *</label>
                                <input type="text" name="name" value="${specialization.name}" required
                                       class="w-full px-4 py-3 border border-gray-200 rounded-xl focus:ring-2 focus:ring-primary-500 transition-all"
                                       placeholder="e.g. Cardiology">
                            </div>
                            <div>
                                <label class="block text-sm font-semibold text-gray-700 mb-2">Icon Class (FontAwesome)</label>
                                <input type="text" name="iconClass" value="${specialization.iconClass}"
                                       class="w-full px-4 py-3 border border-gray-200 rounded-xl focus:ring-2 focus:ring-primary-500 transition-all"
                                       placeholder="e.g. fa-heartbeat">
                            </div>
                            <div>
                                <label class="block text-sm font-semibold text-gray-700 mb-2">Description</label>
                                <textarea name="description" rows="3"
                                          class="w-full px-4 py-3 border border-gray-200 rounded-xl focus:ring-2 focus:ring-primary-500 transition-all"
                                          placeholder="Brief description...">${specialization.description}</textarea>
                            </div>
                            <div class="pt-2 flex space-x-3">
                                <button type="submit" class="flex-1 px-6 py-3 bg-primary-600 text-white font-semibold rounded-xl hover:bg-primary-700 transition-all shadow-lg shadow-primary-500/25">
                                    ${specialization != null ? 'Update' : 'Add'}
                                </button>
                                <c:if test="${specialization != null}">
                                    <a href="${pageContext.request.contextPath}/admin/specializations" 
                                       class="px-6 py-3 bg-gray-100 text-gray-700 font-semibold rounded-xl hover:bg-gray-200 transition-all text-center">
                                        Cancel
                                    </a>
                                </c:if>
                            </div>
                        </div>
                    </form>
                </div>
            </div>

            <!-- Table -->
            <div class="lg:col-span-2">
                <div class="bg-white rounded-2xl shadow-sm border border-gray-100 overflow-hidden">
                    <div class="overflow-x-auto">
                        <table class="w-full">
                            <thead class="bg-gray-50">
                                <tr>
                                    <th class="px-6 py-3 text-left text-xs font-semibold text-gray-500 uppercase">Icon</th>
                                    <th class="px-6 py-3 text-left text-xs font-semibold text-gray-500 uppercase">Name</th>
                                    <th class="px-6 py-3 text-left text-xs font-semibold text-gray-500 uppercase">Description</th>
                                    <th class="px-6 py-3 text-right text-xs font-semibold text-gray-500 uppercase">Actions</th>
                                </tr>
                            </thead>
                            <tbody class="divide-y divide-gray-100">
                                <c:forEach var="spec" items="${specializations}">
                                    <tr class="hover:bg-gray-50 transition-colors">
                                        <td class="px-6 py-4">
                                            <div class="w-10 h-10 bg-gray-100 rounded-lg flex items-center justify-center text-primary-600">
                                                <i class="fas ${not empty spec.iconClass ? spec.iconClass : 'fa-stethoscope'} text-lg"></i>
                                            </div>
                                        </td>
                                        <td class="px-6 py-4 text-sm font-bold text-gray-900">${spec.name}</td>
                                        <td class="px-6 py-4 text-sm text-gray-600 max-w-xs truncate">${spec.description}</td>
                                        <td class="px-6 py-4 text-right">
                                            <div class="flex justify-end space-x-3">
                                                <a href="${pageContext.request.contextPath}/admin/specializations?action=edit&id=${spec.id}" 
                                                   class="text-primary-600 hover:text-primary-700 font-medium text-sm">
                                                    <i class="fas fa-edit"></i>
                                                </a>
                                                <form method="post" action="${pageContext.request.contextPath}/admin/specializations" class="inline" onsubmit="return confirm('Delete this specialization?')">
                                                    <input type="hidden" name="csrfToken" value="${csrfToken}">
                                                    <input type="hidden" name="action" value="delete">
                                                    <input type="hidden" name="id" value="${spec.id}">
                                                    <button type="submit" class="text-red-600 hover:text-red-700 font-medium text-sm">
                                                        <i class="fas fa-trash"></i>
                                                    </button>
                                                </form>
                                            </div>
                                        </td>
                                    </tr>
                                </c:forEach>
                                <c:if test="${empty specializations}">
                                    <tr>
                                        <td colspan="4" class="px-6 py-8 text-center text-gray-500">No specializations found.</td>
                                    </tr>
                                </c:if>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div>
    </div>
</main>

<jsp:include page="/WEB-INF/views/common/footer.jsp" />
