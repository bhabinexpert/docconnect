<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<!-- Footer -->
<footer class="bg-gray-900 text-gray-300 mt-auto">
    <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-12">
        <div class="grid grid-cols-1 md:grid-cols-4 gap-8">
            <!-- Brand -->
            <div class="md:col-span-1">
                <div class="flex items-center space-x-3 mb-4">
                    <div class="w-10 h-10 bg-gradient-to-br from-primary-500 to-accent-500 rounded-xl flex items-center justify-center">
                        <i class="fas fa-heartbeat text-white text-lg"></i>
                    </div>
                    <span class="text-xl font-bold text-white">DocConnect</span>
                </div>
                <p class="text-gray-400 text-sm leading-relaxed">Your trusted platform for finding the best doctors and booking appointments across Nepal.</p>
            </div>

            <!-- Quick Links -->
            <div>
                <h4 class="text-white font-semibold mb-4">Quick Links</h4>
                <ul class="space-y-2.5">
                    <li><a href="${pageContext.request.contextPath}/home" class="text-sm hover:text-accent-400 transition-colors">Home</a></li>
                    <li><a href="${pageContext.request.contextPath}/doctors" class="text-sm hover:text-accent-400 transition-colors">Find Doctors</a></li>
                    <li><a href="${pageContext.request.contextPath}/about" class="text-sm hover:text-accent-400 transition-colors">About Us</a></li>
                    <li><a href="${pageContext.request.contextPath}/contact" class="text-sm hover:text-accent-400 transition-colors">Contact</a></li>
                    <li><a href="${pageContext.request.contextPath}/register" class="text-sm hover:text-accent-400 transition-colors">Register</a></li>
                    <li><a href="${pageContext.request.contextPath}/login" class="text-sm hover:text-accent-400 transition-colors">Login</a></li>
                </ul>
            </div>

            <!-- Specializations -->
            <div>
                <h4 class="text-white font-semibold mb-4">Specializations</h4>
                <ul class="space-y-2.5">
                    <li><a href="${pageContext.request.contextPath}/doctors?specialization=1" class="text-sm hover:text-accent-400 transition-colors">Cardiology</a></li>
                    <li><a href="${pageContext.request.contextPath}/doctors?specialization=2" class="text-sm hover:text-accent-400 transition-colors">Dermatology</a></li>
                    <li><a href="${pageContext.request.contextPath}/doctors?specialization=3" class="text-sm hover:text-accent-400 transition-colors">Orthopedics</a></li>
                    <li><a href="${pageContext.request.contextPath}/doctors?specialization=5" class="text-sm hover:text-accent-400 transition-colors">Neurology</a></li>
                </ul>
            </div>

            <!-- Contact -->
            <div>
                <h4 class="text-white font-semibold mb-4">Contact Us</h4>
                <ul class="space-y-2.5">
                    <li class="flex items-center space-x-2 text-sm"><i class="fas fa-map-marker-alt w-4 text-accent-400"></i><span>Kathmandu, Nepal</span></li>
                    <li class="flex items-center space-x-2 text-sm"><i class="fas fa-phone w-4 text-accent-400"></i><span>+977-1-4XXXXXX</span></li>
                    <li class="flex items-center space-x-2 text-sm"><i class="fas fa-envelope w-4 text-accent-400"></i><span>info@docconnect.com.np</span></li>
                </ul>
                <div class="flex space-x-3 mt-4">
                    <a href="#" class="w-9 h-9 bg-gray-800 rounded-lg flex items-center justify-center hover:bg-primary-600 transition-colors"><i class="fab fa-facebook-f text-sm"></i></a>
                    <a href="#" class="w-9 h-9 bg-gray-800 rounded-lg flex items-center justify-center hover:bg-primary-600 transition-colors"><i class="fab fa-twitter text-sm"></i></a>
                    <a href="#" class="w-9 h-9 bg-gray-800 rounded-lg flex items-center justify-center hover:bg-primary-600 transition-colors"><i class="fab fa-instagram text-sm"></i></a>
                </div>
            </div>
        </div>

        <div class="border-t border-gray-800 mt-10 pt-6 text-center">
            <p class="text-gray-500 text-sm">&copy; 2026 DocConnect Nepal. All rights reserved. | University Coursework Project</p>
        </div>
    </div>
</footer>

</body>
</html>
