<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<jsp:include page="/WEB-INF/views/common/header.jsp" />
<jsp:include page="/WEB-INF/views/common/navbar.jsp" />
<main class="flex-1 bg-gray-50">
  <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-8">
    <h1 class="text-3xl font-bold text-gray-900 mb-8">Manage Slots</h1>
    <c:if test="${param.success != null}"><div class="mb-6 p-4 bg-green-50 border border-green-200 rounded-xl flex items-center space-x-3"><i class="fas fa-check-circle text-green-500"></i><span class="text-green-700 text-sm">${param.success}</span></div></c:if>
    <c:if test="${param.error != null}"><div class="mb-6 p-4 bg-red-50 border border-red-200 rounded-xl flex items-center space-x-3"><i class="fas fa-exclamation-circle text-red-500"></i><span class="text-red-700 text-sm">${param.error}</span></div></c:if>

    <!-- Add Slot Form -->
    <div class="bg-white rounded-2xl shadow-sm border border-gray-100 p-6 mb-8">
      <h2 class="text-lg font-bold text-gray-900 mb-4"><i class="fas fa-plus-circle mr-2 text-primary-600"></i>Add New Slot</h2>
      <form method="post" action="${pageContext.request.contextPath}/admin/slots" class="grid grid-cols-1 md:grid-cols-5 gap-4 items-end" id="addSlotForm">
        <input type="hidden" name="csrfToken" value="${csrfToken}">
        <input type="hidden" name="action" value="add">
        <div>
          <label class="block text-sm font-semibold text-gray-700 mb-2">Doctor *</label>
          <select name="doctorId" required class="w-full px-4 py-3 border border-gray-200 rounded-xl focus:ring-2 focus:ring-primary-500 transition-all">
            <option value="">Select Doctor</option>
            <c:forEach var="doc" items="${doctors}"><option value="${doc.id}">${doc.fullName}</option></c:forEach>
          </select>
        </div>
        <div class="md:col-span-1">
          <label class="block text-sm font-semibold text-gray-700 mb-2">Recurring Day</label>
          <select name="dayOfWeek" class="w-full px-4 py-3 border border-gray-200 rounded-xl focus:ring-2 focus:ring-primary-500 transition-all">
            <option value="">Specific Date Instead</option>
            <option>Monday</option><option>Tuesday</option><option>Wednesday</option><option>Thursday</option><option>Friday</option><option>Saturday</option><option>Sunday</option>
          </select>
        </div>
        <div class="md:col-span-1">
          <label class="block text-sm font-semibold text-gray-700 mb-2">OR Specific Date</label>
          <input type="date" name="specificDate" class="w-full px-4 py-3 border border-gray-200 rounded-xl focus:ring-2 focus:ring-primary-500 transition-all">
        </div>
        <div>
          <label class="block text-sm font-semibold text-gray-700 mb-2">Start *</label>
          <input type="time" name="startTime" required class="w-full px-4 py-3 border border-gray-200 rounded-xl focus:ring-2 focus:ring-primary-500 transition-all">
        </div>
        <div>
          <label class="block text-sm font-semibold text-gray-700 mb-2">End *</label>
          <input type="time" name="endTime" required class="w-full px-4 py-3 border border-gray-200 rounded-xl focus:ring-2 focus:ring-primary-500 transition-all">
        </div>
        <button type="submit" class="px-6 py-3 bg-primary-600 text-white font-semibold rounded-xl hover:bg-primary-700 transition-all shadow-lg shadow-primary-500/25" id="addSlotBtn">
          <i class="fas fa-plus mr-2"></i>Add
        </button>
      </form>
    </div>

    <!-- Slots Table -->
    <div class="bg-white rounded-2xl shadow-sm border border-gray-100 overflow-hidden">
      <div class="overflow-x-auto">
        <table class="w-full" id="slots-table">
          <thead class="bg-gray-50"><tr>
            <th class="px-6 py-3 text-left text-xs font-semibold text-gray-500 uppercase">Doctor</th>
            <th class="px-6 py-3 text-left text-xs font-semibold text-gray-500 uppercase">Day</th>
            <th class="px-6 py-3 text-left text-xs font-semibold text-gray-500 uppercase">Time</th>
            <th class="px-6 py-3 text-left text-xs font-semibold text-gray-500 uppercase">Status</th>
            <th class="px-6 py-3 text-left text-xs font-semibold text-gray-500 uppercase">Actions</th>
          </tr></thead>
          <tbody class="divide-y divide-gray-100">
          <c:forEach var="slot" items="${slots}">
            <tr class="hover:bg-gray-50 transition-colors">
              <td class="px-6 py-4 text-sm font-medium text-gray-900">${slot.doctorName}</td>
              <td class="px-6 py-4 text-sm text-gray-600">
                <c:choose>
                  <c:when test="${slot.specificDate != null}">
                    <span class="text-primary-600 font-bold"><i class="fas fa-calendar-star mr-1"></i>${slot.specificDate}</span>
                  </c:when>
                  <c:otherwise>${slot.dayOfWeek}</c:otherwise>
                </c:choose>
              </td>
              <td class="px-6 py-4 text-sm text-gray-600">${slot.formattedTimeRange}</td>
              <td class="px-6 py-4"><span class="px-3 py-1 rounded-full text-xs font-bold ${slot.active ? 'bg-green-100 text-green-700' : 'bg-red-100 text-red-700'}">${slot.active ? 'Active' : 'Inactive'}</span></td>
              <td class="px-6 py-4 flex space-x-3">
                <form method="post" action="${pageContext.request.contextPath}/admin/slots" class="inline">
                  <input type="hidden" name="csrfToken" value="${csrfToken}">
                  <input type="hidden" name="action" value="toggle">
                  <input type="hidden" name="slotId" value="${slot.id}">
                  <input type="hidden" name="isActive" value="${!slot.active}">
                  <button type="submit" class="text-sm font-medium ${slot.active ? 'text-yellow-600 hover:text-yellow-700' : 'text-green-600 hover:text-green-700'}">
                    <i class="fas ${slot.active ? 'fa-toggle-on' : 'fa-toggle-off'}"></i> ${slot.active ? 'Deactivate' : 'Activate'}
                  </button>
                </form>
                <form method="post" action="${pageContext.request.contextPath}/admin/slots" class="inline" onsubmit="return confirm('Delete this slot?')">
                  <input type="hidden" name="csrfToken" value="${csrfToken}">
                  <input type="hidden" name="action" value="delete">
                  <input type="hidden" name="slotId" value="${slot.id}">
                  <button type="submit" class="text-red-600 hover:text-red-700 font-medium text-sm"><i class="fas fa-trash"></i> Delete</button>
                </form>
              </td>
            </tr>
          </c:forEach>
          </tbody>
        </table>
      </div>
    </div>
  </div>
</main>
<jsp:include page="/WEB-INF/views/common/footer.jsp" />
