<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<jsp:include page="/WEB-INF/views/common/header.jsp" />
<jsp:include page="/WEB-INF/views/common/navbar.jsp" />

<main class="flex-1 bg-gray-50">
    <div class="max-w-4xl mx-auto px-4 sm:px-6 lg:px-8 py-8">
        <h1 class="text-3xl font-bold text-gray-900 mb-2">Book Appointment</h1>
        <p class="text-gray-500 mb-8">with <span class="text-primary-600 font-semibold">${doctor.fullName}</span> - ${doctor.specializationName}</p>

        <c:if test="${error != null}">
            <div class="mb-6 p-4 bg-red-50 border border-red-200 rounded-xl flex items-center space-x-3">
                <i class="fas fa-exclamation-circle text-red-500"></i>
                <span class="text-red-700 text-sm">${error}</span>
            </div>
        </c:if>

        <div class="grid grid-cols-1 lg:grid-cols-3 gap-6">
            <!-- Doctor Info Card -->
            <div class="bg-white rounded-2xl shadow-sm border border-gray-100 p-6 h-fit">
                <div class="flex items-center space-x-4 mb-4">
                    <div class="w-14 h-14 bg-gradient-to-br from-primary-100 to-accent-100 rounded-2xl flex items-center justify-center">
                        <i class="fas fa-user-md text-primary-600 text-xl"></i>
                    </div>
                    <div>
                        <h3 class="font-bold text-gray-900">${doctor.fullName}</h3>
                        <p class="text-primary-600 text-sm">${doctor.specializationName}</p>
                    </div>
                </div>
                <div class="space-y-3 text-sm">
                    <div class="flex justify-between"><span class="text-gray-500">Fee:</span><span class="font-semibold text-gray-900">Rs. ${doctor.consultationFee}</span></div>
                    <div class="flex justify-between"><span class="text-gray-500">Experience:</span><span class="font-semibold text-gray-900">${doctor.experienceYears} years</span></div>
                    <div class="flex justify-between"><span class="text-gray-500">Qualification:</span><span class="font-semibold text-gray-900 text-right">${doctor.qualification}</span></div>
                </div>
            </div>

            <!-- Booking Form -->
            <div class="lg:col-span-2">
                <!-- Step 1: Select Date -->
                <div class="bg-white rounded-2xl shadow-sm border border-gray-100 p-6 mb-6">
                    <h2 class="text-lg font-bold text-gray-900 mb-4"><span class="inline-flex items-center justify-center w-8 h-8 bg-primary-100 text-primary-600 rounded-lg text-sm font-bold mr-2">1</span>Upcoming Availability</h2>

                    <div class="relative">
                        <div class="flex overflow-x-auto pb-2 gap-3 no-scrollbar scroll-smooth">
                            <c:forEach var="date" items="${availableDates}">
                                <a href="${pageContext.request.contextPath}/patient/book?doctorId=${doctor.id}&date=${date}"
                                   class="flex-shrink-0 group w-24 p-3 rounded-2xl border-2 transition-all text-center ${selectedDate == date.toString() ? 'border-primary-500 bg-primary-50 shadow-sm' : 'border-gray-100 hover:border-primary-200 bg-gray-50/50'}">
                                    <div class="text-[10px] font-bold ${selectedDate == date.toString() ? 'text-primary-600' : 'text-gray-400 group-hover:text-gray-500'} uppercase tracking-wider mb-1">
                                            ${date.dayOfWeek.toString().substring(0,3)}
                                    </div>
                                    <div class="text-2xl font-black ${selectedDate == date.toString() ? 'text-primary-700' : 'text-gray-800'} mb-1">
                                            ${date.dayOfMonth}
                                    </div>
                                    <div class="text-[10px] font-semibold text-gray-500 uppercase tracking-tighter">
                                            ${date.month.toString().substring(0,3)} ${date.year}
                                    </div>
                                </a>
                            </c:forEach>
                        </div>

                        <c:if test="${empty availableDates}">
                            <div class="text-center py-4 bg-gray-50 rounded-xl border border-dashed border-gray-200">
                                <i class="fas fa-calendar-alt text-gray-400 mb-2"></i>
                                <p class="text-gray-500 text-sm">No upcoming availability found.</p>
                            </div>
                        </c:if>
                    </div>
                </div>

                <!-- Step 2: Available Slots -->
                <c:if test="${selectedDate != null}">
                    <div class="bg-white rounded-2xl shadow-sm border border-gray-100 p-6 mb-6 fade-in">
                        <h2 class="text-lg font-bold text-gray-900 mb-4">
                            <span class="inline-flex items-center justify-center w-8 h-8 bg-accent-100 text-accent-600 rounded-lg text-sm font-bold mr-2">2</span>
                            Available Slots for ${selectedDate}
                        </h2>
                        <c:choose>
                            <c:when test="${empty availableSlots}">
                                <div class="text-center py-8">
                                    <div class="w-14 h-14 bg-gray-100 rounded-2xl flex items-center justify-center mx-auto mb-3">
                                        <i class="fas fa-calendar-times text-gray-400 text-xl"></i>
                                    </div>
                                    <p class="text-gray-500">No available slots for this date. Please select another date.</p>
                                </div>
                            </c:when>
                            <c:otherwise>
                                <form method="post" action="${pageContext.request.contextPath}/patient/book" id="bookForm">
                                    <input type="hidden" name="csrfToken" value="${csrfToken}">
                                    <input type="hidden" name="doctorId" value="${doctor.id}">
                                    <input type="hidden" name="appointmentDate" value="${selectedDate}">

                                    <div class="grid grid-cols-2 md:grid-cols-3 gap-3 mb-6">
                                        <c:forEach var="slot" items="${availableSlots}">
                                            <label class="cursor-pointer">
                                                <input type="radio" name="slotId" value="${slot.id}" class="peer hidden" required>
                                                <div class="p-4 rounded-xl border-2 border-gray-200 text-center peer-checked:border-primary-500 peer-checked:bg-primary-50 hover:border-primary-300 transition-all">
                                                    <div class="font-bold text-gray-800 text-sm">${slot.formattedTimeRange}</div>
                                                    <div class="text-xs text-gray-500 mt-1">${slot.dayOfWeek}</div>
                                                </div>
                                            </label>
                                        </c:forEach>
                                    </div>

                                    <div class="mb-6">
                                        <label for="notes" class="block text-sm font-semibold text-gray-700 mb-2">Notes (optional)</label>
                                        <textarea id="notes" name="notes" rows="3" placeholder="Any symptoms or specific concerns..."
                                                  class="w-full px-4 py-3 border border-gray-200 rounded-xl focus:ring-2 focus:ring-primary-500 focus:border-primary-500 transition-all"></textarea>
                                    </div>

                                    <button type="submit" class="w-full py-4 bg-gradient-to-r from-primary-600 to-accent-600 text-white font-bold rounded-xl hover:from-primary-700 hover:to-accent-700 transition-all shadow-lg text-lg" id="confirmBookBtn">
                                        <i class="fas fa-calendar-check mr-2"></i>Confirm Booking
                                    </button>
                                </form>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </c:if>
            </div>
        </div>
    </div>
</main>

<jsp:include page="/WEB-INF/views/common/footer.jsp" />
