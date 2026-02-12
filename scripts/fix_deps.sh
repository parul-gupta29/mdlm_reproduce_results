#!/bin/bash
# Fix binary incompatibilities in the mdlm conda environment.
#
# Errors like:
#   ValueError: numpy.dtype size changed, may indicate binary incompatibility.
#   ValueError: pyarrow._fs.LocalFileSystem size changed, may indicate binary incompatibility.
#
# These are caused by mismatched C extensions between packages installed
# via conda and pip. Fix: force-reinstall compatible versions via pip
# using only prebuilt binary wheels (--only-binary :all:).

set -e

echo "Fixing binary incompatibilities (numpy, pandas, pyarrow, datasets)..."

# Use --only-binary to avoid compiling from source (which fails on old GCC).
# Install all four together so pip resolves compatible versions in one pass.
pip install --force-reinstall --only-binary :all: \
  numpy==1.26.4 \
  pandas==2.2.1 \
  pyarrow==15.0.2

pip install --force-reinstall datasets==2.18.0

echo "Verifying fix..."
python -c "
import numpy; print('numpy:', numpy.__version__)
import pandas; print('pandas:', pandas.__version__)
import pyarrow; print('pyarrow:', pyarrow.__version__)
import datasets; print('datasets:', datasets.__version__)
print('All imports OK')
"

echo "Done. You can now run the evaluation scripts."
