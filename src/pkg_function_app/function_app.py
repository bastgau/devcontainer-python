"""..."""

from typing import Any, Dict
import azure.functions as func

from pkg_function_app.shared.functions.call_dataset_refresh_via_adf import CallDatasetRefreshViaADF
from pkg_function_app.shared.functions.get_dataset_status import GetDatasetStatus

app = func.FunctionApp(http_auth_level=func.AuthLevel.FUNCTION)


@app.route(route="call_dataset_refresh_via_azure_data_factory")  # type: ignore
def call_dataset_refresh(req: func.HttpRequest) -> func.HttpResponse:
    """..."""

    obj_function: CallDatasetRefreshViaADF = CallDatasetRefreshViaADF()

    settings: Dict[str, Any] = {
        "pipeline_name": "powerbi_dataset_refresh",
        "resource_group_name": "regricshared01dev",
        "data_factory_name": "adfrictoolsdev",
        "subscription_id": "09c2ee2c-ddd1-411a-abcc-2201ad22e477",
    }

    obj_function.configure_adf(settings)
    return execute_function_app(obj_function, req)


@app.route(route="get_dataset_status")  # type: ignore
def get_dataset_status(req: func.HttpRequest) -> func.HttpResponse:
    """..."""

    obj_function: GetDatasetStatus = GetDatasetStatus()
    return execute_function_app(obj_function, req)


def execute_function_app(obj_function: Any, req: func.HttpRequest) -> func.HttpResponse:
    """..."""

    try:
        result: Dict[str, Any] = obj_function.prepare_and_execute_from_func(dict(req.params))
        main_result: Dict[str, Any] = obj_function.format(result)
        return func.HttpResponse(**obj_function.function_response(main_result, 200))
    except Exception as err:  # pylint: disable=broad-exception-caught
        return func.HttpResponse(**obj_function.function_response_error(err))
