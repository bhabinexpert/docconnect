<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<jsp:include page="/WEB-INF/views/common/header.jsp" />
<jsp:include page="/WEB-INF/views/common/navbar.jsp" />

<main class="flex-1 flex items-center justify-center py-12 px-4">
    <div class="w-full max-w-md">
        <div class="text-center mb-8 slide-up">
            <div class="w-16 h-16 bg-gradient-to-br from-accent-500 to-primary-500 rounded-2xl flex items-center justify-center mx-auto mb-4 shadow-lg shadow-accent-500/25">
                <i class="fas fa-user-plus text-white text-2xl"></i>
            </div>
            <h1 class="text-3xl font-bold text-gray-900">Create Account</h1>
            <p class="text-gray-500 mt-2">Join DocConnect Nepal today</p>
        </div>

        <div class="bg-white rounded-2xl shadow-xl shadow-gray-200/50 p-8 border border-gray-100 fade-in">
            <c:if test="${error != null}">
                <div class="mb-6 p-4 bg-red-50 border border-red-200 rounded-xl flex items-center space-x-3" id="register-error-msg">
                    <i class="fas fa-exclamation-circle text-red-500"></i>
                    <span class="text-red-700 text-sm">${error}</span>
                </div>
            </c:if>

            <form method="post" action="${pageContext.request.contextPath}/register" id="registerForm" onsubmit="return validateRegisterForm()">
                <input type="hidden" name="csrfToken" value="${csrfToken}">

                <div class="mb-4">
                    <label for="fullName" class="block text-sm font-semibold text-gray-700 mb-2">Full Name *</label>
                    <div class="relative">
                        <div class="absolute inset-y-0 left-0 pl-4 flex items-center pointer-events-none"><i class="fas fa-user text-gray-400"></i></div>
                        <input type="text" id="fullName" name="fullName" value="${fullName}" required
                               class="w-full pl-11 pr-4 py-3 border border-gray-200 rounded-xl focus:ring-2 focus:ring-primary-500 focus:border-primary-500 transition-all"
                               placeholder="Enter your full name">
                    </div>
                    <span id="fullNameError" class="text-red-500 text-xs mt-1 hidden"></span>
                </div>

                <div class="mb-4">
                    <label for="regEmail" class="block text-sm font-semibold text-gray-700 mb-2">Email Address *</label>
                    <div class="relative">
                        <div class="absolute inset-y-0 left-0 pl-4 flex items-center pointer-events-none"><i class="fas fa-envelope text-gray-400"></i></div>
                        <input type="email" id="regEmail" name="email" value="${email}" required
                               class="w-full pl-11 pr-4 py-3 border border-gray-200 rounded-xl focus:ring-2 focus:ring-primary-500 focus:border-primary-500 transition-all"
                               placeholder="you@example.com">
                    </div>
                    <span id="regEmailError" class="text-red-500 text-xs mt-1 hidden"></span>
                </div>

                <div class="mb-4">
                    <label for="phone" class="block text-sm font-semibold text-gray-700 mb-2">Phone Number</label>
                    <div class="relative">
                        <div class="absolute inset-y-0 left-0 pl-4 flex items-center pointer-events-none"><i class="fas fa-phone text-gray-400"></i></div>
                        <input type="tel" id="phone" name="phone" value="${phone}"
                               class="w-full pl-11 pr-4 py-3 border border-gray-200 rounded-xl focus:ring-2 focus:ring-primary-500 focus:border-primary-500 transition-all"
                               placeholder="98XXXXXXXX">
                    </div>
                    <span id="phoneError" class="text-red-500 text-xs mt-1 hidden"></span>
                </div>

                <div class="mb-4">
                    <label for="gender" class="block text-sm font-semibold text-gray-700 mb-2">Gender</label>
                    <select id="gender" name="gender" class="w-full px-4 py-3 border border-gray-200 rounded-xl focus:ring-2 focus:ring-primary-500 focus:border-primary-500 transition-all text-gray-700">
                        <option value="">Select Gender</option>
                        <option value="Male" ${gender == 'Male' ? 'selected' : ''}>Male</option>
                        <option value="Female" ${gender == 'Female' ? 'selected' : ''}>Female</option>
                        <option value="Other" ${gender == 'Other' ? 'selected' : ''}>Other</option>
                    </select>
                </div>

                <div class="mb-4">
                    <label for="regPassword" class="block text-sm font-semibold text-gray-700 mb-2">Password *</label>
                    <div class="relative">
                        <div class="absolute inset-y-0 left-0 pl-4 flex items-center pointer-events-none"><i class="fas fa-lock text-gray-400"></i></div>
                        <input type="password" id="regPassword" name="password" required
                               class="w-full pl-11 pr-4 py-3 border border-gray-200 rounded-xl focus:ring-2 focus:ring-primary-500 focus:border-primary-500 transition-all"
                               placeholder="Min 6 characters">
                    </div>
                    <span id="regPasswordError" class="text-red-500 text-xs mt-1 hidden"></span>
                </div>

                <div class="mb-6">
                    <label for="confirmPassword" class="block text-sm font-semibold text-gray-700 mb-2">Confirm Password *</label>
                    <div class="relative">
                        <div class="absolute inset-y-0 left-0 pl-4 flex items-center pointer-events-none"><i class="fas fa-lock text-gray-400"></i></div>
                        <input type="password" id="confirmPassword" name="confirmPassword" required
                               class="w-full pl-11 pr-4 py-3 border border-gray-200 rounded-xl focus:ring-2 focus:ring-primary-500 focus:border-primary-500 transition-all"
                               placeholder="Repeat password">
                    </div>
                    <span id="confirmPasswordError" class="text-red-500 text-xs mt-1 hidden"></span>
                </div>

                <button type="submit" class="w-full py-3.5 bg-gradient-to-r from-accent-600 to-primary-600 text-white font-semibold rounded-xl hover:from-accent-700 hover:to-primary-700 transition-all duration-300 shadow-lg shadow-accent-500/25 flex items-center justify-center" id="registerBtn">
                    <i class="fas fa-user-plus mr-2"></i>Create Account
                </button>
            </form>

            <div class="mt-6 text-center">
                <p class="text-gray-500 text-sm">Already have an account?
                    <a href="${pageContext.request.contextPath}/login" class="text-primary-600 font-semibold hover:text-primary-700 transition-colors">Sign in here</a>
                </p>
            </div>
        </div>
    </div>
</main>

<script>
    function validateRegisterForm() {
        let valid = true;
        const fields = [
            { id: 'fullName', errId: 'fullNameError', check: v => v.trim().length >= 2, msg: 'Full name is required (min 2 chars).' },
            { id: 'regEmail', errId: 'regEmailError', check: v => /^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(v), msg: 'Please enter a valid email.' },
            { id: 'phone', errId: 'phoneError', check: v => !v || /^\d{10}$/.test(v), msg: 'Phone must be 10 digits.' },
            { id: 'regPassword', errId: 'regPasswordError', check: v => v.length >= 6, msg: 'Password must be at least 6 characters.' },
            { id: 'confirmPassword', errId: 'confirmPasswordError', check: v => v === document.getElementById('regPassword').value, msg: 'Passwords do not match.' }
        ];

        fields.forEach(f => {
            const el = document.getElementById(f.id);
            const err = document.getElementById(f.errId);
            err.classList.add('hidden');
            if (!f.check(el.value)) {
                err.textContent = f.msg;
                err.classList.remove('hidden');
                valid = false;
            }
        });
        return valid;
    }
</script>

<jsp:include page="/WEB-INF/views/common/footer.jsp" />
