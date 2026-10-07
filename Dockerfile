# Hardened Dockerfile

FROM eclipse-temurin:21-jre-alpine

# Create non-root user
RUN addgroup -S app && adduser -S -G app app

WORKDIR /app

# Copy application and give ownership to app user
COPY --chown=app:app target/novabank-transfer.jar app.jar

# Run as non-root user
USER app

EXPOSE 8082

# Health check
HEALTHCHECK --interval=30s --timeout=5s --start-period=60s --retries=3 \
    CMD wget -qO- http://localhost:8082/actuator/health || exit 1

ENTRYPOINT ["java", "-jar", "app.jar"]
