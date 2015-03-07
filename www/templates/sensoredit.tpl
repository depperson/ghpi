{include file="header.tpl"}
    <title>GHPi Sensors</title>
{include file="topbar.tpl"}
    <div class="container-fluid">
        <div class="col-sm-9 col-md-10 main">
            <h1 class="page-header">Sensor {$sensor.address}</h1>
            {if $noticetext}
	    <div class="alert alert-{$noticelevel} role="alert">
	        {$noticetext} 
            </div>{/if}
            <div class="row">
                <div class="col-sm-6">
                    <form class="form-horizontal" method="post" action="sensor.php">
                        <div class="form-group">
                            <label class="col-sm-2 control-label">Address</label>
                            <div class="col-sm-4">
                                <p class="form-control-static">{$sensor.address}</p>
                                <input type="hidden" name="address" value="{$sensor.address}">
                                <input type="hidden" name="edit" value="yes">
                            </div>
                        </div>
                        <div class="form-group">
                            <label class="col-sm-2 control-label">Name</label>
                            <div class="col-sm-5">
                                <input class="form-control" name="name" value="{$sensor.name}">
                            </div>
                        </div>
                        <div class="form-group">
                            <div class="col-sm-offset-2 col-sm-4">
                                <button type="submit" class="btn btn-default btn-primary">Save</button>
                            </div>
                        </div>
                    </form>
                </div>
                <div class="col-sm-6">
                    <img src="graphs/6h-temps-{$sensor.address}.rrd.png">
                </div>
                <p> &nbsp; </p>
            </div><!-- end form row //-->
            <div class="row">
                <div class="col-sm-6">
                    <img src="graphs/1d-temps-{$sensor.address}.rrd.png">
                </div>
                <div class="col-sm-6">
                    <img src="graphs/2d-temps-{$sensor.address}.rrd.png">
                </div>
                <p> &nbsp; </p>
            </div>
            <div class="row">
                <div class="col-sm-6">
                    <img src="graphs/7d-temps-{$sensor.address}.rrd.png">
                </div>
                <div class="col-sm-6">
                    <img src="graphs/14d-temps-{$sensor.address}.rrd.png">
                </div>
                <p> &nbsp; </p>
            </div>
            <div class="row">
                <div class="col-sm-6">
                    <img src="graphs/1m-temps-{$sensor.address}.rrd.png">
                </div>
                <div class="col-sm-6">
                    <img src="graphs/3m-temps-{$sensor.address}.rrd.png">
                </div>
                <p> &nbsp; </p>
            </div>
            <div class="row">
                <div class="col-sm-6">
                    <img src="graphs/1y-temps-{$sensor.address}.rrd.png">
                </div>
            </div>
        </div>
    </div>
{include file="footer.tpl"}
