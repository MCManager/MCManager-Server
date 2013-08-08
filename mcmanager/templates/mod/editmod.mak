<%inherit file="base.mak"/>
<%namespace name="form" file="form.mak" />
<h2>${title}</h2>
<hr>
<div class="row"><div class="span10">
    <form class="form-horizontal" method="post" action="${request.url}" novalidate="novalidate" id="edit-mod">
        ${form.formerror(error)}
        ${form.horfield('txtName', 'Name', 'text', attr={
            'data-maxlength': '32',
            'data-regexp': '^[\w ]+$',
            'required': 'required'
        })}
        ${form.horfield('txtAuthor', 'Author', 'text', attr={
            'data-maxlength': '32'
        })}
        ${form.horfield('txtInstall', 'Install Location', 'text', attr={
            'value': 'mods',
            'data-type': 'alphanum',
            'required': 'required'
        })}
        ${form.horfield('txtUrl', 'Homepage', 'text', attr={
            'data-type': 'url',
            'required': 'required'
        })}
        <%form:horgeneric name="selTarget" label="Target">
            <select id="selTarget" required="required" name="selTarget">
                <option value="both">Server and Client</option>
                <option value="server">Server</option>
                <option value="client">Client</option>
            </select>
        </%form:horgeneric>
        <%form:horgeneric name="parPermission" label="Permission">
            <textarea rows=5 name="parPermission" id="parPermission"></textarea>
        </%form:horgeneric>
        % if v is UNDEFINED:
            ${form.horsubmit(request.route_url('modlist'))}
        % else:
            ${form.horsubmit(request.route_url('viewmod', id=v.id))}
        % endif
    </form>
</div></div>
<%!
    import json
    def js(text):
        return json.dumps({'t': text})[7:-2]
%>
<%block name="endscripts">
    ${form.formscripts('edit-mod')}
    % if v is not UNDEFINED:
        <script type="text/javascript">
            $(document).ready(function(){
                $('#txtName').val("${v.name}");
                % if v.author:
                    $('#txtAuthor').val("${v.author}");
                % endif
                $('#txtInstall').val("${v.install}");
                $('#txtUrl').val("${v.url}");
                $('#selTarget').val("${v.target}");
                % if v.permission:
                    $('#parPermission').val("${v.permission | n,js}");
                % endif
            });
        </script>
    % endif
</%block>