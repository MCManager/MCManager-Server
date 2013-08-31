<%inherit file="base.mak"/>
<div class="row">
    <div class="col-lg-8">
        <h2>${title}</h2>
        <a href="#" class="btn btn-primary" id='showid'>Copy ID to Clipboard</a>
        <h4><a href="${request.route_url('profile', id=server.owner.id)}">${server.owner.username}</a></h4>
    </div>
    <div class="col-lg-4">
    % if perm:
        <div class="btn-group pull-right tmargin">
            <a href="${request.route_url('editserver', id=server.id)}" class="btn btn-info action-edit">Edit Server</a>
            <a id="delete" class="btn btn-danger action-delete">Delete Server</a>
        </div>
    % endif
    </div>
</div>
<hr>
<h3>Server Information</h3>
<table class="table table-hover table-bordered">
    <tr><td>Added</td><td>${server.id.generation_time.strftime('%e %b %Y %I:%m:%S %p')}</td></tr>
    <tr>
        <td>Homepage</td>
        <td>
            % if server.url:
                <a target="_blank" rel="nofollow" href="${server.url}">${server.url}</a>
            % else:
                None
            % endif
        </td>
    </tr>
    <tr><td>Host</td><td>${server.host}</td></tr>
    <tr><td>Port</td><td>${server.port}</td></tr>
    <tr><td>Pack</td><td><a href="${request.route_url('viewpack', id=server.build.pack.id)}">${server.build.pack.name}</a></td></tr>
    <tr><td>Pack Revision</td><td>${server.build.revision}</td></tr>
    <tr><td>Custom Config</td><td>${server.config}</td></tr>
</table>
<%block name="endscripts">
    <script src="//raw.github.com/makeusabrew/bootbox/master/bootbox.js"></script>
    <script type="text/javascript">
        $(document).ready(function(){
            $('#delete').click(function(){
                bootbox.confirm("Are you sure you want to delete this server?", function(result){
                    if (result)
                        window.location = "${request.route_url('deleteserver', id=server.id)}";
                });
            });
            $('#showid').click(function(){
                window.prompt("Copy to clipboard: Ctrl+C, Enter", "${server.id}");
            });
        });
    </script>
</%block>