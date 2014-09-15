taiga = @.taiga

angular.module("taiga").constant('urls', {
    "auth": "/api/v1/auth"
});


# format = (fmt, obj) ->
#     obj = _.clone(obj)
#     return fmt.replace /%s/g, (match) -> String(obj.shift())

# taiga = @.taiga

# class UrlsService extends taiga.Service
#     @.$inject = ["$tgConfig"]

#     constructor: (@config) ->
#         @.urls = {}
#         @.host = config.get("host")
#         @.scheme = config.get("scheme")

#     update: (urls) ->
#         @.urls = _.merge(@.urls, urls)

#     resolve: ->
#         args = _.toArray(arguments)

#         if args.length == 0
#             throw Error("wrong arguments to setUrls")

#         name = args.slice(0, 1)[0]
#         url = format(@.urls[name], args.slice(1))
#         return format("%s://%s%s", [@.scheme, @.host, url])


# module = angular.module("taigaBase")
# module.service('$tgUrls', UrlsService)
