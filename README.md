# AI Fact-Check Agent

An AI-powered Flutter Web application that automatically verifies factual claims from uploaded PDF documents. The system acts as a **“Truth Layer”** by detecting misleading, outdated, or false information using AI-powered extraction and live web verification.

---

# 🚀 Features

- 📄 Upload PDF documents
- 🔍 Extract factual claims automatically
- 📊 Detect:
  - Statistics
  - Dates
  - Percentages
  - Financial claims
  - Technical figures
- 🌐 Verify claims using live web data
- ✅ Classify claims as:
  - Verified
  - Inaccurate
  - False
- 📑 Generate verification reports
- 💻 Responsive Flutter Web interface

---

# 🧠 Problem Statement

AI-generated and marketing content often contains:
- outdated statistics
- hallucinated facts
- misleading claims

Manually verifying every claim is time-consuming.

This project automates the fact-checking process by extracting claims from PDFs and validating them against trusted online sources.

---

# ⚙️ Tech Stack

## Frontend
- Flutter Web

## Backend / AI Services
- OpenAI API / Gemini API
- PDF Processing
- HTTP APIs

## Deployment
- Firebase Hosting

---

# 🛠️ Workflow

```text
Upload PDF
      ↓
Extract Claims
      ↓
Search Live Web Sources
      ↓
Compare & Verify Facts
      ↓
Generate Verification Report
```

---

# 📸 Screenshots

Add your screenshots here.

Example:

```md
![Home Screen](assets/home.png)
![Verification Report](assets/report.png)
```

---

# 🧪 Example Verification Output

| Claim | Status |
|---|---|
| “India has 2B internet users” | ❌ False |
| “ChatGPT launched in 2022” | ✅ Verified |
| “AI market will reach $1 trillion by 2030” | ⚠️ Inaccurate |

---

# 🌍 Live Demo

## Deployed App

https://your-app.web.app

---

# 📂 Project Structure

```text
lib/
 ├── screens/
 ├── widgets/
 ├── services/
 ├── models/
 └── main.dart
```

---

# ▶️ Run Locally

## Clone Repository

```bash
git clone https://github.com/your-username/your-repo-name.git
```

## Install Dependencies

```bash
flutter pub get
```

## Run Flutter Web

```bash
flutter run -d chrome
```

---

# 🔑 Environment Variables

Create a `.env` file and add your API key:

```env
OPENAI_API_KEY=your_api_key
```

OR

```env
GEMINI_API_KEY=your_api_key
```

---

# 📌 Future Improvements

- Multi-language fact verification
- Real-time citation highlighting
- AI hallucination risk scoring
- Advanced credibility analysis
- Downloadable PDF reports

---

# 👨‍💻 Author

Isha

---

# 📄 License

This project is developed for educational and assignment purposes.
