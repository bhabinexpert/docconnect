<%@ page contentType="text/html;charset=UTF-8" language="java" isErrorPage="true" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<jsp:include page="/WEB-INF/views/common/header.jsp" />
<jsp:include page="/WEB-INF/views/common/navbar.jsp" />
<main class="flex-1 flex items-center justify-center py-16 px-4">
    <div class="text-center fade-in">
        <div class="w-24 h-24 bg-gradient-to-br from-red-100 to-orange-100 rounded-3xl flex items-center justify-center mx-auto mb-6">
            <span class="text-5xl font-extrabold text-red-500">500</span>
        </div>
        <h1 class="text-3xl font-bold text-gray-900 mb-3">Server Error</h1>
        <p class="text-gray-500 mb-8 max-w-md mx-auto">Something went wrong on our end. Please try again later or contact support.</p>
        <div class="flex justify-center space-x-4">
            <a href="${pageContext.request.contextPath}/home" class="px-8 py-3 bg-primary-600 text-white font-semibold rounded-xl hover:bg-primary-700 transition-all shadow-lg shadow-primary-500/25"><i class="fas fa-home mr-2"></i>Go Home</a>
        </div>
    </div>
</main>
<jsp:include page="/WEB-INF/views/common/footer.jsp" />
