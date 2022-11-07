#!/bin/bash
# Create AWS Lambda package file.
TMP_PKG="$PROJECT_ROOT/tmp_pkg"
TMP_LAYER="$PROJECT_ROOT/tmp_layer"
TMP_LAYER_SUB_DIR="$TMP_LAYER/python"

rm -rf "$TMP_PKG" "$TMP_LAYER" "$TF_VAR_lambda_package_name" "$TF_VAR_lambda_layer_name"

cd "$PROJECT_ROOT/application" || exit

# Create package
mkdir -p "$TMP_PKG"
cp -r ./* "$TMP_PKG"
cd "$TMP_PKG"
zip -r9 "$TF_VAR_lambda_package_name" .

# Create AWS Lambda layer. Note: max size for a layer is 250MB.
mkdir -p "$TMP_LAYER_SUB_DIR"
pip install -r requirements.txt --target "$TMP_LAYER_SUB_DIR"
cd "$TMP_LAYER"
zip -r9 "$TF_VAR_lambda_layer_name" .

rm -rf "$TMP_PKG"
rm -rf "$TMP_LAYER"
