{include file="header.tpl"}
    <title>GHPi Sensors</title>
{include file="topbar.tpl"}
    <div class="container-fluid">
        <div class="col-sm-9 col-md-10 main">
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
