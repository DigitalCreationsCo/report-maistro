# Report mAIstro

Report mAIstro is an open-source research assistant designed to generate high-quality reports on any topic using an AI-driven **plan-and-execute** workflow. Inspired by Google's [Gemini Deep Research](https://blog.google/products/gemini/google-gemini-deep-research/), it enables structured, parallelized research while incorporating human oversight.  

## 🌟 Key Features  

- **Intelligent Planning with Google Gemini-Pro**: Uses `gemini-pro` for advanced reasoning, report structuring, and topic decomposition.  
- **Parallel Web Research**: Leverages the [Tavily API](https://tavily.com/) for real-time web searches across report sections.  
- **Customizable Research Structure**: Users can modify report layouts, add feedback, and iterate through different report plans.  
- **LLM-Powered Writing with Claude 3.5 Sonnet**: Synthesizes research findings into well-structured markdown reports.  
- **Human-in-the-Loop Review**: Users can approve, modify, or refine report sections before finalization.  
- **LangSmith Studio Integration**: Provides a UI for real-time feedback, iteration, and API observability.  

## 📌 Use Case  

Report mAIstro is built for researchers, analysts, and writers who need comprehensive, structured reports on any subject. Whether it's market research, academic papers, or investigative journalism, the AI automates research gathering and report composition, significantly reducing manual effort.

- **Business Strategy Reports**: Analyzes competitive landscapes, industry trends, and case studies.  
- **Scientific & Technical Research**: Collects relevant publications, synthesizes findings, and structures arguments.  
- **Comparative Analysis**: Builds structured comparison tables with AI-driven insights.  
- **Financial & Policy Reports**: Aggregates news, market trends, and regulatory updates.  

---

## 🚀 Quickstart  

Clone the repository:  

```bash
git clone https://github.com/langchain-ai/report_maistro.git
cd report_maistro
```

### 🔑 Set Up API Keys  

Report mAIstro requires API keys for:  
- **Anthropic** (default writer - Claude 3.5 Sonnet)  
- **Google Gemini-Pro** (default planner - reasoning and structuring)  
- **Tavily API** (real-time web search)  

Copy the environment template and update your `.env` file:

```bash
cp .env.example .env
```

Edit the `.env` file and provide your API keys:

```bash
export TAVILY_API_KEY=<your_tavily_api_key>
export ANTHROPIC_API_KEY=<your_anthropic_api_key>
export GOOGLE_API_KEY=<your_google_gemini_api_key>
```

### ⚡ Start the Assistant  

#### Mac/Linux  

```bash
# Install uv package manager
curl -LsSf https://astral.sh/uv/install.sh | sh

# Install dependencies and start LangGraph server
uvx --refresh --from "langgraph-cli[inmem]" --with-editable . --python 3.11 langgraph dev
```

#### Windows  

```powershell
# Install dependencies 
pip install -e .
pip install langgraph-cli[inmem]

# Start the LangGraph server
langgraph dev
```

### 🎨 Access LangSmith Studio  

```
- 🚀 API: http://127.0.0.1:2024
- 🎨 Studio UI: https://smith.langchain.com/studio/?baseUrl=http://127.0.0.1:2024
- 📚 API Docs: http://127.0.0.1:2024/docs
```

---

## 🔎 How It Works  

### 1️⃣ Planning Phase (Gemini-Pro)  

- **Analyzes Topic**: Uses **Gemini-Pro** to break down the topic into well-structured report sections.  
- **Human Review**: Users can **approve, modify, or provide feedback** before research begins.  

### 2️⃣ Research Phase (Tavily API)  

- **Parallel Web Research**: Searches across multiple sections simultaneously.  
- **Extracts and Filters Data**: Uses advanced filtering to ensure high-quality sources.  

### 3️⃣ Writing Phase (Claude 3.5 Sonnet)  

- **Synthesizes Findings**: Converts research data into structured, well-formatted content.  
- **Maintains Context Awareness**: Ensures logical flow between sections.  
- **Optimized for Markdown**: Ready for direct publishing or further editing.  

---

## 🛠 Customizing Reports  

You can customize reports by providing a structured outline in natural language. This improves report focus and relevance.  

### Example Structures  

| Report Type       | Suggested Structure |
|------------------|------------------|
| **Market Analysis**  | Introduction → Industry Overview → Competitive Landscape → Key Players → Market Trends → Conclusion |
| **Scientific Report** | Abstract → Background Research → Methodology → Results → Discussion → References |
| **Comparative Report** | Introduction → Feature 1 Comparison → Feature 2 Comparison → Strengths & Weaknesses → Final Verdict |

> See [example reports](report_examples/) for more templates.  

---

## 📡 Integration with LangSmith Studio  

Report mAIstro is built using **LangGraph**, allowing full integration with **LangSmith Studio** for API observability, logging, and human feedback.  

### Features:  
- **Real-time Execution Visualization**: Track LLM calls, reasoning steps, and research queries.  
- **Iterative Feedback**: Modify report structures, refine research, and guide AI-generated content.  
- **Performance Monitoring**: View token usage, API response times, and prompt success rates.  

### Using LangSmith Studio  

1️⃣ **Submit a Topic**  

![Topic Submission](https://github.com/user-attachments/assets/70ce93d8-c29f-49ea-9e06-19377d8cac7b)  

2️⃣ **Receive a Report Plan**  

![Report Plan](https://github.com/user-attachments/assets/a464e71c-e122-422f-9736-62f8bf0b8777)  

3️⃣ **Provide Feedback & Iterate**  

![Feedback Iteration](https://github.com/user-attachments/assets/d82102f3-0adb-4eca-ae96-2fe720b22b71)  

4️⃣ **Approve & Generate Final Report**  

![Final Report](https://github.com/user-attachments/assets/1d693e16-79df-4823-8355-482999546922)  

---

## 📌 Deployment Options  

### 1️⃣ Local Deployment  

Follow the [quickstart](#quickstart) guide.  

### 2️⃣ Hosted Deployment (LangGraph Platform)  

Easily deploy to the **LangGraph Platform** for a cloud-based solution. See [LangGraph Docs](https://langchain-ai.github.io/langgraph/concepts/#deployment-options).  

---

## 🎯 Motivation  

Google's **Deep Research** project highlights the power of AI-assisted research. Report mAIstro builds on these concepts while **allowing customization of models, prompts, and report structures**, providing an open-source, adaptable alternative.  

🔹 **Why Use Report mAIstro?**  
✅ Automates structured research and writing  
✅ Human oversight for high-quality results  
✅ Fully customizable with different models & prompts  
✅ Integrated with LangSmith Studio for real-time iteration  

---

## 📜 License  

MIT License - See [LICENSE](LICENSE) for details.  
