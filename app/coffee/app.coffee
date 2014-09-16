@taiga = taiga = {}

configure = ($routeProvider, $locationProvider) ->
    $routeProvider.when("/login", {templateUrl: "partials/login.html"})
    $routeProvider.when("/", {templateUrl: "partials/feedback.html"})

    $locationProvider.html5Mode(true)

modules = [
    "ngRoute",
    "ngAnimate"
]

# Main module definition
module = angular.module("taiga", modules)

module.config([
    "$routeProvider",
    "$locationProvider"
    configure
])
