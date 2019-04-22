#!/bin/bash
#
# Runs the test suite on the Girder Oauth Plugin in an isolated environment
#
# Prerequisite: docker run -itd --name=test-mongo -p 27017:27017 --net=host mongo
# Build: docker build -t eliasmarkc/girder:test-harness .
# Usage: docker run --rm -it -v ~/projects/girder/plugins/oauth/:/girder/plugins/oauth --net=host eliasmarkc/girder:test-harness

# Fail on error
set -e

# Install WholeTale plugin dependencies
pip install passlib pyOpenSSL

# Run CMake
cmake \
    -DRUN_CORE_TESTS:BOOL=OFF \
    -DBUILD_JAVASCRIPT_TESTS:BOOL=OFF \
    -DJAVASCRIPT_STYLE_TESTS:BOOL=OFF \
    -DTEST_PLUGINS:STRING=oauth \
    -DCOVERAGE_MINIMUM_PASS:STRING=4 \
    -DPYTHON_COVERAGE=ON \
    -DPYTHON_STATIC_ANALYSIS=ON \
    -DPYTHON_VERSION="3.6" \
    -DPYTHON_COVERAGE_EXECUTABLE="$COVERAGE" \
    -DFLAKE8_EXECUTABLE="$FLAKE8" \
    -DPYTHON_EXECUTABLE="$PYTHON"

# Run CTest
ctest -VV

# Run a particular set of tests by regex
#ctest -VV -R 'image'
