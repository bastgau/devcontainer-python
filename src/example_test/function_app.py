"""..."""

import azure.functions as func

app = func.FunctionApp(http_auth_level=func.AuthLevel.FUNCTION)


@app.route(route="call_dataset_refresh")
def call_dataset_refresh(req: func.HttpRequest) -> func.HttpResponse:
    """..."""
    del req
    return func.HttpResponse("ok")


@app.route(route="get_dataset_status")
def get_dataset_status(req: func.HttpRequest) -> func.HttpResponse:
    """..."""
    del req
    return func.HttpResponse("ok")
