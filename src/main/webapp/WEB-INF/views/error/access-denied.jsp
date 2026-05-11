<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<jsp:include page="/WEB-INF/views/common/header.jsp" />
<jsp:include page="/WEB-INF/views/common/navbar.jsp" />
<main class="flex-1 flex items-center justify-center py-16 px-4">
  <div class="text-center fade-in">
    <div class="w-24 h-24 bg-gradient-to-br from-yellow-100 to-red-100 rounded-3xl flex items-center justify-center mx-auto mb-6">
      <i class="fas fa-ban text-red-500 text-4xl"></i>
    </div>
    <h1 class="text-3xl font-bold text-gray-900 mb-3">Access Denied</h1>
    <p class="text-gray-500 mb-8 max-w-md mx-auto">You don't have permission to access this page. Please login with appropriate credentials.</p>
    <div class="flex justify-center space-x-4">
      <a href="${pageContext.request.contextPath}/home" class="px-8 py-3 bg-primary-600 text-white font-semibold rounded-xl hover:bg-primary-700 transition-all shadow-lg shadow-primary-500/25"><i class="fas fa-home mr-2"></i>Go Home</a>
      <a href="${pageContext.request.contextPath}/login" class="px-8 py-3 border-2 border-gray-200 text-gray-700 font-semibold rounded-xl hover:bg-gray-50 transition-all"><i class="fas fa-sign-in-alt mr-2"></i>Login</a>
    </div>
  </div>
</main>
<jsp:include page="/WEB-INF/views/common/footer.jsp" />
