from flask import Flask, request, jsonify
from langchain_openai import ChatOpenAI
from langchain_community.utilities import SQLDatabase
from langchain_community.agent_toolkits import SQLDatabaseToolkit
from langchain.hub import pull
from langchain_core.messages import SystemMessage, HumanMessage
from langgraph.prebuilt import create_react_agent
from urllib.parse import quote_plus
from dotenv import load_dotenv
import os

# Load environment variables
load_dotenv()

# Fetch and validate environment variables
api_key = os.getenv("OPENAI_API_KEY")
mysql_host = os.getenv("MYSQL_HOST")
mysql_user = os.getenv("MYSQL_USER")
mysql_password = os.getenv("MYSQL_PASSWORD")
mysql_db = os.getenv("MYSQL_DB")
mysql_port = os.getenv("DATABASE_PORT", "3306")  

if not all([api_key, mysql_host, mysql_user, mysql_password, mysql_db, mysql_port]):
    raise ValueError("Missing required environment variables.")

mysql_password_encoded = quote_plus(mysql_password)


app = Flask(__name__)

# Initialize the LLM
llm = ChatOpenAI(
    model="gpt-4",
    openai_api_key=api_key,
    temperature=0,
    max_tokens=512,
)

# Connect to MySQL database
db_url = f"mysql+pymysql://{mysql_user}:{mysql_password_encoded}@{mysql_host}:{mysql_port}/{mysql_db}"
try:
    db = SQLDatabase.from_uri(db_url)
    print("Connected to MySQL Database successfully!")
except Exception as e:
    print(f"Error connecting to MySQL Database: {e}")
    exit()

# Initialize SQLDatabaseToolkit
toolkit = SQLDatabaseToolkit(db=db, llm=llm)
tools = toolkit.get_tools()

# Pull SQL Agent System Prompt
prompt_template = pull("langchain-ai/sql-agent-system-prompt")
system_message = SystemMessage(content=prompt_template.format(dialect="mysql", top_k=5))

# Create the ReAct Agent Executor
agent_executor = create_react_agent(llm, tools)

from flask_cors import CORS
CORS(app)


@app.route("/query", methods=["POST"])
def query_database():
    try:
        data = request.get_json()
        question = data.get("question")
        
        if not question:
            return jsonify({"error": "No question provided."}), 400
        
        response = ""
        for step in agent_executor.stream(
            {"messages": [system_message, HumanMessage(content=question)]},
            stream_mode="values",
        ):
            response = step["messages"][-1].content
        
        return jsonify({"answer": response})
    except Exception as e:
        return jsonify({"error": str(e)}), 500

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=2100, debug=True)
