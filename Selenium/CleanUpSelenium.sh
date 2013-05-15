#!/bin/bash

echo Cleaning up selenium files and process
rm -rf /tmp/*.rclog;
rm -rf /tmp/custom*;
killall /usr/lib64/firefox/firefox;
echo Done cleaning selenium
