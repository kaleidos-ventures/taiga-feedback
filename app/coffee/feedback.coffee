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

FeedbackDirective = (@urls, @http, @auth) ->
    link = ($scope, $el, $attrs) ->
        $scope.showOkMessage = false
        $scope.showErrorMessage = false
        $scope.data = {}
        $scope.data.type = null
        $scope.data.attached_file = null
        $scope.data.subject = "Feedback from Chrome plugin"
        $scope.feedbackTypes = []
        feedbackTypes = null
        feedbackTypesUrl = @urls.get("feedbackTypes")
        token = @auth.getToken()

        @http.get(feedbackTypesUrl, {headers: {"Authorization":"Bearer #{token}"}})
        .then (feedbackTypes, status) =>
            $scope.feedbackTypes = feedbackTypes.data.results
            $scope.data.type = feedbackTypes.data.results[0].id

        onSuccessSubmit = () ->
            $scope.data.type = $scope.feedbackTypes[0].id
            $scope.data.attached_file = null
            $scope.data.description = ""
            $scope.showOkMessage = true
            $scope.showErrorMessage = false

        onErrorSubmit = () ->
            $scope.showOkMessage = false
            $scope.showErrorMessage = true

        submit = ->
            form = $el.find("form").checksley()
            if not form.validate()
                return

            url = @urls.get("feedback")

            @http.post(url, $scope.data, {headers: {"Authorization":"Bearer #{token}"}})
            .success (data, status) =>
                onSuccessSubmit()
            .error (data, status) =>
                onErrorSubmit()

        $el.on "click", ".new-feedback", (event) ->
            $scope.showOkMessage = false
            $scope.showErrorMessage = false
            $scope.$apply()

        $el.on "click", "a.button-capture", (event) ->
            chrome.tabs.captureVisibleTab null, {}, (src) =>
                $scope.data.attached_file = src
                $scope.$apply()

        $el.on "click", "a.button-submit", (event) ->
            event.preventDefault()
            submit()


        $el.on "submit", "form", (event) ->
            event.preventDefault()
            submit()

    return {link:link}

module.directive("tgFeedback", ["urls", "$http", "$tgAuth", FeedbackDirective])
