taiga = @.taiga

angular.module("taiga").factory('urls', () ->
    host = "https://api.taiga.io"

    urls = {
        "auth": "/api/v1/auth"
        "feedback": "/api/v1/privileged-feedback"
        "feedbackTypes": "/api/v1/privileged-feedback-types"
    }

    get = (name) => host + urls[name]

    return {get: get}
);
