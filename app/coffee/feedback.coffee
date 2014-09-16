taiga = @.taiga

module = angular.module("taiga")

FeedbackDirective = (@urls, @http) ->
    link = ($scope, $el, $attrs) ->
        $scope.data = {}

        submit = ->
            form = $el.find("form").checksley()
            if not form.validate()
                return

            url = @urls.get("feedback")

            @http.post(url, $scope.data)
            .then (data, status) =>
                console.log "kkk"


        $el.on "click", "a.button-submit", (event) ->
            event.preventDefault()
            submit()

        $el.on "submit", "form", (event) ->
            event.preventDefault()
            submit()

    return {link:link}

module.directive("tgFeedback", ["urls", "$http", FeedbackDirective])
