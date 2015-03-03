{include file="header.tpl"}
    <title>GHPi Settings</title>
{include file="topbar.tpl"}
    <div class="container-fluid">
        <div class="col-sm-6 col-md-12 main">
            <h1 class="page-header">Settings</h1>
                {if $noticetext}
	        <div class="alert alert-{$noticelevel} role="alert">
	            {$noticetext} 
        	</div>{/if}
                <h2 class="sub-header">Sensors</h2><a name="sensors"></a>
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
                <p> &nbsp; </p>
	        <h2 class="sub-header">Weather</h2><a name="weather"></a>
                <div class="row">
                <div class="col-md-6">
	            <form class="form-inline" action="<?php echo $_SERVER['PHP_SELF']; ?>" method="post">
  	                <div class="form-group">
    	                    <label for="zipid">Zipcode</label>
                            <input type="text" class="form-control" id="zipid" 
			        placeholder="78747" name="zip" value="{$zip}">
                        </div>
  	                <button type="submit" class="btn btn-default">Update</button>
 	            </form>
                </div>
                <div class="col-md-6">
                    <p><a href="http://www.wunderground.com/cgi-bin/findweather/getForecast?query=zmw:78655.1.99999&bannertypeclick=wu_clean2day" title="Weather Forecast" target="_blank"><img src="http://weathersticker.wunderground.com/weathersticker/cgi-bin/banner/ban/wxBanner?bannertype=wu_clean2day_cond&zip={$zip}&language=EN" alt="Find more about Weather Underground" width="300" /></a></p>
                </div>
            </div>



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
