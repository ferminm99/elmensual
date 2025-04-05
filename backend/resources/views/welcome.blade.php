<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="utf-8">
    <meta name="csrf-token" content="{{ csrf_token() }}">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>ElMensual</title>

    <!-- Fonts -->
    <link rel="preconnect" href="https://fonts.bunny.net">
    <link href="https://fonts.bunny.net/css?family=figtree:400,600&display=swap" rel="stylesheet" />

    <!-- FullCalendar Styles -->
    <link href="https://cdn.jsdelivr.net/npm/@fullcalendar/daygrid/main.min.css" rel="stylesheet" />
    <link href="https://cdn.jsdelivr.net/npm/@fullcalendar/common/main.min.css" rel="stylesheet" />

    {{-- ⚙️ Link al frontend local o producción --}}
    @if (app()->environment('local'))
        <script type="module" src="http://localhost:5173/resources/js/app.js"></script>
    @else
        <script type="module" src="/build/assets/app.js"></script>
        <link rel="stylesheet" href="/build/assets/app.css">
    @endif
</head>
<body>
    <div id="app"></div>
</body>
</html>
