from pyramid.response import Response, FileIter
from pyramid.httpexceptions import HTTPFound
from pyramid.view import view_config
from ..schema import *
from .common import *
import re


class MMLServerVersions(MMLServerView):
    @view_config(route_name='addversion', renderer='editmodversion.mak', permission='user')
    def addversion(self):
        error = ''
        post = self.request.params

        # Get mod
        mod = self.get_db_object(Mod)

        if 'btnSubmit' in post:
            params = get_params(post)
            if check_params(params):
                try:
                    mv = ModVersion(mod=mod, **params).save()
                    mod.versions.append(mv)
                    mod.save()
                    return HTTPFound(location=self.request.route_url('viewmod', id=mod.id))
                except ValidationError:
                    error = VERROR
            else:
                error = VERROR
        return self.return_dict(title="Add Mod Version", error=error)

    @view_config(route_name='editversion', renderer='editmodversion.mak', permission='user')
    def editversion(self):
        error = ''
        post = self.request.params

        # Get modversion
        mv = self.get_db_object(ModVersion)

        if 'btnSubmit' in post:
            params = get_params(post)
            if check_params(params):
                for key in params:
                    mv[key] = params[key]
                try:
                    mv.save()
                    return HTTPFound(location=self.request.route_url('viewmod', id=mv.mod.id))
                except ValidationError:
                    error = VERROR
            else:
                error = VERROR
        return self.return_dict(title="Edit Mod Version", v=mv, error=error)

    @view_config(route_name='downloadversion')
    def downloadversion(self):
        # Get modversion
        mv = self.get_db_object(ModVersion, perm=False)

        return Response(app_iter=FileIter(mv.mod_file), content_type='application/zip', content_disposition='attachment; filename="{0}-{1}.jar"'.format(mv.mod.name, mv.version))

    @view_config(route_name='deleteversion', permission='user')
    def deleteversion(self):
        # Get modversion
        mv = self.get_db_object(ModVersion)

        mv.mod_file.delete()
        mv.delete()
        return HTTPFound(location=self.request.referer)


def get_params(post):
    p = opt_dict(
        mc_min=post.get('selMCMin'),
        mc_max=post.get('selMCMax'),
        forge_min=post.get('txtForgeMin'),
        forge_max=post.get('txtForgeMax'),
        version=post.get('txtVersion')
    )
    try:
        p['mod_file'] = post.get('uplModFile').file
    except AttributeError:
        pass
    return p


def check_params(params):
    check_forge = lambda x: re.match('^([0-9]\.){3}[0-9]{3}$', params[x]) is not None if x in params else True
    return check_forge('forge_min') and check_forge('forge_max')
