#!/bin/bash
# Licensed to the Apache Software Foundation (ASF) under one
# or more contributor license agreements.  See the NOTICE file
# distributed with this work for additional information
# regarding copyright ownership.  The ASF licenses this file
# to you under the Apache License, Version 2.0 (the
# "License"); you may not use this file except in compliance
# with the License.  You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing,
# software distributed under the License is distributed on an
# "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
# KIND, either express or implied.  See the License for the
# specific language governing permissions and limitations
# under the License.

set -ex

# export KONG_NGINX_HTTP_LUA_SHARED_DICT="tracing_buffer 128m"

COMMIT_ID="39686396ae23d7d341a8ff2212888f02d0b19f6d"

mkdir ~/skywalking-nginx-lua
cd ~/skywalking-nginx-lua

git init
git remote add origin https://github.com/apache/skywalking-nginx-lua
git fetch origin ${COMMIT_ID}
git checkout ${COMMIT_ID}

luarocks make ./rockspec/skywalking-nginx-lua-master-0.rockspec --local

cd /skywalking-kong

luarocks make ./rockspec/kong-plugin-skywalking-master-0.rockspec --local

kong migrations bootstrap

kong start -c /docker/conf/kong.conf --vv