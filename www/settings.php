<?php

// open the db
if (!($db = new PDO('sqlite:ghpi.db'))) 
{
  echo '<b>db open failed.</b>';
}


?><!DOCTYPE html>
<html lang="en">
<head>
 <!-- bootstrap //-->
 <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.2/css/bootstrap.min.css">
 <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.2/css/bootstrap-theme.min.css">
 <script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.2/js/bootstrap.min.js"></script>
 <meta name="viewport" content="width=device-width, initial-scale=1">
 <link href="dashboard.css" rel="stylesheet">
 <!--[if lt IE 9]>
  <script src="https://oss.maxcdn.com/html5shiv/3.7.2/html5shiv.min.js"></script>
  <script src="https://oss.maxcdn.com/respond/1.4.2/respond.min.js"></script>
 <![endif]-->
 <!-- /bootstrap //-->
</head>
<body>
    <nav class="navbar navbar-inverse navbar-fixed-top">
      <div class="container-fluid">
        <div class="navbar-header">
          <button type="button" class="navbar-toggle collapsed" data-toggle="collapse" data-target="#navbar" aria-expanded="false" aria-controls="navbar">
            <span class="sr-only">Toggle navigation</span>
            <span class="icon-bar"></span>
            <span class="icon-bar"></span>
            <span class="icon-bar"></span>
          </button>
          <a class="navbar-brand" href="#">GreenhousePi</a>
        </div>
        <div id="navbar" class="navbar-collapse collapse">
          <ul class="nav navbar-nav navbar-right">
            <li><a href="#">Settings</a></li>
            <li><a href="#">About</a></li>
          </ul>
        </div>
      </div>
    </nav>

    <div class="container-fluid">
      <div class="row">
        <div class="col-sm-3 col-md-2 sidebar">
          <ul class="nav nav-sidebar">
            <li class="active"><a href="#sensors">Sensors <span class="sr-only">(current)</span></a></li>
            <li><a href="#weather">Weather</a></li>
          </ul>
        </div>
        <div class="col-sm-9 col-sm-offset-3 col-md-10 col-md-offset-2 main">
          <h1 class="page-header">Setings</h1>
	  <?php	
		// update the zipcode
		if (isset($_POST["zip"])) 
		{
  		  $zip = (int) $_POST["zip"];
  		  $sql = "UPDATE settings SET value=? WHERE name='zip'";
  		  $res = $db->prepare($sql); 
  		  $res->execute(array($zip));  
		  $err = $db->errorInfo();
		  if ($err[0] != '00000')
		  {
			echo '		<div class="alert alert-danger" role="alert">
		  <b>Error!</b>  The db update failed. 
		</div>';
		  } else {
			echo '		<div class="alert alert-success" role="alert">
		  <b>Success!</b>  The new zipcode '. $zip .' was saved.
		</div>';
		  }
		} // end zipcode post if
		
		// edit sensor
		if (isset($_GET["sensor"]))
		{
		  $sensor = $_GET["sensor"];
		  echo '
          <h2 class="sub-header">Sensor '. $sensor .'</h2><a name="sensors"></a>
	  <form class="form-inline" action="'. $_SERVER['PHP_SELF'] .'" method="post">
	    <div class="form-group">
		<label for="nameid">Description</label>
		<input type="text" class="form-control" id="nameid"
			placeholder="Kitchen"';
		  $res = $db->prepare("SELECT value FROM settings WHERE name='$sensor' LIMIT 1;");
                  $res->execute();
                  $row = $res->fetch();
                  if ($row) echo "value='". $row[0] ."'";
		  echo '>
	    </div>
	    <button type="submit" class="btn btn-default">Update</button>
 	  </form>
';
		} else {
		  echo '
          <h2 class="sub-header">Sensors</h2><a name="sensors"></a>
          <div class="table-responsive">
            <table class="table table-striped">
              <thead>
                <tr>
                  <th>Name</th>
                  <th>Actions</th>
                  <th>Reading</th>
                  <th>Description</th>
                </tr>
              </thead>
              <tbody>
';
		$files = glob("/opt/ghpi/rrd/*");
		foreach ($files as $file) {
			echo "                <tr>";
			echo "                  <td>". $file ."</td>";
			echo "                  <td>
						  <a href='#'>edit</a>
                                                </td>";
			echo "                  <td>100.10</td>";
			echo "                  <td>The quick brown fox jumps over the lazy dog.</td>";
			echo "                </tr>";
		}
		echo '
              </tbody>
            </table>
          </div>';
		} ?>

	  <h2 class="sub-header">Weather</h2><a name="weather"></a>
	  <form class="form-inline" action="<?php echo $_SERVER['PHP_SELF']; ?>" method="post">
  	    <div class="form-group">
    	      <label for="zipid">Zipcode</label>
              <input type="text" class="form-control" id="zipid" 
			placeholder="78747" name="zip" <?php
		$res = $db->prepare("SELECT value FROM settings WHERE name='zip' LIMIT 1;");
		$res->execute();
		$row = $res->fetch();
		if ($row) {
		  echo "value='". $row[0] ."'"; 
		}
	      ?> >
            </div>
  	    <button type="submit" class="btn btn-default">Update</button>
 	  </form>



        </div>
      </div>
    </div>

    <!-- Bootstrap core JavaScript
    ================================================== -->
    <!-- Placed at the end of the document so the pages load faster -->
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/1.11.2/jquery.min.js"></script>
    <script src="../../dist/js/bootstrap.min.js"></script>
    <script src="../../assets/js/docs.min.js"></script>
    <!-- IE10 viewport hack for Surface/desktop Windows 8 bug -->
    <script src="../../assets/js/ie10-viewport-bug-workaround.js"></script>


</body>
</html>
