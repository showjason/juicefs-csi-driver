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

FROM golang:1.19 AS builder
ARG TARGETARCH=amd64
WORKDIR /app
COPY go.mod go.sum /app/
RUN go mod download
COPY . /app/
ENV VERSION=v0.14.1-344-g87fb2de-dirty
ENV BUILD_DATE=2024-01-27T08:00:31Z
ENV GIT_COMMIT=87fb2dee7b55f0856843664b1fc234b8a3e19b3b
ENV LDFLAGS="-X ${PKG}/pkg/driver.driverVersion=${VERSION} -X ${PKG}/pkg/driver.gitCommit=${GIT_COMMIT} -X ${PKG}/pkg/driver.buildDate=${BUILD_DATE} -s -w"

RUN CGO_ENABLED=0 GOOS=linux go build -ldflags "-X github.com/juicedata/juicefs-csi-driver/pkg/driver.driverVersion=v0.14.1-344-g87fb2de-dirty -X github.com/juicedata/juicefs-csi-driver/pkg/driver.gitCommit=87fb2dee7b55f0856843664b1fc234b8a3e19b3b -X github.com/juicedata/juicefs-csi-driver/pkg/driver.buildDate=2024-01-27T08:00:31Z -s -w" -o /app/juicefs-csi-driver ./cmd/

# RUN mkdir -p bin && \
#     CGO_ENABLED=0 GOOS=linux go build -ldflags "-X github.com/juicedata/juicefs-csi-driver/pkg/driver.driverVersion=v0.14.1-344-g87fb2de-dirty -X github.com/juicedata/juicefs-csi-driver/pkg/driver.gitCommit=87fb2dee7b55f0856843664b1fc234b8a3e19b3b -X github.com/juicedata/juicefs-csi-driver/pkg/driver.buildDate=2024-01-27T08:00:31Z -s -w" -o bin/juicefs-csi-driver ./cmd/ && \
#     --privileged

FROM juicedata/juicefs-csi-driver:nightly
COPY --from=builder /app/juicefs-csi-driver /usr/local/bin/juicefs-csi-driver
ENTRYPOINT ["juicefs-csi-driver"]