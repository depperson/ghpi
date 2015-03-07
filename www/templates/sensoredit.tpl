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
                <div class="col-sm-9">
                    <form class="form-horizontal" method="post" action="sensor.php">
                        <div class="form-group">
                            <label class="col-sm-2 control-label">Address</label>
                            <div class="col-sm-5">
                                <p class="form-control-static">{$sensor.address}</p>
                                <input type="hidden" name="address" value="{$sensor.address}">
                                <input type="hidden" name="edit" value="yes">
                            </div>
                        </div>
                        <div class="form-group">
                            <label class="col-sm-2 control-label">Description</label>
                            <div class="col-sm-5">
                                <input class="form-control" name="name" value="{$sensor.name}">
                            </div>
                        </div>
                        <div class="form-group">
                            <div class="col-sm-offset-2 col-sm-10">
                                <button type="submit" class="btn btn-default btn-primary">Save</button>
                            </div>
                        </div>
                    </form>
                </div>
            </div><!-- end form row //-->
            {foreach $files file}
            {$file}
            {/foreach}
        </div>
    </div>
{include file="footer.tpl"}
