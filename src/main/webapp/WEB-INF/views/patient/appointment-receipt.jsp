<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${pageTitle}</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <script src="https://cdnjs.cloudflare.com/ajax/libs/html2pdf.js/0.10.1/html2pdf.bundle.min.js"></script>
    <style>
        @media print {
            .no-print { display: none; }
            body { background: white; }
            .print-shadow { box-shadow: none !important; border: 1px solid #eee; }
        }
        @page { size: auto; margin: 10mm; }
    </style>
</head>
<body class="bg-gray-100 font-sans antialiased p-4">

<div class="max-w-3xl mx-auto">
    <div class="no-print mb-6 flex justify-between items-center">
        <a href="${not empty backUrl ? backUrl : pageContext.request.contextPath.concat('/patient/appointments')}"
           class="text-primary-600 hover:text-primary-700 flex items-center font-medium">
            <i class="fas fa-arrow-left mr-2"></i>
            ${isAdmin ? 'Back to Manage Appointments' : 'Back to My Appointments'}
        </a>
        <div class="flex gap-3">
            <button onclick="window.print()"
                    class="px-6 py-2 bg-gray-600 text-white font-bold rounded-lg hover:bg-gray-700 transition-all flex items-center">
                <i class="fas fa-print mr-2"></i> Print
            </button>
            <button onclick="exportPDF()"
                    id="export-btn"
                    class="px-6 py-2 bg-primary-600 text-white font-bold rounded-lg hover:bg-primary-700 transition-all flex items-center">
                <i class="fas fa-file-pdf mr-2"></i> Export PDF
            </button>
        </div>
    </div>
    <div class="bg-white rounded-2xl shadow-xl p-8 print-shadow overflow-hidden relative">
        <!-- Header Section -->
        <div class="flex justify-between items-start border-b border-gray-100 pb-8 mb-8">
            <div>
                <h1 class="text-3xl font-black text-primary-600 mb-1">DocConnect <span class="text-accent-600">Nepal</span></h1>
                <p class="text-gray-500 text-sm">Your Health, Our Priority</p>
            </div>
            <div class="text-right">
                <div class="bg-purple-600 text-white px-6 py-4 rounded-2xl inline-block" style="background-color:#7c3aed;color:#fff;padding:1rem 1.5rem;border-radius:1rem;">
                    <p class="text-xs uppercase tracking-widest font-bold" style="font-size:0.65rem;letter-spacing:0.12em;font-weight:700;opacity:0.85;margin-bottom:4px;">TURN NUMBER</p>
                    <p class="font-black" style="font-size:2.5rem;font-weight:900;line-height:1;">#${appointment.turnNumber}</p>
                </div>
            </div>
        </div>

        <div class="grid grid-cols-2 gap-8 mb-8">
            <!-- Patient Info -->
            <div class="space-y-4">
                <h2 class="text-xs uppercase tracking-widest font-black text-gray-400">PATIENT DETAILS</h2>
                <div>
                    <p class="text-sm font-bold text-gray-900">${appointment.patientName}</p>
                    <p class="text-sm text-gray-500">${appointment.patientEmail}</p>
                </div>
            </div>
            <!-- Appointment Info -->
            <div class="space-y-4 text-right">
                <h2 class="text-xs uppercase tracking-widest font-black text-gray-400">APPOINTMENT INFO</h2>
                <div>
                    <p class="text-sm font-bold text-gray-900">${appointment.appointmentDate}</p>
                    <p class="text-sm text-gray-500">${appointment.slotTime}</p>
                </div>
            </div>
        </div>

        <!-- Main Content Area -->
        <div class="bg-gray-50 rounded-2xl p-6 mb-8 border border-gray-100">
            <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
                <div class="flex items-center space-x-4">
                    <div class="w-12 h-12 bg-white rounded-xl shadow-sm flex items-center justify-center text-primary-600">
                        <i class="fas fa-user-md text-xl"></i>
                    </div>
                    <div>
                        <p class="text-xs font-bold text-gray-400 uppercase">Doctor</p>
                        <p class="text-base font-bold text-gray-800">${appointment.doctorName}</p>
                        <p class="text-xs text-gray-500">${appointment.specializationName}</p>
                    </div>
                </div>
                <div class="flex items-center space-x-4">
                    <div class="w-12 h-12 bg-white rounded-xl shadow-sm flex items-center justify-center text-accent-600">
                        <i class="fas fa-money-bill-wave text-xl"></i>
                    </div>
                    <div>
                        <p class="text-xs font-bold text-gray-400 uppercase">Consultation Fee</p>
                        <p class="text-base font-bold text-gray-800">Rs. ${appointment.consultationFee}</p>
                    </div>
                </div>
            </div>
        </div>

        <!-- Payment Details Section -->
        <div class="border-t border-gray-100 pt-8 mb-8">
            <h2 class="text-xs uppercase tracking-widest font-black text-gray-400 mb-6">PAYMENT INFORMATION</h2>
            <c:choose>
                <c:when test="${payment != null}">
                    <div class="space-y-3">
                        <div class="flex justify-between text-sm">
                            <span class="text-gray-500">Consultation Fee</span>
                            <span class="font-bold text-gray-900">Rs. ${appointment.consultationFee}</span>
                        </div>
                        <div class="flex justify-between text-sm">
                            <span class="text-gray-500">Payment Method</span>
                            <span class="font-bold text-gray-900 capitalize">${payment.paymentMethod}</span>
                        </div>
                        <div class="flex justify-between text-sm">
                            <span class="text-gray-500">Transaction ID</span>
                            <span class="font-mono text-gray-900">${payment.transactionId}</span>
                        </div>
                        <div class="flex justify-between text-sm">
                            <span class="text-gray-500">Payment Status</span>
                            <span class="px-2 py-0.5 bg-green-100 text-green-700 rounded text-xs font-bold uppercase">Paid</span>
                        </div>
                        <hr class="border-gray-100 my-4">
                        <div class="flex justify-between items-center bg-primary-50 p-4 rounded-xl" style="background-color:#ede9fe;padding:1rem;border-radius:0.75rem;">
                            <span class="font-bold text-primary-900" style="font-weight:700;">TOTAL AMOUNT PAID</span>
                            <span class="text-primary-600" style="font-size:1.5rem;font-weight:900;color:#7c3aed;">Rs. ${payment.amount}</span>
                        </div>
                    </div>
                </c:when>
                <c:otherwise>
                    <div class="space-y-3">
                        <div class="flex justify-between text-sm">
                            <span class="text-gray-500">Consultation Fee</span>
                            <span class="font-bold text-gray-900">Rs. ${appointment.consultationFee}</span>
                        </div>
                        <div class="flex justify-between text-sm">
                            <span class="text-gray-500">Payment Status</span>
                            <span class="px-2 py-0.5 bg-yellow-100 text-yellow-700 rounded text-xs font-bold uppercase">Pending Verification</span>
                        </div>
                        <hr class="border-gray-100 my-4">
                        <div class="flex justify-between items-center bg-primary-50 p-4 rounded-xl" style="background-color:#ede9fe;padding:1rem;border-radius:0.75rem;">
                            <span class="font-bold text-primary-900" style="font-weight:700;">TOTAL AMOUNT</span>
                            <span class="text-primary-600" style="font-size:1.5rem;font-weight:900;color:#7c3aed;">Rs. ${appointment.consultationFee}</span>
                        </div>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>

        <!-- Footer Section -->
        <div class="text-center pt-8 border-t border-dashed border-gray-200">
            <p class="text-sm font-bold text-gray-900 mb-1">Please arrive 15 minutes early.</p>
            <p class="text-xs text-gray-500 uppercase tracking-widest font-bold">BRING THIS PRINTED FORM ON YOUR VISIT</p>
            <div class="mt-8 flex justify-center opacity-10">
                <i class="fas fa-hospital-alt text-9xl"></i>
            </div>
        </div>

        <!-- Security Stamp -->
        <div class="absolute bottom-8 right-8 pointer-events-none opacity-20 transform -rotate-12 border-4 border-green-600 text-green-600 font-black p-4 inline-block uppercase text-2xl tracking-tighter">
            VERIFIED PAYMENT
        </div>
    </div>

    <p class="mt-8 text-center text-xs text-gray-400 italic no-print">
        This is an electronically generated receipt and does not require a physical signature.
    </p>
</div>

<script>
    function exportPDF() {
        var btn = document.getElementById('export-btn');
        btn.disabled = true;
        btn.innerHTML = '<i class="fas fa-spinner fa-spin mr-2"></i> Generating...';

        var element = document.querySelector('.bg-white.rounded-2xl.shadow-xl');
        var opt = {
            margin:       [8, 8, 8, 8],
            filename:     'appointment-receipt-<c:out value="${appointment.id}"/>.pdf',
            image:        { type: 'jpeg', quality: 0.98 },
            html2canvas:  { scale: 2, useCORS: true, logging: false },
            jsPDF:        { unit: 'mm', format: 'a4', orientation: 'portrait' }
        };

        html2pdf().set(opt).from(element).save().then(function() {
            btn.disabled = false;
            btn.innerHTML = '<i class="fas fa-file-pdf mr-2"></i> Export PDF';
        });
    }

    // Auto-export when ?export=true is in the URL
    if (new URLSearchParams(window.location.search).get('export') === 'true') {
        window.addEventListener('load', function() {
            setTimeout(exportPDF, 500);
        });
    }
</script>

</body>
</html>
