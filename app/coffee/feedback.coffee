taiga = @.taiga

module = angular.module("taiga")

class FeedbackController
    @.$inject = [
        "$tgAuth",
        "$location"
    ]
    constructor: (@auth, @location) ->
        if !@auth.isAuthenticated()
            @location.path("/login")

module.controller("FeedbackController", FeedbackController)

FeedbackDirective = (@urls, @http) ->
    link = ($scope, $el, $attrs) ->
        $scope.ok = false
        $scope.data = {}
        $scope.data.type = 0;

        onSuccessSubmit = () ->
            $scope.data = {}
            $scope.ok = true

        submit = ->
            form = $el.find("form").checksley()
            if not form.validate()
                return

            url = @urls.get("feedback")

            console.log $scope

            @http.post(url, $scope.data)
            .then (data, status) =>
                onSuccessSubmit()

        $el.on "click", ".new-feedback", (event) ->
            $scope.ok = false
            $scope.$apply()

        $el.on "click", "a.button-capture", (event) ->
            chrome.tabs.captureVisibleTab null, {}, (src) =>
                $scope.data.image = src
                $scope.$apply()

        $el.on "click", "a.button-submit", (event) ->
            event.preventDefault()
            submit()


        $el.on "submit", "form", (event) ->
            event.preventDefault()
            submit()

    return {link:link}

module.directive("tgFeedback", ["urls", "$http", FeedbackDirective])
