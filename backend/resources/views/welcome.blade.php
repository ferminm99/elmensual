<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="utf-8">
    <meta name="csrf-token" content="{{ csrf_token() }}">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>ElMensual</title>
    @vite('resources/js/app.js')
    @vite('resources/js/app.css')
</head>
<body>
    <div id="app"></div>
</body>
</html>
