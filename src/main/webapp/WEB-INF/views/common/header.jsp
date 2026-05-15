<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="description" content="DocConnect Nepal - Your trusted platform for finding doctors and booking appointments in Nepal.">
    <title>${pageTitle != null ? pageTitle : 'DocConnect Nepal'}</title>

    <script src="https://cdn.tailwindcss.com"></script>
    <script>
        tailwind.config = {
            theme: {
                extend: {
                    colors: {
                        primary: {
                            50: '#eef7ff', 100: '#d9edff', 200: '#bce0ff', 500: '#338dff',
                            600: '#1a6df5', 700: '#1357e1', 900: '#183d8f'
                        },
                        accent: {
                            50: '#f0fdfa', 100: '#ccfbf1', 200: '#99f6e4', 300: '#5eead4',
                            400: '#2dd4bf', 500: '#14b8a6', 600: '#0d9488', 700: '#0f766e'
                        }
                    },
                    fontFamily: {
                        sans: ['Inter', 'system-ui', 'sans-serif']
                    }
                }
            }
        }
    </script>

    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">

    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">

    <style>
        .gradient-text {
            color: transparent;
            background: linear-gradient(135deg, #1a6df5, #14b8a6);
            -webkit-background-clip: text;
            background-clip: text;
        }

        .hero-gradient { background: linear-gradient(135deg, #1a6df5, #0d9488, #14b8a6); }
        .glass { background: rgb(255 255 255 / 0.85); backdrop-filter: blur(12px); }
        .card-hover { transition: transform 0.2s ease, box-shadow 0.2s ease; }
        .card-hover:hover { transform: translateY(-3px); box-shadow: 0 18px 32px rgb(15 23 42 / 0.12); }
        .fade-in, .slide-up { animation: enter 0.35s ease both; }
        .pulse-dot { animation: pulse 1.8s ease-in-out infinite; }
        .no-scrollbar { scrollbar-width: none; }
        .no-scrollbar::-webkit-scrollbar { display: none; }

        @keyframes enter {
            from { opacity: 0; transform: translateY(12px); }
            to { opacity: 1; transform: translateY(0); }
        }

        @keyframes pulse {
            50% { opacity: 0.45; }
        }
    </style>
</head>
<body class="bg-gray-50 min-h-screen flex flex-col">
