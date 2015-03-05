{include file="header.tpl"}
    <title>GHPi Sensors</title>
{include file="topbar.tpl"}
    <div class="container-fluid">
        <div class="col-sm-9 col-md-10 main">
            {if $mode=="view"}
            <h1 class="page-header">Sensor {$sensor.address}</h1>
            {else}
            <h1 class="page-header">Sensors</h1>
            {/if}
            {if $noticetext}
	    <div class="alert alert-{$noticelevel} role="alert">
	        {$noticetext} 
            </div>{/if}
            {if $mode=="view"}
            <div class="row">
                <div class="col-sm-9">
                    <form class="form-horizontal">
                        <div class="form-group">
                            <label class="col-sm-2 control-label">Address</label>
                            <div class="col-sm-5">
                                <p class="form-control-static">{$sensor.address}</p>
                            </div>
                        </div>
                        <div class="form-group">
                            <label class="col-sm-2 control-label">Description</label>
                            <div class="col-sm-5">
                                <input class="form-control" name="newdesc" value="{$sensor.name}">
                            </div>
                        </div>
                    </form>
                </div>
            </div>
            {else}
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
            {/if}
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
