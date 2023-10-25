"""..."""

from typing import Any, Dict

from marshmallow import fields, validate
from pkg_function_app.shared.functions.base_function import BaseFunction
from pkg_function_app.shared.schemas.base_schema import BaseSchema, AssetField


class GetDatasetStatusSchema(BaseSchema):  # type: ignore[misc]
    """..."""
    assets = AssetField(required=True)
    control_key = fields.String(required=True)
    environment = fields.String(validate=validate.OneOf(["DEV", "INT", "TST", "PRD"]))


class GetDatasetStatus(BaseFunction):  # type: ignore[misc]
    """..."""

    _schema_model: Any = GetDatasetStatusSchema

    def prepare_and_execute(self, params: Dict[str, Any]) -> Dict[str, Any]:
        """..."""

        new_params: Dict[str, Any] = self.initialize(params)
        return self.execute(new_params)

    def execute(self, new_params: Any) -> Dict[str, Any]:
        """..."""
        del new_params

        print("ok")

        message: str = ""
        details: str = ""

        print("ok")

        return {"message": message, "details": details}
