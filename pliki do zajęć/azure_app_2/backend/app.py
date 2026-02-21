from flask import Flask, jsonify, request
from flask_cors import CORS
import psycopg2
import os
from dotenv import load_dotenv
from azure.storage.blob import BlobServiceClient
import io
from datetime import datetime

load_dotenv()

app = Flask(__name__)
CORS(app)

def get_db_connection():
    return psycopg2.connect(os.getenv('DATABASE_URL'))

def init_db():
    try:
        conn = get_db_connection()
        cur = conn.cursor()
        cur.execute('''
            CREATE TABLE IF NOT EXISTS messages (
                id SERIAL PRIMARY KEY,
                content TEXT NOT NULL,
                created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
            )
        ''')
        conn.commit()
        cur.close()
        conn.close()
    except Exception as e:
        print(f"DB init error: {e}")

init_db()

@app.route('/api/hello')
def hello():
    return jsonify({
        'message': 'Hello World from Backend!',
        'status': 'success'
    })

@app.route('/api/health')
def health():
    return jsonify({'status': 'healthy'})

@app.route('/api/db/messages', methods=['GET'])
def get_messages():
    try:
        conn = get_db_connection()
        cur = conn.cursor()
        cur.execute('SELECT id, content, created_at FROM messages ORDER BY created_at DESC LIMIT 10')
        messages = [{'id': row[0], 'content': row[1], 'created_at': str(row[2])} for row in cur.fetchall()]
        cur.close()
        conn.close()
        return jsonify({'messages': messages, 'status': 'success'})
    except Exception as e:
        return jsonify({'error': str(e), 'status': 'error'}), 500

@app.route('/api/db/messages', methods=['POST'])
def add_message():
    try:
        data = request.get_json()
        content = data.get('content', 'Test message')
        conn = get_db_connection()
        cur = conn.cursor()
        cur.execute('INSERT INTO messages (content) VALUES (%s) RETURNING id', (content,))
        message_id = cur.fetchone()[0]
        conn.commit()
        cur.close()
        conn.close()
        return jsonify({'id': message_id, 'content': content, 'status': 'success'})
    except Exception as e:
        return jsonify({'error': str(e), 'status': 'error'}), 500

@app.route('/api/blob/upload', methods=['POST'])
def upload_blob():
    try:
        blob_service_client = BlobServiceClient.from_connection_string(os.getenv('AZURE_STORAGE_CONNECTION_STRING'))
        container_name = os.getenv('AZURE_STORAGE_CONTAINER', 'demo-container')
        
        data = request.get_json()
        content = data.get('content', 'Hello from Azure Blob Storage!')
        filename = f"test_{datetime.now().strftime('%Y%m%d_%H%M%S')}.txt"
        
        blob_client = blob_service_client.get_blob_client(container=container_name, blob=filename)
        blob_client.upload_blob(content, overwrite=True)
        
        return jsonify({'filename': filename, 'status': 'success', 'url': blob_client.url})
    except Exception as e:
        return jsonify({'error': str(e), 'status': 'error'}), 500

@app.route('/api/blob/list', methods=['GET'])
def list_blobs():
    try:
        blob_service_client = BlobServiceClient.from_connection_string(os.getenv('AZURE_STORAGE_CONNECTION_STRING'))
        container_name = os.getenv('AZURE_STORAGE_CONTAINER', 'demo-container')
        container_client = blob_service_client.get_container_client(container_name)
        
        blobs = [{'name': blob.name, 'size': blob.size, 'last_modified': str(blob.last_modified)} 
                 for blob in container_client.list_blobs()]
        
        return jsonify({'blobs': blobs, 'status': 'success'})
    except Exception as e:
        return jsonify({'error': str(e), 'status': 'error'}), 500

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000, debug=True)
