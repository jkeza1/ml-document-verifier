// iRembo Document Verification System
// Client-side application logic

console.log('iRembo Document Verification System Loaded');

// API Base URL
const API_BASE_URL = 'http://localhost:8000/api';

// Utility function to make API calls
async function makeApiCall(endpoint, method = 'GET', data = null) {
    try {
        const options = {
            method: method,
            headers: {
                'Content-Type': 'application/json',
            },
        };
        
        if (data) {
            options.body = JSON.stringify(data);
        }
        
        const response = await fetch(`${API_BASE_URL}${endpoint}`, options);
        if (!response.ok) {
            throw new Error(`API Error: ${response.statusText}`);
        }
        
        return await response.json();
    } catch (error) {
        console.error('API Call Error:', error);
        throw error;
    }
}

// Document Upload Handler
document.addEventListener('DOMContentLoaded', function() {
    const uploadForm = document.getElementById('uploadForm');
    if (uploadForm) {
        uploadForm.addEventListener('submit', handleDocumentUpload);
    }
    
    const aiUploadForm = document.getElementById('aiUploadForm');
    if (aiUploadForm) {
        aiUploadForm.addEventListener('submit', handleAIUpload);
    }
    
    const appealForm = document.getElementById('appealForm');
    if (appealForm) {
        appealForm.addEventListener('submit', handleAppealSubmit);
    }
    
    const verificationForm = document.getElementById('verificationForm');
    if (verificationForm) {
        verificationForm.addEventListener('submit', handleVerification);
    }
    
    const aiReviewForm = document.getElementById('aiReviewForm');
    if (aiReviewForm) {
        aiReviewForm.addEventListener('submit', handleAIReview);
    }
    
    // Drag and drop for AI upload
    const dragDropZone = document.getElementById('dragDropZone');
    if (dragDropZone) {
        dragDropZone.addEventListener('dragover', handleDragOver);
        dragDropZone.addEventListener('drop', handleFileDrop);
    }
});

async function handleDocumentUpload(event) {
    event.preventDefault();
    const formData = new FormData(event.target);
    
    try {
        const response = await fetch(`${API_BASE_URL}/upload`, {
            method: 'POST',
            body: formData
        });
        
        const result = await response.json();
        document.getElementById('ai-feedback').innerHTML = 
            `<div class="feedback-result">${JSON.stringify(result, null, 2)}</div>`;
    } catch (error) {
        console.error('Upload Error:', error);
    }
}

async function handleAIUpload(event) {
    event.preventDefault();
    const formData = new FormData(event.target);
    
    try {
        const response = await fetch(`${API_BASE_URL}/ai-process`, {
            method: 'POST',
            body: formData
        });
        
        const result = await response.json();
        document.getElementById('processing-results').innerHTML = 
            `<div class="processing-results">${JSON.stringify(result, null, 2)}</div>`;
    } catch (error) {
        console.error('AI Processing Error:', error);
    }
}

async function handleAppealSubmit(event) {
    event.preventDefault();
    const formData = new FormData(event.target);
    
    try {
        const result = await makeApiCall('/appeals', 'POST', Object.fromEntries(formData));
        alert('Appeal submitted successfully!');
    } catch (error) {
        alert('Error submitting appeal');
    }
}

async function handleVerification(event) {
    event.preventDefault();
    const formData = new FormData(event.target);
    
    try {
        const result = await makeApiCall('/verify', 'POST', Object.fromEntries(formData));
        alert('Verification saved successfully!');
    } catch (error) {
        alert('Error saving verification');
    }
}

async function handleAIReview(event) {
    event.preventDefault();
    const formData = new FormData(event.target);
    
    try {
        const result = await makeApiCall('/ai-review', 'POST', Object.fromEntries(formData));
        alert('AI Review submitted successfully!');
    } catch (error) {
        alert('Error submitting AI review');
    }
}

function handleDragOver(event) {
    event.preventDefault();
    event.currentTarget.classList.add('drag-over');
}

function handleFileDrop(event) {
    event.preventDefault();
    event.currentTarget.classList.remove('drag-over');
    const files = event.dataTransfer.files;
    // Handle dropped files
    console.log('Files dropped:', files);
}

// Export functions for use in other scripts
window.iRembo = {
    makeApiCall: makeApiCall,
    handleDocumentUpload: handleDocumentUpload,
    handleAIUpload: handleAIUpload,
    handleAppealSubmit: handleAppealSubmit,
    handleVerification: handleVerification,
    handleAIReview: handleAIReview
};
