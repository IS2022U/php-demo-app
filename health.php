<?php
// Health check endpoint — used by Docker HEALTHCHECK and Kubernetes liveness/readiness probes
header('Content-Type: application/json');
http_response_code(200);

echo json_encode([
    'status'   => 'ok',
    'hostname' => gethostname(),
    'time'     => date('Y-m-d H:i:s'),
    'version'  => '2.0',
]);
