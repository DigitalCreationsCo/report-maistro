FROM langchain/langgraph-api:3.11

# Set working directory before adding dependencies
WORKDIR /deps/report-mAIstro

# Copy application code
ADD . /deps/report-mAIstro

# Install dependencies
RUN PYTHONDONTWRITEBYTECODE=1 pip install --no-cache-dir -c /api/constraints.txt -e /deps/*

# Set environment variables for runtime
ENV TAVILY_API_KEY=${TAVILY_API_KEY}
ENV REDIS_URI=${REDIS_URI}
ENV DATABASE_URI=${DATABASE_URI}

# Set the graph mapping
ENV LANGSERVE_GRAPHS='{"report_maistro": "/deps/report-mAIstro/src/report_maistro/graph.py:graph"}'

# Set port environment variable
ENV PORT=8000

# Expose port (metadata, not actual binding)
EXPOSE 8000

# Ensure the container runs the application correctly
CMD ["langgraph", "dev"]