<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!-- Navigation Bar -->
<c:choose>
<%-- ═══════════════════════════════════════════════════════════
     ADMIN NAVBAR — management-focused, no patient-facing links
     ═══════════════════════════════════════════════════════════ --%>
<c:when test="${sessionScope.userRole == 'admin'}">
<nav class="bg-gray-900 shadow-lg sticky top-0 z-50 border-b border-gray-700">
    <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <div class="flex justify-between items-center h-14">
            <!-- Logo -->
            <a href="${pageContext.request.contextPath}/admin/dashboard" class="flex items-center space-x-3 group">
                <div class="w-8 h-8 bg-gradient-to-br from-primary-500 to-accent-500 rounded-lg flex items-center justify-center shadow-lg">
                    <i class="fas fa-heartbeat text-white text-sm"></i>
                </div>
                <span class="text-base font-bold text-white">DocConnect</span>
                <span class="text-xs font-bold text-amber-400 bg-amber-400/15 px-2 py-0.5 rounded-full">Admin</span>
            </a>

            <!-- Admin Quick Nav (Desktop) -->
            <div class="hidden md:flex items-center space-x-1">
                <a href="${pageContext.request.contextPath}/admin/dashboard"
                   class="px-3 py-2 rounded-lg text-gray-300 hover:text-white hover:bg-white/10 transition-all duration-200 font-medium text-sm flex items-center gap-1.5" id="nav-admin-dash">
                    <i class="fas fa-tachometer-alt"></i><span>Dashboard</span>
                </a>
                <a href="${pageContext.request.contextPath}/admin/doctors"
                   class="px-3 py-2 rounded-lg text-gray-300 hover:text-white hover:bg-white/10 transition-all duration-200 font-medium text-sm flex items-center gap-1.5" id="nav-admin-doctors">
                    <i class="fas fa-user-md"></i><span>Doctors</span>
                </a>
                <a href="${pageContext.request.contextPath}/admin/specializations"
                   class="px-3 py-2 rounded-lg text-gray-300 hover:text-white hover:bg-white/10 transition-all duration-200 font-medium text-sm flex items-center gap-1.5" id="nav-admin-specs">
                    <i class="fas fa-stethoscope"></i><span>Specialties</span>
                </a>
                <a href="${pageContext.request.contextPath}/admin/slots"
                   class="px-3 py-2 rounded-lg text-gray-300 hover:text-white hover:bg-white/10 transition-all duration-200 font-medium text-sm flex items-center gap-1.5" id="nav-admin-slots">
                    <i class="fas fa-calendar-alt"></i><span>Slots</span>
                </a>
                <a href="${pageContext.request.contextPath}/admin/appointments"
                   class="px-3 py-2 rounded-lg text-gray-300 hover:text-white hover:bg-white/10 transition-all duration-200 font-medium text-sm flex items-center gap-1.5" id="nav-admin-apts">
                    <i class="fas fa-calendar-check"></i><span>Appointments</span>
                </a>
                <a href="${pageContext.request.contextPath}/admin/users"
                   class="px-3 py-2 rounded-lg text-gray-300 hover:text-white hover:bg-white/10 transition-all duration-200 font-medium text-sm flex items-center gap-1.5" id="nav-admin-users">
                    <i class="fas fa-users-cog"></i><span>Users</span>
                </a>
                <a href="${pageContext.request.contextPath}/admin/reports"
                   class="px-3 py-2 rounded-lg text-gray-300 hover:text-white hover:bg-white/10 transition-all duration-200 font-medium text-sm flex items-center gap-1.5" id="nav-admin-reports">
                    <i class="fas fa-chart-bar"></i><span>Reports</span>
                </a>

                <!-- Admin user / logout -->
                <div class="relative ml-2 group">
                    <button class="flex items-center space-x-2 px-3 py-2 rounded-lg bg-white/10 text-white hover:bg-white/20 transition-all duration-200 font-medium text-sm">
                        <div class="w-6 h-6 bg-amber-500 rounded-full flex items-center justify-center">
                            <span class="text-white text-xs font-bold">${sessionScope.userName.substring(0, 1)}</span>
                        </div>
                        <span class="hidden lg:inline text-sm">${sessionScope.userName}</span>
                        <i class="fas fa-chevron-down text-xs opacity-60"></i>
                    </button>
                    <div class="absolute right-0 mt-2 w-44 bg-white rounded-xl shadow-xl border border-gray-100 py-1 opacity-0 invisible group-hover:opacity-100 group-hover:visible transition-all duration-200 z-50">
                        <a href="${pageContext.request.contextPath}/logout" class="block px-4 py-2.5 text-sm text-red-600 hover:bg-red-50 transition-colors">
                            <i class="fas fa-sign-out-alt mr-2"></i>Logout
                        </a>
                    </div>
                </div>
            </div>

            <!-- Mobile menu toggle -->
            <button class="md:hidden p-2 rounded-lg hover:bg-white/10 transition-colors text-gray-300"
                    onclick="document.getElementById('adminMobileMenu').classList.toggle('hidden')">
                <i class="fas fa-bars text-lg"></i>
            </button>
        </div>

        <!-- Admin Mobile Menu -->
        <div id="adminMobileMenu" class="hidden md:hidden pb-4 border-t border-gray-700 mt-2 pt-4 space-y-1">
            <a href="${pageContext.request.contextPath}/admin/dashboard" class="block px-4 py-2.5 rounded-lg text-gray-300 hover:bg-white/10 hover:text-white transition-all font-medium text-sm"><i class="fas fa-tachometer-alt mr-2 w-5"></i>Dashboard</a>
            <a href="${pageContext.request.contextPath}/admin/doctors" class="block px-4 py-2.5 rounded-lg text-gray-300 hover:bg-white/10 hover:text-white transition-all font-medium text-sm"><i class="fas fa-user-md mr-2 w-5"></i>Doctors</a>
            <a href="${pageContext.request.contextPath}/admin/specializations" class="block px-4 py-2.5 rounded-lg text-gray-300 hover:bg-white/10 hover:text-white transition-all font-medium text-sm"><i class="fas fa-stethoscope mr-2 w-5"></i>Specialties</a>
            <a href="${pageContext.request.contextPath}/admin/slots" class="block px-4 py-2.5 rounded-lg text-gray-300 hover:bg-white/10 hover:text-white transition-all font-medium text-sm"><i class="fas fa-calendar-alt mr-2 w-5"></i>Slots</a>
            <a href="${pageContext.request.contextPath}/admin/appointments" class="block px-4 py-2.5 rounded-lg text-gray-300 hover:bg-white/10 hover:text-white transition-all font-medium text-sm"><i class="fas fa-calendar-check mr-2 w-5"></i>Appointments</a>
            <a href="${pageContext.request.contextPath}/admin/users" class="block px-4 py-2.5 rounded-lg text-gray-300 hover:bg-white/10 hover:text-white transition-all font-medium text-sm"><i class="fas fa-users-cog mr-2 w-5"></i>Users</a>
            <a href="${pageContext.request.contextPath}/admin/reports" class="block px-4 py-2.5 rounded-lg text-gray-300 hover:bg-white/10 hover:text-white transition-all font-medium text-sm"><i class="fas fa-chart-bar mr-2 w-5"></i>Reports</a>
            <hr class="border-gray-700 my-2">
            <a href="${pageContext.request.contextPath}/logout" class="block px-4 py-2.5 rounded-lg text-red-400 hover:bg-red-900/30 transition-all font-medium text-sm"><i class="fas fa-sign-out-alt mr-2 w-5"></i>Logout</a>
        </div>
    </div>
</nav>
</c:when>

<%-- ═══════════════════════════════════════════════════════════
     PATIENT / GUEST NAVBAR — booking-focused
     ═══════════════════════════════════════════════════════════ --%>
<c:otherwise>
<nav class="bg-white/95 backdrop-blur-md shadow-sm sticky top-0 z-50 border-b border-gray-100">
    <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <div class="flex justify-between items-center h-16">
            <!-- Logo -->
            <a href="${pageContext.request.contextPath}/home" class="flex items-center space-x-3 group" id="nav-logo">
                <div class="w-10 h-10 bg-gradient-to-br from-primary-600 to-accent-500 rounded-xl flex items-center justify-center shadow-lg group-hover:shadow-primary-500/30 transition-all duration-300">
                    <i class="fas fa-heartbeat text-white text-lg"></i>
                </div>
                <span class="text-xl font-bold gradient-text">DocConnect</span>
                <span class="text-xs font-semibold text-accent-600 bg-accent-50 px-2 py-0.5 rounded-full hidden sm:inline">Nepal</span>
            </a>

            <!-- Global Search (Desktop) -->
            <div class="hidden lg:block flex-1 max-w-sm mx-10 relative">
                <form action="${pageContext.request.contextPath}/doctors" method="get" class="relative group" id="nav-search-form">
                    <div class="absolute inset-y-0 left-0 pl-3 flex items-center pointer-events-none">
                        <i class="fas fa-search text-gray-400 group-focus-within:text-primary-500 transition-colors"></i>
                    </div>
                    <input type="text" name="keyword" id="nav-search-input" placeholder="Search doctors, specialties..." autoComplete="off"
                           class="block w-full pl-10 pr-3 py-2 border border-gray-200 rounded-xl leading-5 bg-gray-50 placeholder-gray-400 focus:outline-none focus:bg-white focus:ring-2 focus:ring-primary-500/10 focus:border-primary-500 sm:text-sm transition-all duration-200">
                </form>
                <!-- Live Search Dropdown -->
                <div id="search-results" class="absolute left-0 right-0 mt-2 bg-white rounded-xl shadow-2xl border border-gray-100 py-2 hidden z-50 overflow-hidden slide-up">
                    <div id="results-container" class="max-h-80 overflow-y-auto"></div>
                    <div class="px-4 py-2 bg-gray-50 border-t border-gray-100 text-center">
                        <a href="javascript:void(0)" onclick="document.getElementById('nav-search-form').submit()" class="text-xs font-bold text-primary-600 hover:text-primary-700">View all results</a>
                    </div>
                </div>
            </div>

            <script>
                function initLiveSearch(inputId, boxId, containerId) {
                    const input = document.getElementById(inputId);
                    const box = document.getElementById(boxId);
                    const container = document.getElementById(containerId);
                    let debounceTimer;
                    if (!input || !box || !container) return;
                    input.addEventListener('input', function() {
                        clearTimeout(debounceTimer);
                        const query = this.value.trim();
                        if (query.length < 2) { box.classList.add('hidden'); return; }
                        debounceTimer = setTimeout(() => {
                            fetch('${pageContext.request.contextPath}/api/search/doctors?q=' + encodeURIComponent(query))
                                .then(res => res.json())
                                .then(data => {
                                    container.innerHTML = '';
                                    if (data.length === 0) {
                                        container.innerHTML = '<div class="px-4 py-3 text-sm text-gray-500 text-center">No doctors found</div>';
                                    } else {
                                        data.forEach(doc => {
                                            const item = document.createElement('a');
                                            item.href = '${pageContext.request.contextPath}/doctor?id=' + doc.id;
                                            item.className = 'flex items-center space-x-3 px-4 py-3 hover:bg-primary-50 transition-colors border-b border-gray-50 last:border-0';
                                            item.innerHTML = `<div class="w-8 h-8 bg-primary-100 rounded-lg flex items-center justify-center flex-shrink-0"><i class="fas fa-user-md text-primary-600 text-xs"></i></div><div class="min-w-0"><div class="text-sm font-bold text-gray-900 truncate">\${doc.fullName}</div><div class="text-[10px] text-gray-500">\${doc.specializationName}</div></div>`;
                                            container.appendChild(item);
                                        });
                                    }
                                    box.classList.remove('hidden');
                                })
                                .catch(err => console.error('Search error:', err));
                        }, 300);
                    });
                    document.addEventListener('click', function(e) {
                        if (!input.contains(e.target) && !box.contains(e.target)) { box.classList.add('hidden'); }
                    });
                }
                document.addEventListener('DOMContentLoaded', function() {
                    initLiveSearch('nav-search-input', 'search-results', 'results-container');
                    initLiveSearch('nav-search-mobile', 'search-results-mobile', 'results-container-mobile');
                });
            </script>

            <!-- Desktop Navigation -->
            <div class="hidden md:flex items-center space-x-0.5">
                <a href="${pageContext.request.contextPath}/home" class="px-3 py-2 rounded-lg text-gray-600 hover:text-primary-600 hover:bg-primary-50 transition-all duration-200 font-medium text-sm whitespace-nowrap" id="nav-home">Home</a>
                <a href="${pageContext.request.contextPath}/doctors" class="px-3 py-2 rounded-lg text-gray-600 hover:text-primary-600 hover:bg-primary-50 transition-all duration-200 font-medium text-sm whitespace-nowrap" id="nav-doctors">Doctors</a>
                <a href="${pageContext.request.contextPath}/about" class="px-3 py-2 rounded-lg text-gray-600 hover:text-primary-600 hover:bg-primary-50 transition-all duration-200 font-medium text-sm whitespace-nowrap" id="nav-about">About</a>
                <a href="${pageContext.request.contextPath}/contact" class="px-3 py-2 rounded-lg text-gray-600 hover:text-primary-600 hover:bg-primary-50 transition-all duration-200 font-medium text-sm whitespace-nowrap" id="nav-contact">Contact</a>

                <c:choose>
                    <c:when test="${sessionScope.user != null}">
                        <a href="${pageContext.request.contextPath}/patient/dashboard" class="px-3 py-2 rounded-lg text-gray-600 hover:text-primary-600 hover:bg-primary-50 transition-all duration-200 font-medium text-sm whitespace-nowrap" id="nav-dashboard">Dashboard</a>
                        <a href="${pageContext.request.contextPath}/patient/appointments" class="px-3 py-2 rounded-lg text-gray-600 hover:text-primary-600 hover:bg-primary-50 transition-all duration-200 font-medium text-sm whitespace-nowrap" id="nav-appointments">Appointments</a>

                        <!-- User Dropdown -->
                        <div class="relative ml-3 group">
                            <button class="flex items-center space-x-2 px-4 py-2 rounded-lg bg-primary-50 text-primary-700 hover:bg-primary-100 transition-all duration-200 font-medium text-sm" id="nav-user-menu">
                                <div class="w-7 h-7 bg-gradient-to-br from-primary-500 to-accent-500 rounded-full flex items-center justify-center">
                                    <span class="text-white text-xs font-bold">${sessionScope.userName.substring(0, 1)}</span>
                                </div>
                                <span class="hidden lg:inline">${sessionScope.userName}</span>
                                <i class="fas fa-chevron-down text-xs"></i>
                            </button>
                            <div class="absolute right-0 mt-2 w-48 bg-white rounded-xl shadow-xl border border-gray-100 py-1 opacity-0 invisible group-hover:opacity-100 group-hover:visible transition-all duration-200 z-50">
                                <a href="${pageContext.request.contextPath}/patient/profile" class="block px-4 py-2.5 text-sm text-gray-700 hover:bg-primary-50 hover:text-primary-600 transition-colors" id="nav-profile">
                                    <i class="fas fa-user mr-2 w-4"></i>My Profile
                                </a>
                                <a href="${pageContext.request.contextPath}/patient/payments" class="block px-4 py-2.5 text-sm text-gray-700 hover:bg-primary-50 hover:text-primary-600 transition-colors" id="nav-payments">
                                    <i class="fas fa-credit-card mr-2 w-4"></i>Payments
                                </a>
                                <hr class="my-1 border-gray-100">
                                <a href="${pageContext.request.contextPath}/logout" class="block px-4 py-2.5 text-sm text-red-600 hover:bg-red-50 transition-colors" id="nav-logout">
                                    <i class="fas fa-sign-out-alt mr-2 w-4"></i>Logout
                                </a>
                            </div>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <a href="${pageContext.request.contextPath}/login" class="px-5 py-2 rounded-lg text-primary-600 hover:bg-primary-50 transition-all duration-200 font-medium text-sm border border-primary-200" id="nav-login">Login</a>
                        <a href="${pageContext.request.contextPath}/register" class="px-5 py-2 rounded-lg bg-gradient-to-r from-primary-600 to-primary-700 text-white hover:from-primary-700 hover:to-primary-800 transition-all duration-200 font-medium text-sm shadow-lg shadow-primary-500/25" id="nav-register">Register</a>
                    </c:otherwise>
                </c:choose>
            </div>

            <!-- Mobile menu button -->
            <button class="md:hidden p-2 rounded-lg hover:bg-gray-100 transition-colors" onclick="document.getElementById('mobileMenu').classList.toggle('hidden')" id="nav-mobile-toggle">
                <i class="fas fa-bars text-gray-600 text-lg"></i>
            </button>
        </div>

        <!-- Mobile Menu -->
        <div id="mobileMenu" class="hidden md:hidden pb-4 border-t border-gray-100 mt-2 pt-4 space-y-2">
            <!-- Mobile Search -->
            <div class="px-4 mb-4">
                <form action="${pageContext.request.contextPath}/doctors" method="get" class="relative">
                    <div class="absolute inset-y-0 left-0 pl-3 flex items-center pointer-events-none">
                        <i class="fas fa-search text-gray-400"></i>
                    </div>
                    <input type="text" name="keyword" id="nav-search-mobile" placeholder="Search doctors..." autoComplete="off"
                           class="block w-full pl-10 pr-3 py-2 border border-gray-200 rounded-xl leading-5 bg-gray-50 focus:outline-none focus:ring-1 focus:ring-primary-500 focus:border-primary-500 sm:text-sm transition-all duration-200">
                    <div id="search-results-mobile" class="hidden absolute left-0 right-0 mt-2 bg-white rounded-xl shadow-xl border border-gray-100 z-50 overflow-hidden slide-up">
                        <div id="results-container-mobile" class="max-h-80 overflow-y-auto"></div>
                    </div>
                </form>
            </div>
            <a href="${pageContext.request.contextPath}/home" class="block px-4 py-2.5 rounded-lg text-gray-600 hover:bg-primary-50 hover:text-primary-600 transition-all font-medium text-sm"><i class="fas fa-home mr-2 w-5"></i>Home</a>
            <a href="${pageContext.request.contextPath}/doctors" class="block px-4 py-2.5 rounded-lg text-gray-600 hover:bg-primary-50 hover:text-primary-600 transition-all font-medium text-sm"><i class="fas fa-user-md mr-2 w-5"></i>Doctors</a>
            <a href="${pageContext.request.contextPath}/about" class="block px-4 py-2.5 rounded-lg text-gray-600 hover:bg-primary-50 hover:text-primary-600 transition-all font-medium text-sm"><i class="fas fa-info-circle mr-2 w-5"></i>About</a>
            <a href="${pageContext.request.contextPath}/contact" class="block px-4 py-2.5 rounded-lg text-gray-600 hover:bg-primary-50 hover:text-primary-600 transition-all font-medium text-sm"><i class="fas fa-headset mr-2 w-5"></i>Contact</a>
            <c:choose>
                <c:when test="${sessionScope.user != null}">
                    <a href="${pageContext.request.contextPath}/patient/dashboard" class="block px-4 py-2.5 rounded-lg text-gray-600 hover:bg-primary-50 hover:text-primary-600 transition-all font-medium text-sm"><i class="fas fa-columns mr-2 w-5"></i>Dashboard</a>
                    <a href="${pageContext.request.contextPath}/patient/appointments" class="block px-4 py-2.5 rounded-lg text-gray-600 hover:bg-primary-50 hover:text-primary-600 transition-all font-medium text-sm"><i class="fas fa-calendar-check mr-2 w-5"></i>Appointments</a>
                    <a href="${pageContext.request.contextPath}/patient/profile" class="block px-4 py-2.5 rounded-lg text-gray-600 hover:bg-primary-50 hover:text-primary-600 transition-all font-medium text-sm"><i class="fas fa-user mr-2 w-5"></i>Profile</a>
                    <hr class="border-gray-100 my-2">
                    <a href="${pageContext.request.contextPath}/logout" class="block px-4 py-2.5 rounded-lg text-red-600 hover:bg-red-50 transition-all font-medium text-sm"><i class="fas fa-sign-out-alt mr-2 w-5"></i>Logout</a>
                </c:when>
                <c:otherwise>
                    <div class="flex space-x-3 px-4 pt-2">
                        <a href="${pageContext.request.contextPath}/login" class="flex-1 text-center py-2.5 rounded-lg border border-primary-200 text-primary-600 font-medium text-sm hover:bg-primary-50 transition-all">Login</a>
                        <a href="${pageContext.request.contextPath}/register" class="flex-1 text-center py-2.5 rounded-lg bg-primary-600 text-white font-medium text-sm hover:bg-primary-700 transition-all">Register</a>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>
    </div>
</nav>
</c:otherwise>
</c:choose>
