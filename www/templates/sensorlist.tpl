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
                                <td>{$sensor.name}</td>
                                <td><a href='?mode=edit&sensor={$sensor.name}'>edit</a></td>
                                <td>{$sensor.value}</td>
                            </tr>
{/foreach}
                        </tbody>
                    </table>
                </div>

