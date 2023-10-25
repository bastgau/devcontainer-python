"""..."""

import json

from typing import Any, Dict

from marshmallow import ValidationError
from pkg_function_app.shared.schemas.base_schema import BaseSchema

from pkg_function_app.shared.libs.exceptions import (
    ExceptionValidationParameter,
    ExceptionServiceUnknown,
    UnauthorizedException,
    ExceptionBadParameter,
    ExceptionEventTypeUnknown,
    ExceptionAssetUnknown,
)


class BaseFunction:
    """
    Base class for every functions
    """

    format_date: str = "%Y-%m-%d %H:%M:%S"
    _schema_model: Any = BaseSchema

    def initialize(self, params: Any) -> Dict[str, str]:
        """
        The function initilizes function parameters

        Args:
            params(Any): list of parameters of the function

        Returns:
            Dict[str, str]: list of accepted parameters parameters

        Exceptions:
            ExceptionValidationParameter: raise exception if input parameters are not accepted
        """

        try:
            new_params: Dict[str, str] = self._schema_model().load(params)
        except ValidationError as err:
            raise ExceptionValidationParameter("Bad Parameter discovered during initialisation 'function' class.", err) from err

        return new_params

    def function_response(self, result: Dict[str, Any], status_code: int = 200) -> Dict[str, Any]:
        """..."""

        if "success" not in result:
            result["success"] = True

        body: str = json.dumps(result)
        return {"body": body, "status_code": status_code}

    def function_response_error(self, raised_exception: Exception) -> Dict[str, Any]:
        """..."""

        status_code: int = 500

        message: str = str(raised_exception)
        details: Dict[str, Any] = {}

        try:
            raise raised_exception
        except ExceptionServiceUnknown:
            status_code = 404
            message = raised_exception.args[0]
            details = raised_exception.args[1]
        except UnauthorizedException:
            status_code = 401
            message = raised_exception.args[0]
            details = raised_exception.args[1]
        except ExceptionValidationParameter:
            status_code = 400
            message = raised_exception.args[0]
            details = raised_exception.args[1].messages
        except ExceptionAssetUnknown:
            status_code = 400
            message = raised_exception.args[0]
            details = raised_exception.args[1]
        except ExceptionBadParameter:
            status_code = 400
        except ExceptionEventTypeUnknown:
            status_code = 500
        except Exception:  # pylint: disable=broad-exception-caught
            status_code = 500
        finally:

            body: Dict[str, Any] = {"success": False, "message": message}

            if len(details) > 0:
                body["details"] = details

        return {"body": json.dumps(body), "status_code": status_code}

    def format(self, output: Dict[str, Any]) -> Dict[str, Any]:
        """..."""

        result: Dict[str, Any] = {"message": output["message"]}

        if "details" in output:
            result["details"] = output["details"]

        return result
