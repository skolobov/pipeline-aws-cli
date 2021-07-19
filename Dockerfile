FROM amazonlinux:2 as installer
ARG AWS_CLI_SOURCE=https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip
RUN \ 
  yum update -y \
  && yum install -y unzip \
  && curl "${AWS_CLI_SOURCE}" -o awscli.zip \
  && unzip awscli.zip \
  # The --bin-dir is specified so that we can copy the
  # entire bin directory from the installer stage into
  # into /usr/local/bin of the final stage without
  # accidentally copying over any other executables that
  # may be present in /usr/local/bin of the installer stage.
  && ./aws/install --bin-dir /aws-cli-bin/

FROM amazonlinux:2
RUN yum update -y \
  && yum install -y less groff git \
  && yum clean all
COPY --from=installer /usr/local/aws-cli/ /usr/local/aws-cli/
COPY --from=installer /aws-cli-bin/ /usr/local/bin/
WORKDIR /aws
ENTRYPOINT ["/usr/local/bin/aws"]
