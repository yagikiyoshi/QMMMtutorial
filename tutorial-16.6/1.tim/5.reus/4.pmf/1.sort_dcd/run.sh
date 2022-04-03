#!/bin/bash

export PATH=${PATH}:/path/to/genesis/bin

rm prod3_param*
rm prod4_param*
remd_convert remd_convert3.inp >& remd_convert3.out
remd_convert remd_convert4.inp >& remd_convert4.out

