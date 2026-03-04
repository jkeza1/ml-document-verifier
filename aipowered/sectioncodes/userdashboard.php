<?php

// Function to generate safe modal IDs
function safe_modal_id($type, $id){
    $cleanType = preg_replace('/[^a-zA-Z0-9]/', '', $type);
    return $cleanType . $id;
}

/* ===============================
   HANDLE CANCELLATION
================================ */
if(isset($_POST['cancel_application'])){
    $app_id = intval($_POST['app_id']);
    $app_type = $_POST['app_type'];

    $table_map = [
        'Criminal Record' => 'applicationcriminalrecord',
        'Driving License' => 'applicationdrivinglicense',
        'Driving Replacement' => 'applicationdrivingreplacement',
        'Good Conduct' => 'applicationgoodconduct',
        'Marriage Certificate' => 'applicationmarriagecertificate',
        'National ID' => 'applicationnationalid',
        'Passport' => 'applicationpassport',
        'Passport Replacement' => 'applicationpassportreplacement',
        'Provisional License' => 'applicationprovisionallicense'
    ];

    if(array_key_exists($app_type, $table_map)){
        $table = $table_map[$app_type];

        if($table === 'applicationmarriagecertificate') {
            $update_query = "UPDATE $table SET status='Cancelled' 
                             WHERE id=$app_id 
                             AND (applicant_email='$user_email' OR applicant_phone='$user_phone') 
                             AND status='Pending'";
        } else {
            $update_query = "UPDATE $table SET status='Cancelled' 
                             WHERE id=$app_id 
                             AND (email='$user_email' OR phone='$user_phone') 
                             AND status='Pending'";
        }

        mysqli_query($conn, $update_query);
        echo "<script>window.location.href='userdashboard.php';</script>";
        exit();
    }
}

/* ===============================
   HANDLE REMIND APPLICATION
   (Citizen reminding Admin)
================================ */
if(isset($_POST['remind_application'])){
    $app_id = intval($_POST['app_id']);
    $app_type = $_POST['app_type'];

    $table_map = [
        'Criminal Record' => 'applicationcriminalrecord',
        'Driving License' => 'applicationdrivinglicense',
        'Driving Replacement' => 'applicationdrivingreplacement',
        'Good Conduct' => 'applicationgoodconduct',
        'Marriage Certificate' => 'applicationmarriagecertificate',
        'National ID' => 'applicationnationalid',
        'Passport' => 'applicationpassport',
        'Passport Replacement' => 'applicationpassportreplacement',
        'Provisional License' => 'applicationprovisionallicense'
    ];

    if(array_key_exists($app_type, $table_map)){
        $table = $table_map[$app_type];

        // Fetch citizen info for context
        if($table === 'applicationmarriagecertificate'){
            $query = mysqli_query($conn, "SELECT applicant_email AS email, applicant_phone AS phone FROM $table WHERE id=$app_id");
        } else {
            $query = mysqli_query($conn, "SELECT email, phone FROM $table WHERE id=$app_id");
        }

        $row_user = mysqli_fetch_assoc($query);
        $citizen_email = $row_user['email'];
        $citizen_phone = $row_user['phone'];

        // Admin email
        $admin_email = "kezjoana7@gmail.com";

        // PHPMailer to send reminder
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
            $mail->setFrom('kezjoana7@gmail.com', 'Irembo AI-POWERED');

            $mail->addAddress($admin_email);

            $mail->Subject = "Reminder: Pending Application";

            $mail->Body = "
                <p>Hello Admin,</p>
                <p>The citizen has requested a reminder for a pending application:</p>
                <ul>
                    <li><strong>Application ID:</strong> {$app_id}</li>
                    <li><strong>Application Type:</strong> {$app_type}</li>
                    <li><strong>Citizen Email:</strong> {$citizen_email}</li>
                    <li><strong>Citizen Phone:</strong> {$citizen_phone}</li>
                </ul>
                <p>Please review and update the application status if necessary.</p>
                <p>Thank you,<br>Irembo AI-POWERED System</p>
            ";

            $mail->send();

            echo "<script>alert('Reminder has been sent to the administration.');</script>";
            echo "<script>window.location.href='userdashboard.php';</script>";
            exit();

        } catch (Exception $e) {
            echo "<script>alert('Failed to send reminder to administration.');</script>";
            echo "<script>window.location.href='userdashboard.php';</script>";
            exit();
        }
    }
}

/* ===============================
   FUNCTION: COUNT PENDING FOR A TYPE
================================ */
function count_pending_by_type($conn, $app_type){
    $table_map = [
        'Criminal Record' => 'applicationcriminalrecord',
        'Driving License' => 'applicationdrivinglicense',
        'Driving Replacement' => 'applicationdrivingreplacement',
        'Good Conduct' => 'applicationgoodconduct',
        'Marriage Certificate' => 'applicationmarriagecertificate',
        'National ID' => 'applicationnationalid',
        'Passport' => 'applicationpassport',
        'Passport Replacement' => 'applicationpassportreplacement',
        'Provisional License' => 'applicationprovisionallicense'
    ];

    $table = $table_map[$app_type];
    $query = mysqli_query($conn, "SELECT COUNT(*) as total FROM $table WHERE status='Pending'");
    $row = mysqli_fetch_assoc($query);
    return $row['total'];
}

/* ===============================
   FUNCTION: GET POSITION OF CURRENT APPLICATION (BY TYPE)
================================ */
function get_application_position_by_type($conn, $app_type, $application_date){
    $table_map = [
        'Criminal Record' => 'applicationcriminalrecord',
        'Driving License' => 'applicationdrivinglicense',
        'Driving Replacement' => 'applicationdrivingreplacement',
        'Good Conduct' => 'applicationgoodconduct',
        'Marriage Certificate' => 'applicationmarriagecertificate',
        'National ID' => 'applicationnationalid',
        'Passport' => 'applicationpassport',
        'Passport Replacement' => 'applicationpassportreplacement',
        'Provisional License' => 'applicationprovisionallicense'
    ];

    $table = $table_map[$app_type];

    $query = mysqli_query($conn, "
        SELECT COUNT(*) as total 
        FROM $table 
        WHERE status='Pending' 
        AND application_date < '$application_date'
    ");
    $row = mysqli_fetch_assoc($query);
    return $row['total'] + 1; // Position
}

/* ===============================
   FETCH ALL APPLICATIONS
================================ */
$allApplications = mysqli_query($conn, "
SELECT id, service_name, application_date, status, admin_reason, expected_feedback_date, 'Criminal Record' as type
FROM applicationcriminalrecord
WHERE email='$user_email' OR phone='$user_phone'

UNION ALL
SELECT id, service_name, application_date, status, admin_reason, expected_feedback_date, 'Driving License'
FROM applicationdrivinglicense
WHERE email='$user_email' OR phone='$user_phone'

UNION ALL
SELECT id, service_name, application_date, status, admin_reason, expected_feedback_date, 'Driving Replacement'
FROM applicationdrivingreplacement
WHERE email='$user_email' OR phone='$user_phone'

UNION ALL
SELECT id, service_name, application_date, status, admin_reason, expected_feedback_date, 'Good Conduct'
FROM applicationgoodconduct
WHERE email='$user_email' OR phone='$user_phone'

UNION ALL
SELECT id, service_name, application_date, status, admin_reason, expected_feedback_date, 'Marriage Certificate'
FROM applicationmarriagecertificate
WHERE applicant_email='$user_email' OR applicant_phone='$user_phone'

UNION ALL
SELECT id, service_name, application_date, status, admin_reason, expected_feedback_date, 'National ID'
FROM applicationnationalid
WHERE email='$user_email' OR phone='$user_phone'

UNION ALL
SELECT id, service_name, application_date, status, admin_reason, expected_feedback_date, 'Passport'
FROM applicationpassport
WHERE email='$user_email' OR phone='$user_phone'

UNION ALL
SELECT id, service_name, application_date, status, admin_reason, expected_feedback_date, 'Passport Replacement'
FROM applicationpassportreplacement
WHERE email='$user_email' OR phone='$user_phone'

UNION ALL
SELECT id, service_name, application_date, status, admin_reason, expected_feedback_date, 'Provisional License'
FROM applicationprovisionallicense
WHERE email='$user_email' OR phone='$user_phone'

ORDER BY application_date DESC
");
?>

<section class="ftco-section services-section">
<div class="container">
<div class="p-4">
<h5>Your Applications</h5>

<?php if(mysqli_num_rows($allApplications) > 0): ?>
<table class="table table-striped table-bordered">
<thead>
<tr>
    <th>ID</th>
    <th>Service Type</th>
    <th>Service Name</th>
    <th>Application Date</th>
    <th>Status</th>
    <th>Action</th>
    <th>View</th>
</tr>
</thead>
<tbody>

<?php while($row = mysqli_fetch_assoc($allApplications)):
    $status = strtolower($row['status']);
    $modalId = safe_modal_id($row['type'], $row['id']);

    // Count pending for this type and position
    $total_pending = ($status == 'pending') ? count_pending_by_type($conn, $row['type']) : null;
    $position = ($status == 'pending') ? get_application_position_by_type($conn, $row['type'], $row['application_date']) : null;

    // Show remind button 5+ days after expected feedback
    $show_remind = false;
    if($status == 'pending' && !empty($row['expected_feedback_date'])){
        $today = new DateTime();
        $feedback_date = new DateTime($row['expected_feedback_date']);
        $interval = $today->diff($feedback_date)->days;
        if($today > $feedback_date && $interval >= 5){
            $show_remind = true;
        }
    }
?>

<tr>
<td><?php echo $row['id']; ?></td>
<td><?php echo $row['type']; ?></td>
<td><?php echo $row['service_name']; ?></td>
<td><?php echo $row['application_date']; ?></td>

<td>
<?php
if($status == 'pending'){ 
    echo '<span style="color:orange;font-weight:bold;">Pending</span><br>';
    echo '<small>';
    echo 'Pending: <b>'.$total_pending.'</b><br>';
    echo 'Position: <b>'.$position.'</b><br>';
    echo 'Before You: <b>'.($position - 1).'</b>';
    echo '</small>';
}
elseif($status == 'approved') echo '<span style="color:green;font-weight:bold;">Approved</span>';
elseif($status == 'rejected') echo '<span style="color:red;font-weight:bold;">Rejected</span>';
elseif($status == 'cancelled') echo '<span style="color:gray;font-weight:bold;">Cancelled</span>';
else echo $row['status'];
?>
</td>

<td>
<?php if($status == 'pending'): ?>
<form method="POST" style="margin:0; display:inline-block;">
    <input type="hidden" name="app_id" value="<?php echo $row['id']; ?>">
    <input type="hidden" name="app_type" value="<?php echo $row['type']; ?>">
    <button type="submit" name="cancel_application" 
        class="btn btn-danger btn-sm"
        onclick="return confirm('Are you sure you want to cancel this application?');">
        Cancel
    </button>
</form>

<?php if($show_remind): ?>
<form method="POST" style="margin:0; display:inline-block;">
    <input type="hidden" name="app_id" value="<?php echo $row['id']; ?>">
    <input type="hidden" name="app_type" value="<?php echo $row['type']; ?>">
    <button type="submit" name="remind_application" class="btn btn-warning btn-sm">
        Remind
    </button>
</form>
<?php endif; ?>

<?php else: ?>
-
<?php endif; ?>
</td>

<td>
<button type="button" class="btn btn-info btn-sm"
data-bs-toggle="modal" data-bs-target="#<?php echo $modalId; ?>">
View More
</button>

<div class="modal fade" id="<?php echo $modalId; ?>" tabindex="-1">
<div class="modal-dialog modal-lg">
<div class="modal-content">
<div class="modal-header">
<h5 class="modal-title">Application Details</h5>
<button type="button" class="btn-close" data-bs-dismiss="modal"></button>
</div>
<div class="modal-body">

<?php
$table_map = [
'Criminal Record' => 'applicationcriminalrecord',
'Driving License' => 'applicationdrivinglicense',
'Driving Replacement' => 'applicationdrivingreplacement',
'Good Conduct' => 'applicationgoodconduct',
'Marriage Certificate' => 'applicationmarriagecertificate',
'National ID' => 'applicationnationalid',
'Passport' => 'applicationpassport',
'Passport Replacement' => 'applicationpassportreplacement',
'Provisional License' => 'applicationprovisionallicense'
];

$table = $table_map[$row['type']];

if($table === 'applicationmarriagecertificate'){
$detailQuery = mysqli_query($conn, "SELECT * FROM $table 
WHERE id=".$row['id']." 
AND (applicant_email='$user_email' OR applicant_phone='$user_phone')");
} else {
$detailQuery = mysqli_query($conn, "SELECT * FROM $table 
WHERE id=".$row['id']." 
AND (email='$user_email' OR phone='$user_phone')");
}

$detail = mysqli_fetch_assoc($detailQuery);

echo '<table class="table table-bordered">';
foreach($detail as $key => $value){
echo '<tr><th>'.ucwords(str_replace('_',' ',$key)).'</th><td>'.$value.'</td></tr>';
}
echo '</table>';
?>

</div>
<div class="modal-footer">
<button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
</div>
</div>
</div>
</div>

</td>
</tr>

<?php endwhile; ?>
</tbody>
</table>

<?php else: ?>
<p>No applications found.</p>
<?php endif; ?>

</div>
</div>
</section>