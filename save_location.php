<?php
header("Content-Type: application/json");

$servername = "localhost";
$username   = "root";
$password   = "";
$dbname     = "map_db";

$conn = new mysqli($servername, $username, $password, $dbname);
$conn->set_charset("utf8mb4");

if ($conn->connect_error) {
    die(json_encode(["status" => "error", "message" => "Connection failed"]));
}

$name = $_POST['name'];
$latitude = $_POST['latitude'];
$longitude = $_POST['longitude'];

if (empty($name)) {
    echo json_encode(["status" => "error", "message" => "Name required"]);
    exit;
}

$sql = "INSERT INTO locations (name, latitude, longitude)
        VALUES ('$name', '$latitude', '$longitude')";

if ($conn->query($sql) === TRUE) {
    echo json_encode(["status" => "success"]);
} else {
    echo json_encode(["status" => "error", "message" => $conn->error]);
}

$conn->close();
?>
