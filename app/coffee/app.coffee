@taiga = taiga = {}

configure = ($routeProvider, $locationProvider) ->
    $routeProvider.when("/login", {templateUrl: "partials/login.html"})

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
