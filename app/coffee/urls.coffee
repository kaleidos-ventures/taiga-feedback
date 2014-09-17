taiga = @.taiga

angular.module("taiga").factory('urls', () ->
    host = "http://localhost:8000"

    urls = {
        "auth": "/api/v1/auth"
        "feedback": "/api/v1/issues"
    }

    get = (name) => host + urls[name]

    return {get: get}
);
