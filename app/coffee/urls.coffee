taiga = @.taiga

angular.module("taiga").factory('urls', () ->
    host = "http://localhost:8000"

    urls = {
        "auth": "/api/v1/auth"
        "feedback": "/api/v1/feedback"
        "feedbackTypes": "/api/v1/feedback_types"
    }

    get = (name) => host + urls[name]

    return {get: get}
);
