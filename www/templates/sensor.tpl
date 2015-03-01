<!DOCTYPE html>
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
                <button type="button" class="navbar-toggle collapsed" data-toggle="collapse" 
                    data-target="#navbar" aria-expanded="false" aria-controls="navbar">
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
                    <li><a href="settings.php">Settings</a></li>
                    <li class="active">
                        <a href="#sensors">Sensors <span class="sr-only">(current)</span></a>
                    </li>
                </ul>
            </div>
        <div class="col-sm-9 col-sm-offset-3 col-md-10 col-md-offset-2 main">
            <h1 class="page-header">Sensors</h1>
                {if $noticetext}
	        <div class="alert alert-{$noticelevel} role="alert">
	            {$noticetext} 
        	</div>{/if}
                <form class="form-inline" action="sensor.php" method="post">
                    <div class="form-group">
                        <a href="sensor.php?mode=scan" class="btn btn-primary">Scan</a>
                        <label for="sensorid">or add a sensor</label>
                        <input type="text" class="form-control" id="sensorid"
                            placeholder="28-abcdef" name="sensor">
                        <label for="nameid">with description</label>
                        <input type="text" class="form-control" id="nameid"
                            placeholder="Living room" name="desc">
                        <input type="hidden" name="add" value="yes">
                    </div>
                    <button type="submit" class="btn btn-default">Add</button>
                </form>
                <p> &nbsp; </p>
                {include file="sensorlist.tpl"}
            </div>
        </div>
    </div>

    <!-- Bootstrap core JavaScript  --- disabled
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/1.11.2/jquery.min.js"></script>
    <script src="../../dist/js/bootstrap.min.js"></script>
    <script src="../../assets/js/docs.min.js"></script>
    <script src="../../assets/js/ie10-viewport-bug-workaround.js"></script>
    ================================================== -->


</body>
</html>
