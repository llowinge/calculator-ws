#
# JBoss, Home of Professional Open Source
# Copyright 2015, Red Hat, Inc. and/or its affiliates, and individual
# contributors by the @authors tag. See the copyright.txt in the
# distribution for a full listing of individual contributors.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
# http://www.apache.org/licenses/LICENSE-2.0
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

FROM eclipse-temurin:11
COPY target/server /opt/jboss/wildfly

# Ensure signals are forwarded to the JVM process correctly for graceful shutdown
ENV LAUNCH_JBOSS_IN_BACKGROUND true

ENV BASIC_AUTH_USER=""
ENV BASIC_AUTH_PASSWORD=""

# Expose the ports we're interested in
EXPOSE 8080

USER 1001
RUN chown -R 1001:0 /opt/jboss/wildfly/standalone/log

# Set the default command to run on boot
# This will boot WildFly in the standalone mode and bind to all interface
ENTRYPOINT ["/bin/sh", "-c", "if [ \"x$BASIC_AUTH_USER\" != \"x\" -a \"x$BASIC_AUTH_PASSWORD\" != \"x\" ]; then /opt/jboss/wildfly/bin/add-user.sh -a -u \"$BASIC_AUTH_USER\" -p \"$BASIC_AUTH_PASSWORD\" -g app-users; fi; /opt/jboss/wildfly/bin/standalone.sh -b 0.0.0.0"]
