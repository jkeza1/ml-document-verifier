
from flask import Flask, request, jsonify
from flask_cors import CORS
import tensorflow as tf
import joblib
import numpy as np
import cv2
from PIL import Image
import io

app = Flask(__name__)
CORS(app)

# Load model and scaler
model = tf.keras.models.load_model('output/models/document_verification_model.keras')
scaler = joblib.load('output/models/feature_scaler.pkl')

def extract_features_from_image(image_bytes):
    """Extract features from uploaded image."""
    # Convert bytes to image
    img = Image.open(io.BytesIO(image_bytes))
    img_array = np.array(img)
    
    # Convert to grayscale if needed
    if len(img_array.shape) == 3:
        gray = cv2.cvtColor(img_array, cv2.COLOR_RGB2GRAY)
    else:
        gray = img_array
    
    # Resize
    resized = cv2.resize(gray, (224, 224))
    
    # Extract features (same as training)
    features = {}
    features['mean_brightness'] = np.mean(resized)
    features['std_brightness'] = np.std(resized)
    features['contrast'] = resized.max() - resized.min()
    
    edges = cv2.Canny(resized, 100, 200)
    features['edge_density'] = np.sum(edges > 0) / (224 * 224)
    
    features['blur_score'] = cv2.Laplacian(resized, cv2.CV_64F).var()
    
    binary = cv2.threshold(resized, 0, 255, cv2.THRESH_BINARY_INV + cv2.THRESH_OTSU)[1]
    features['text_density'] = np.sum(binary > 0) / (224 * 224)
    
    hist = cv2.calcHist([resized], [0], None, [16], [0, 256])
    hist = hist.flatten() / hist.sum()
    features['hist_entropy'] = -np.sum(hist * np.log2(hist + 1e-10))
    
    features['aspect_ratio'] = img_array.shape[1] / img_array.shape[0]
    
    return np.array(list(features.values())).reshape(1, -1)

@app.route('/api/health', methods=['GET'])
def health():
    return jsonify({'status': 'healthy', 'model': 'loaded'})

@app.route('/api/verify-document', methods=['POST'])
def verify_document():
    try:
        # Check if image is in request
        if 'image' not in request.files:
            return jsonify({'error': 'No image provided'}), 400
        
        # Read image
        image_file = request.files['image']
        image_bytes = image_file.read()
        
        # Extract features
        features = extract_features_from_image(image_bytes)
        
        # Normalize
        features_scaled = scaler.transform(features)
        
        # Predict
        prediction = model.predict(features_scaled, verbose=0)
        confidence = float(prediction[0][0])
        is_valid = confidence > 0.5
        
        return jsonify({
            'valid': bool(is_valid),
            'confidence': round(confidence * 100, 2),
            'status': 'approved' if is_valid else 'rejected'
        })
    
    except Exception as e:
        return jsonify({'error': str(e)}), 500

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000, debug=True)
