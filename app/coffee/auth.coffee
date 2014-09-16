taiga = @.taiga

module = angular.module("taiga")

class AuthService
    @.$inject = ["$rootScope",
                 "$tgStorage",
                 "urls",
                 "$http"]

    constructor: (@rootscope, @storage, @urls, @http) ->

    getUser: ->
        if @rootscope.user
            return @rootscope.user

        user = @storage.get("userInfo")
        if userData
            @rootscope.user = user
            return user

        return null

    setUser: (user) ->
        @rootscope.auth = user
        @storage.set("userInfo", user)
        @rootscope.user = user

    clear: ->
        @rootscope.auth = null
        @rootscope.user = null
        @storage.remove("userInfo")

    setToken: (token) ->
        @storage.set("token", token)

    getToken: ->
        return @storage.get("token")

    removeToken: ->
        @storage.remove("token")

    isAuthenticated: ->
        if @.getUser() != null
            return true
        return false

    login: (data, type) ->
        url = @urls.get("auth")

        data = _.clone(data, false)
        data.type = if type then type else "normal"

        @.removeToken()

        return @http.post(url, data).then (data, status) =>
            user = data.data
            @.setToken(user.auth_token)
            @.setUser(user)
            return user

    logout: ->
        @.removeToken()
        @.clear()

module.service("$tgAuth", AuthService)


###########################################################################
## Login Directive
#############################################################################

LoginDirective = ($auth, $location) ->
    link = ($scope, $el, $attrs) ->
        $scope.data = {}

        onSuccessSubmit = (response) ->
            $location.path("/")

        submit = ->
            form = $el.find("form").checksley()
            if not form.validate()
                return

            promise = $auth.login($scope.data)
            promise.then(onSuccessSubmit)

        $el.on "click", "a.button-login", (event) ->
            event.preventDefault()
            submit()

        $el.on "submit", "form", (event) ->
            event.preventDefault()
            submit()

    return {link:link}

module.directive("tgLogin", ["$tgAuth", "$location", LoginDirective])
