#!/bin/bash

find $SOURCE_PATH -type d -iregex ".*__pycache__.*" -exec rm -rf {} +
find $WORKSPACE_PATH/tests -type d -iregex ".*__pycache__.*" -exec rm -rf {} +

find $WORKSPACE_PATH -type d -iregex ".*\.mypy_cache" -exec rm -rf {} +
find $WORKSPACE_PATH -type d -iregex ".*\.pytest_cache" -exec rm -rf {} +
