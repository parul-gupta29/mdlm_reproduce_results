#!/bin/bash
# Fix numpy/pandas binary incompatibility in the mdlm conda environment.
#
# The error:
#   ValueError: numpy.dtype size changed, may indicate binary incompatibility.
#   Expected 96 from C header, got 88 from PyObject
#
# This is caused by a mismatch between numpy and pandas C extensions.
# Fix: reinstall numpy and pandas with compatible versions via pip.

set -e

echo "Fixing numpy/pandas binary incompatibility..."

pip install --force-reinstall numpy==1.26.4
pip install --force-reinstall pandas==2.2.1

echo "Verifying fix..."
python -c "import pandas; import numpy; print('numpy:', numpy.__version__); print('pandas:', pandas.__version__); print('OK')"

echo "Done. You can now run the evaluation scripts."
