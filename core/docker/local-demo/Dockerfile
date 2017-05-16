FROM ortussolutions/commandbox:latest

ENV CFENGINE lucee@5

COPY build/mura-dependencies.sh ${BUILD_DIR}/mura-dependencies.sh
COPY build/mura-run.sh ${BUILD_DIR}/mura-run.sh

RUN chmod +x ${BUILD_DIR}/mura-dependencies.sh
RUN chmod +x ${BUILD_DIR}/mura-run.sh
RUN ${BUILD_DIR}/mura-dependencies.sh

CMD $BUILD_DIR/mura-run.sh
