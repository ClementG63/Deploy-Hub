FROM ubuntu:20.04 as builder

RUN apt-get update && apt-get install -y curl git unzip xz-utils zip libglu1-mesa

ENV FLUTTER_VERSION=3.7.12

RUN cd /opt/ && \
    curl -o flutter.tar.xz https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/flutter_linux_$FLUTTER_VERSION-stable.tar.xz && \
    tar xf flutter.tar.xz && rm flutter.tar.xz && \
    git config --global --add safe.directory /opt/flutter

ENV PATH="$PATH:/opt/flutter/bin"

WORKDIR /app

COPY pubspec.yaml .

RUN flutter pub get

COPY . ./

RUN flutter build web --release


FROM nginx:stable-alpine3.17 as main

COPY config/nginx.conf /etc/nginx/nginx.conf

COPY --from=builder /app/build/web /usr/share/nginx/html

CMD ["nginx", "-g", "daemon off;"]
