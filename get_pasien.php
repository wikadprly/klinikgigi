<?php
// Terapkan header CORS (Access-Control-Allow-Origin: *)
header('Access-Control-Allow-Origin: *'); 
header('Content-Type: application/json');

$host = "localhost";
$user = "root";
$pass = "";
$db = "simklinik"; 

// Membuat koneksi ke database
$conn = new mysqli($host, $user, $pass, $db);

if ($conn->connect_error) {
    die(json_encode(["status" => "error", "message" => "Koneksi ke database gagal: " . $conn->connect_error]));
}

// 1. Ambil user_id dari parameter GET
$user_id_login = isset($_GET['user_id']) ? $_GET['user_id'] : null;

if (empty($user_id_login)) {
    echo json_encode(["status" => "error", "message" => "Parameter user_id tidak ditemukan"]);
    $conn->close();
    exit;
}

// 2. Query: Ambil rekam_medis_id, file_foto, jenis_kelamin, DAN nama_pengguna dari tabel users
$sql_user = "SELECT rekam_medis_id, file_foto, jenis_kelamin, nama_pengguna FROM users WHERE user_id = ?";
$stmt_user = $conn->prepare($sql_user);
$stmt_user->bind_param("i", $user_id_login); // Menggunakan "i" untuk user_id INT (2)
$stmt_user->execute();
$result_user = $stmt_user->get_result();
$user_data = $result_user->fetch_assoc();
$stmt_user->close();

if (!$user_data || $user_data['rekam_medis_id'] === NULL) {
    echo json_encode(["status" => "error", "message" => "User tidak terdaftar sebagai pasien atau rekam medis tidak terhubung"]);
    $conn->close();
    exit;
}

$rekam_medis_id = $user_data['rekam_medis_id'];
$file_foto_user = $user_data['file_foto']; // Path foto dari users
$jenis_kelamin_user = $user_data['jenis_kelamin']; // Jenis kelamin dari users
$nama_user = $user_data['nama_pengguna']; // Nama dari users

// 3. Query: Ambil data pasien dari tabel rekam_medis (Hanya untuk RM, ID, dan Tanggal Lahir)
$sql_pasien = "SELECT id, rekam_medis AS no_identitas, tanggal_lahir 
               FROM rekam_medis 
               WHERE id = ?"; 

$stmt_pasien = $conn->prepare($sql_pasien);
$stmt_pasien->bind_param("i", $rekam_medis_id);
$stmt_pasien->execute();
$result_pasien = $stmt_pasien->get_result();

if ($result_pasien && $result_pasien->num_rows > 0) {
    $data = $result_pasien->fetch_assoc();
    
    // GABUNGKAN DATA: Gantikan data rekam_medis dengan data ter-update dari users
    $data['file_foto'] = $file_foto_user;
    $data['jenis_kelamin'] = $jenis_kelamin_user; 
    $data['nama'] = $nama_user; // Prioritaskan nama dari users
    
    echo json_encode($data);
} else {
    echo json_encode(["status" => "error", "message" => "Data pasien tidak ditemukan di rekam_medis"]);
}

$conn->close();