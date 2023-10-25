"""..."""

from typing import Any, Dict, List, Mapping, Union
from marshmallow import Schema, fields, ValidationError

from marshmallow.fields import Field


class AssetField(Field):  # type: ignore[misc]
    """..."""

    def _deserialize(
        self,
        value: Union[Any, List[str]],
        attr: Union[None, str],
        data: Union[None, Mapping[str, Any]],
        **kwargs: Dict[str, Any],
    ) -> List[str]:
        """..."""

        if isinstance(value, str):
            list_set = set(value.replace(" ", "").split(","))  # to have unique values
            return list(list_set)

        if isinstance(value, list):
            return value

        raise ValidationError("Assets must be provided throught List[str] or str (asset names separated by commas).")


class GenericJson(Field):  # type: ignore[misc]
    """..."""

    def _deserialize(
        self,
        value: Any,
        attr: Union[None, str],
        data: Union[None, Mapping[str, Any]],
        **kwargs: Dict[str, Any],
    ) -> Dict[str, Any]:
        """..."""

        if not isinstance(value, dict):
            raise ValidationError(f"The parameter {str(attr)} should be a value in Json format.")

        return value  # pyright: ignore


class BaseSchema(Schema):  # type: ignore[misc]
    """..."""
    code = fields.String(required=False)
