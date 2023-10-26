"""..."""

import logging
import azure.functions as func

app = func.FunctionApp(http_auth_level=func.AuthLevel.FUNCTION)


@app.route(route="http_trigger", auth_level=func.AuthLevel.FUNCTION)
def http_trigger(req: func.HttpRequest) -> func.HttpResponse:
    """..."""
    logging.info("Python HTTP trigger function processed a request.")
    return func.HttpResponse(f"Hello. This HTTP triggered function executed successfully ({req.method.upper()})")
