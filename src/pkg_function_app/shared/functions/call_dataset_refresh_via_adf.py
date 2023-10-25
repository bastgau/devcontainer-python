"""..."""

from typing import Any, Dict

from marshmallow import fields
from pkg_function_app.shared.functions.base_function import BaseFunction
from pkg_function_app.shared.schemas.base_schema import BaseSchema

from pkg_function_app.shared.libs.azure.data_factory import pipeline_launch


class CallDatasetRefreshViaADFSchema(BaseSchema):  # type: ignore[misc]
    """..."""
    workspace_id = fields.String(required=True)
    dataset_id = fields.String(required=True)
    pipeline_name = fields.String(required=True)
    data_factory_name = fields.String(required=True)
    resource_group_name = fields.String(required=True)
    subscription_id = fields.String(required=True)


class CallDatasetRefreshViaADF(BaseFunction):  # type: ignore[misc]
    """..."""

    _schema_model: Any = CallDatasetRefreshViaADFSchema
    _adf_settings: Dict[str, Any] = {}

    def prepare_and_execute_from_func(self, params: Dict[str, Any]) -> Dict[str, Any]:
        """..."""

        params = self._adf_settings | params

        new_params: Dict[str, Any] = self.initialize(params)
        return self.execute(new_params)

    def configure_adf(self, settings: Dict[str, Any]) -> None:
        """"..."""
        self._adf_settings = settings

    def execute(self, params: Any) -> Dict[str, Any]:
        """..."""

        is_launched: bool = pipeline_launch(
            pipeline_name=params["pipeline_name"],
            rg_name=params["resource_group_name"],
            df_name=params["data_factory_name"],
            subscription_id=params["subscription_id"],
            parameters={
                "workspace_id": params["workspace_id"],
                "dataset_id": params["dataset_id"],
            }
        )

        if is_launched is False:
            raise RuntimeError("Dataset refresh cannot be refreshed.")

        return {"message": "Dataset refresh just started."}
