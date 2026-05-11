<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<jsp:include page="/WEB-INF/views/common/header.jsp" />
<jsp:include page="/WEB-INF/views/common/navbar.jsp" />

<main class="flex-1 bg-gray-50">
    <div class="max-w-3xl mx-auto px-4 sm:px-6 lg:px-8 py-8">
        <a href="${pageContext.request.contextPath}/admin/doctors" class="inline-flex items-center text-primary-600 hover:text-primary-700 font-medium mb-6"><i class="fas fa-arrow-left mr-2"></i>Back to Doctors</a>
        <h1 class="text-3xl font-bold text-gray-900 mb-8">${doctor != null ? 'Edit Doctor' : 'Add New Doctor'}</h1>

        <c:if test="${error != null}"><div class="mb-6 p-4 bg-red-50 border border-red-200 rounded-xl flex items-center space-x-3"><i class="fas fa-exclamation-circle text-red-500"></i><span class="text-red-700 text-sm">${error}</span></div></c:if>

        <div class="bg-white rounded-2xl shadow-sm border border-gray-100 p-8">
            <form method="post" action="${pageContext.request.contextPath}/admin/doctors" id="doctorForm">
                <input type="hidden" name="csrfToken" value="${csrfToken}">
                <input type="hidden" name="action" value="save">
                <c:if test="${doctor != null}"><input type="hidden" name="id" value="${doctor.id}"></c:if>

                <div class="grid grid-cols-1 md:grid-cols-2 gap-5">
                    <div class="md:col-span-2">
                        <label class="block text-sm font-semibold text-gray-700 mb-2">Full Name *</label>
                        <input type="text" name="fullName" value="${doctor != null ? doctor.fullName : ''}" required class="w-full px-4 py-3 border border-gray-200 rounded-xl focus:ring-2 focus:ring-primary-500 focus:border-primary-500 transition-all">
                    </div>
                    <div>
                        <label class="block text-sm font-semibold text-gray-700 mb-2">Email</label>
                        <input type="email" name="email" value="${doctor != null ? doctor.email : ''}" class="w-full px-4 py-3 border border-gray-200 rounded-xl focus:ring-2 focus:ring-primary-500 focus:border-primary-500 transition-all">
                    </div>
                    <div>
                        <label class="block text-sm font-semibold text-gray-700 mb-2">Phone</label>
                        <input type="tel" name="phone" value="${doctor != null ? doctor.phone : ''}" class="w-full px-4 py-3 border border-gray-200 rounded-xl focus:ring-2 focus:ring-primary-500 focus:border-primary-500 transition-all">
                    </div>
                    <div>
                        <label class="block text-sm font-semibold text-gray-700 mb-2">Specialization *</label>
                        <select name="specializationId" required class="w-full px-4 py-3 border border-gray-200 rounded-xl focus:ring-2 focus:ring-primary-500 focus:border-primary-500 transition-all">
                            <option value="">Select</option>
                            <c:forEach var="spec" items="${specializations}">
                                <option value="${spec.id}" ${doctor != null && doctor.specializationId == spec.id ? 'selected' : ''}>${spec.name}</option>
                            </c:forEach>
                        </select>
                    </div>
                    <div>
                        <label class="block text-sm font-semibold text-gray-700 mb-2">Gender</label>
                        <select name="gender" class="w-full px-4 py-3 border border-gray-200 rounded-xl focus:ring-2 focus:ring-primary-500 focus:border-primary-500 transition-all">
                            <option value="">Select</option>
                            <option value="Male" ${doctor != null && doctor.gender == 'Male' ? 'selected' : ''}>Male</option>
                            <option value="Female" ${doctor != null && doctor.gender == 'Female' ? 'selected' : ''}>Female</option>
                            <option value="Other" ${doctor != null && doctor.gender == 'Other' ? 'selected' : ''}>Other</option>
                        </select>
                    </div>
                    <div>
                        <label class="block text-sm font-semibold text-gray-700 mb-2">Qualification *</label>
                        <input type="text" name="qualification" value="${doctor != null ? doctor.qualification : ''}" required class="w-full px-4 py-3 border border-gray-200 rounded-xl focus:ring-2 focus:ring-primary-500 focus:border-primary-500 transition-all" placeholder="e.g. MBBS, MD">
                    </div>
                    <div>
                        <label class="block text-sm font-semibold text-gray-700 mb-2">Experience (years)</label>
                        <input type="number" name="experienceYears" value="${doctor != null ? doctor.experienceYears : 0}" min="0" class="w-full px-4 py-3 border border-gray-200 rounded-xl focus:ring-2 focus:ring-primary-500 focus:border-primary-500 transition-all">
                    </div>
                    <div>
                        <label class="block text-sm font-semibold text-gray-700 mb-2">Consultation Fee (Rs.) *</label>
                        <input type="number" name="consultationFee" value="${doctor != null ? doctor.consultationFee : ''}" required min="0" step="0.01" class="w-full px-4 py-3 border border-gray-200 rounded-xl focus:ring-2 focus:ring-primary-500 focus:border-primary-500 transition-all">
                    </div>
                    <div class="md:col-span-2">
                        <label class="block text-sm font-semibold text-gray-700 mb-2">Bio</label>
                        <textarea name="bio" rows="4" class="w-full px-4 py-3 border border-gray-200 rounded-xl focus:ring-2 focus:ring-primary-500 focus:border-primary-500 transition-all">${doctor != null ? doctor.bio : ''}</textarea>
                    </div>
                    <div class="flex items-center">
                        <input type="checkbox" name="isActive" id="isActive" ${doctor == null || doctor.active ? 'checked' : ''} class="w-4 h-4 text-primary-600 rounded border-gray-300 focus:ring-primary-500">
                        <label for="isActive" class="ml-2 text-sm font-semibold text-gray-700">Active</label>
                    </div>
                </div>

                <div class="mt-8 flex space-x-4">
                    <button type="submit" class="px-8 py-3 bg-primary-600 text-white font-semibold rounded-xl hover:bg-primary-700 transition-all shadow-lg shadow-primary-500/25" id="saveDoctorBtn">
                        <i class="fas fa-save mr-2"></i>${doctor != null ? 'Update Doctor' : 'Add Doctor'}
                    </button>
                    <a href="${pageContext.request.contextPath}/admin/doctors" class="px-8 py-3 border-2 border-gray-200 text-gray-700 font-semibold rounded-xl hover:bg-gray-50 transition-all">Cancel</a>
                </div>
            </form>
        </div>
    </div>
</main>
<jsp:include page="/WEB-INF/views/common/footer.jsp" />
