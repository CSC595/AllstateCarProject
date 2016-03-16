from flask import jsonify, render_template, Response, send_file
from app import app
from camera import detector

@app.route('/run_app')
def run_app():
    detector.start()
    result = [{
        'status': 'working'
    }]
    return jsonify({'result': result})

@app.route('/stop_app')
def stop_app():
    detector.stop()
    result = [{
        'status': 'stopped'
    }]
    return jsonify({'result': result})


@app.route('/result')
def get_camera_result():
    
    result = []
    rs = detector.isLookingAround
    if rs == 'yes':
        result.append({'lookaround': 'yes'})
    elif rs == 'no':
        result.append({'lookaround': 'no'})
    else:
        result.append({'lookaround': 'n/a'})
    return jsonify({'result': result})

@app.route('/pic')
def get_pic():
    pic_path = '/home/pi/Desktop/AllstateServer/FaceDetection.png'
    return send_file(pic_path, mimetype='image/png')
