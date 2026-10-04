<?php
declare(strict_types=1);
$configFile = __DIR__ . '/config.php';
if (!is_file($configFile)) { throw new RuntimeException('Configuração ausente. Copie config.example.php para config.php.'); }
$config = require $configFile;
date_default_timezone_set($config['app']['timezone'] ?? 'America/Sao_Paulo');
function db(): PDO { static $pdo; global $config; if ($pdo) return $pdo; $d=$config['db']; $pdo=new PDO("mysql:host={$d['host']};port={$d['port']};dbname={$d['name']};charset={$d['charset']}",$d['user'],$d['pass'],[PDO::ATTR_ERRMODE=>PDO::ERRMODE_EXCEPTION,PDO::ATTR_DEFAULT_FETCH_MODE=>PDO::FETCH_ASSOC,PDO::ATTR_EMULATE_PREPARES=>false]); return $pdo; }
function uuidv4(): string { $b=random_bytes(16); $b[6]=chr((ord($b[6])&15)|64); $b[8]=chr((ord($b[8])&63)|128); return vsprintf('%s%s-%s-%s-%s-%s%s%s',str_split(bin2hex($b),4)); }
function jsonResponse(array $data,int $status=200): never { http_response_code($status); header('Content-Type: application/json; charset=utf-8'); header('Cache-Control: no-store'); echo json_encode($data,JSON_UNESCAPED_UNICODE|JSON_UNESCAPED_SLASHES); exit; }
function bodyText(): string { return file_get_contents('php://input') ?: ''; }
function bodyJson(string $raw): array { $v=json_decode($raw,true); if(!is_array($v)) throw new InvalidArgumentException('Dados inválidos.'); return $v; }
function slugify(string $s): string { $s=iconv('UTF-8','ASCII//TRANSLIT//IGNORE',$s)?:$s; $s=strtolower(preg_replace('/[^a-zA-Z0-9]+/','-',$s)??''); return substr(trim($s,'-'),0,60); }
function normalizeSearch(string $s): string { $s=iconv('UTF-8','ASCII//TRANSLIT//IGNORE',$s)?:$s; return trim(preg_replace('/\s+/',' ',strtolower($s))??''); }
function validUuid(string $s): bool { return preg_match('/^[0-9a-f]{8}-[0-9a-f]{4}-4[0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12}$/i',$s)===1; }
function isoNow(): string { return gmdate('Y-m-d\TH:i:s.v\Z'); }
