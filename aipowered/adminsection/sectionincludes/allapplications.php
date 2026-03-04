<?php
// Function to generate safe IDs
function safe_id($type, $id){
    $cleanType = preg_replace('/[^a-zA-Z0-9]/', '', $type);
    return $cleanType . $id;
}

/* =========================================
   HANDLE ADMIN ACTION (APPROVE / REJECT / DENY)
========================================= */

if(isset($_POST['update_status'])){

    $app_id = intval($_POST['app_id']);
    $app_type = $_POST['app_type'];
    $new_status = $_POST['new_status'];
    $reason = mysqli_real_escape_string($conn, $_POST['reason']);

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

        // ✅ Get citizen info before updating
        $getUser = mysqli_query($conn, 
            "SELECT full_name, email, national_id 
             FROM $table WHERE id=$app_id LIMIT 1");

        if(mysqli_num_rows($getUser) > 0){

            $user = mysqli_fetch_assoc($getUser);
            $full_name = $user['full_name'];
            $email = $user['email'];
            $national_id = $user['national_id'];

            // ✅ Update status
            $update = "UPDATE $table 
                       SET status='$new_status', admin_reason='$reason' 
                       WHERE id=$app_id";

            mysqli_query($conn, $update);

            require 'phpincludes/PHPMailer/src/PHPMailer.php';
            require 'phpincludes/PHPMailer/src/SMTP.php';
            require 'phpincludes/PHPMailer/src/Exception.php';

            try {

                $mail = new PHPMailer\PHPMailer\PHPMailer(true);
                $mail->isSMTP();
                $mail->Host       = 'smtp.gmail.com';
                $mail->SMTPAuth   = true;
                $mail->Username   = 'kezjoana7@gmail.com';
                $mail->Password   = 'xddr fkbk swkt nikk'; 
                $mail->SMTPSecure = PHPMailer\PHPMailer\PHPMailer::ENCRYPTION_STARTTLS;
                $mail->Port       = 587;

                $mail->setFrom('mytourdraft@gmail.com', 'Irembo AI-POWERED');
                $mail->addAddress($email);

                $mail->isHTML(true);
                $mail->Subject = "Irembo AI-POWERED: Application Status Update";

                // Status color
                $color = ($new_status == 'Approved') ? 'green' : 'red';

                $mail->Body = "
                    <p>Dear {$full_name},</p>

                    <p>Your <strong>{$app_type}</strong> application 
                    (National ID: {$national_id}) has been reviewed.</p>

                    <p>Status: 
                    <strong style='color:{$color};'>{$new_status}</strong></p>

                    <p><strong>Admin Comment:</strong><br>
                    {$reason}</p>

                    <p>Please log into your account for more details.</p>

                    <p>Thank you,<br>
                    Irembo AI-POWERED Team</p>
                ";

                $mail->send();

            } catch (Exception $e) {
                // Optional: log error
            }

        }
        echo "<script>
        swal({
            title: 'Done!',
            text: 'Action saved.',
            icon: 'success',
            button: 'OK'
        }).then(() => {
            window.location.href = 'allapplications.php';
        });
        </script>";
    }
}

/* =========================================
   FETCH ALL APPLICATIONS
========================================= */
$allApplications = mysqli_query($conn, "
SELECT id, service_name, application_date, status, 'Criminal Record' as type
FROM applicationcriminalrecord
UNION ALL
SELECT id, service_name, application_date, status, 'Driving License'
FROM applicationdrivinglicense
UNION ALL
SELECT id, service_name, application_date, status, 'Driving Replacement'
FROM applicationdrivingreplacement
UNION ALL
SELECT id, service_name, application_date, status, 'Good Conduct'
FROM applicationgoodconduct
UNION ALL
SELECT id, service_name, application_date, status, 'Marriage Certificate'
FROM applicationmarriagecertificate
UNION ALL
SELECT id, service_name, application_date, status, 'National ID'
FROM applicationnationalid
UNION ALL
SELECT id, service_name, application_date, status, 'Passport'
FROM applicationpassport
UNION ALL
SELECT id, service_name, application_date, status, 'Passport Replacement'
FROM applicationpassportreplacement
UNION ALL
SELECT id, service_name, application_date, status, 'Provisional License'
FROM applicationprovisionallicense
ORDER BY application_date DESC
");
?>






























<section class="container mt-4">
<h4>All Applications (Admin Panel)</h4>

<?php if(mysqli_num_rows($allApplications) > 0): ?>
<table class="table table-bordered table-striped">
<thead>
<tr>
    <th>ID</th>
    <th>Type</th>
    <th>Service Name</th>
    <th>Date</th>
    <th>Status</th>
    <th>Action</th>
</tr>
</thead>
<tbody>
<?php while($row = mysqli_fetch_assoc($allApplications)): 
    $status = strtolower($row['status']);
    $formId = safe_id($row['type'], $row['id']);
?>
<tr>
<td><?php echo $row['id']; ?></td>
<td><?php echo $row['type']; ?></td>
<td><?php echo $row['service_name']; ?></td>
<td><?php echo $row['application_date']; ?></td>
<td>
<?php
if($status == 'pending') echo '<span class="text-warning fw-bold">Pending</span>';
elseif($status == 'approved') echo '<span class="text-success fw-bold">Approved</span>';
elseif($status == 'rejected') echo '<span class="text-danger fw-bold">Rejected</span>';
elseif($status == 'denied') echo '<span class="text-purple fw-bold">Denied</span>';
else echo $row['status'];
?>
</td>
<td>
<?php if($status == 'pending'): ?>
    <button class="btn btn-primary btn-sm toggle-form-btn" data-form-id="<?php echo $formId; ?>">
        Review
    </button>
<?php else: ?>
    -
<?php endif; ?>
</td>
</tr>

<!-- HIDDEN INLINE FORM -->
<tr class="review-form-row" id="form-<?php echo $formId; ?>" style="display:none;">
<td colspan="6">
<form method="POST">
    <input type="hidden" name="app_id" value="<?php echo $row['id']; ?>">
    <input type="hidden" name="app_type" value="<?php echo $row['type']; ?>">
    <input type="hidden" name="new_status">

    <div class="mb-3">
        <label>Reason (Required)</label>
        <textarea name="reason" class="form-control" required></textarea>
    </div>

    <button type="submit" name="update_status" class="btn btn-success"
        onclick="this.form.new_status.value='Approved'; return true;">Approve</button>

    <button type="submit" name="update_status" class="btn btn-danger"
        onclick="this.form.new_status.value='Rejected'; return true;">Reject</button>

    <button type="submit" name="update_status" class="btn btn-dark"
        onclick="this.form.new_status.value='Denied'; return true;">Deny</button>

    <button type="button" class="btn btn-secondary close-form-btn">Close</button>
</form>
</td>
</tr>

<?php endwhile; ?>
</tbody>
</table>
<?php else: ?>
<p>No applications found.</p>
<?php endif; ?>
</section>

<!-- JS TO TOGGLE FORMS -->
<script>
document.querySelectorAll('.toggle-form-btn').forEach(btn => {
    btn.addEventListener('click', function(){
        const formId = 'form-' + this.dataset.formId;
        // hide all other forms
        document.querySelectorAll('.review-form-row').forEach(f => f.style.display = 'none');
        // show this form
        document.getElementById(formId).style.display = 'table-row';
    });
});

// close button
document.querySelectorAll('.close-form-btn').forEach(btn => {
    btn.addEventListener('click', function(){
        this.closest('.review-form-row').style.display = 'none';
    });
});
</script>