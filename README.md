# Amazon Bedrock sql-agent Langchain

## Content
- [Overview](#overview)
- [Prerequisites](#prerequisites)
- [Performance optimization](#performance-optimization)
- [Configuration](#configuration)
- [Running the example](#running-the-example)
- [Security Considerations](#security-considerations)
- [Links and References](#links-and-references)

## Overview

The goal of this repo is to provide users the ability to use Amazon Bedrock and generative AI to take natural language questions, and transform them into relational database queries against MSSQL Databases using LangChain SQL Agent. 

LangChain SQL Agent provides a more flexible way of interacting with SQL Databases than a chain. The main advantages of using the SQL Agent are:

- It can answer questions based on the databases' schema as well as on the databases' content (like describing a specific table).
- It can recover from errors by running a generated query, catching the traceback and regenerating - it correctly.
- It can query the database as many times as needed to answer the user question.
- It will save tokens by only retrieving the schema from relevant tables.

## Prerequisites:

1. Amazon Bedrock Access and CLI Credentials. Ensure that the proper FM model access is provided in the Amazon Bedrock console
2. SQL Server Access
3. Python 3.10 
4. Please note that this project leverages the [langchain-experimental](https://pypi.org/project/langchain-experimental/) package which has known vulnerabilities.
5. ODBC Driver 18 for SQL Server installed ([instructions](#configuration))

## Performance optimization 
To enhance agent performance, we use a custom prompt enriched with domain-specific knowledge through a few-shot prompt. This approach improves the model’s query accuracy by incorporating relevant examples directly into the prompt for reference. Optimization involves adjusting the default prompt prefix and suffix, then passing these updated values to the SQL agent:  

``` 
sql_agent = create_sql_agent(llm=llm, db=db, top_k=5, prefix=prefix_prompt, suffix=suffix_prompt, verbose=True)
```

## Configuration

To create the DB used in this example, run [createDBScript.sql](createDBScript.sql) on the SQL server.

Obtain the following information for the SQL server:

```
SQL_HOST = 'ip of the host'
SQL_PORT = '1433'  
SQL_DATABASE = 'sales_db'
SQL_USERNAME = 'user'
SQL_PASSWORD ='password'
``` 

Run the following code in the Linux terminal window to install the Microsoft Open Database Connectivity (ODBC) driver for SQL Server (Linux).

```
# RHEL 7 and Linux 7
curl https://packages.microsoft.com/config/rhel/7/prod.repo | sudo tee /etc/yum.repos.d/mssql-release.repo
sudo yum remove unixODBC-utf16 unixODBC-utf16-devel #to avoid conflicts
sudo ACCEPT_EULA=Y yum install -y msodbcsql18
# Optional: for bcp and sqlcmd
sudo ACCEPT_EULA=Y yum install -y mssql-tools18
echo 'export PATH="$PATH:/opt/mssql-tools18/bin"' >> ~/.bashrc
source ~/.bashrc
# For unixODBC development headers
sudo yum install -y unixODBC-devel
```

Install the required packages using pip:
```
pip install yaml
pip install boto3
pip install json
pip install pyodbc
pip install sqlalchemy
pip install langchain-aws
pip install boto3 pyodbc
pip install --upgrade langchain
pip install langchain-experimental
pip install langchain-community
```
Depending on the region and model that you are planning to use Amazon Bedrock in, you may need to reconfigure the llm settings in amazon_sql_bedrock_query.py file:
```
llm = ChatBedrock(
    model_id="anthropic.claude-3-sonnet-20240229-v1:0",
    model_kwargs=dict(temperature=0.8),
    region_name='us-east-1'
)
```

## Running the example

There are two options to run this example:

#### 1. Jupyter Notebook 
One option is to run the [sql_bedrock_query.ipynb](sql_bedrock_query.ipynb) notebook in an environment where you have access to the Linux terminal, as you'll need to install the ODBC driver. You can execute this notebook using Amazon SageMaker JupyterLab.

#### 2. Deploy the API 
 
One option of running this application is to expose the api endpoints from [app.py](app.py) on an AWS EC2 instance. To do so, follow these general steps:

1. Set Up Your EC2 Instance:
   - Ensure your security group allows inbound traffic on port 5000 for HTTP (0.0.0.0/0)
   - Install the (ODBC) driver for SQL Server 
   - Install the all the required packages
   
2. Install Flask (a micro web framework for Python to run APIs): `pip3 install flask` 

3. Copy the app files to the instance ([using FileZilla](https://stackoverflow.com/questions/16744863/connect-to-amazon-ec2-file-directory-using-filezilla-and-sftp)).

4. Configure AWS CLI credentials using `aws configure`. This will create `~/.aws/config` file.

4. Run the Flask Application:
`python3 app.py` or in the background: `nohup python3 app.py > output.log 2>&1 &^C`

5. Test the API Endpoint: Open Postman or any other API testing tool.
    Send a GET request to `http://<your-ec2-public-ip>:5000/api/hello`.

6. Once the app is running, send an actual user question the to the endpoint using the SQL server/DB information obtained earlier:

```
curl --location 'http://://<your-ec2-public-ip>:5000/api/sqlanswer' \
--header 'Content-Type: application/json' \
--data '{
  "question": "Find all orders for customers with the name '\''Jane Smith'\''?",
  "sql_server": "sql server ip",
  "sql_port": "1433",
  "sql_database": "sales_db",
  "sql_username": "user",
  "sql_password": "password"
}
```

## Security Considerations 

This system requires executing model-generated database queries. There are inherent risks in doing this. Make sure that your database connection permissions are always scoped as narrowly as possible for your chain/agent's needs. This will mitigate though not eliminate the risks of building a model-driven system. For more on general security best practices, [see here](https://python.langchain.com/v0.1/docs/security/)


## Links and References
[LangChain SQL Agent quickstart](https://python.langchain.com/v0.1/docs/use_cases/sql/agents/)

[create_sql_agent documentation](https://api.python.langchain.com/en/latest/agent_toolkits/langchain_community.agent_toolkits.sql.base.create_sql_agent.html)

[Few Shot Examples](https://python.langchain.com/v0.1/docs/use_cases/sql/prompting/#few-shot-examples)

[Chat Bedrock](https://python.langchain.com/v0.2/docs/integrations/chat/bedrock/)

[Default agent prompts](https://github.com/langchain-ai/langchain/blob/master/libs/community/langchain_community/agent_toolkits/sql/prompt.py)

[Amazon-Bedrock-Amazon-Redshift-POC](https://github.com/aws-samples/genai-quickstart-pocs/blob/main/genai-quickstart-pocs-python/amazon-bedrock-amazon-redshift-poc/README.md)

[A generative AI use case using Amazon RDS for SQL Server as a vector data store](https://aws.amazon.com/blogs/database/a-generative-ai-use-case-using-amazon-rds-for-sql-server-as-a-vector-data-store/)

