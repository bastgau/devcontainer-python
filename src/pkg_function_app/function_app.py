"""..."""

import azure.functions as func

app = func.FunctionApp(http_auth_level=func.AuthLevel.FUNCTION)


@app.route(route="http_trigger")  # type: ignore
def http_trigger(_: func.HttpRequest) -> func.HttpResponse:
    """..."""

    return func.HttpResponse("ok", status_code=200)
