"""..."""

from datetime import datetime, timedelta
import logging

from typing import Any, Dict, List, Optional, Union

from azure.mgmt.datafactory import DataFactoryManagementClient
from azure.mgmt.datafactory.models import RunFilterParameters, PipelineRunsQueryResponse, CreateRunResponse, PipelineRun

from azure.identity import DefaultAzureCredential

adf_client_cached: Union[None, DataFactoryManagementClient] = None


def _create_client(subscription_id: str) -> DataFactoryManagementClient:
    """..."""

    global adf_client_cached  # pylint: disable=global-statement

    if adf_client_cached is None:

        # Initialize Azure Data Factory Client
        credentials = DefaultAzureCredential()
        adf_client_cached = DataFactoryManagementClient(credentials, subscription_id)

    return adf_client_cached


def pipeline_launch(pipeline_name: str, rg_name: str, df_name: str, subscription_id: str, parameters: Optional[Dict[str, Any]] = None) -> bool:
    """..."""

    adf_client: DataFactoryManagementClient = _create_client(subscription_id)

    # Create a pipeline run
    run_response: CreateRunResponse = adf_client.pipelines.create_run(rg_name, df_name, pipeline_name, parameters=parameters)  # pyright: ignore

    # Monitor the pipeline run
    pipeline_run: PipelineRun = adf_client.pipeline_runs.get(rg_name, df_name, run_response.run_id)  # pyright: ignore

    logging.critical("pipeline_launch - Run with status: %s", pipeline_run.status)
    # Possible values: Queued, InProgress, Succeeded, Failed, Canceling, Cancelled.
    # https://learn.microsoft.com/en-us/python/api/azure-mgmt-datafactory/azure.mgmt.datafactory.models.pipelinerun?view=azure-python
    if pipeline_run.status is None or pipeline_run.status in ["Failed", "Canceling", "Cancelled"]:
        logging.error("pipeline_launch - pipeline is launched but failed")
        return False

    return True


def is_pipeline_running(  # pylint: disable=dangerous-default-value
    pipeline_name: str,
    rg_name: str,
    df_name: str,
    subscription_id: str,
    status: List[str] = ["InProgress", "Queued"],
    since_days: int = 2,
) -> bool:
    """..."""

    last_updated_after: datetime = datetime.utcnow() - timedelta(days=since_days)
    last_updated_before: datetime = datetime.utcnow()

    conditions: List[Any] = []

    # for value in status:

    conditions.append({"operand": "Status", "operator": "Equals", "values": status})

    conditions.append({"operand": "PipelineName", "operator": "Equals", "values": [pipeline_name]})

    adf_client: DataFactoryManagementClient = _create_client(subscription_id)

    # TODO : A RESOUDRE - Datetime with no tzinfo will be considered UTC.

    filter_params: RunFilterParameters = RunFilterParameters(
        last_updated_after=last_updated_after, last_updated_before=last_updated_before, filters=conditions
    )

    pipeline_runs: PipelineRunsQueryResponse = adf_client.pipeline_runs.query_by_factory(  # pyright: ignore
        resource_group_name=rg_name,
        factory_name=df_name,
        filter_parameters=filter_params,
    )

    return len(pipeline_runs.value) > 0
