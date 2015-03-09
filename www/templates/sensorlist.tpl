                <div class="table-responsive">
                    <table class="table table-striped">
                        <thead>
                            <tr>
                                <th class="col-md-2">Name</th>
                                <th class="col-md-2">Actions</th>
                                <th>Description</th>
                            </tr>
                        </thead>
                        <tbody>
{foreach $sensors sensor}
                            <tr>
                                <td>{$sensor.address}</td>
                                <td>
                                    <a href='sensor.php?sensor={$sensor.address}'>
                                        <img src="graphs/6h-temps-{$sensor.address}.rrd.png" width="100px">
                                    </a>
                                </td>
                                <td>{$sensor.name}</td>
                            </tr>
{/foreach}
                        </tbody>
                    </table>
                </div>

