<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="description" content="DocConnect Nepal - Your trusted platform for finding doctors and booking appointments in Nepal.">
    <title>${pageTitle != null ? pageTitle : 'DocConnect Nepal'}</title>

    <!-- Tailwind CSS CDN -->
    <script src="https://cdn.tailwindcss.com"></script>
    <script>
        tailwind.config = {
            theme: {
                extend: {
                    colors: {
                        primary: { 50: '#eef7ff', 100: '#d9edff', 200: '#bce0ff', 300: '#8eccff', 400: '#59b0ff', 500: '#338dff', 600: '#1a6df5', 700: '#1357e1', 800: '#1646b6', 900: '#183d8f', 950: '#132757' },
                        accent: { 50: '#f0fdfa', 100: '#ccfbf1', 200: '#99f6e4', 300: '#5eead4', 400: '#2dd4bf', 500: '#14b8a6', 600: '#0d9488', 700: '#0f766e', 800: '#115e59', 900: '#134e4a', 950: '#042f2e' },
                        healthcare: { 50: '#fdf4ff', 100: '#fae8ff', 200: '#f5d0fe', 300: '#f0abfc', 400: '#e879f9', 500: '#d946ef', 600: '#c026d3', 700: '#a21caf', 800: '#86198f', 900: '#701a75' }
                    },
                    fontFamily: {
                        sans: ['Inter', 'system-ui', '-apple-system', 'sans-serif'],
                    }
                }
            }
        }
    </script>

    <!-- Google Fonts -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">

    <!-- Font Awesome -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">

    <style>
        * { font-family: 'Inter', system-ui, sans-serif; }

        /* Custom scrollbar */
        ::-webkit-scrollbar { width: 8px; }
        ::-webkit-scrollbar-track { background: #f1f5f9; }
        ::-webkit-scrollbar-thumb { background: #94a3b8; border-radius: 4px; }
        ::-webkit-scrollbar-thumb:hover { background: #64748b; }

        /* Smooth animations */
        .fade-in { animation: fadeIn 0.5s ease-in-out; }
        @keyframes fadeIn { from { opacity: 0; transform: translateY(10px); } to { opacity: 1; transform: translateY(0); } }

        .slide-up { animation: slideUp 0.6s ease-out; }
        @keyframes slideUp { from { opacity: 0; transform: translateY(30px); } to { opacity: 1; transform: translateY(0); } }

        /* Gradient text */
        .gradient-text {
            background: linear-gradient(135deg, #1a6df5, #14b8a6);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
        }

        /* Glass effect */
        .glass {
            background: rgba(255, 255, 255, 0.8);
            backdrop-filter: blur(16px);
            -webkit-backdrop-filter: blur(16px);
            border: 1px solid rgba(255, 255, 255, 0.3);
        }

        /* Card hover effect */
        .card-hover {
            transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
        }
        .card-hover:hover {
            transform: translateY(-4px);
            box-shadow: 0 20px 40px -12px rgba(0, 0, 0, 0.15);
        }

        /* Pulse animation for status indicators */
        .pulse-dot { animation: pulse 2s infinite; }
        @keyframes pulse {
            0%, 100% { opacity: 1; }
            50% { opacity: 0.5; }
        }

        /* Hero gradient */
        .hero-gradient {
            background: linear-gradient(135deg, #1a6df5 0%, #0d9488 50%, #14b8a6 100%);
        }

        .no-scrollbar::-webkit-scrollbar { display: none; }
        .no-scrollbar { -ms-overflow-style: none; scrollbar-width: none; }
    </style>

    <!-- Global Error Logging -->
    <script>
        window.addEventListener('error', function(event) {
            console.group('%c Frontend Error Detected ', 'background: #fee2e2; color: #991b1b; font-weight: bold; border-radius: 4px; padding: 2px 4px;');
            console.error('Message:', event.message);
            console.error('Source:', event.filename + ':' + event.lineno + ':' + event.colno);
            if (event.error && event.error.stack) {
                console.error('Stack Trace:', event.error.stack);
            }
            console.groupEnd();
        });

        window.addEventListener('unhandledrejection', function(event) {
            console.group('%c Unhandled Promise Rejection ', 'background: #fef3c7; color: #92400e; font-weight: bold; border-radius: 4px; padding: 2px 4px;');
            console.error('Reason:', event.reason);
            console.groupEnd();
        });

        console.log('%c DocConnect Nepal %c Error Logger Initialized ', 'background: #1a6df5; color: white; border-radius: 4px 0 0 4px; padding: 2px 4px;', 'background: #14b8a6; color: white; border-radius: 0 4px 4px 0; padding: 2px 4px;');
    </script>
</head>
<body class="bg-gray-50 min-h-screen flex flex-col">
