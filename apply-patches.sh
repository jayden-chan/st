#!/bin/zsh

set -x

patch --merge < patches/st-boxdraw_v2-0.8.3.diff
patch --merge < patches/st-ligatures-boxdraw-20200430-0.8.3.diff
patch --merge < patches/st-copyurl-0.8.4.diff
patch --merge < patches/st-osc10-20210106-4ef0cbd.diff
nvim st.h
patch --merge < patches/st-anysize-0.8.4.diff
patch --merge < patches/st-blinking_cursor-20200531-a2a7044.diff
patch --merge < patches/st-vertcenter-20180320-6ac8c8a.diff
patch --merge < patches/st-newterm-0.8.2.diff
nvim config.def.h
