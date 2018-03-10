#!/bin/bash

# Function to indent output with 2 spaces - Aditya Hajare <aditya43@gmail.com>

indent() { sed 's/^/  /'; }
banner_indent() { sed 's/^/            /'; }