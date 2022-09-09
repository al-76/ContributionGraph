#!/bin/sh

XCODE_DERIVED_DATA=~/Library/Developer/Xcode/DerivedData/ContributionGraph-*/Build
APP_NAME=ContributionGraph

PROFDATA=`ls $XCODE_DERIVED_DATA/ProfileData/*/Coverage.profdata`
COVERAGE=`ls $XCODE_DERIVED_DATA/Products/Debug-iphonesimulator/$APP_NAME.app/$APP_NAME`
xcrun llvm-cov export -format=lcov -instr-profile=$PROFDATA $COVERAGE > coverage.lcov
