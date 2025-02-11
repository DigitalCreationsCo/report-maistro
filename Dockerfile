FROM langchain/langgraph-api:3.11



ADD . /deps/report-mAIstro

RUN PYTHONDONTWRITEBYTECODE=1 pip install --no-cache-dir -c /api/constraints.txt -e /deps/*
ENV LANGSERVE_GRAPHS='{"report_masitro": "/deps/report-mAIstro/src/report_maistro/graph.py:graph"}'

WORKDIR /deps/report-mAIstro