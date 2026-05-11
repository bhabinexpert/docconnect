<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<jsp:include page="/WEB-INF/views/common/header.jsp" />
<jsp:include page="/WEB-INF/views/common/navbar.jsp" />

<main class="flex-1 flex items-center justify-center py-12 px-4">
    <div class="w-full max-w-md">
        <div class="text-center mb-8 slide-up">
            <div class="w-16 h-16 bg-gradient-to-br from-primary-500 to-accent-500 rounded-2xl flex items-center justify-center mx-auto mb-4 shadow-lg shadow-primary-500/25">
                <i class="fas fa-sign-in-alt text-white text-2xl"></i>
            </div>
            <h1 class="text-3xl font-bold text-gray-900">Welcome Back</h1>
            <p class="text-gray-500 mt-2">Sign in to your DocConnect account</p>
        </div>

        <div class="bg-white rounded-2xl shadow-xl shadow-gray-200/50 p-8 border border-gray-100 fade-in">
            <!-- Success message -->
            <c:if test="${param.success != null}">
                <div class="mb-6 p-4 bg-green-50 border border-green-200 rounded-xl flex items-center space-x-3" id="login-success-msg">
                    <i class="fas fa-check-circle text-green-500"></i>
                    <span class="text-green-700 text-sm">${param.success}</span>
                </div>
            </c:if>

            <!-- Error message -->
            <c:if test="${error != null}">
                <div class="mb-6 p-4 bg-red-50 border border-red-200 rounded-xl flex items-center space-x-3" id="login-error-msg">
                    <i class="fas fa-exclamation-circle text-red-500"></i>
                    <span class="text-red-700 text-sm">${error}</span>
                </div>
            </c:if>

            <c:if test="${param.error != null}">
                <div class="mb-6 p-4 bg-red-50 border border-red-200 rounded-xl flex items-center space-x-3">
                    <i class="fas fa-exclamation-circle text-red-500"></i>
                    <span class="text-red-700 text-sm">${param.error}</span>
                </div>
            </c:if>

            <form method="post" action="${pageContext.request.contextPath}/login" id="loginForm" onsubmit="return validateLoginForm()">
                <input type="hidden" name="csrfToken" value="${csrfToken}">

                <div class="mb-5">
                    <label for="email" class="block text-sm font-semibold text-gray-700 mb-2">Email Address</label>
                    <div class="relative">
                        <div class="absolute inset-y-0 left-0 pl-4 flex items-center pointer-events-none">
                            <i class="fas fa-envelope text-gray-400"></i>
                        </div>
                        <input type="email" id="email" name="email" value="${email}" required
                               class="w-full pl-11 pr-4 py-3 border border-gray-200 rounded-xl focus:ring-2 focus:ring-primary-500 focus:border-primary-500 transition-all text-gray-800 placeholder-gray-400"
                               placeholder="you@example.com">
                    </div>
                    <span id="emailError" class="text-red-500 text-xs mt-1 hidden"></span>
                </div>

                <div class="mb-6">
                    <label for="password" class="block text-sm font-semibold text-gray-700 mb-2">Password</label>
                    <div class="relative">
                        <div class="absolute inset-y-0 left-0 pl-4 flex items-center pointer-events-none">
                            <i class="fas fa-lock text-gray-400"></i>
                        </div>
                        <input type="password" id="password" name="password" required
                               class="w-full pl-11 pr-4 py-3 border border-gray-200 rounded-xl focus:ring-2 focus:ring-primary-500 focus:border-primary-500 transition-all text-gray-800 placeholder-gray-400"
                               placeholder="Enter your password">
                    </div>
                    <span id="passwordError" class="text-red-500 text-xs mt-1 hidden"></span>
                </div>

                <button type="submit" class="w-full py-3.5 bg-gradient-to-r from-primary-600 to-primary-700 text-white font-semibold rounded-xl hover:from-primary-700 hover:to-primary-800 transition-all duration-300 shadow-lg shadow-primary-500/25 flex items-center justify-center" id="loginBtn">
                    <i class="fas fa-sign-in-alt mr-2"></i>Sign In
                </button>
            </form>

            <div class="mt-6 text-center">
                <p class="text-gray-500 text-sm">Don't have an account?
                    <a href="${pageContext.request.contextPath}/register" class="text-primary-600 font-semibold hover:text-primary-700 transition-colors" id="login-to-register">Create one here</a>
                </p>
            </div>

            <%-- ADMIN CREDENTIALS (keep private — never expose in UI)
                 Email : admin@docconnect.com
                 Pass  : admin123
                 Role  : admin
                 Note  : Change this password after first login.
            --%>
        </div>
    </div>
</main>

<script>
    function validateLoginForm() {
        let valid = true;
        const email = document.getElementById('email');
        const password = document.getElementById('password');
        const emailError = document.getElementById('emailError');
        const passwordError = document.getElementById('passwordError');

        // Reset
        emailError.classList.add('hidden');
        passwordError.classList.add('hidden');

        // Email validation
        const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
        if (!email.value.trim() || !emailRegex.test(email.value)) {
            emailError.textContent = 'Please enter a valid email address.';
            emailError.classList.remove('hidden');
            valid = false;
        }

        // Password validation
        if (password.value.length < 1) {
            passwordError.textContent = 'Password is required.';
            passwordError.classList.remove('hidden');
            valid = false;
        }

        return valid;
    }
</script>

<jsp:include page="/WEB-INF/views/common/footer.jsp" />
