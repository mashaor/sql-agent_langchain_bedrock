from flask import Flask, jsonify, request
from amazon_sql_bedrock_query import sql_answer, validate_sql_connection
#nohup python3 app.py > output.log 2>&1 &^C

app = Flask(__name__)
app.debug = True 

@app.route('/api/hello', methods=['GET'])
def hello():
    return "Hello, Flask!"


@app.route('/api/sqlanswer', methods=['POST'])
def api_endpoint():
    try:
        if not request.is_json:
            return jsonify({"error": "Request must be JSON"}), 400
        
        # Get the JSON data from the request
        data = request.get_json()
        
        if not data:
            raise ValueError("Missing JSON payload")
        
        required_keys = ['question', 'sql_server', 'sql_port', 'sql_database', 'sql_username', 'sql_password']
        for key in required_keys:
            if key not in data:
                raise ValueError(f"Missing required key: {key}")
            
        # You can access query parameters with request.args
        answer = sql_answer(data)

        # Process the request and prepare the response
        response = {'message': answer}

        return jsonify(response)
    
    except ValueError as e:
        return jsonify({"error": str(e)}), 400
    except Exception as e:
        return jsonify({"error": "Internal server error:" + str(e)}), 500 
    

@app.route('/api/testsqlconnection', methods=['POST'])
def test_sql_connection():
    data = request.json
    response = validate_sql_connection(data)
    return jsonify({"status": response})

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)  # Run the app on port 5000
