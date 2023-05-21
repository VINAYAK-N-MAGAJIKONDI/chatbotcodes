from flask import Flask, request, jsonify
from bardapi import core as bard

app = Flask(__name__)
app.config['JSON_SORT_KEYS'] = False

token = 'WQgjUQ5kvoFes5Vls82gwQPLeZ2p2hpQpv6x3TL2fPVVKRlXNoguWijrTnlfeTcWduQjlQ.'

@app.route('/get_answer', methods=['POST'])
def get_answer():
    message = request.json.get('message')
    response = bard.Bard(token).get_answer(message)
    return jsonify(response)

if __name__ == '__main__':
    app.run(debug=True)
