<?php
if(isset($_POST['applycriminalrecord'])){

    include 'connection.php';

    $national_id = mysqli_real_escape_string($conn, $_POST['national_id']);

    // 🔎 Check if citizen exists
    $citizen_check = mysqli_query($conn, 
        "SELECT * FROM citizensregistry WHERE national_id='$national_id' LIMIT 1");

    if(mysqli_num_rows($citizen_check) == 0){
        echo "<script>
        swal('Citizen Not Found!',
             'The provided National ID is not registered in the system.',
             'error');
        </script>";
    }

    // 🔎 Check existing pending application
    $check = mysqli_query($conn, 
        "SELECT * FROM applicationcriminalrecord 
         WHERE national_id='$national_id' 
         AND status='Pending'");

    if(mysqli_num_rows($check) > 0){
        echo "<script>
        swal('Application Exists!',
             'You already have a pending criminal record application.',
             'warning');
        </script>";
    }

    // =========================
    // Collect Data
    // =========================
    $full_name = mysqli_real_escape_string($conn, $_POST['full_name']);
    $email = mysqli_real_escape_string($conn, $_POST['email']);
    $phone = mysqli_real_escape_string($conn, $_POST['phone']);
    $purpose = mysqli_real_escape_string($conn, $_POST['purpose']);

    $service_name = $_POST['service_name'];
    $processing_days = (int)$_POST['processing_time'];
    $price = $_POST['price'];
    $provided_by = $_POST['provided_by'];

    $application_date = date("Y-m-d H:i:s");
    $expected_feedback_date = date("Y-m-d H:i:s", strtotime("+$processing_days days"));

    // =========================
    // File Upload
    // =========================
    $upload_dir = "adminsection/criminalrecord/";
    if(!is_dir($upload_dir)) mkdir($upload_dir, 0777, true);

    $file_name = time() . "_" . $_FILES['attachment']['name'];
    $upload_path = $upload_dir . $file_name;
    move_uploaded_file($_FILES['attachment']['tmp_name'], $upload_path);

    // =========================
    // Insert Application
    // =========================
    mysqli_query($conn, "INSERT INTO applicationcriminalrecord
        (full_name, email, phone, national_id, purpose, attachment,
         service_name, processing_days, price, provided_by,
         application_date, expected_feedback_date)
        VALUES
        ('$full_name','$email','$phone','$national_id','$purpose','$upload_path',
         '$service_name','$processing_days','$price','$provided_by',
         '$application_date','$expected_feedback_date')");


    /* =====================================
       📧 SEND EMAIL NOTIFICATION TO CITIZEN
    ===================================== */

    require 'backendcodes/PHPMailer/src/PHPMailer.php';
    require 'backendcodes/PHPMailer/src/SMTP.php';
    require 'backendcodes/PHPMailer/src/Exception.php';

    try {

        $mail = new PHPMailer(true);
        $mail->isSMTP();
        $mail->Host       = 'smtp.gmail.com';
        $mail->SMTPAuth   = true;
        $mail->Username   = 'kezjoana7@gmail.com';
        $mail->Password   = 'xddr fkbk swkt nikk'; 
        $mail->SMTPSecure = PHPMailer::ENCRYPTION_STARTTLS;
        $mail->Port       = 587;
        $mail->isHTML(true);
        $mail->setFrom('mytourdraft@gmail.com', 'Irembo AI-POWERED');

        $mail->addAddress($email);

        $mail->Subject = "Irembo AI-POWERED: Criminal Record Application Received";

        $mail->Body = "
            <p>Dear {$full_name},</p>

            <p>Your <strong>Criminal Record Certificate</strong> application has been successfully received.</p>

            <p><strong>Application Details:</strong><br>
            National ID: {$national_id}<br>
            Service: {$service_name}<br>
            Purpose: {$purpose}<br>
            Price: {$price}<br>
            Processing Time: {$processing_days} day(s)</p>

            <p><strong>Expected Feedback Date:</strong> {$expected_feedback_date}</p>

            <p>You will receive another notification once your certificate is processed.</p>

            <p>If you did not apply for this service, please contact support immediately.</p>

            <p>Thank you,<br>
            Irembo AI-POWERED Team</p>
        ";

        $mail->send();

        echo "<script>
        swal({
            title: 'Success!',
            text: 'Application submitted successfully! A confirmation email has been sent.',
            icon: 'success',
            button: 'OK'
        }).then(() => {
            window.location.href = '';
        });
        </script>";

    } catch (Exception $e) {

        echo "<script>
        swal({
            title: 'Application Submitted!',
            text: 'Application saved but email notification failed.',
            icon: 'warning',
            button: 'OK'
        }).then(() => {
            window.location.href = '';
        });
        </script>";
    }
}
?>