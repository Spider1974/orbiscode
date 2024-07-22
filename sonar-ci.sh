#!/bin/bash

set -e

mvn -B clean install
mvn -B sonar:sonar