<?php
if(isset($_POST['ai_compare'])){
    $apiKey = "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";
    $image = $_POST['image'];
    $type  = $_POST['type'];
    $result = mysqli_query($conn, "SELECT * FROM systeminfo ORDER BY id ASC LIMIT 1");
    $row = mysqli_fetch_assoc($result);
    $columnMap = [
        'National ID' => 'nationalid',
        'Driving License' => 'drivinglicense',
        'Driving Replacement' => 'drivinglicense',
        'Passport' => 'passport',
        'Marriage Certificate' => 'marriagecertificate',
        'Good Conduct' => 'goodconduct',
        'Provisional License' => 'provisionaldriving'
    ];
    if(!isset($columnMap[$type])){
        echo "<div class='alert alert-warning'>No AI template configured.</div>";
    }
    $column = $columnMap[$type];
    if(empty($row[$column])){
        echo "<div class='alert alert-danger'>Sample document not uploaded in system settings.</div>";
    }
    $sampleImagePath = "systemimages/".$row[$column];
    $userImage   = base64_encode(file_get_contents($image));
    $sampleImage = base64_encode(file_get_contents($sampleImagePath));
    $data = [
        "model"=>"gpt-4.1-mini",

        "input"=>[
            [
                "role"=>"user",
                "content"=>[

                    [
                        "type"=>"input_text",
                        "text"=>"Compare these two government documents. 
                        The first image is the official government template.
                        The second image is submitted by a citizen.
                        Detect forgery, layout mismatch, missing seals, font differences, or tampering.
                        Provide authenticity score from 0-100."
                    ],

                    [
                        "type"=>"input_image",
                        "image_base64"=>$sampleImage
                    ],

                    [
                        "type"=>"input_image",
                        "image_base64"=>$userImage
                    ]
                ]
            ]
        ]
    ];
    $ch = curl_init("https://api.openai.com/v1/responses");

    curl_setopt_array($ch,[

        CURLOPT_RETURNTRANSFER => true,

        CURLOPT_HTTPHEADER => [
            "Authorization: Bearer ".$apiKey,
            "Content-Type: application/json"
        ],

        CURLOPT_POST => true,
        CURLOPT_POSTFIELDS => json_encode($data)

    ]);

    $response = curl_exec($ch);
    curl_close($ch);
    $result = json_decode($response,true);
    echo "<div class='alert alert-info'>";

    if(isset($result['output'][0]['content'][0]['text'])){
        echo nl2br($result['output'][0]['content'][0]['text']);
    }else{
        echo "AI could not analyze the document.";
        exit();
    }

    echo "</div>";
}
function safe_id($type, $id){
    $cleanType = preg_replace('/[^a-zA-Z0-9]/', '', $type);
    return $cleanType . $id;
}
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

        mysqli_query($conn,
            "UPDATE $table 
             SET status='$new_status', admin_reason='$reason' 
             WHERE id=$app_id");

        echo "<script>
        swal({
            title: 'Done!',
            text: 'Action saved.',
            icon: 'success'
        }).then(()=>{ location.reload(); });
        </script>";
    }
}
$allApplications = mysqli_query($conn, "

SELECT id, service_name, application_date, status,
attachment as file1, NULL as file2,
'Criminal Record' as type
FROM applicationcriminalrecord

UNION ALL

SELECT id, service_name, application_date, status,
NULL,NULL,'Driving License'
FROM applicationdrivinglicense

UNION ALL

SELECT id, service_name, application_date, status,
old_license_image, police_document,
'Driving Replacement'
FROM applicationdrivingreplacement

UNION ALL

SELECT id, service_name, application_date, status,
NULL,NULL,'Good Conduct'
FROM applicationgoodconduct

UNION ALL

SELECT id, service_name, application_date, status,
NULL,NULL,'Marriage Certificate'
FROM applicationmarriagecertificate

UNION ALL

SELECT id, service_name, application_date, status,
old_id_image, police_document,
'National ID'
FROM applicationnationalid

UNION ALL

SELECT id, service_name, application_date, status,
NULL,NULL,'Passport'
FROM applicationpassport

UNION ALL

SELECT id, service_name, application_date, status,
NULL,NULL,'Passport Replacement'
FROM applicationpassportreplacement

UNION ALL

SELECT id, service_name, application_date, status,
NULL,NULL,'Provisional License'
FROM applicationprovisionallicense

ORDER BY application_date DESC
");
?>

<section class="p-4" style="margin-top:60px;">

<h4>All Applications (Admin Panel)</h4>

<?php if(mysqli_num_rows($allApplications) > 0): ?>

<table class="table table-bordered table-striped">

<thead>
<tr>
<th>ID</th>
<th>Type</th>
<th>Date</th>
<th>Status</th>
<th>Documents</th>
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
<td><?php echo $row['application_date']; ?></td>

<td>
<?php
if($status=='pending') echo "<span class='text-warning fw-bold'>Pending</span>";
elseif($status=='approved') echo "<span class='text-success fw-bold'>Approved</span>";
elseif($status=='rejected') echo "<span class='text-danger fw-bold'>Rejected</span>";
elseif($status=='denied') echo "<span class='text-dark fw-bold'>Denied</span>";
?>
</td>

<td>

<?php

switch($row['type']){

case 'Criminal Record':
$folder="criminalrecord/";
break;

case 'Driving Replacement':
$folder="drivingreplacement/";
break;

case 'National ID':
$folder="nationalid/";
break;

default:
$folder="";
}

if($folder!="" && !empty($row['file1'])){

$img=$folder.$row['file1'];

echo "<a href='$img' target='_blank'>
<img src='$img' width='60' style='border:1px solid #ccc;border-radius:4px;padding:2px;'>
</a>";

}else{
echo "-";
}

?>

</td>
<td>

<?php

if($folder!="" && !empty($row['file2'])){

echo "<a href='{$folder}{$row['file2']}' target='_blank'>
<img src='{$folder}{$row['file2']}' width='60' style='border:1px solid #ccc;border-radius:4px;padding:2px;'>
</a>";

}else{
echo "-";
}

?>

</td>

<td>

<?php

if($folder!="" && !empty($row['file1'])){

$img=$folder.$row['file1'];

echo "<button class='btn btn-primary btn-sm ai-btn'
data-img='$img'
data-type='{$row['type']}'>
 AI Analysis
</button>";

}else{
echo "-";
}

?>

</td>

<td>

<?php if($status=='pending'): ?>

<button class="btn btn-primary btn-sm toggle-form-btn"
data-form-id="<?php echo $formId; ?>">
Review
</button>

<?php else: echo "-"; endif; ?>

</td>

</tr>


<tr class="review-form-row" id="form-<?php echo $formId; ?>" style="display:none;">
<td colspan="8">
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

$details = null;

if(isset($table_map[$row['type']])){
    
    $table = $table_map[$row['type']];
    
    $q = mysqli_query($conn,"SELECT * FROM $table WHERE id=".$row['id']);
    
    if(mysqli_num_rows($q)>0){
        $details = mysqli_fetch_assoc($q);
    }
}

?>


<?php if($details): ?>

<div class="card mb-3">
<div class="card-header bg-light fw-bold">
Application Details
</div>

<div class="card-body">

<div class="row">

<?php foreach($details as $field=>$value): ?>

<?php if($field!='status' && $field!='admin_reason'): ?>

<div class="col-md-4">

<label class="fw-bold text-muted">
<?php echo ucfirst(str_replace("_"," ",$field)); ?>
</label>

<div>

<?php
if(!empty($value) && preg_match('/\.(jpg|jpeg|png|gif)$/i',$value)){
    echo "<img src='$folder$value' width='120' class='img-thumbnail'>";
}else{
    echo htmlspecialchars($value);
}
?>

</div>

</div>

<?php endif; ?>

<?php endforeach; ?>

</div>

</div>
</div>

<?php endif; ?>
<form method="POST">

<input type="hidden" name="app_id" value="<?php echo $row['id']; ?>">
<input type="hidden" name="app_type" value="<?php echo $row['type']; ?>">
<input type="hidden" name="new_status">

<div class="mb-3">
<label>Reason</label>
<textarea name="reason" class="form-control" required></textarea>
</div>

<button type="submit" name="update_status"
class="btn btn-success"
onclick="this.form.new_status.value='Approved'">Approve</button>

<button type="submit" name="update_status"
class="btn btn-danger"
onclick="this.form.new_status.value='Rejected'">Reject</button>

<button type="submit" name="update_status"
class="btn btn-dark"
onclick="this.form.new_status.value='Denied'">Deny</button>

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



<!-- AI RESULT MODAL -->

<div class="modal fade" id="aiModal">

<div class="modal-dialog modal-lg">

<div class="modal-content">

<div class="modal-header">
<h5>AI Document Analysis</h5>
<button  class="btn-close" data-bs-dismiss="modal">X</button>
</div>

<div class="modal-body">

<div id="aiResult">

<center>
<div class="spinner-border"></div>
<p>Analyzing document...</p>
</center>

</div>

</div>

</div>
</div>
</div>



<script>

/* REVIEW FORM TOGGLE */

document.querySelectorAll('.toggle-form-btn').forEach(btn=>{
btn.onclick=function(){

const id='form-'+this.dataset.formId;

document.querySelectorAll('.review-form-row')
.forEach(f=>f.style.display='none');

document.getElementById(id).style.display='table-row';

}
});

document.querySelectorAll('.close-form-btn').forEach(btn=>{
btn.onclick=function(){
this.closest('.review-form-row').style.display='none';
}
});


/* AI DOCUMENT COMPARISON */

document.querySelectorAll('.ai-btn').forEach(btn=>{

btn.onclick=function(){

let img=this.dataset.img;
let type=this.dataset.type;

document.getElementById('aiResult').innerHTML=
"<center><div class='spinner-border'></div><p>Analyzing...</p></center>";

let modal=new bootstrap.Modal(document.getElementById('aiModal'));
modal.show();

fetch("",{

method:"POST",
headers:{"Content-Type":"application/x-www-form-urlencoded"},

body:"ai_compare=1&image="+encodeURIComponent(img)+"&type="+encodeURIComponent(type)

})

.then(res=>res.text())

.then(data=>{
document.getElementById('aiResult').innerHTML=data;
});

}

});

</script>