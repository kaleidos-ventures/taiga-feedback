taiga = @.taiga

module = angular.module("taiga")

class AuthService
    @.$inject = ["$rootScope",
                 "$tgStorage",
                 "urls"]

    constructor: (@rootscope, @storage, @urls) ->

    getUser: ->
        if @rootscope.user
            return @rootscope.user

        userData = @storage.get("userInfo")
        if userData
            user = @model.make_model("users", userData)
            @rootscope.user = user
            return user

        return null

    setUser: (user) ->
        @rootscope.auth = user
        @storage.set("userInfo", user.getAttrs())
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

    ## Http interface

    login: (data, type) ->
        url = @urls["auth"]

        data = _.clone(data, false)
        data.type = if type then type else "normal"

        @.removeToken()

        return @http.post(url, data).then (data, status) =>
            user = @model.make_model("users", data.data)
            @.setToken(user.auth_token)
            @.setUser(user)
            return user

    logout: ->
        @.removeToken()
        @.clear()

    register: (data, type, existing) ->
        url = @urls.resolve("auth-register")

        data = _.clone(data, false)
        data.type = if type then type else "public"
        if type == "private"
            data.existing = if existing then existing else false

        @.removeToken()

        return @http.post(url, data).then (response) =>
            user = @model.make_model("users", response.data)
            @.setToken(user.auth_token)
            @.setUser(user)
            return user

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
