# Copyright 2018 The Kubernetes Authors.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

FROM golang:1.21 AS builder
# ARG TARGETARCH=amd64
# ARG VERSION=$(git describe --tags --match 'v*' --always --dirty)
# ARG BUILD_DATE=$(date -u +"%Y-%m-%dT%H:%M:%SZ")
# ARG GIT_COMMIT=$(git rev-parse HEAD)
# ARG PKG=github.com/juicedata/juicefs-csi-driver
# ARG LDFLAGS="-X ${PKG}/pkg/driver.driverVersion=${VERSION} -X ${PKG}/pkg/driver.gitCommit=${GIT_COMMIT} -X ${PKG}/pkg/driver.buildDate=${BUILD_DATE} -s -w"
WORKDIR /app
# COPY go.mod go.sum /app/
COPY . /app/
RUN go mod download
ENV VERSION=v0.14.1-344-g87fb2de-dirty
ENV BUILD_DATE=2024-01-27T08:00:31Z
ENV GIT_COMMIT=87fb2dee7b55f0856843664b1fc234b8a3e19b3b
ENV LDFLAGS="-X ${PKG}/pkg/driver.driverVersion=${VERSION} -X ${PKG}/pkg/driver.gitCommit=${GIT_COMMIT} -X ${PKG}/pkg/driver.buildDate=${BUILD_DATE} -s -w"

RUN CGO_ENABLED=0 GOOS=linux go build -ldflags "${LDFLAGS}"

FROM juicedata/juicefs-csi-driver:nightly
COPY --from=builder /app/juicefs-csi-driver /usr/local/bin/juicefs-csi-driver
ENTRYPOINT ["juicefs-csi-driver"]