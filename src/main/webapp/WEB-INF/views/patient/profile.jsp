<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<jsp:include page="/WEB-INF/views/common/header.jsp" />
<jsp:include page="/WEB-INF/views/common/navbar.jsp" />

<main class="flex-1 bg-gray-50">
    <div class="max-w-4xl mx-auto px-4 sm:px-6 lg:px-8 py-8">
        <h1 class="text-3xl font-bold text-gray-900 mb-8">My Profile</h1>

        <c:if test="${param.success != null}">
            <div class="mb-6 p-4 bg-green-50 border border-green-200 rounded-xl flex items-center space-x-3"><i class="fas fa-check-circle text-green-500"></i><span class="text-green-700 text-sm">${param.success}</span></div>
        </c:if>
        <c:if test="${param.error != null}">
            <div class="mb-6 p-4 bg-red-50 border border-red-200 rounded-xl flex items-center space-x-3"><i class="fas fa-exclamation-circle text-red-500"></i><span class="text-red-700 text-sm">${param.error}</span></div>
        </c:if>

        <c:set var="u" value="${sessionScope.user}" />

        <!-- Profile Photo -->
        <div class="bg-white rounded-2xl shadow-sm border border-gray-100 p-8 mb-6">
            <h2 class="text-xl font-bold text-gray-900 mb-6"><i class="fas fa-image mr-2 text-primary-600"></i>Profile Photo</h2>
            <form method="post" action="${pageContext.request.contextPath}/patient/profile" enctype="multipart/form-data" class="flex items-center space-x-6">
                <input type="hidden" name="csrfToken" value="${csrfToken}">
                <input type="hidden" name="action" value="uploadPhoto">

                <div class="w-24 h-24 rounded-full overflow-hidden bg-primary-100 flex items-center justify-center flex-shrink-0 border-2 border-gray-200">
                    <c:choose>
                        <c:when test="${not empty u.photoUrl}">
                            <img id="photoPreview" src="${u.photoUrl}" alt="Profile photo" class="w-full h-full object-cover">
                        </c:when>
                        <c:otherwise>
                            <img id="photoPreview" src="" alt="" class="w-full h-full object-cover hidden">
                            <span id="photoInitial" class="text-3xl font-bold text-primary-600">${u.fullName.substring(0,1)}</span>
                        </c:otherwise>
                    </c:choose>
                </div>

                <div class="flex-1">
                    <input type="file" name="photo" accept="image/*" required onchange="previewPhoto(event)"
                           class="block w-full text-sm text-gray-600 file:mr-4 file:py-2 file:px-4 file:rounded-lg file:border-0 file:text-sm file:font-semibold file:bg-primary-50 file:text-primary-700 hover:file:bg-primary-100 cursor-pointer">
                    <p class="text-xs text-gray-500 mt-2">JPG, PNG, GIF or WEBP. Max 5 MB.</p>
                    <button type="submit" class="mt-3 px-6 py-2 bg-primary-600 text-white font-semibold rounded-xl hover:bg-primary-700 transition-all text-sm shadow-lg shadow-primary-500/25">
                        <i class="fas fa-upload mr-2"></i>Upload Photo
                    </button>
                </div>
            </form>
        </div>

        <!-- Profile Info -->
        <div class="bg-white rounded-2xl shadow-sm border border-gray-100 p-8 mb-6">
            <h2 class="text-xl font-bold text-gray-900 mb-6"><i class="fas fa-user-edit mr-2 text-primary-600"></i>Personal Information</h2>
            <form method="post" action="${pageContext.request.contextPath}/patient/profile" id="profileForm">
                <input type="hidden" name="csrfToken" value="${csrfToken}">
                <input type="hidden" name="action" value="updateProfile">

                <div class="grid grid-cols-1 md:grid-cols-2 gap-5">
                    <div>
                        <label class="block text-sm font-semibold text-gray-700 mb-2">Full Name *</label>
                        <input type="text" name="fullName" value="${u.fullName}" required
                               class="w-full px-4 py-3 border border-gray-200 rounded-xl focus:ring-2 focus:ring-primary-500 focus:border-primary-500 transition-all">
                    </div>
                    <div>
                        <label class="block text-sm font-semibold text-gray-700 mb-2">Email</label>
                        <input type="email" value="${u.email}" disabled
                               class="w-full px-4 py-3 border border-gray-200 rounded-xl bg-gray-50 text-gray-500">
                    </div>
                    <div>
                        <label class="block text-sm font-semibold text-gray-700 mb-2">Phone Number</label>
                        <input type="tel" name="phone" value="${u.phone}"
                               class="w-full px-4 py-3 border border-gray-200 rounded-xl focus:ring-2 focus:ring-primary-500 focus:border-primary-500 transition-all">
                    </div>
                    <div>
                        <label class="block text-sm font-semibold text-gray-700 mb-2">Gender</label>
                        <select name="gender" class="w-full px-4 py-3 border border-gray-200 rounded-xl focus:ring-2 focus:ring-primary-500 focus:border-primary-500 transition-all">
                            <option value="">Select</option>
                            <option value="Male" ${u.gender == 'Male' ? 'selected' : ''}>Male</option>
                            <option value="Female" ${u.gender == 'Female' ? 'selected' : ''}>Female</option>
                            <option value="Other" ${u.gender == 'Other' ? 'selected' : ''}>Other</option>
                        </select>
                    </div>
                    <div>
                        <label class="block text-sm font-semibold text-gray-700 mb-2">Date of Birth</label>
                        <input type="date" name="dateOfBirth" value="${u.dateOfBirth}"
                               class="w-full px-4 py-3 border border-gray-200 rounded-xl focus:ring-2 focus:ring-primary-500 focus:border-primary-500 transition-all">
                    </div>
                    <div>
                        <label class="block text-sm font-semibold text-gray-700 mb-2">Address</label>
                        <input type="text" name="address" value="${u.address}" placeholder="City, District"
                               class="w-full px-4 py-3 border border-gray-200 rounded-xl focus:ring-2 focus:ring-primary-500 focus:border-primary-500 transition-all">
                    </div>
                </div>
                <div class="mt-6">
                    <button type="submit" class="px-8 py-3 bg-primary-600 text-white font-semibold rounded-xl hover:bg-primary-700 transition-all shadow-lg shadow-primary-500/25" id="updateProfileBtn">
                        <i class="fas fa-save mr-2"></i>Update Profile
                    </button>
                </div>
            </form>
        </div>

        <!-- Change Password -->
        <div class="bg-white rounded-2xl shadow-sm border border-gray-100 p-8">
            <h2 class="text-xl font-bold text-gray-900 mb-6"><i class="fas fa-lock mr-2 text-accent-600"></i>Change Password</h2>
            <form method="post" action="${pageContext.request.contextPath}/patient/profile" id="passwordForm" onsubmit="return validatePasswordForm()">
                <input type="hidden" name="csrfToken" value="${csrfToken}">
                <input type="hidden" name="action" value="changePassword">

                <div class="space-y-5 max-w-md">
                    <div>
                        <label class="block text-sm font-semibold text-gray-700 mb-2">Current Password *</label>
                        <input type="password" name="currentPassword" required
                               class="w-full px-4 py-3 border border-gray-200 rounded-xl focus:ring-2 focus:ring-primary-500 focus:border-primary-500 transition-all" id="currentPassword">
                    </div>
                    <div>
                        <label class="block text-sm font-semibold text-gray-700 mb-2">New Password *</label>
                        <input type="password" name="newPassword" required minlength="6"
                               class="w-full px-4 py-3 border border-gray-200 rounded-xl focus:ring-2 focus:ring-primary-500 focus:border-primary-500 transition-all" id="newPassword">
                    </div>
                    <div>
                        <label class="block text-sm font-semibold text-gray-700 mb-2">Confirm New Password *</label>
                        <input type="password" name="confirmPassword" required
                               class="w-full px-4 py-3 border border-gray-200 rounded-xl focus:ring-2 focus:ring-primary-500 focus:border-primary-500 transition-all" id="confirmNewPassword">
                        <span id="pwMatchError" class="text-red-500 text-xs mt-1 hidden">Passwords do not match</span>
                    </div>
                    <button type="submit" class="px-8 py-3 bg-accent-600 text-white font-semibold rounded-xl hover:bg-accent-700 transition-all shadow-lg shadow-accent-500/25" id="changePasswordBtn">
                        <i class="fas fa-key mr-2"></i>Change Password
                    </button>
                </div>
            </form>
        </div>
    </div>
</main>

<script>
    function previewPhoto(e) {
        const file = e.target.files && e.target.files[0];
        if (!file) return;
        const img = document.getElementById('photoPreview');
        const initial = document.getElementById('photoInitial');
        img.src = URL.createObjectURL(file);
        img.classList.remove('hidden');
        if (initial) initial.classList.add('hidden');
    }
    function validatePasswordForm() {
        const np = document.getElementById('newPassword').value;
        const cp = document.getElementById('confirmNewPassword').value;
        const err = document.getElementById('pwMatchError');
        if (np !== cp) { err.classList.remove('hidden'); return false; }
        if (np.length < 6) { alert('Password must be at least 6 characters.'); return false; }
        err.classList.add('hidden');
        return true;
    }
</script>

<jsp:include page="/WEB-INF/views/common/footer.jsp" />
